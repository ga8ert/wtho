import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_uk.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale) : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('uk')
  ];

  /// Simple greeting
  ///
  /// In en, this message translates to:
  /// **'Hello'**
  String get hello;

  /// No description provided for @welcome.
  ///
  /// In en, this message translates to:
  /// **'Welcome to our app!'**
  String get welcome;

  /// No description provided for @logout.
  ///
  /// In en, this message translates to:
  /// **'Log out'**
  String get logout;

  /// No description provided for @login.
  ///
  /// In en, this message translates to:
  /// **'Log in'**
  String get login;

  /// No description provided for @sign_up.
  ///
  /// In en, this message translates to:
  /// **'Sign Up'**
  String get sign_up;

  /// No description provided for @email.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get email;

  /// No description provided for @password.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @confirm.
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get confirm;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @logo1.
  ///
  /// In en, this message translates to:
  /// **'WHO TO\n'**
  String get logo1;

  /// No description provided for @logo2.
  ///
  /// In en, this message translates to:
  /// **'HANG OUT'**
  String get logo2;

  /// No description provided for @login_with_email.
  ///
  /// In en, this message translates to:
  /// **'Log in with Email'**
  String get login_with_email;

  /// No description provided for @sign_in_with_facebook.
  ///
  /// In en, this message translates to:
  /// **'Sign in with Facebook'**
  String get sign_in_with_facebook;

  /// No description provided for @sign_in_with_google.
  ///
  /// In en, this message translates to:
  /// **'Sign in with Google'**
  String get sign_in_with_google;

  /// No description provided for @name.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get name;

  /// No description provided for @surname.
  ///
  /// In en, this message translates to:
  /// **'Surname'**
  String get surname;

  /// No description provided for @age.
  ///
  /// In en, this message translates to:
  /// **'Age'**
  String get age;

  /// No description provided for @city.
  ///
  /// In en, this message translates to:
  /// **'City'**
  String get city;

  /// No description provided for @registration.
  ///
  /// In en, this message translates to:
  /// **'Registration'**
  String get registration;

  /// No description provided for @registration_success.
  ///
  /// In en, this message translates to:
  /// **'Registration Success!'**
  String get registration_success;

  /// No description provided for @groups_nearby.
  ///
  /// In en, this message translates to:
  /// **'Groups nearby'**
  String get groups_nearby;

  /// No description provided for @profile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profile;

  /// No description provided for @email_verification_sent.
  ///
  /// In en, this message translates to:
  /// **'Email Verification Sent'**
  String get email_verification_sent;

  /// No description provided for @please_verify_email.
  ///
  /// In en, this message translates to:
  /// **'Please Verify Email'**
  String get please_verify_email;

  /// No description provided for @take_a_photo.
  ///
  /// In en, this message translates to:
  /// **'Take a photo'**
  String get take_a_photo;

  /// No description provided for @choose_from_gallery.
  ///
  /// In en, this message translates to:
  /// **'Choose from gallery'**
  String get choose_from_gallery;

  /// No description provided for @ok.
  ///
  /// In en, this message translates to:
  /// **'Ok'**
  String get ok;

  /// No description provided for @error.
  ///
  /// In en, this message translates to:
  /// **'Error'**
  String get error;

  /// No description provided for @confirm_email.
  ///
  /// In en, this message translates to:
  /// **'Confirm email'**
  String get confirm_email;

  /// No description provided for @please_confirm_email.
  ///
  /// In en, this message translates to:
  /// **'Please confirm your email using the link in the email. After confirming, click - I confirmed.'**
  String get please_confirm_email;

  /// No description provided for @email_not_yet_confirmed.
  ///
  /// In en, this message translates to:
  /// **'Email not confirmed yet!'**
  String get email_not_yet_confirmed;

  /// No description provided for @i_confirmed.
  ///
  /// In en, this message translates to:
  /// **'I confirmed'**
  String get i_confirmed;

  /// No description provided for @letter_has_been_sent.
  ///
  /// In en, this message translates to:
  /// **'The letter has been sent!'**
  String get letter_has_been_sent;

  /// No description provided for @send_a_letter.
  ///
  /// In en, this message translates to:
  /// **'Send a letter'**
  String get send_a_letter;

  /// No description provided for @events.
  ///
  /// In en, this message translates to:
  /// **'Events'**
  String get events;

  /// No description provided for @friends.
  ///
  /// In en, this message translates to:
  /// **'Friends'**
  String get friends;

  /// No description provided for @no_events.
  ///
  /// In en, this message translates to:
  /// **'No events'**
  String get no_events;

  /// No description provided for @no_data.
  ///
  /// In en, this message translates to:
  /// **'No data to display'**
  String get no_data;

  /// No description provided for @km.
  ///
  /// In en, this message translates to:
  /// **'km'**
  String get km;

  /// No description provided for @please_confirm_email_before_login.
  ///
  /// In en, this message translates to:
  /// **'Please confirm your email before logging in.'**
  String get please_confirm_email_before_login;

  /// No description provided for @email_not_verified.
  ///
  /// In en, this message translates to:
  /// **'Email is not verified yet.'**
  String get email_not_verified;

  /// No description provided for @email_verification_error.
  ///
  /// In en, this message translates to:
  /// **'Email verification error: {error}'**
  String email_verification_error(Object error);

  /// No description provided for @email_send_error.
  ///
  /// In en, this message translates to:
  /// **'Failed to send email: {error}'**
  String email_send_error(Object error);

  /// No description provided for @fill_all_required_fields.
  ///
  /// In en, this message translates to:
  /// **'Please fill in all required fields.'**
  String get fill_all_required_fields;

  /// No description provided for @error_with_message.
  ///
  /// In en, this message translates to:
  /// **'Error: {error}'**
  String error_with_message(Object error);

  /// No description provided for @create_event.
  ///
  /// In en, this message translates to:
  /// **'Create event'**
  String get create_event;

  /// No description provided for @title.
  ///
  /// In en, this message translates to:
  /// **'Title'**
  String get title;

  /// No description provided for @place.
  ///
  /// In en, this message translates to:
  /// **'Place'**
  String get place;

  /// No description provided for @offline.
  ///
  /// In en, this message translates to:
  /// **'Offline'**
  String get offline;

  /// No description provided for @online.
  ///
  /// In en, this message translates to:
  /// **'Online'**
  String get online;

  /// No description provided for @hybrid.
  ///
  /// In en, this message translates to:
  /// **'Hybrid'**
  String get hybrid;

  /// No description provided for @meeting_type.
  ///
  /// In en, this message translates to:
  /// **'Meeting type'**
  String get meeting_type;

  /// No description provided for @map_point_selected.
  ///
  /// In en, this message translates to:
  /// **'Map point: {lat}, {lng}'**
  String map_point_selected(Object lat, Object lng);

  /// No description provided for @map_point_not_selected.
  ///
  /// In en, this message translates to:
  /// **'Map point not selected'**
  String get map_point_not_selected;

  /// No description provided for @select_on_map.
  ///
  /// In en, this message translates to:
  /// **'Select on map'**
  String get select_on_map;

  /// No description provided for @start_time.
  ///
  /// In en, this message translates to:
  /// **'Start: {time}'**
  String start_time(Object time);

  /// No description provided for @select_start_time.
  ///
  /// In en, this message translates to:
  /// **'Select start date and time'**
  String get select_start_time;

  /// No description provided for @done.
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get done;

  /// No description provided for @select.
  ///
  /// In en, this message translates to:
  /// **'Select'**
  String get select;

  /// No description provided for @end_time.
  ///
  /// In en, this message translates to:
  /// **'End: {time}'**
  String end_time(Object time);

  /// No description provided for @select_end_time.
  ///
  /// In en, this message translates to:
  /// **'Select end date and time'**
  String get select_end_time;

  /// No description provided for @users_added.
  ///
  /// In en, this message translates to:
  /// **'Users added: {count}'**
  String users_added(Object count);

  /// No description provided for @no_users_selected.
  ///
  /// In en, this message translates to:
  /// **'No users selected'**
  String get no_users_selected;

  /// No description provided for @add_users.
  ///
  /// In en, this message translates to:
  /// **'Add users'**
  String get add_users;

  /// No description provided for @chat_not_implemented.
  ///
  /// In en, this message translates to:
  /// **'Chat is not implemented yet'**
  String get chat_not_implemented;

  /// No description provided for @description.
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get description;

  /// No description provided for @failed_to_get_uid.
  ///
  /// In en, this message translates to:
  /// **'Failed to get uid'**
  String get failed_to_get_uid;

  /// No description provided for @event_created.
  ///
  /// In en, this message translates to:
  /// **'Event created!'**
  String get event_created;

  /// No description provided for @determining_location.
  ///
  /// In en, this message translates to:
  /// **'Determining location...'**
  String get determining_location;

  /// No description provided for @location_unavailable.
  ///
  /// In en, this message translates to:
  /// **'Location unavailable'**
  String get location_unavailable;

  /// No description provided for @add.
  ///
  /// In en, this message translates to:
  /// **'Add'**
  String get add;

  /// No description provided for @decline.
  ///
  /// In en, this message translates to:
  /// **'Decline'**
  String get decline;

  /// No description provided for @select_point_on_map.
  ///
  /// In en, this message translates to:
  /// **'Select point on map'**
  String get select_point_on_map;

  /// No description provided for @select_friends.
  ///
  /// In en, this message translates to:
  /// **'Select friends'**
  String get select_friends;

  /// No description provided for @no_friends.
  ///
  /// In en, this message translates to:
  /// **'You have no friends'**
  String get no_friends;

  /// No description provided for @no_name.
  ///
  /// In en, this message translates to:
  /// **'No name'**
  String get no_name;

  /// No description provided for @ukrainian.
  ///
  /// In en, this message translates to:
  /// **'Ukrainian'**
  String get ukrainian;

  /// No description provided for @join_request_sent.
  ///
  /// In en, this message translates to:
  /// **'Join request sent!'**
  String get join_request_sent;

  /// No description provided for @description_missing.
  ///
  /// In en, this message translates to:
  /// **'Description missing'**
  String get description_missing;

  /// No description provided for @participants.
  ///
  /// In en, this message translates to:
  /// **'Participants'**
  String get participants;

  /// No description provided for @originator.
  ///
  /// In en, this message translates to:
  /// **'Originator'**
  String get originator;

  /// No description provided for @join_requests.
  ///
  /// In en, this message translates to:
  /// **'Join requests'**
  String get join_requests;

  /// No description provided for @get_directions.
  ///
  /// In en, this message translates to:
  /// **'Get directions'**
  String get get_directions;

  /// No description provided for @sending.
  ///
  /// In en, this message translates to:
  /// **'Sending'**
  String get sending;

  /// No description provided for @invite_to_join_the_event.
  ///
  /// In en, this message translates to:
  /// **'Invite to join the event'**
  String get invite_to_join_the_event;

  /// No description provided for @go_to_chat.
  ///
  /// In en, this message translates to:
  /// **'Go to chat'**
  String get go_to_chat;

  /// No description provided for @english.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get english;

  /// No description provided for @delete_account.
  ///
  /// In en, this message translates to:
  /// **'Delete Account'**
  String get delete_account;

  /// No description provided for @delete_account_confirm.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete your account? This action cannot be undone.'**
  String get delete_account_confirm;

  /// No description provided for @no_friends_yet.
  ///
  /// In en, this message translates to:
  /// **'No friends yet.'**
  String get no_friends_yet;

  /// No description provided for @no_users_found.
  ///
  /// In en, this message translates to:
  /// **'No users found.'**
  String get no_users_found;

  /// No description provided for @search_by_nickname.
  ///
  /// In en, this message translates to:
  /// **'Search by nickname'**
  String get search_by_nickname;

  /// No description provided for @nickname.
  ///
  /// In en, this message translates to:
  /// **'Nickname'**
  String get nickname;

  /// No description provided for @nickname_too_short.
  ///
  /// In en, this message translates to:
  /// **'Nickname must be at least 4 characters'**
  String get nickname_too_short;

  /// No description provided for @nickname_taken.
  ///
  /// In en, this message translates to:
  /// **'Nickname already taken'**
  String get nickname_taken;

  /// No description provided for @registration_success_check_email.
  ///
  /// In en, this message translates to:
  /// **'Registration successful! Please check your email.'**
  String get registration_success_check_email;

  /// No description provided for @unknown.
  ///
  /// In en, this message translates to:
  /// **'?'**
  String get unknown;

  /// No description provided for @ellipsis.
  ///
  /// In en, this message translates to:
  /// **'...'**
  String get ellipsis;

  /// Shown in friends search when a request is already sent but not accepted yet
  ///
  /// In en, this message translates to:
  /// **'Friend request sent'**
  String get friend_request_sent;

  /// No description provided for @event_type_social_bar.
  ///
  /// In en, this message translates to:
  /// **'Bar hangout'**
  String get event_type_social_bar;

  /// No description provided for @event_type_social_bar_emoji.
  ///
  /// In en, this message translates to:
  /// **'🎉🍻'**
  String get event_type_social_bar_emoji;

  /// No description provided for @event_type_social_hangout.
  ///
  /// In en, this message translates to:
  /// **'Just hang out'**
  String get event_type_social_hangout;

  /// No description provided for @event_type_social_hangout_emoji.
  ///
  /// In en, this message translates to:
  /// **'🕺💃'**
  String get event_type_social_hangout_emoji;

  /// No description provided for @event_type_social_neighbors.
  ///
  /// In en, this message translates to:
  /// **'Neighbors meetup'**
  String get event_type_social_neighbors;

  /// No description provided for @event_type_social_neighbors_emoji.
  ///
  /// In en, this message translates to:
  /// **'🏢🤝'**
  String get event_type_social_neighbors_emoji;

  /// No description provided for @event_type_social_coffee.
  ///
  /// In en, this message translates to:
  /// **'Go for coffee'**
  String get event_type_social_coffee;

  /// No description provided for @event_type_social_coffee_emoji.
  ///
  /// In en, this message translates to:
  /// **'☕️🗨️'**
  String get event_type_social_coffee_emoji;

  /// No description provided for @event_type_social_newcomers.
  ///
  /// In en, this message translates to:
  /// **'Newcomers in the city'**
  String get event_type_social_newcomers;

  /// No description provided for @event_type_social_newcomers_emoji.
  ///
  /// In en, this message translates to:
  /// **'🆕🏙️'**
  String get event_type_social_newcomers_emoji;

  /// No description provided for @event_type_social_introverts.
  ///
  /// In en, this message translates to:
  /// **'Introverts gathering'**
  String get event_type_social_introverts;

  /// No description provided for @event_type_social_introverts_emoji.
  ///
  /// In en, this message translates to:
  /// **'😶‍🌫️📚'**
  String get event_type_social_introverts_emoji;

  /// No description provided for @event_type_social_movie_pizza.
  ///
  /// In en, this message translates to:
  /// **'Movie & pizza night'**
  String get event_type_social_movie_pizza;

  /// No description provided for @event_type_social_movie_pizza_emoji.
  ///
  /// In en, this message translates to:
  /// **'🍕🎬'**
  String get event_type_social_movie_pizza_emoji;

  /// No description provided for @event_type_social_memes_tea.
  ///
  /// In en, this message translates to:
  /// **'Memes & tea evening'**
  String get event_type_social_memes_tea;

  /// No description provided for @event_type_social_memes_tea_emoji.
  ///
  /// In en, this message translates to:
  /// **'😂🍵'**
  String get event_type_social_memes_tea_emoji;

  /// No description provided for @event_type_social_talk.
  ///
  /// In en, this message translates to:
  /// **'Just talk'**
  String get event_type_social_talk;

  /// No description provided for @event_type_social_talk_emoji.
  ///
  /// In en, this message translates to:
  /// **'🗣️💬'**
  String get event_type_social_talk_emoji;

  /// No description provided for @event_type_social_relax.
  ///
  /// In en, this message translates to:
  /// **'Afterwork relax'**
  String get event_type_social_relax;

  /// No description provided for @event_type_social_relax_emoji.
  ///
  /// In en, this message translates to:
  /// **'🧘‍♂️🌙'**
  String get event_type_social_relax_emoji;

  /// No description provided for @event_type_sport_company.
  ///
  /// In en, this message translates to:
  /// **'Company for sports'**
  String get event_type_sport_company;

  /// No description provided for @event_type_sport_company_emoji.
  ///
  /// In en, this message translates to:
  /// **'🏋️‍♀️🤸‍♂️'**
  String get event_type_sport_company_emoji;

  /// No description provided for @event_type_sport_play.
  ///
  /// In en, this message translates to:
  /// **'Let\'s play something'**
  String get event_type_sport_play;

  /// No description provided for @event_type_sport_play_emoji.
  ///
  /// In en, this message translates to:
  /// **'⚽🏐🏓'**
  String get event_type_sport_play_emoji;

  /// No description provided for @event_type_sport_gym.
  ///
  /// In en, this message translates to:
  /// **'Going to the gym — join me?'**
  String get event_type_sport_gym;

  /// No description provided for @event_type_sport_gym_emoji.
  ///
  /// In en, this message translates to:
  /// **'🏋️‍♂️🤝'**
  String get event_type_sport_gym_emoji;

  /// No description provided for @event_type_sport_morning.
  ///
  /// In en, this message translates to:
  /// **'Morning workout'**
  String get event_type_sport_morning;

  /// No description provided for @event_type_sport_morning_emoji.
  ///
  /// In en, this message translates to:
  /// **'🌅🤸‍♀️'**
  String get event_type_sport_morning_emoji;

  /// No description provided for @event_type_sport_trip.
  ///
  /// In en, this message translates to:
  /// **'Mini day trip'**
  String get event_type_sport_trip;

  /// No description provided for @event_type_sport_trip_emoji.
  ///
  /// In en, this message translates to:
  /// **'🚌🏞️'**
  String get event_type_sport_trip_emoji;

  /// No description provided for @event_type_sport_beach.
  ///
  /// In en, this message translates to:
  /// **'Beach / river day'**
  String get event_type_sport_beach;

  /// No description provided for @event_type_sport_beach_emoji.
  ///
  /// In en, this message translates to:
  /// **'🏖️🍉'**
  String get event_type_sport_beach_emoji;

  /// No description provided for @event_type_sport_dog.
  ///
  /// In en, this message translates to:
  /// **'Walk the dog'**
  String get event_type_sport_dog;

  /// No description provided for @event_type_sport_dog_emoji.
  ///
  /// In en, this message translates to:
  /// **'🐕🚶‍♂️'**
  String get event_type_sport_dog_emoji;

  /// No description provided for @event_type_sport_cafe.
  ///
  /// In en, this message translates to:
  /// **'Trying a new cafe'**
  String get event_type_sport_cafe;

  /// No description provided for @event_type_sport_cafe_emoji.
  ///
  /// In en, this message translates to:
  /// **'☕️🆕'**
  String get event_type_sport_cafe_emoji;

  /// No description provided for @event_type_games_board.
  ///
  /// In en, this message translates to:
  /// **'Board games in park/cafe'**
  String get event_type_games_board;

  /// No description provided for @event_type_games_board_emoji.
  ///
  /// In en, this message translates to:
  /// **'🎲🃏'**
  String get event_type_games_board_emoji;

  /// No description provided for @event_type_games_night.
  ///
  /// In en, this message translates to:
  /// **'Game night / PlayStation'**
  String get event_type_games_night;

  /// No description provided for @event_type_games_night_emoji.
  ///
  /// In en, this message translates to:
  /// **'🎮🕹️'**
  String get event_type_games_night_emoji;

  /// No description provided for @event_type_games_standup.
  ///
  /// In en, this message translates to:
  /// **'Comedy room / standup'**
  String get event_type_games_standup;

  /// No description provided for @event_type_games_standup_emoji.
  ///
  /// In en, this message translates to:
  /// **'😂🎤'**
  String get event_type_games_standup_emoji;

  /// No description provided for @event_type_games_karaoke.
  ///
  /// In en, this message translates to:
  /// **'Karaoke night'**
  String get event_type_games_karaoke;

  /// No description provided for @event_type_games_karaoke_emoji.
  ///
  /// In en, this message translates to:
  /// **'🎤🎶'**
  String get event_type_games_karaoke_emoji;

  /// No description provided for @event_type_games_cook.
  ///
  /// In en, this message translates to:
  /// **'Cooking together'**
  String get event_type_games_cook;

  /// No description provided for @event_type_games_cook_emoji.
  ///
  /// In en, this message translates to:
  /// **'🍳👩‍🍳'**
  String get event_type_games_cook_emoji;

  /// No description provided for @event_type_games_creative.
  ///
  /// In en, this message translates to:
  /// **'Creative meetup'**
  String get event_type_games_creative;

  /// No description provided for @event_type_games_creative_emoji.
  ///
  /// In en, this message translates to:
  /// **'🎨✍️'**
  String get event_type_games_creative_emoji;

  /// No description provided for @event_type_games_language.
  ///
  /// In en, this message translates to:
  /// **'Language tandem'**
  String get event_type_games_language;

  /// No description provided for @event_type_games_language_emoji.
  ///
  /// In en, this message translates to:
  /// **'🗣️🇬🇧🇩🇪🇺🇦'**
  String get event_type_games_language_emoji;

  /// No description provided for @event_type_games_quest.
  ///
  /// In en, this message translates to:
  /// **'Quest / bowling / VR'**
  String get event_type_games_quest;

  /// No description provided for @event_type_games_quest_emoji.
  ///
  /// In en, this message translates to:
  /// **'🕵️🎳🕶️'**
  String get event_type_games_quest_emoji;

  /// No description provided for @event_type_chill_picnic.
  ///
  /// In en, this message translates to:
  /// **'Picnic for no reason'**
  String get event_type_chill_picnic;

  /// No description provided for @event_type_chill_picnic_emoji.
  ///
  /// In en, this message translates to:
  /// **'🧺🎸'**
  String get event_type_chill_picnic_emoji;

  /// No description provided for @event_type_chill_yard.
  ///
  /// In en, this message translates to:
  /// **'Chill in the yard/roof'**
  String get event_type_chill_yard;

  /// No description provided for @event_type_chill_yard_emoji.
  ///
  /// In en, this message translates to:
  /// **'🏡🌇'**
  String get event_type_chill_yard_emoji;

  /// No description provided for @event_type_chill_morning_coffee.
  ///
  /// In en, this message translates to:
  /// **'Morning coffee before work'**
  String get event_type_chill_morning_coffee;

  /// No description provided for @event_type_chill_morning_coffee_emoji.
  ///
  /// In en, this message translates to:
  /// **'🌅☕️'**
  String get event_type_chill_morning_coffee_emoji;

  /// No description provided for @event_type_chill_blanket.
  ///
  /// In en, this message translates to:
  /// **'Blanket & thermos hangout'**
  String get event_type_chill_blanket;

  /// No description provided for @event_type_chill_blanket_emoji.
  ///
  /// In en, this message translates to:
  /// **'🧣🍂'**
  String get event_type_chill_blanket_emoji;

  /// No description provided for @filters.
  ///
  /// In en, this message translates to:
  /// **'Filters'**
  String get filters;

  /// No description provided for @radius.
  ///
  /// In en, this message translates to:
  /// **'Radius (km)'**
  String get radius;

  /// No description provided for @reset_filters.
  ///
  /// In en, this message translates to:
  /// **'Reset'**
  String get reset_filters;

  /// No description provided for @event_type_other.
  ///
  /// In en, this message translates to:
  /// **'Other'**
  String get event_type_other;

  /// No description provided for @event_type_other_emoji.
  ///
  /// In en, this message translates to:
  /// **'🤷🤔🧐'**
  String get event_type_other_emoji;

  /// No description provided for @who_am_i_with.
  ///
  /// In en, this message translates to:
  /// **'Who am I with?'**
  String get who_am_i_with;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @failed_to_save.
  ///
  /// In en, this message translates to:
  /// **'Failed to save'**
  String get failed_to_save;

  /// No description provided for @failed_to_load_friends.
  ///
  /// In en, this message translates to:
  /// **'Failed to load friends'**
  String get failed_to_load_friends;

  /// No description provided for @no_friends_found.
  ///
  /// In en, this message translates to:
  /// **'No friends found'**
  String get no_friends_found;

  /// No description provided for @my_events.
  ///
  /// In en, this message translates to:
  /// **'My events'**
  String get my_events;

  /// No description provided for @joined_events.
  ///
  /// In en, this message translates to:
  /// **'Joined events'**
  String get joined_events;

  /// No description provided for @chat_expiry.
  ///
  /// In en, this message translates to:
  /// **'Chat will be available for {days} more days after the event ends.'**
  String chat_expiry(Object days);

  /// No description provided for @chat_expired.
  ///
  /// In en, this message translates to:
  /// **'Chat expired and will be deleted soon.'**
  String get chat_expired;

  /// No description provided for @chat_input_hint.
  ///
  /// In en, this message translates to:
  /// **'Type a message...'**
  String get chat_input_hint;

  /// No description provided for @no_chat_id_for_event.
  ///
  /// In en, this message translates to:
  /// **'No chatId for this event!'**
  String get no_chat_id_for_event;

  /// No description provided for @add_photo.
  ///
  /// In en, this message translates to:
  /// **'Add photo'**
  String get add_photo;

  /// No description provided for @support_us.
  ///
  /// In en, this message translates to:
  /// **'Support Us'**
  String get support_us;

  /// No description provided for @support_us_title.
  ///
  /// In en, this message translates to:
  /// **'Support our project!'**
  String get support_us_title;

  /// No description provided for @support_us_body.
  ///
  /// In en, this message translates to:
  /// **'If you like our app, you can support us and help us grow. Your support motivates us to make the app even better!'**
  String get support_us_body;

  /// No description provided for @support_us_action.
  ///
  /// In en, this message translates to:
  /// **'Support'**
  String get support_us_action;

  /// No description provided for @support_us_thank_you.
  ///
  /// In en, this message translates to:
  /// **'Thank you for your support!'**
  String get support_us_thank_you;

  /// No description provided for @photo_not_selected.
  ///
  /// In en, this message translates to:
  /// **'Photo not selected.'**
  String get photo_not_selected;

  /// No description provided for @file_too_large.
  ///
  /// In en, this message translates to:
  /// **'File is too large. Max 8 MB.'**
  String get file_too_large;

  /// No description provided for @file_not_exists.
  ///
  /// In en, this message translates to:
  /// **'File does not exist or path is empty.'**
  String get file_not_exists;

  /// No description provided for @failed_to_upload_photo.
  ///
  /// In en, this message translates to:
  /// **'Failed to upload photo.'**
  String get failed_to_upload_photo;

  /// No description provided for @error_with_colon.
  ///
  /// In en, this message translates to:
  /// **'Error: {error}'**
  String error_with_colon(Object error);

  /// No description provided for @location_permission.
  ///
  /// In en, this message translates to:
  /// **'Location Permission'**
  String get location_permission;

  /// No description provided for @location_permission_message.
  ///
  /// In en, this message translates to:
  /// **'To use this feature, please allow location access in the app settings.'**
  String get location_permission_message;

  /// No description provided for @open_settings.
  ///
  /// In en, this message translates to:
  /// **'Open Settings'**
  String get open_settings;

  /// No description provided for @location_permission_denied.
  ///
  /// In en, this message translates to:
  /// **'Location permission is permanently denied. Please enable it in the app settings.'**
  String get location_permission_denied;

  /// No description provided for @with_friends.
  ///
  /// In en, this message translates to:
  /// **'Here you can choose the friends you are currently hanging out with.'**
  String get with_friends;

  /// No description provided for @event_group_social.
  ///
  /// In en, this message translates to:
  /// **'🎉 Social / Hangout'**
  String get event_group_social;

  /// No description provided for @event_group_sport.
  ///
  /// In en, this message translates to:
  /// **'🏃‍♀️ Activity / Sport'**
  String get event_group_sport;

  /// No description provided for @event_group_games.
  ///
  /// In en, this message translates to:
  /// **'🎲 Board games / Fun'**
  String get event_group_games;

  /// No description provided for @event_group_chill.
  ///
  /// In en, this message translates to:
  /// **'🌳 Chill'**
  String get event_group_chill;

  /// No description provided for @public_chat_title.
  ///
  /// In en, this message translates to:
  /// **'Open chat (anyone can join)'**
  String get public_chat_title;

  /// No description provided for @private_chat_title.
  ///
  /// In en, this message translates to:
  /// **'Private chat (only approved users can join)'**
  String get private_chat_title;

  /// No description provided for @public_chat_subtitle.
  ///
  /// In en, this message translates to:
  /// **'Chat will be available to everyone.'**
  String get public_chat_subtitle;

  /// No description provided for @private_chat_subtitle.
  ///
  /// In en, this message translates to:
  /// **'Chat will be available only after approval.'**
  String get private_chat_subtitle;

  /// No description provided for @public_chat_confirm.
  ///
  /// In en, this message translates to:
  /// **'Open chat will be visible to everyone. Are you sure you want to make the chat public?'**
  String get public_chat_confirm;

  /// No description provided for @edit_profile_title.
  ///
  /// In en, this message translates to:
  /// **'Edit profile'**
  String get edit_profile_title;

  /// No description provided for @edit_profile_soon.
  ///
  /// In en, this message translates to:
  /// **'Edit profile coming soon!'**
  String get edit_profile_soon;

  /// No description provided for @edit_profile_ok.
  ///
  /// In en, this message translates to:
  /// **'OK'**
  String get edit_profile_ok;

  /// No description provided for @edit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get edit;

  /// No description provided for @preview.
  ///
  /// In en, this message translates to:
  /// **'Preview'**
  String get preview;

  /// No description provided for @media.
  ///
  /// In en, this message translates to:
  /// **'Media'**
  String get media;

  /// No description provided for @about_me.
  ///
  /// In en, this message translates to:
  /// **'About Me'**
  String get about_me;

  /// No description provided for @about_me_hint.
  ///
  /// In en, this message translates to:
  /// **'Tell something about yourself...'**
  String get about_me_hint;
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['en', 'uk'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {


  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en': return AppLocalizationsEn();
    case 'uk': return AppLocalizationsUk();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.'
  );
}
