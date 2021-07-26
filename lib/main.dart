import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

import 'core/services/locale.dart';
import 'core/services/server.dart';
import 'core/router.dart';

void main() {
  runApp(const SocialApp());
}

/// MaterialApp entry point.
///
/// {@category Application}
class SocialApp extends StatelessWidget {
  const SocialApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider(create: (_) => LocaleProvider()),
        Provider(create: (_) => Server()),
      ],
      builder: (context, child) {
        return ValueListenableBuilder<Object>(
          valueListenable: context.read<LocaleProvider>().locale,
          builder: (context, locale, child) {
            return MaterialApp(
              title: 'Social App',
              localizationsDelegates: const [
                AppLocalizations.delegate, // Add this line
                GlobalMaterialLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
                GlobalCupertinoLocalizations.delegate,
              ],
              supportedLocales: const [
                Locale('en', ''),
                Locale('ru', ''),
              ],
              locale: locale as Locale,
              theme: ThemeData.light(),
              home: const AppRouter(),
              debugShowCheckedModeBanner: false,
            );
          },
        );
      },
    );
  }
}
