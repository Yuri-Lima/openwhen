import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../core/billing/billing_feature_flags.dart';
import '../../../../core/billing/stripe_billing_provider.dart';
import '../../../../core/billing/subscription_tier.dart';
import '../../../../core/billing/subscription_tier_provider.dart';
import '../../../../core/billing/tier_guard.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../shared/theme/app_theme.dart';
import '../../../../shared/widgets/owl_watermark.dart';

/// Stripe Checkout / Portal return URLs (must be allowed in Cloud Functions).
Uri subscriptionSuccessUri() {
  if (kIsWeb) {
    final b = Uri.base;
    return Uri(
      scheme: b.scheme,
      host: b.host,
      port: b.hasPort ? b.port : null,
      path: '/subscription-success',
    );
  }
  return Uri.parse('openwhen://subscription-success');
}

Uri subscriptionCancelUri() {
  if (kIsWeb) {
    final b = Uri.base;
    return Uri(
      scheme: b.scheme,
      host: b.host,
      port: b.hasPort ? b.port : null,
      path: '/subscription-cancel',
    );
  }
  return Uri.parse('openwhen://subscription-cancel');
}

Uri subscriptionPortalReturnUri() {
  if (kIsWeb) {
    final b = Uri.base;
    return Uri(
      scheme: b.scheme,
      host: b.host,
      port: b.hasPort ? b.port : null,
      path: '/subscription-portal-return',
    );
  }
  return Uri.parse('openwhen://subscription-portal-return');
}

class SubscriptionPlansScreen extends ConsumerStatefulWidget {
  const SubscriptionPlansScreen({super.key});

  @override
  ConsumerState<SubscriptionPlansScreen> createState() =>
      _SubscriptionPlansScreenState();
}

class _SubscriptionPlansScreenState extends ConsumerState<SubscriptionPlansScreen> {
  bool _loadingCheckout = false;
  bool _loadingPortal = false;
  bool _requestedMigrate = false;

  Future<void> _checkout(SubscriptionTier plan) async {
    final l10n = AppLocalizations.of(context)!;
    if (!kBillingStripeEnabled) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.subscriptionBillingDisabledSnack)),
        );
      }
      return;
    }
    if (_loadingCheckout) return;
    setState(() => _loadingCheckout = true);
    try {
      final billing = ref.read(billingProvider);
      final url = await billing.createCheckoutSession(
        plan: plan,
        successUrl: subscriptionSuccessUri(),
        cancelUrl: subscriptionCancelUri(),
      );
      final ok = await launchUrl(url, mode: LaunchMode.externalApplication);
      if (!ok && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.subscriptionCheckoutError)),
        );
      }
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.subscriptionCheckoutError)),
        );
      }
    } finally {
      if (mounted) setState(() => _loadingCheckout = false);
    }
  }

  Future<void> _portal() async {
    final l10n = AppLocalizations.of(context)!;
    if (!kBillingStripeEnabled) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.subscriptionBillingDisabledSnack)),
        );
      }
      return;
    }
    if (_loadingPortal) return;
    setState(() => _loadingPortal = true);
    try {
      final billing = ref.read(billingProvider);
      final url = await billing.createPortalSession(
        returnUrl: subscriptionPortalReturnUri(),
      );
      final ok = await launchUrl(url, mode: LaunchMode.externalApplication);
      if (!ok && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.subscriptionPortalError)),
        );
      }
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.subscriptionPortalError)),
        );
      }
    } finally {
      if (mounted) setState(() => _loadingPortal = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!_requestedMigrate) {
      _requestedMigrate = true;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ref.read(billingProvider).migrateBillingDefaultsIfNeeded();
      });
    }
    final l10n = AppLocalizations.of(context)!;
    final tierAsync = ref.watch(subscriptionTierProvider);
    final current = tierAsync.asData?.value ?? SubscriptionTier.free;

    return Scaffold(
      backgroundColor: context.pal.bg,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: context.pal.headerGradient,
              ),
            ),
            child: SafeArea(
              bottom: false,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(24, 16, 24, 20),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Container(
                        width: 36,
                        height: 36,
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.08),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(
                          Icons.arrow_back,
                          size: 18,
                          color: Colors.white.withValues(alpha: 0.6),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Row(
                        children: [
                          Text(
                            l10n.subscriptionScreenTitle,
                            style: GoogleFonts.dmSerifDisplay(
                              fontSize: 22,
                              color: context.pal.white,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                          const SizedBox(width: 6),
                          const OwlWatermark(
                            width: 18,
                            height: 22,
                            opacity: 2.2,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                if (!kBillingStripeEnabled) ...[
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: context.pal.card,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: context.pal.border),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(Icons.info_outline, color: context.pal.accent, size: 22),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            l10n.subscriptionBillingDisabledBanner,
                            style: GoogleFonts.dmSans(
                              fontSize: 13,
                              height: 1.35,
                              color: context.pal.ink,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                ],
                Text(
                  '${l10n.subscriptionCurrentPlanLabel}: ${tierDisplayName(current, l10n)}',
                  style: GoogleFonts.dmSans(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: context.pal.ink,
                  ),
                ),
                const SizedBox(height: 16),
                _planCard(
                  context,
                  title: l10n.subscriptionPlanAmanhaName,
                  subtitle: l10n.subscriptionPlanAmanhaPitch,
                  highlight: current == SubscriptionTier.free,
                  cta: null,
                ),
                const SizedBox(height: 12),
                _planCard(
                  context,
                  title: l10n.subscriptionPlanBrisaName,
                  subtitle: l10n.subscriptionPlanBrisaPitch,
                  highlight: current == SubscriptionTier.plus,
                  cta: current.index < SubscriptionTier.plus.index
                      ? TextButton(
                          onPressed:
                              _loadingCheckout ? null : () => _checkout(SubscriptionTier.plus),
                          child: Text(l10n.subscriptionSubscribeBrisa),
                        )
                      : null,
                ),
                const SizedBox(height: 12),
                _planCard(
                  context,
                  title: l10n.subscriptionPlanHorizonteName,
                  subtitle: l10n.subscriptionPlanHorizontePitch,
                  highlight: current == SubscriptionTier.pro,
                  cta: current.index < SubscriptionTier.pro.index
                      ? TextButton(
                          onPressed:
                              _loadingCheckout ? null : () => _checkout(SubscriptionTier.pro),
                          child: Text(l10n.subscriptionSubscribeHorizonte),
                        )
                      : null,
                ),
                if (current != SubscriptionTier.free && kBillingStripeEnabled) ...[
                  const SizedBox(height: 24),
                  OutlinedButton(
                    onPressed: _loadingPortal ? null : _portal,
                    child: Text(l10n.subscriptionManageBilling),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _planCard(
    BuildContext context, {
    required String title,
    required String subtitle,
    required bool highlight,
    Widget? cta,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: context.pal.card,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: highlight ? context.pal.accent : context.pal.border,
          width: highlight ? 2 : 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: GoogleFonts.dmSerifDisplay(
              fontSize: 20,
              color: context.pal.ink,
              fontStyle: FontStyle.italic,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            subtitle,
            style: GoogleFonts.dmSans(
              fontSize: 13,
              color: context.pal.inkSoft,
              height: 1.4,
            ),
          ),
          if (cta != null) ...[const SizedBox(height: 12), cta],
        ],
      ),
    );
  }
}
