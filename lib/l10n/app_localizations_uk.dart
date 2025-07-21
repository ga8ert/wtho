// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Ukrainian (`uk`).
class AppLocalizationsUk extends AppLocalizations {
  AppLocalizationsUk([String locale = 'uk']) : super(locale);

  @override
  String get hello => 'Привіт';

  @override
  String get welcome => 'Ласкаво просимо до нашого застосунку!';

  @override
  String get logout => 'Вийти';

  @override
  String get login => 'Увійти';

  @override
  String get sign_up => 'Створити акаунт';

  @override
  String get email => 'Електронна пошта';

  @override
  String get password => 'Пароль';

  @override
  String get settings => 'Налаштування';

  @override
  String get language => 'Мова';

  @override
  String get confirm => 'Підтвердити';

  @override
  String get cancel => 'Скасувати';

  @override
  String get logo1 => 'З КИМ\n';

  @override
  String get logo2 => 'ЗАТУСИТИ';

  @override
  String get login_with_email => 'Увійти за допомогою пошти';

  @override
  String get sign_in_with_facebook => 'Увійти за допомогою Facebook';

  @override
  String get sign_in_with_google => 'Увійти через Google';

  @override
  String get name => 'Імʼя';

  @override
  String get surname => 'Прізвище';

  @override
  String get age => 'Вік';

  @override
  String get city => 'Місто';

  @override
  String get registration => 'Реєстрація';

  @override
  String get registration_success => 'Реєстрація успішна!';

  @override
  String get groups_nearby => 'Групи поруч';

  @override
  String get profile => 'Профіль';

  @override
  String get email_verification_sent => 'Верифікацію відправленно на пошту!';

  @override
  String get please_verify_email => 'Будь ласка, верифікуйте пошту!';

  @override
  String get take_a_photo => 'Зробити фото';

  @override
  String get choose_from_gallery => 'Вибрати з галереї';

  @override
  String get ok => 'Ок';

  @override
  String get error => 'Помилка';

  @override
  String get confirm_email => 'Підтвердіть email';

  @override
  String get please_confirm_email => 'Будь ласка, підтвердіть email за посиланням у листі. Після підтвердження натисніть - Я підтвердив.';

  @override
  String get email_not_yet_confirmed => 'Email ще не підтверджено!';

  @override
  String get i_confirmed => 'Я підтвердив';

  @override
  String get letter_has_been_sent => 'Лист повторно надіслано!';

  @override
  String get send_a_letter => 'Надіслати лист';

  @override
  String get events => 'Івенти';

  @override
  String get friends => 'Друзі';

  @override
  String get no_events => 'Немає івентів';

  @override
  String get no_data => 'Немає даних для відображення';

  @override
  String get km => 'км';

  @override
  String get please_confirm_email_before_login => 'Будь ласка, підтвердіть email перед входом.';

  @override
  String get email_not_verified => 'Email ще не підтверджено.';

  @override
  String email_verification_error(Object error) {
    return 'Помилка перевірки email: $error';
  }

  @override
  String email_send_error(Object error) {
    return 'Не вдалося надіслати лист: $error';
  }

  @override
  String get fill_all_required_fields => 'Заповніть всі обовʼязкові поля';

  @override
  String error_with_message(Object error) {
    return 'Помилка: $error';
  }

  @override
  String get create_event => 'Створити івент';

  @override
  String get title => 'Заголовок';

  @override
  String get place => 'Місце';

  @override
  String get offline => 'Офлайн';

  @override
  String get online => 'Онлайн';

  @override
  String get hybrid => 'Гібрид';

  @override
  String get meeting_type => 'Тип зустрічі';

  @override
  String map_point_selected(Object lat, Object lng) {
    return 'Точка на карті: $lat, $lng';
  }

  @override
  String get map_point_not_selected => 'Точка на карті не вибрана';

  @override
  String get select_on_map => 'Вибрати на карті';

  @override
  String start_time(Object time) {
    return 'Початок: $time';
  }

  @override
  String get select_start_time => 'Оберіть дату та час початку';

  @override
  String get done => 'Готово';

  @override
  String get select => 'Вибрати';

  @override
  String end_time(Object time) {
    return 'Кінець: $time';
  }

  @override
  String get select_end_time => 'Оберіть дату та час завершення';

  @override
  String users_added(Object count) {
    return 'Додано користувачів: $count';
  }

  @override
  String get no_users_selected => 'Користувачі не вибрані';

  @override
  String get add_users => 'Додати користувачів';

  @override
  String get chat_not_implemented => 'Чат ще не реалізовано';

  @override
  String get description => 'Опис';

