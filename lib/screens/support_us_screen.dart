import 'package:flutter/material.dart';
import '../l10n/app_localizations.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';

class SupportUsScreen extends StatefulWidget {
  const SupportUsScreen({super.key});

  @override
  State<SupportUsScreen> createState() => _SupportUsScreenState();
}

class _SupportUsScreenState extends State<SupportUsScreen> {
  Future<String> _fetchSupportLink() async {
    final remoteConfig = FirebaseRemoteConfig.instance;
    await remoteConfig.setConfigSettings(
      RemoteConfigSettings(
        fetchTimeout: const Duration(seconds: 10),
        minimumFetchInterval: Duration.zero,
      ),
    );
    try {
      await remoteConfig.setDefaults({'monobank_link': ''});
      await remoteConfig.fetchAndActivate();
    } catch (_) {}
    return remoteConfig.getString('monobank_link');
  }

  Future<void> _launchSupportLink(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
      if (!mounted) return;
    } else {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context)!.support_us_thank_you),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.support_us),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () {
            if (!mounted) return;
            Navigator.of(context).pop();
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 32),
            Icon(Icons.favorite, color: Colors.red, size: 64),
            const SizedBox(height: 24),
            Text(
              AppLocalizations.of(context)!.support_us_title,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            Text(
              AppLocalizations.of(context)!.support_us_body,
              style: const TextStyle(fontSize: 16),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            FutureBuilder<String>(
              future: _fetchSupportLink(),
              builder: (context, snapshot) {
                final url = snapshot.data ?? '';
                final isReady =
                    snapshot.connectionState == ConnectionState.done &&
                    url.isNotEmpty;
                return ElevatedButton.icon(
                  icon: const Icon(Icons.favorite),
                  label: Text(AppLocalizations.of(context)!.support_us_action),
                  onPressed: isReady
                      ? () async {
                          if (!mounted) return;
                          await _launchSupportLink(url);
                        }
                      : null,
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
