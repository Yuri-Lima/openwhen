import 'package:flutter/material.dart';

import '../../l10n/app_localizations.dart';
import '../../features/profile/presentation/screens/subscription_plans_screen.dart';
import 'subscription_tier.dart';

String tierDisplayName(SubscriptionTier tier, AppLocalizations l10n) {
  switch (tier) {
    case SubscriptionTier.free:
      return l10n.subscriptionPlanAmanhaName;
    case SubscriptionTier.plus:
      return l10n.subscriptionPlanBrisaName;
    case SubscriptionTier.pro:
      return l10n.subscriptionPlanHorizonteName;
  }
}

/// If [current] does not meet [requiredTier], shows dialog and optional navigation to plans.
/// Returns true when the user may proceed.
Future<bool> ensureTierOrPrompt(
  BuildContext context, {
  required SubscriptionTier current,
  required SubscriptionTier requiredTier,
}) async {
  if (tierMeets(current, requiredTier)) return true;
  final l10n = AppLocalizations.of(context)!;
  final planName = tierDisplayName(requiredTier, l10n);
  final go = await showDialog<bool>(
    context: context,
    builder: (ctx) => AlertDialog(
      title: Text(l10n.subscriptionUpgradeDialogTitle),
      content: Text(l10n.subscriptionUpgradeDialogBody(planName)),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(ctx, false),
          child: Text(l10n.actionCancel),
        ),
        TextButton(
          onPressed: () => Navigator.pop(ctx, true),
          child: Text(l10n.subscriptionUpgradeDialogViewPlans),
        ),
      ],
    ),
  );
  if (go == true && context.mounted) {
    await Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => const SubscriptionPlansScreen(),
      ),
    );
  }
  return false;
}
