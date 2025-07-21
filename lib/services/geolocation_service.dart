import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'dart:io' show Platform;
import '../l10n/app_localizations.dart';

class GeolocationService {
  static Future<Position?> getCurrentPosition({BuildContext? context}) async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return null;
    }
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // For Android: show dialog with explanation
        if (!kIsWeb && Platform.isAndroid && context != null) {
          await showDialog(
            context: context,
            builder: (ctx) => AlertDialog(
              title: Text(AppLocalizations.of(context)!.location_permission),
              content: Text(
                AppLocalizations.of(context)!.location_permission_message,
              ),
              actions: [
                TextButton(
                  onPressed: () async {
                    Navigator.of(ctx).pop();
                    await Geolocator.openAppSettings();
                  },
                  child: Text(AppLocalizations.of(context)!.open_settings),
                ),
                TextButton(
                  onPressed: () => Navigator.of(ctx).pop(),
                  child: Text(AppLocalizations.of(context)!.cancel),
                ),
              ],
            ),
          );
        }
        return null;
      }
    }
    if (permission == LocationPermission.deniedForever) {
      // For Android: show dialog with explanation
      if (!kIsWeb && Platform.isAndroid && context != null) {
        await showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: Text(AppLocalizations.of(context)!.location_permission),
            content: Text(
              AppLocalizations.of(context)!.location_permission_denied,
            ),
            actions: [
              TextButton(
                onPressed: () async {
                  Navigator.of(ctx).pop();
                  await Geolocator.openAppSettings();
                },
                child: Text(AppLocalizations.of(context)!.open_settings),
              ),
              TextButton(
                onPressed: () => Navigator.of(ctx).pop(),
                child: Text(AppLocalizations.of(context)!.cancel),
              ),
            ],
          ),
        );
      }
      return null;
    }
    final pos = await Geolocator.getCurrentPosition();
    return pos;
  }
}
