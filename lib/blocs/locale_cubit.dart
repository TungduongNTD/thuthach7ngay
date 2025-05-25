import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

class LocaleCubit extends Cubit<Locale> {
  static const String _localeKey = 'selected_locale';
  final Box _settingsBox;

  LocaleCubit(this._settingsBox) : super(_loadLocale(_settingsBox));

  static Locale _loadLocale(Box settingsBox) {
    final String? savedLocale = settingsBox.get(_localeKey);
    return savedLocale != null ? Locale(savedLocale) : const Locale('en');
  }

  void setLocale(Locale locale) {
    _settingsBox.put(_localeKey, locale.languageCode);
    emit(locale);
  }
} 