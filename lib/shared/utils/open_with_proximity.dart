import 'package:flutter/material.dart';

import '../../features/capsules/presentation/screens/capsule_opening_screen.dart';
import '../../features/letters/presentation/screens/letter_opening_screen.dart';
import '../../l10n/app_localizations.dart';
import 'proximity_gate.dart';
import 'sender_location.dart';

Future<void> openLetterWithProximityGate(
  BuildContext context, {
  required Map<String, dynamic> data,
  required String docId,
}) async {
  final need = data['openRequiresProximity'] == true;
  final loc = parseSenderLocationData(data['senderLocation']);
  if (!need || loc == null) {
    if (!context.mounted) return;
    await Navigator.push<void>(
      context,
      MaterialPageRoute<void>(
        builder: (_) => LetterOpeningScreen(data: data, docId: docId),
      ),
    );
    return;
  }

  final result = await checkWithinProximityRadius(
    anchorLat: loc.lat,
    anchorLng: loc.lng,
  );
  if (!context.mounted) return;
  final l10n = AppLocalizations.of(context)!;

  if (result == ProximityCheckResult.withinRadius) {
    await Navigator.push<void>(
      context,
      MaterialPageRoute<void>(
        builder: (_) => LetterOpeningScreen(data: data, docId: docId),
      ),
    );
    return;
  }
  if (result == ProximityCheckResult.tooFar) {
    await showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.locationProximityTooFarTitle),
        content: Text(l10n.locationProximityTooFarBody),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(l10n.actionOk),
          ),
        ],
      ),
    );
    return;
  }
  await showDialog<void>(
    context: context,
    builder: (ctx) => AlertDialog(
      title: Text(l10n.locationProximityNeedLocationTitle),
      content: Text(l10n.locationProximityNeedLocationBody),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(ctx),
          child: Text(l10n.actionOk),
        ),
      ],
    ),
  );
}

Future<void> openCapsuleWithProximityGate(
  BuildContext context, {
  required Map<String, dynamic> data,
  required String docId,
}) async {
  final need = data['openRequiresProximity'] == true;
  final loc = parseSenderLocationData(data['senderLocation']);
  if (!need || loc == null) {
    if (!context.mounted) return;
    await Navigator.push<void>(
      context,
      MaterialPageRoute<void>(
        builder: (_) => CapsuleOpeningScreen(data: data, docId: docId),
      ),
    );
    return;
  }

  final result = await checkWithinProximityRadius(
    anchorLat: loc.lat,
    anchorLng: loc.lng,
  );
  if (!context.mounted) return;
  final l10n = AppLocalizations.of(context)!;

  if (result == ProximityCheckResult.withinRadius) {
    await Navigator.push<void>(
      context,
      MaterialPageRoute<void>(
        builder: (_) => CapsuleOpeningScreen(data: data, docId: docId),
      ),
    );
    return;
  }
  if (result == ProximityCheckResult.tooFar) {
    await showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.locationProximityTooFarTitle),
        content: Text(l10n.locationProximityTooFarBody),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(l10n.actionOk),
          ),
        ],
      ),
    );
    return;
  }
  await showDialog<void>(
    context: context,
    builder: (ctx) => AlertDialog(
      title: Text(l10n.locationProximityNeedLocationTitle),
      content: Text(l10n.locationProximityNeedLocationBody),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(ctx),
          child: Text(l10n.actionOk),
        ),
      ],
    ),
  );
}
