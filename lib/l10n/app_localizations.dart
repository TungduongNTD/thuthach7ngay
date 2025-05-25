import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_pl.dart';
import 'app_localizations_vi.dart';

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
    Locale('pl'),
    Locale('vi')
  ];

  /// No description provided for @add.
  ///
  /// In en, this message translates to:
  /// **'Add'**
  String get add;

  /// No description provided for @and.
  ///
  /// In en, this message translates to:
  /// **'and'**
  String get and;

  /// No description provided for @app_name.
  ///
  /// In en, this message translates to:
  /// **'Bay Bay'**
  String get app_name;

  /// No description provided for @auth_brand_quote_text1.
  ///
  /// In en, this message translates to:
  /// **'Track, manage, and improve your habits'**
  String get auth_brand_quote_text1;

  /// No description provided for @auth_declaration_text.
  ///
  /// In en, this message translates to:
  /// **'By continuing, you agree to'**
  String get auth_declaration_text;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @description.
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get description;

  /// No description provided for @edit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get edit;

  /// No description provided for @edit_habit.
  ///
  /// In en, this message translates to:
  /// **'Edit habit'**
  String get edit_habit;

  /// No description provided for @finished.
  ///
  /// In en, this message translates to:
  /// **'Completed'**
  String get finished;

  /// No description provided for @for_a_better_life.
  ///
  /// In en, this message translates to:
  /// **' for a better life'**
  String get for_a_better_life;

  /// No description provided for @icon.
  ///
  /// In en, this message translates to:
  /// **'Icon'**
  String get icon;

  /// No description provided for @mark_as_done.
  ///
  /// In en, this message translates to:
  /// **'Mark as done'**
  String get mark_as_done;

  /// No description provided for @name.
  ///
  /// In en, this message translates to:
  /// **'Full name'**
  String get name;

  /// No description provided for @name_cannot_be_empty.
  ///
  /// In en, this message translates to:
  /// **'Name cannot be empty'**
  String get name_cannot_be_empty;

  /// No description provided for @new_habit.
  ///
  /// In en, this message translates to:
  /// **'New habit'**
  String get new_habit;

  /// No description provided for @no_habits.
  ///
  /// In en, this message translates to:
  /// **'No habits found'**
  String get no_habits;

  /// No description provided for @or_sign_in_later.
  ///
  /// In en, this message translates to:
  /// **'OR SIGN IN LATER'**
  String get or_sign_in_later;

  /// No description provided for @privacy_policy.
  ///
  /// In en, this message translates to:
  /// **'Privacy policy'**
  String get privacy_policy;

  /// No description provided for @remove.
  ///
  /// In en, this message translates to:
  /// **'Remove'**
  String get remove;

  /// No description provided for @remove_habit.
  ///
  /// In en, this message translates to:
  /// **'Remove habit'**
  String get remove_habit;

  /// No description provided for @remove_habit_confirmation.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete this habit?'**
  String get remove_habit_confirmation;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @terms_of_service.
  ///
  /// In en, this message translates to:
  /// **'Terms of service'**
  String get terms_of_service;

  /// No description provided for @to_do.
  ///
  /// In en, this message translates to:
  /// **'To do'**
  String get to_do;

  /// No description provided for @undo_habit.
  ///
  /// In en, this message translates to:
  /// **'Undo'**
  String get undo_habit;

  /// No description provided for @welcome_to.
  ///
  /// In en, this message translates to:
  /// **'Welcome to'**
  String get welcome_to;

  /// No description provided for @morning_greeting.
  ///
  /// In en, this message translates to:
  /// **'Good morning'**
  String get morning_greeting;

  /// No description provided for @afternoon_greeting.
  ///
  /// In en, this message translates to:
  /// **'Good afternoon'**
  String get afternoon_greeting;

  /// No description provided for @evening_greeting.
  ///
  /// In en, this message translates to:
  /// **'Good evening'**
  String get evening_greeting;

  /// No description provided for @profile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profile;

  /// No description provided for @profile_saved.
  ///
  /// In en, this message translates to:
  /// **'Profile saved'**
  String get profile_saved;

  /// No description provided for @please_enter_name.
  ///
  /// In en, this message translates to:
  /// **'Please enter your name'**
  String get please_enter_name;

  /// No description provided for @please_enter_age.
  ///
  /// In en, this message translates to:
  /// **'Please enter your age'**
  String get please_enter_age;

  /// No description provided for @please_enter_valid_age.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid age'**
  String get please_enter_valid_age;

  /// No description provided for @please_enter_height.
  ///
  /// In en, this message translates to:
  /// **'Please enter your height'**
  String get please_enter_height;

  /// No description provided for @please_enter_valid_height.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid height'**
  String get please_enter_valid_height;

  /// No description provided for @please_enter_goal.
  ///
  /// In en, this message translates to:
  /// **'Please enter your goal'**
  String get please_enter_goal;

  /// No description provided for @age.
  ///
  /// In en, this message translates to:
  /// **'Age'**
  String get age;

  /// No description provided for @height.
  ///
  /// In en, this message translates to:
  /// **'Height (cm)'**
  String get height;

  /// No description provided for @goal.
  ///
  /// In en, this message translates to:
  /// **'Goal'**
  String get goal;

  /// No description provided for @stats.
  ///
  /// In en, this message translates to:
  /// **'Statistics'**
  String get stats;

  /// No description provided for @days_streak.
  ///
  /// In en, this message translates to:
  /// **'Day streak'**
  String get days_streak;

  /// No description provided for @habits_completed.
  ///
  /// In en, this message translates to:
  /// **'Habits completed'**
  String get habits_completed;

  /// No description provided for @success_rate.
  ///
  /// In en, this message translates to:
  /// **'Success rate'**
  String get success_rate;

  /// No description provided for @select_language.
  ///
  /// In en, this message translates to:
  /// **'Select Language'**
  String get select_language;

  /// No description provided for @change_language.
  ///
  /// In en, this message translates to:
  /// **'Change Language'**
  String get change_language;

  /// No description provided for @login_quote.
  ///
  /// In en, this message translates to:
  /// **'\"Small daily improvements lead to stunning results.\"'**
  String get login_quote;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @theme.
  ///
  /// In en, this message translates to:
  /// **'Theme'**
  String get theme;

  /// No description provided for @light.
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get light;

  /// No description provided for @dark.
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get dark;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @english.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get english;

  /// No description provided for @vietnamese.
  ///
  /// In en, this message translates to:
  /// **'Vietnamese'**
  String get vietnamese;

  /// No description provided for @data_export.
  ///
  /// In en, this message translates to:
  /// **'Data Export'**
  String get data_export;

  /// No description provided for @export_data.
  ///
  /// In en, this message translates to:
  /// **'Export Data'**
  String get export_data;

  /// No description provided for @export_success.
  ///
  /// In en, this message translates to:
  /// **'Data exported successfully!'**
  String get export_success;

  /// No description provided for @export_failed.
  ///
  /// In en, this message translates to:
  /// **'Failed to export data'**
  String get export_failed;

  /// No description provided for @app_version.
  ///
  /// In en, this message translates to:
  /// **'Version 1.0.0'**
  String get app_version;

  /// No description provided for @logout.
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get logout;

  /// No description provided for @logout_confirmation.
  ///
  /// In en, this message translates to:
  /// **'Logout Confirmation'**
  String get logout_confirmation;

  /// No description provided for @logout_confirmation_message.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to logout?'**
  String get logout_confirmation_message;

  /// No description provided for @personal_information.
  ///
  /// In en, this message translates to:
  /// **'Personal Information'**
  String get personal_information;

  /// No description provided for @goals.
  ///
  /// In en, this message translates to:
  /// **'Goals'**
  String get goals;

  /// No description provided for @statistics.
  ///
  /// In en, this message translates to:
  /// **'Statistics'**
  String get statistics;

  /// No description provided for @days_active.
  ///
  /// In en, this message translates to:
  /// **'Days Active'**
  String get days_active;

  /// No description provided for @current_streak.
  ///
  /// In en, this message translates to:
  /// **'Current Streak'**
  String get current_streak;

  /// No description provided for @achievements.
  ///
  /// In en, this message translates to:
  /// **'Achievements'**
  String get achievements;

  /// No description provided for @google_account.
  ///
  /// In en, this message translates to:
  /// **'Google Account'**
  String get google_account;

  /// No description provided for @email_account.
  ///
  /// In en, this message translates to:
  /// **'Email Account'**
  String get email_account;

  /// No description provided for @guest_account.
  ///
  /// In en, this message translates to:
  /// **'Guest Account'**
  String get guest_account;

  /// No description provided for @sign_in_to_set_goals.
  ///
  /// In en, this message translates to:
  /// **'Sign in to set goals'**
  String get sign_in_to_set_goals;

  /// No description provided for @improve_my_health.
  ///
  /// In en, this message translates to:
  /// **'Improve my health'**
  String get improve_my_health;

  /// No description provided for @profile_updated_successfully.
  ///
  /// In en, this message translates to:
  /// **'Profile updated successfully'**
  String get profile_updated_successfully;

  /// No description provided for @failed_to_update_profile.
  ///
  /// In en, this message translates to:
  /// **'Failed to update profile'**
  String get failed_to_update_profile;

  /// No description provided for @failed_to_pick_image.
  ///
  /// In en, this message translates to:
  /// **'Failed to pick image'**
  String get failed_to_pick_image;

  /// No description provided for @please_enter_valid_number.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid number'**
  String get please_enter_valid_number;
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['en', 'pl', 'vi'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {


  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en': return AppLocalizationsEn();
    case 'pl': return AppLocalizationsPl();
    case 'vi': return AppLocalizationsVi();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.'
  );
}
