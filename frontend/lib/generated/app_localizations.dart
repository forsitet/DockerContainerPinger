import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_ru.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'generated/app_localizations.dart';
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
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

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
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('ru'),
  ];

  /// No description provided for @auth_title.
  ///
  /// In ru, this message translates to:
  /// **'Авторизация'**
  String get auth_title;

  /// No description provided for @sign_in.
  ///
  /// In ru, this message translates to:
  /// **'Войти'**
  String get sign_in;

  /// No description provided for @sign_out.
  ///
  /// In ru, this message translates to:
  /// **'Выйти'**
  String get sign_out;

  /// No description provided for @auth_success.
  ///
  /// In ru, this message translates to:
  /// **'Вы успешно авторизовались!'**
  String get auth_success;

  /// No description provided for @auth_failure.
  ///
  /// In ru, this message translates to:
  /// **'Ошибка авторизации. Пожалуйста, проверьте свои учетные данные.'**
  String get auth_failure;

  /// No description provided for @success_save.
  ///
  /// In ru, this message translates to:
  /// **'Успешное сохранение!'**
  String get success_save;

  /// No description provided for @error_save.
  ///
  /// In ru, this message translates to:
  /// **'Ошибка сохранения. Пожалуйста, попробуйте еще раз.'**
  String get error_save;

  /// No description provided for @loading.
  ///
  /// In ru, this message translates to:
  /// **'Загрузка...'**
  String get loading;

  /// No description provided for @get_containers_error.
  ///
  /// In ru, this message translates to:
  /// **'Ошибка получения контейнеров'**
  String get get_containers_error;

  /// No description provided for @deleting_containers_error.
  ///
  /// In ru, this message translates to:
  /// **'Ошибка удаления устаревших контейнеров'**
  String get deleting_containers_error;

  /// No description provided for @deleting_containers_success.
  ///
  /// In ru, this message translates to:
  /// **'Устаревшие контейнеры успешно удалены'**
  String get deleting_containers_success;

  /// No description provided for @deleting_containers.
  ///
  /// In ru, this message translates to:
  /// **'Удаление устаревших контейнеров'**
  String get deleting_containers;

  /// No description provided for @choose_date_to_delete.
  ///
  /// In ru, this message translates to:
  /// **'Выберите дату. Все контейнеры, последний пинг которых был до этой даты, будут удалены.'**
  String get choose_date_to_delete;

  /// No description provided for @empty_containers.
  ///
  /// In ru, this message translates to:
  /// **'Нет доступных контейнеров.'**
  String get empty_containers;

  /// No description provided for @edit_container.
  ///
  /// In ru, this message translates to:
  /// **'Редактировать контейнер'**
  String get edit_container;

  /// No description provided for @welcome.
  ///
  /// In ru, this message translates to:
  /// **'Добро пожаловать в наше приложение!'**
  String get welcome;

  /// No description provided for @invalid_data.
  ///
  /// In ru, this message translates to:
  /// **'Некорректные данные. Проверьте все поля.'**
  String get invalid_data;

  /// No description provided for @cancel.
  ///
  /// In ru, this message translates to:
  /// **'Отмена'**
  String get cancel;

  /// No description provided for @confirm.
  ///
  /// In ru, this message translates to:
  /// **'Подтвердить'**
  String get confirm;

  /// No description provided for @delete.
  ///
  /// In ru, this message translates to:
  /// **'Удалить'**
  String get delete;

  /// No description provided for @edit.
  ///
  /// In ru, this message translates to:
  /// **'Редактировать'**
  String get edit;

  /// No description provided for @save.
  ///
  /// In ru, this message translates to:
  /// **'Сохранить'**
  String get save;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'ru'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'ru':
      return AppLocalizationsRu();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
