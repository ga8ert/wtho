part of 'settings_bloc.dart';

abstract class SettingsEvent {}

class LoadSettings extends SettingsEvent {}

class ChangeLanguage extends SettingsEvent {
  final Locale locale;
  ChangeLanguage(this.locale);
}
