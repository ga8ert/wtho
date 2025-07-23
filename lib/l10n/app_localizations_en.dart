// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get hello => 'Hello';

  @override
  String get welcome => 'Welcome to our app!';

  @override
  String get logout => 'Log out';

  @override
  String get login => 'Log in';

  @override
  String get sign_up => 'Sign Up';

  @override
  String get email => 'Email';

  @override
  String get password => 'Password';

  @override
  String get settings => 'Settings';

  @override
  String get language => 'Language';

  @override
  String get confirm => 'Confirm';

  @override
  String get cancel => 'Cancel';

  @override
  String get logo1 => 'WHO TO\n';

  @override
  String get logo2 => 'HANG OUT';

  @override
  String get login_with_email => 'Log in with Email';

  @override
  String get sign_in_with_facebook => 'Sign in with Facebook';

  @override
  String get sign_in_with_google => 'Sign in with Google';

  @override
  String get name => 'Name';

  @override
  String get surname => 'Surname';

  @override
  String get age => 'Age';

  @override
  String get city => 'City';

  @override
  String get registration => 'Registration';

  @override
  String get registration_success => 'Registration Success!';

  @override
  String get groups_nearby => 'Groups nearby';

  @override
  String get profile => 'Profile';

  @override
  String get email_verification_sent => 'Email Verification Sent';

  @override
  String get please_verify_email => 'Please Verify Email';

  @override
  String get take_a_photo => 'Take a photo';

  @override
  String get choose_from_gallery => 'Choose from gallery';

  @override
  String get ok => 'Ok';

  @override
  String get error => 'Error';

  @override
  String get confirm_email => 'Confirm email';

  @override
  String get please_confirm_email => 'Please confirm your email using the link in the email. After confirming, click - I confirmed.';

  @override
  String get email_not_yet_confirmed => 'Email not confirmed yet!';

  @override
  String get i_confirmed => 'I confirmed';

  @override
  String get letter_has_been_sent => 'The letter has been sent!';

  @override
  String get send_a_letter => 'Send a letter';

  @override
  String get events => 'Events';

  @override
  String get friends => 'Friends';

  @override
  String get no_events => 'No events';

  @override
  String get no_data => 'No data to display';

  @override
  String get km => 'km';

  @override
  String get please_confirm_email_before_login => 'Please confirm your email before logging in.';

  @override
  String get email_not_verified => 'Email is not verified yet.';

  @override
  String email_verification_error(Object error) {
    return 'Email verification error: $error';
  }

  @override
  String email_send_error(Object error) {
    return 'Failed to send email: $error';
  }

  @override
  String get fill_all_required_fields => 'Please fill in all required fields.';

  @override
  String error_with_message(Object error) {
    return 'Error: $error';
  }

  @override
  String get create_event => 'Create event';

  @override
  String get title => 'Title';

  @override
  String get place => 'Place';

  @override
  String get offline => 'Offline';

  @override
  String get online => 'Online';

  @override
  String get hybrid => 'Hybrid';

  @override
  String get meeting_type => 'Meeting type';

  @override
  String map_point_selected(Object lat, Object lng) {
    return 'Map point: $lat, $lng';
  }

  @override
  String get map_point_not_selected => 'Map point not selected';

  @override
  String get select_on_map => 'Select on map';

  @override
  String start_time(Object time) {
    return 'Start: $time';
  }

  @override
  String get select_start_time => 'Select start date and time';

  @override
  String get done => 'Done';

  @override
  String get select => 'Select';

  @override
  String end_time(Object time) {
    return 'End: $time';
  }

  @override
  String get select_end_time => 'Select end date and time';

  @override
  String users_added(Object count) {
    return 'Users added: $count';
  }

  @override
  String get no_users_selected => 'No users selected';

  @override
  String get add_users => 'Add users';

  @override
  String get chat_not_implemented => 'Chat is not implemented yet';

  @override
  String get description => 'Description';

  @override
  String get failed_to_get_uid => 'Failed to get uid';

  @override
  String get event_created => 'Event created!';

  @override
  String get determining_location => 'Determining location...';

  @override
  String get location_unavailable => 'Location unavailable';

  @override
  String get add => 'Add';

  @override
  String get decline => 'Decline';

  @override
  String get select_point_on_map => 'Select point on map';

  @override
  String get select_friends => 'Select friends';

  @override
  String get no_friends => 'You have no friends';

  @override
  String get no_name => 'No name';

  @override
  String get ukrainian => 'Ukrainian';

  @override
  String get join_request_sent => 'Join request sent!';

  @override
  String get description_missing => 'Description missing';

  @override
  String get participants => 'Participants';

  @override
  String get originator => 'Originator';

  @override
  String get join_requests => 'Join requests';

  @override
  String get get_directions => 'Get directions';

  @override
  String get sending => 'Sending';

  @override
  String get invite_to_join_the_event => 'Invite to join the event';

  @override
  String get go_to_chat => 'Go to chat';

  @override
  String get english => 'English';

  @override
  String get delete_account => 'Delete Account';

  @override
  String get delete_account_confirm => 'Are you sure you want to delete your account? This action cannot be undone.';

  @override
  String get no_friends_yet => 'No friends yet.';

  @override
  String get no_users_found => 'No users found.';

  @override
  String get search_by_nickname => 'Search by nickname';

  @override
  String get nickname => 'Nickname';

  @override
  String get nickname_too_short => 'Nickname must be at least 4 characters';

  @override
  String get nickname_taken => 'Nickname already taken';

  @override
  String get registration_success_check_email => 'Registration successful! Please check your email.';

  @override
  String get unknown => '?';

  @override
  String get ellipsis => '...';

  @override
  String get friend_request_sent => 'Friend request sent';

  @override
  String get event_type_social_bar => 'Bar hangout';

  @override
  String get event_type_social_bar_emoji => '🎉🍻';

  @override
  String get event_type_social_hangout => 'Just hang out';

  @override
  String get event_type_social_hangout_emoji => '🕺💃';

  @override
  String get event_type_social_neighbors => 'Neighbors meetup';

  @override
  String get event_type_social_neighbors_emoji => '🏢🤝';

  @override
  String get event_type_social_coffee => 'Go for coffee';

  @override
  String get event_type_social_coffee_emoji => '☕️🗨️';

  @override
  String get event_type_social_newcomers => 'Newcomers in the city';

  @override
  String get event_type_social_newcomers_emoji => '🆕🏙️';

  @override
  String get event_type_social_introverts => 'Introverts gathering';

  @override
  String get event_type_social_introverts_emoji => '😶‍🌫️📚';

  @override
  String get event_type_social_movie_pizza => 'Movie & pizza night';

  @override
  String get event_type_social_movie_pizza_emoji => '🍕🎬';

  @override
  String get event_type_social_memes_tea => 'Memes & tea evening';

  @override
  String get event_type_social_memes_tea_emoji => '😂🍵';

  @override
  String get event_type_social_talk => 'Just talk';

  @override
  String get event_type_social_talk_emoji => '🗣️💬';

  @override
  String get event_type_social_relax => 'Afterwork relax';

  @override
  String get event_type_social_relax_emoji => '🧘‍♂️🌙';

  @override
  String get event_type_sport_company => 'Company for sports';

  @override
  String get event_type_sport_company_emoji => '🏋️‍♀️🤸‍♂️';

  @override
  String get event_type_sport_play => 'Let\'s play something';

  @override
  String get event_type_sport_play_emoji => '⚽🏐🏓';

  @override
  String get event_type_sport_gym => 'Going to the gym — join me?';

  @override
  String get event_type_sport_gym_emoji => '🏋️‍♂️🤝';

  @override
  String get event_type_sport_morning => 'Morning workout';

  @override
  String get event_type_sport_morning_emoji => '🌅🤸‍♀️';

  @override
  String get event_type_sport_trip => 'Mini day trip';

  @override
  String get event_type_sport_trip_emoji => '🚌🏞️';

  @override
  String get event_type_sport_beach => 'Beach / river day';

  @override
  String get event_type_sport_beach_emoji => '🏖️🍉';

  @override
  String get event_type_sport_dog => 'Walk the dog';

  @override
  String get event_type_sport_dog_emoji => '🐕🚶‍♂️';

  @override
  String get event_type_sport_cafe => 'Trying a new cafe';

  @override
  String get event_type_sport_cafe_emoji => '☕️🆕';

  @override
  String get event_type_games_board => 'Board games in park/cafe';

  @override
  String get event_type_games_board_emoji => '🎲🃏';

  @override
  String get event_type_games_night => 'Game night / PlayStation';

  @override
  String get event_type_games_night_emoji => '🎮🕹️';

  @override
  String get event_type_games_standup => 'Comedy room / standup';

  @override
  String get event_type_games_standup_emoji => '😂🎤';

  @override
  String get event_type_games_karaoke => 'Karaoke night';

  @override
  String get event_type_games_karaoke_emoji => '🎤🎶';

  @override
  String get event_type_games_cook => 'Cooking together';

  @override
  String get event_type_games_cook_emoji => '🍳👩‍🍳';

  @override
  String get event_type_games_creative => 'Creative meetup';

  @override
  String get event_type_games_creative_emoji => '🎨✍️';

  @override
  String get event_type_games_language => 'Language tandem';

  @override
  String get event_type_games_language_emoji => '🗣️🇬🇧🇩🇪🇺🇦';

  @override
  String get event_type_games_quest => 'Quest / bowling / VR';

  @override
  String get event_type_games_quest_emoji => '🕵️🎳🕶️';

  @override
  String get event_type_chill_picnic => 'Picnic for no reason';

  @override
  String get event_type_chill_picnic_emoji => '🧺🎸';

  @override
  String get event_type_chill_yard => 'Chill in the yard/roof';

  @override
  String get event_type_chill_yard_emoji => '🏡🌇';

  @override
  String get event_type_chill_morning_coffee => 'Morning coffee before work';

  @override
  String get event_type_chill_morning_coffee_emoji => '🌅☕️';

  @override
  String get event_type_chill_blanket => 'Blanket & thermos hangout';

  @override
  String get event_type_chill_blanket_emoji => '🧣🍂';

  @override
  String get filters => 'Filters';

  @override
  String get radius => 'Radius (km)';

  @override
  String get reset_filters => 'Reset';

  @override
  String get event_type_other => 'Other';

  @override
  String get event_type_other_emoji => '🤷🤔🧐';

  @override
  String get who_am_i_with => 'Who am I with?';

  @override
  String get save => 'Save';

  @override
  String get failed_to_save => 'Failed to save';

  @override
  String get failed_to_load_friends => 'Failed to load friends';

  @override
  String get no_friends_found => 'No friends found';

  @override
  String get my_events => 'My events';

  @override
  String get joined_events => 'Joined events';

  @override
  String chat_expiry(Object days) {
    return 'Chat will be available for $days more days after the event ends.';
  }

  @override
  String get chat_expired => 'Chat expired and will be deleted soon.';

  @override
  String get chat_input_hint => 'Type a message...';

  @override
  String get no_chat_id_for_event => 'No chatId for this event!';

  @override
  String get add_photo => 'Add photo';

  @override
  String get support_us => 'Support Us';

  @override
  String get support_us_title => 'Support our project!';

  @override
  String get support_us_body => 'If you like our app, you can support us and help us grow. Your support motivates us to make the app even better!';

  @override
  String get support_us_action => 'Support';

  @override
  String get support_us_thank_you => 'Thank you for your support!';

  @override
  String get photo_not_selected => 'Photo not selected.';

  @override
  String get file_too_large => 'File is too large. Max 8 MB.';

  @override
  String get file_not_exists => 'File does not exist or path is empty.';

  @override
  String get failed_to_upload_photo => 'Failed to upload photo.';

  @override
  String error_with_colon(Object error) {
    return 'Error: $error';
  }

  @override
  String get location_permission => 'Location Permission';

  @override
  String get location_permission_message => 'To use this feature, please allow location access in the app settings.';

  @override
  String get open_settings => 'Open Settings';

  @override
  String get location_permission_denied => 'Location permission is permanently denied. Please enable it in the app settings.';

  @override
  String get with_friends => 'Here you can choose the friends you are currently hanging out with.';

  @override
  String get event_group_social => '🎉 Social / Hangout';

  @override
  String get event_group_sport => '🏃‍♀️ Activity / Sport';

  @override
  String get event_group_games => '🎲 Board games / Fun';

  @override
  String get event_group_chill => '🌳 Chill';

  @override
  String get public_chat_title => 'Open chat (anyone can join)';

  @override
  String get private_chat_title => 'Private chat (only approved users can join)';

  @override
  String get public_chat_subtitle => 'Chat will be available to everyone.';

  @override
  String get private_chat_subtitle => 'Chat will be available only after approval.';

  @override
  String get public_chat_confirm => 'Open chat will be visible to everyone. Are you sure you want to make the chat public?';

  @override
  String get edit_profile_title => 'Edit profile';

  @override
  String get edit_profile_soon => 'Edit profile coming soon!';

  @override
  String get edit_profile_ok => 'OK';

  @override
  String get edit => 'Edit';

  @override
  String get preview => 'Preview';

  @override
  String get media => 'Media';

  @override
  String get about_me => 'About Me';

  @override
  String get about_me_hint => 'Tell something about yourself...';
}
