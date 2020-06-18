import 'package:flutter/material.dart';
import 'package:splashbloc/generated/locale_base.dart';


const supportedLanguageMap = const {
  'en': 'locales/en.json',
  'ms': 'locales/ms.json',
};

class LocDelegate extends LocalizationsDelegate<LocaleBase> {
  const LocDelegate();

  @override
  bool isSupported(Locale locale) =>
      supportedLanguageMap.containsKey(locale.languageCode);

  @override
  Future<LocaleBase> load(Locale locale) async {
    var lang = 'en';
    if (isSupported(locale)) lang = locale.languageCode;
    final loc = LocaleBase();
    await loc.load(supportedLanguageMap[lang]);
    return loc;
  }

  @override
  bool shouldReload(LocDelegate old) => false;
}

class LangLibrary {
  static Localemain main(BuildContext context) {
    LocaleBase base = Localizations.of(context, LocaleBase);
    return base.main;
  }
}