import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'dart:io' show Platform;

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
        // Для Android: показати діалог з поясненням
        if (!kIsWeb && Platform.isAndroid && context != null) {
          await showDialog(
            context: context,
            builder: (ctx) => AlertDialog(
              title: const Text('Location Permission'),
              content: const Text(
                'To use this feature, please allow location access in the app settings.',
              ),
              actions: [
                TextButton(
                  onPressed: () async {
                    Navigator.of(ctx).pop();
                    await Geolocator.openAppSettings();
                  },
                  child: const Text('Open Settings'),
                ),
                TextButton(
                  onPressed: () => Navigator.of(ctx).pop(),
                  child: const Text('Cancel'),
                ),
              ],
            ),
          );
        }
        return null;
      }
    }
    if (permission == LocationPermission.deniedForever) {
      // Для Android: показати діалог з поясненням
      if (!kIsWeb && Platform.isAndroid && context != null) {
        await showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: const Text('Location Permission'),
            content: const Text(
              'Location permission is permanently denied. Please enable it in the app settings.',
            ),
            actions: [
              TextButton(
                onPressed: () async {
                  Navigator.of(ctx).pop();
                  await Geolocator.openAppSettings();
                },
                child: const Text('Open Settings'),
              ),
              TextButton(
                onPressed: () => Navigator.of(ctx).pop(),
                child: const Text('Cancel'),
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
