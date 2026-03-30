/// Response from callable [adminGetModerationInfo] (no secrets).
class AdminModerationInfo {
  const AdminModerationInfo({
    required this.providerId,
    required this.credentialsConfigured,
  });

  final String providerId;
  final bool credentialsConfigured;
}