  @override
  String get failed_to_get_uid => 'Не вдалося отримати uid';

  @override
  String get event_created => 'Івент створено!';

  @override
  String get determining_location => 'Визначаємо локацію...';

  @override
  String get location_unavailable => 'Локація недоступна';

  @override
  String get add => 'Додати';

  @override
  String get decline => 'Відхилити';

  @override
  String get select_point_on_map => 'Виберіть точку на карті';

  @override
  String get select_friends => 'Виберіть друзів';

  @override
  String get no_friends => 'У вас немає друзів';

  @override
  String get no_name => 'Без імені';

  @override
  String get ukrainian => 'Українська';

  @override
  String get join_request_sent => 'Запит на приєднання надіслано!';

  @override
  String get description_missing => 'Опис відсутній';

  @override
  String get participants => 'Учасники';

  @override
  String get originator => 'Ініціатор';

  @override
  String get join_requests => 'Запити на приєднання';

  @override
  String get get_directions => 'Прокласти маршрут';

  @override
  String get sending => 'Відправка';

  @override
  String get invite_to_join_the_event => 'Запросити приєднання до події';

  @override
  String get go_to_chat => 'Перейти у чат';

  @override
  String get english => 'Англійська';

  @override
  String get delete_account => 'Видалити акаунт';

  @override
  String get delete_account_confirm => 'Ви впевнені, що хочете видалити акаунт? Цю дію не можна скасувати.';

  @override
  String get no_friends_yet => 'Немає друзів.';

  @override
  String get no_users_found => 'Користувачів не знайдено.';

  @override
  String get search_by_nickname => 'Пошук по нікнейму';

  @override
  String get nickname => 'Нікнейм';

  @override
  String get nickname_too_short => 'Нікнейм має містити щонайменше 4 символи';

  @override
  String get nickname_taken => 'Нікнейм вже зайнятий';

  @override
  String get registration_success_check_email => 'Реєстрація успішна! Перевірте вашу пошту.';

  @override
  String get unknown => '?';

  @override
  String get ellipsis => '...';

  @override
  String get friend_request_sent => 'Запит надіслано';

  @override
  String get event_type_aquapark => 'Аквапарк';

  @override
  String get event_type_aquapark_emoji => '💦🛟👙';

  @override
  String get event_type_art_gallery => 'Арт-галерея';

  @override
  String get event_type_art_gallery_emoji => '🖼️🎨🧑‍🎨';

  @override
  String get event_type_bbq => 'Барбекю';

  @override
  String get event_type_bbq_emoji => '🍖🔥🪵';

  @override
  String get event_type_bowling => 'Боулінг';

  @override
  String get event_type_bowling_emoji => '🎳🎯🍕';

  @override
  String get event_type_library => 'Бібліотека';

  @override
  String get event_type_library_emoji => '📚🤓🕯️';

  @override
  String get event_type_bike => 'Велопрогулянка';

  @override
  String get event_type_bike_emoji => '🚴‍♂️🌳🗺️';

  @override
  String get event_type_boardgames => 'Вечір настолок';

  @override
  String get event_type_boardgames_emoji => '🎲♟️🃏';

  @override
  String get event_type_exhibition => 'Виставка';

  @override
  String get event_type_exhibition_emoji => '🏛️📸🧐';

  @override
  String get event_type_gastro => 'Гастро-тур';

  @override
  String get event_type_gastro_emoji => '🍣🥘🍷';

  @override
  String get event_type_beach => 'День на пляжі';

  @override
  String get event_type_beach_emoji => '🏖️☀️🌊';

  @override
  String get event_type_yoga => 'Заняття йогою';

  @override
  String get event_type_yoga_emoji => '🧘‍♀️🕉️🌿';

  @override
  String get event_type_karaoke => 'Караоке';

  @override
  String get event_type_karaoke_emoji => '🎤🎶😄';

  @override
  String get event_type_karting => 'Картинг';

  @override
  String get event_type_karting_emoji => '🏎️💨🔥';

  @override
  String get event_type_quest => 'Квест-кімната';

  @override
  String get event_type_quest_emoji => '🕵️🔐🧩';

  @override
  String get event_type_coworking => 'Коворкінг-зустріч';

  @override
  String get event_type_coworking_emoji => '💻☕📈';

  @override
  String get event_type_concert => 'Концерт';

  @override
  String get event_type_concert_emoji => '🎸🎤🔊';

  @override
  String get event_type_lasertag => 'Лазертаг / Пейнтбол';

  @override
  String get event_type_lasertag_emoji => '🔫🧢🕶️';

