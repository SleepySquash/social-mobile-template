import 'package:flutter/material.dart';

class LocaleProvider {
  ValueNotifier<Locale> locale =
      ValueNotifier<Locale>(const Locale.fromSubtags());
  void setLocale(String code) =>
      locale.value = Locale.fromSubtags(languageCode: code);

  static String toLanguage(String code) {
    switch (code) {
      case 'ru':
        return 'Русский';
      case 'en':
        return 'English';
      default:
        return 'Unknown';
    }
  }
}
