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
  String get event_type_aquapark => 'Aquapark';

  @override
  String get event_type_aquapark_emoji => '💦🛟👙';

  @override
  String get event_type_art_gallery => 'Art gallery';

  @override
  String get event_type_art_gallery_emoji => '🖼️🎨🧑‍🎨';

  @override
  String get event_type_bbq => 'Barbecue';

  @override
  String get event_type_bbq_emoji => '🍖🔥🪵';

  @override
  String get event_type_bowling => 'Bowling';

  @override
  String get event_type_bowling_emoji => '🎳🎯🍕';

  @override
  String get event_type_library => 'Library';

  @override
  String get event_type_library_emoji => '📚🤓🕯️';

  @override
  String get event_type_bike => 'Bike ride';

  @override
  String get event_type_bike_emoji => '🚴‍♂️🌳🗺️';

  @override
  String get event_type_boardgames => 'Board games night';

  @override
  String get event_type_boardgames_emoji => '🎲♟️🃏';

  @override
  String get event_type_exhibition => 'Exhibition';

  @override
  String get event_type_exhibition_emoji => '🏛️📸🧐';

  @override
  String get event_type_gastro => 'Gastro tour';

  @override
  String get event_type_gastro_emoji => '🍣🥘🍷';

  @override
  String get event_type_beach => 'Beach day';

  @override
  String get event_type_beach_emoji => '🏖️☀️🌊';

  @override
  String get event_type_yoga => 'Yoga class';

  @override
  String get event_type_yoga_emoji => '🧘‍♀️🕉️🌿';

  @override
  String get event_type_karaoke => 'Karaoke';

  @override
  String get event_type_karaoke_emoji => '🎤🎶😄';

  @override
  String get event_type_karting => 'Karting';

  @override
  String get event_type_karting_emoji => '🏎️💨🔥';

  @override
  String get event_type_quest => 'Quest room';

  @override
  String get event_type_quest_emoji => '🕵️🔐🧩';

  @override
  String get event_type_coworking => 'Coworking meeting';

  @override
  String get event_type_coworking_emoji => '💻☕📈';

  @override
  String get event_type_concert => 'Concert';

  @override
  String get event_type_concert_emoji => '🎸🎤🔊';

  @override
  String get event_type_lasertag => 'Lasertag / Paintball';

  @override
  String get event_type_lasertag_emoji => '🔫🧢🕶️';

  @override
  String get event_type_picnic => 'Summer picnic';

  @override
  String get event_type_picnic_emoji => '🧺🍓🌼';

  @override
  String get event_type_masterclass => 'Master class (cooking, art)';

  @override
  String get event_type_masterclass_emoji => '👩‍🍳🎨🫕';

  @override
  String get event_type_museum => 'Museum';

  @override
  String get event_type_museum_emoji => '🏺🔎📜';

  @override
  String get event_type_movie => 'Movie night';

  @override
  String get event_type_movie_emoji => '🎬🍿🛋️';

  @override
  String get event_type_ferris => 'Ferris wheel / amusement park';

  @override
  String get event_type_ferris_emoji => '🎡🎠🍭';

  @override
  String get event_type_pub => 'Pub';

  @override
  String get event_type_pub_emoji => '🍺🎯🍟';

  @override
  String get event_type_park => 'Park';

  @override
  String get event_type_park_emoji => '🌳🛴🍃';

  @override
  String get event_type_hiking => 'Hiking';

  @override
  String get event_type_hiking_emoji => '🥾🏞️🔥';

  @override
  String get event_type_restaurant => 'Restaurant';

  @override
  String get event_type_restaurant_emoji => '🍽️🍷🕯️';

  @override
  String get event_type_skating => 'Rollerdrome / Ice rink';

  @override
  String get event_type_skating_emoji => '⛸️🎶🌀';

  @override
  String get event_type_safari => 'Safari / Zoo';

  @override
  String get event_type_safari_emoji => '🦁🐘🦓';

  @override
  String get event_type_gym => 'Gym / Group training';

  @override
  String get event_type_gym_emoji => '🏋️‍♂️💪🎧';

  @override
  String get event_type_party => 'Theme party';

  @override
  String get event_type_party_emoji => '🎉🎭✨';

  @override
  String get event_type_private => 'Private / Intimate meeting';

  @override
  String get event_type_private_emoji => '🕯️🍷🔞';

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
}
