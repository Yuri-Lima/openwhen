/// Normalizes an email for stable matching (Firestore + claim callable).
/// Keep in sync with [normalizeReceiverEmailForMatching] in `functions/src/external_letters.ts`.
String normalizeReceiverEmailForMatching(String email) {
  return email.trim().toLowerCase();
}
