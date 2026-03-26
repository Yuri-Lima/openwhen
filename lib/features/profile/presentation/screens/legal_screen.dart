import 'package:flutter/material.dart';
import '../../../../shared/widgets/owl_logo.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../shared/theme/app_theme.dart';
import '../../../../l10n/app_localizations.dart';

enum LegalType { terms, privacy, about, help }

class LegalScreen extends StatelessWidget {
  final LegalType type;
  const LegalScreen({super.key, required this.type});

  String _getTitle(AppLocalizations l10n) {
    switch (type) {
      case LegalType.terms: return l10n.legalTitleTerms;
      case LegalType.privacy: return l10n.legalTitlePrivacy;
      case LegalType.about: return l10n.legalTitleAbout;
      case LegalType.help: return l10n.legalTitleHelp;
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      backgroundColor: context.pal.bg,
      body: Column(
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
                        width: 36, height: 36,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.08),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(Icons.arrow_back, size: 18, color: Colors.white.withOpacity(0.6)),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Text(_getTitle(l10n),
                        style: GoogleFonts.dmSerifDisplay(fontSize: 20, color: context.pal.white, fontStyle: FontStyle.italic)),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: _buildContent(context, l10n),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContent(BuildContext context, AppLocalizations l10n) {
    switch (type) {
      case LegalType.terms: return _buildTerms(context, l10n);
      case LegalType.privacy: return _buildPrivacy(context, l10n);
      case LegalType.about: return _buildAbout(context, l10n);
      case LegalType.help: return _buildHelp(context, l10n);
    }
  }

  Widget _buildTerms(BuildContext context, AppLocalizations l10n) {
    return _buildLegalContent(context,
      lastUpdate: l10n.legalLastUpdate('22/03/2026'),
      intro: l10n.termsIntro,
      sections: [
        _Section(l10n.termsSection1Title, l10n.termsSection1Body),
        _Section(l10n.termsSection2Title, l10n.termsSection2Body),
        _Section(l10n.termsSection3Title, l10n.termsSection3Body),
        _Section(l10n.termsSection4Title, l10n.termsSection4Body),
        _Section(l10n.termsSection5Title, l10n.termsSection5Body),
        _Section(l10n.termsSection6Title, l10n.termsSection6Body),
        _Section(l10n.termsSection7Title, l10n.termsSection7Body),
      ],
    );
  }

  Widget _buildPrivacy(BuildContext context, AppLocalizations l10n) {
    return _buildLegalContent(context,
      lastUpdate: l10n.legalLastUpdate('22/03/2026'),
      intro: l10n.privacyIntro,
      sections: [
        _Section(l10n.privacySection1Title, l10n.privacySection1Body),
        _Section(l10n.privacySection2Title, l10n.privacySection2Body),
        _Section(l10n.privacySection3Title, l10n.privacySection3Body),
        _Section(l10n.privacySection4Title, l10n.privacySection4Body),
        _Section(l10n.privacySection5Title, l10n.privacySection5Body),
        _Section(l10n.privacySection6Title, l10n.privacySection6Body),
        _Section(l10n.privacySection7Title, l10n.privacySection7Body),
        _Section(l10n.privacySection8Title, l10n.privacySection8Body),
      ],
    );
  }

  Widget _buildAbout(BuildContext context, AppLocalizations l10n) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Center(
          child: Column(
            children: [
              Container(
                width: 80, height: 80,
                decoration: BoxDecoration(
                  color: context.pal.accent,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [BoxShadow(color: context.pal.accent.withOpacity(0.3), blurRadius: 20)],
                ),
                child: Center(
                  child: const OwlLogo(size: 64),
                ),
              ),
              const SizedBox(height: 16),
              Text('OpenWhen', style: GoogleFonts.dmSerifDisplay(fontSize: 28, color: context.pal.ink, fontStyle: FontStyle.italic)),
              const SizedBox(height: 4),
              Text(l10n.aboutTagline,
                style: GoogleFonts.dmSans(fontSize: 14, color: context.pal.inkSoft, fontStyle: FontStyle.italic)),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(color: context.pal.accentWarm, borderRadius: BorderRadius.circular(20)),
                child: Text(l10n.aboutVersion,
                  style: GoogleFonts.dmSans(fontSize: 12, color: context.pal.accent, fontWeight: FontWeight.w500)),
              ),
            ],
          ),
        ),
        const SizedBox(height: 32),
        _buildInfoCard(context, '💌', l10n.aboutWhatIsTitle, l10n.aboutWhatIsBody),
        const SizedBox(height: 12),
        _buildInfoCard(context, '🔒', l10n.aboutSecurityTitle, l10n.aboutSecurityBody),
        const SizedBox(height: 12),
        _buildInfoCard(context, '⚖️', l10n.aboutComplianceTitle, l10n.aboutComplianceBody),
        const SizedBox(height: 12),
        _buildInfoCard(context, '🇧🇷', l10n.aboutCompanyTitle, l10n.aboutCompanyBody),
        const SizedBox(height: 24),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: context.pal.card,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: context.pal.border),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(l10n.aboutContacts, style: GoogleFonts.dmSans(fontSize: 14, color: context.pal.ink, fontWeight: FontWeight.w600)),
              const SizedBox(height: 8),
              _buildContact(context, l10n.aboutContactSupport, 'suporte@openwhen.app'),
              _buildContact(context, l10n.aboutContactPrivacy, 'privacidade@openwhen.app'),
              _buildContact(context, l10n.aboutContactLegal, 'juridico@openwhen.app'),
              _buildContact(context, l10n.aboutContactDpo, 'dpo@openwhen.app'),
            ],
          ),
        ),
        const SizedBox(height: 24),
        Center(
          child: Text(l10n.aboutCopyright,
            textAlign: TextAlign.center,
            style: GoogleFonts.dmSans(fontSize: 11, color: context.pal.inkFaint, height: 1.5)),
        ),
      ],
    );
  }

  Widget _buildHelp(BuildContext context, AppLocalizations l10n) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: context.pal.accentWarm,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: context.pal.accent.withOpacity(0.2)),
          ),
          child: Row(
            children: [
              const Text('💬', style: TextStyle(fontSize: 24)),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(l10n.helpCenter, style: GoogleFonts.dmSans(fontSize: 14, color: context.pal.ink, fontWeight: FontWeight.w600)),
                    Text(l10n.helpCenterSubtitle,
                      style: GoogleFonts.dmSans(fontSize: 12, color: context.pal.inkSoft)),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        Text(l10n.helpFaqSection,
          style: GoogleFonts.dmSans(fontSize: 10, color: context.pal.inkFaint, letterSpacing: 1.5, fontWeight: FontWeight.w500)),
        const SizedBox(height: 12),
        _buildFaq(context, l10n.helpFaq1Q, l10n.helpFaq1A),
        _buildFaq(context, l10n.helpFaq2Q, l10n.helpFaq2A),
        _buildFaq(context, l10n.helpFaq3Q, l10n.helpFaq3A),
        _buildFaq(context, l10n.helpFaq4Q, l10n.helpFaq4A),
        _buildFaq(context, l10n.helpFaq5Q, l10n.helpFaq5A),
        _buildFaq(context, l10n.helpFaq6Q, l10n.helpFaq6A),
        _buildFaq(context, l10n.helpFaq7Q, l10n.helpFaq7A),
        _buildFaq(context, l10n.helpFaq8Q, l10n.helpFaq8A),
        const SizedBox(height: 24),
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: context.pal.card,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: context.pal.border),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(l10n.helpNotFoundTitle,
                style: GoogleFonts.dmSerifDisplay(fontSize: 16, color: context.pal.ink, fontStyle: FontStyle.italic)),
              const SizedBox(height: 8),
              Text(l10n.helpNotFoundBody,
                style: GoogleFonts.dmSans(fontSize: 13, color: context.pal.inkSoft)),
              const SizedBox(height: 12),
              _buildContact(context, l10n.aboutContactSupport, 'suporte@openwhen.app'),
              _buildContact(context, l10n.helpResponseTime, l10n.helpResponseTimeValue),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildLegalContent(
    BuildContext context, {
    required String lastUpdate,
    required String intro,
    required List<_Section> sections,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: context.pal.accentWarm,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: context.pal.accent.withOpacity(0.2)),
          ),
          child: Row(
            children: [
              Icon(Icons.info_outline, size: 16, color: context.pal.accent),
              const SizedBox(width: 8),
              Text(lastUpdate,
                style: GoogleFonts.dmSans(fontSize: 12, color: context.pal.accent, fontWeight: FontWeight.w500)),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Text(intro,
          style: GoogleFonts.dmSans(fontSize: 13, color: context.pal.inkSoft, height: 1.7)),
        const SizedBox(height: 24),
        ...sections.map((s) => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(s.title,
              style: GoogleFonts.dmSans(fontSize: 14, color: context.pal.ink, fontWeight: FontWeight.w700)),
            const SizedBox(height: 6),
            Text(s.content,
              style: GoogleFonts.dmSans(fontSize: 13, color: context.pal.inkSoft, height: 1.7)),
            const SizedBox(height: 20),
          ],
        )),
      ],
    );
  }

  Widget _buildInfoCard(BuildContext context, String emoji, String title, String content) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: context.pal.card,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: context.pal.border),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(emoji, style: const TextStyle(fontSize: 22)),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: GoogleFonts.dmSans(fontSize: 14, color: context.pal.ink, fontWeight: FontWeight.w600)),
                const SizedBox(height: 4),
                Text(content, style: GoogleFonts.dmSans(fontSize: 12, color: context.pal.inkSoft, height: 1.6)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFaq(BuildContext context, String question, String answer) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: context.pal.card,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: context.pal.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(question,
            style: GoogleFonts.dmSans(fontSize: 14, color: context.pal.ink, fontWeight: FontWeight.w600)),
          const SizedBox(height: 6),
          Text(answer,
            style: GoogleFonts.dmSans(fontSize: 13, color: context.pal.inkSoft, height: 1.6)),
        ],
      ),
    );
  }

  Widget _buildContact(BuildContext context, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        children: [
          Text('$label: ', style: GoogleFonts.dmSans(fontSize: 13, color: context.pal.inkSoft)),
          Text(value, style: GoogleFonts.dmSans(fontSize: 13, color: context.pal.accent, fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }
}

class _Section {
  final String title;
  final String content;
  const _Section(this.title, this.content);
}