  @override
  String get event_type_picnic => 'Літній пікнік';

  @override
  String get event_type_picnic_emoji => '🧺🍓🌼';

  @override
  String get event_type_masterclass => 'Майстер-клас (кулінарія, арт)';

  @override
  String get event_type_masterclass_emoji => '👩‍🍳🎨🫕';

  @override
  String get event_type_museum => 'Музей';

  @override
  String get event_type_museum_emoji => '🏺🔎📜';

  @override
  String get event_type_movie => 'Ніч кіно';

  @override
  String get event_type_movie_emoji => '🎬🍿🛋️';

  @override
  String get event_type_ferris => 'Оглядове колесо / парк атракціонів';

  @override
  String get event_type_ferris_emoji => '🎡🎠🍭';

  @override
  String get event_type_pub => 'Паб';

  @override
  String get event_type_pub_emoji => '🍺🎯🍟';

  @override
  String get event_type_park => 'Парк';

  @override
  String get event_type_park_emoji => '🌳🛴🍃';

  @override
  String get event_type_hiking => 'Похід у гори';

  @override
  String get event_type_hiking_emoji => '🥾🏞️🔥';

  @override
  String get event_type_restaurant => 'Ресторан';

  @override
  String get event_type_restaurant_emoji => '🍽️🍷🕯️';

  @override
  String get event_type_skating => 'Роллердром / каток';

  @override
  String get event_type_skating_emoji => '⛸️🎶🌀';

  @override
  String get event_type_safari => 'Сафарі / зоопарк';

  @override
  String get event_type_safari_emoji => '🦁🐘🦓';

  @override
  String get event_type_gym => 'Спортзал / групове тренування';

  @override
  String get event_type_gym_emoji => '🏋️‍♂️💪🎧';

  @override
  String get event_type_party => 'Тематична вечірка';

  @override
  String get event_type_party_emoji => '🎉🎭✨';

  @override
  String get event_type_private => 'Приватна / Інтимна зустріч';

  @override
  String get event_type_private_emoji => '🕯️🍷🔞';

  @override
  String get filters => 'Фільтри';

  @override
  String get radius => 'Радіус (км)';

  @override
  String get reset_filters => 'Скинути';

  @override
  String get event_type_other => 'Інше';

  @override
  String get event_type_other_emoji => '🤷🤔🧐';

  @override
  String get who_am_i_with => 'З ким я зараз?';

  @override
  String get save => 'Зберегти';

  @override
  String get failed_to_save => 'Не вдалося зберегти';

  @override
  String get failed_to_load_friends => 'Не вдалося завантажити друзів';

  @override
  String get no_friends_found => 'Друзів не знайдено';

  @override
  String get my_events => 'Мої івенти';

  @override
  String get joined_events => 'Приєднані івенти';

  @override
  String chat_expiry(Object days) {
    return 'Чат буде доступний ще $days днів після завершення івенту.';
  }

  @override
  String get chat_expired => 'Чат завершився і скоро буде видалений.';

  @override
  String get chat_input_hint => 'Введіть повідомлення...';

  @override
  String get no_chat_id_for_event => 'Немає chatId для цього івенту!';

  @override
  String get add_photo => 'Додати фото';

  @override
  String get support_us => 'Підтримати нас';

  @override
  String get support_us_title => 'Підтримайте наш проєкт!';

  @override
  String get support_us_body => 'Якщо вам подобається наш застосунок, ви можете підтримати нас і допомогти розвиватися. Ваша підтримка мотивує нас робити застосунок ще кращим!';

  @override
  String get support_us_action => 'Підтримати';

  @override
  String get support_us_thank_you => 'Дякуємо за вашу підтримку!';

  @override
  String get photo_not_selected => 'Фото не вибрано.';

  @override
  String get file_too_large => 'Файл занадто великий. Макс 8 МБ.';

  @override
  String get file_not_exists => 'Файл не існує або шлях порожній.';

  @override
  String get failed_to_upload_photo => 'Не вдалося завантажити фото.';

  @override
  String error_with_colon(Object error) {
    return 'Помилка: $error';
  }

  @override
  String get location_permission => 'Дозвіл на локацію';

  @override
  String get location_permission_message => 'Для використання цієї функції, будь ласка, дозвольте доступ до локації в налаштуваннях додатку.';

  @override
  String get open_settings => 'Відкрити налаштування';

  @override
  String get location_permission_denied => 'Дозвіл на локацію назавжди відхилено. Будь ласка, увімкніть його в налаштуваннях додатку.';

  @override
  String get with_friends => 'Тут ти можеш обрати друзів з якими ви зараз тусите';
}
