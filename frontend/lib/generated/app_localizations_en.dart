// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get auth_title => 'Authorization';

  @override
  String get sign_in => 'Sign In';

  @override
  String get sign_out => 'Sign Out';

  @override
  String get auth_success => 'You have successfully signed in!';

  @override
  String get auth_failure =>
      'Ошибка авторизации. Пожалуйста, проверьте свои учетные данные.';

  @override
  String get success_save => 'Успешное сохранение!';

  @override
  String get error_save => 'Ошибка сохранения. Пожалуйста, попробуйте еще раз.';

  @override
  String get loading => 'Загрузка...';

  @override
  String get get_containers_error => 'Ошибка получения контейнеров';

  @override
  String get deleting_containers_error =>
      'Ошибка удаления устаревших контейнеров';

  @override
  String get deleting_containers_success =>
      'Устаревшие контейнеры успешно удалены';

  @override
  String get deleting_containers => 'Удаление устаревших контейнеров';

  @override
  String get choose_date_to_delete =>
      'Выберите дату. Все контейнеры, последний пинг которых был до этой даты, будут удалены.';

  @override
  String get empty_containers => 'Нет доступных контейнеров.';

  @override
  String get edit_container => 'Редактировать контейнер';

  @override
  String get welcome => 'Добро пожаловать в наше приложение!';

  @override
  String get invalid_data => 'Некорректные данные. Проверьте все поля.';

  @override
  String get cancel => 'Отмена';

  @override
  String get confirm => 'Подтвердить';

  @override
  String get delete => 'Удалить';

  @override
  String get edit => 'Редактировать';

  @override
  String get save => 'Сохранить';
}
