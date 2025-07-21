import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/settings/settings_bloc.dart';
import '../l10n/app_localizations.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../bloc/auth/auth_bloc.dart';
import '../bloc/auth/auth_event.dart';
import '../bloc/auth/auth_state.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Align(
          alignment: Alignment.centerLeft,
          child: Text(
            AppLocalizations.of(context)!.settings,
            style: const TextStyle(fontSize: 36, fontWeight: FontWeight.w300),
          ),
        ),
      ),
      backgroundColor: Colors.white,
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is DeleteAccountInProgress) {
            showDialog(
              context: context,
              barrierDismissible: false,
              builder: (context) =>
                  const Center(child: CircularProgressIndicator()),
            );
          } else if (state is DeleteAccountSuccess) {
            Navigator.of(context, rootNavigator: true).pop(); // Close loader
            Navigator.of(context).pop(); // Close settings
          } else if (state is DeleteAccountError) {
            Navigator.of(context, rootNavigator: true).pop(); // Close loader
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.message)));
          }
        },
        child: BlocBuilder<SettingsBloc, SettingsState>(
          builder: (context, state) {
            Locale? currentLocale;
            if (state is SettingsLoaded) {
              currentLocale = state.locale;
            }
            return Column(
              children: [
                ListTile(title: Text(AppLocalizations.of(context)!.language)),
                RadioListTile<Locale>(
                  title: Text(AppLocalizations.of(context)!.english),
                  value: const Locale('en'),
                  groupValue: currentLocale ?? const Locale('en'),
                  onChanged: (locale) {
                    if (locale != null) {
                      context.read<SettingsBloc>().add(ChangeLanguage(locale));
                    }
                  },
                ),
                RadioListTile<Locale>(
                  title: Text(AppLocalizations.of(context)!.ukrainian),
                  value: const Locale('uk'),
                  groupValue: currentLocale ?? const Locale('en'),
                  onChanged: (locale) {
                    if (locale != null) {
                      context.read<SettingsBloc>().add(ChangeLanguage(locale));
                    }
                  },
                ),
                Divider(color: Colors.grey[300], height: 0.5),
                const Spacer(),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 24,
                  ),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
                      minimumSize: const Size.fromHeight(48),
                    ),
                    onPressed: () async {
                      final confirmed = await showDialog<bool>(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: Text(
                            AppLocalizations.of(context)!.delete_account,
                          ),
                          content: Text(
                            AppLocalizations.of(
                              context,
                            )!.delete_account_confirm,
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.of(context).pop(false),
                              child: Text(AppLocalizations.of(context)!.cancel),
                            ),
                            TextButton(
                              onPressed: () => Navigator.of(context).pop(true),
                              child: Text(
                                AppLocalizations.of(context)!.delete_account,
                              ),
                            ),
                          ],
                        ),
                      );
                      if (confirmed == true) {
                        context.read<AuthBloc>().add(DeleteAccountRequested());
                      }
                    },
                    child: Text(AppLocalizations.of(context)!.delete_account),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
