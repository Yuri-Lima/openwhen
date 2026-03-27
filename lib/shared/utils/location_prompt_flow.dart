import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../l10n/app_localizations.dart';
import 'location_capture.dart';

/// Shown when saving a letter or capsule: optional share + optional 10 m open restriction.
Future<({Map<String, dynamic>? senderLocation, bool openRequiresProximity})>
    promptSenderLocationAndProximity(
  BuildContext context,
  AppLocalizations l10n,
) async {
  final share = await showDialog<bool>(
    context: context,
    builder: (ctx) => AlertDialog(
      title: Text(l10n.locationAskShareTitle),
      content: Text(l10n.locationAskShareBody),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(ctx, false),
          child: Text(l10n.locationAskShareDeny),
        ),
        TextButton(
          onPressed: () => Navigator.pop(ctx, true),
          child: Text(l10n.locationAskShareAllow),
        ),
      ],
    ),
  );
  if (share != true) {
    return (senderLocation: null, openRequiresProximity: false);
  }

  final pos = await tryGetCurrentPosition();
  if (!context.mounted) {
    return (senderLocation: null, openRequiresProximity: false);
  }
  if (pos == null) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(l10n.locationCaptureFailed)),
    );
    return (senderLocation: null, openRequiresProximity: false);
  }

  final senderLocation = <String, dynamic>{
    'lat': pos.latitude,
    'lng': pos.longitude,
    'capturedAt': Timestamp.now(),
  };

  final restrict = await showDialog<bool>(
    context: context,
    builder: (ctx) => AlertDialog(
      title: Text(l10n.locationAskRestrictTitle),
      content: Text(l10n.locationAskRestrictBody),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(ctx, false),
          child: Text(l10n.locationAskRestrictNo),
        ),
        TextButton(
          onPressed: () => Navigator.pop(ctx, true),
          child: Text(l10n.locationAskRestrictYes),
        ),
      ],
    ),
  );

  return (
    senderLocation: senderLocation,
    openRequiresProximity: restrict == true,
  );
}
