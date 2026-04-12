import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Banner shown when the user's account is in `pending_deletion` state.
///
/// Displays how many days remain and a button to cancel the deletion.
class PendingDeletionBanner extends StatelessWidget {
  const PendingDeletionBanner({
    super.key,
    required this.daysRemaining,
    required this.onCancel,
    required this.cancelLabel,
    required this.messageBuilder,
  });

  final int daysRemaining;
  final VoidCallback onCancel;
  final String cancelLabel;

  /// Builds the message text, receiving `daysRemaining` so the caller
  /// can produce a localised string like "Conta agendada para exclusão em X dias".
  final String Function(int days) messageBuilder;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFFEF2F2), // light red bg
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFFCA5A5), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.warning_amber_rounded,
                  color: Color(0xFFDC2626), size: 20),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  messageBuilder(daysRemaining),
                  style: GoogleFonts.dmSans(
                    fontSize: 13,
                    color: const Color(0xFF991B1B),
                    fontWeight: FontWeight.w500,
                    height: 1.4,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              onPressed: onCancel,
              style: OutlinedButton.styleFrom(
                foregroundColor: const Color(0xFFDC2626),
                side: const BorderSide(color: Color(0xFFFCA5A5)),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8)),
                padding: const EdgeInsets.symmetric(vertical: 10),
              ),
              child: Text(cancelLabel,
                  style: GoogleFonts.dmSans(
                      fontSize: 13, fontWeight: FontWeight.w600)),
            ),
          ),
        ],
      ),
    );
  }
}
