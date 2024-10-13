import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:simple_locale/simple_locale.dart';

const supportedLocales = [
  Locale('en'),
  Locale('ja'),
];

const fallbackLocale = Locale("en");

void main() async {
  // Even if you use riverpod etc., please place LocalizedApp directly under
  // RunApp (it will be the parent widget of ProviderScope).
  runApp(const LocalizedApp(
      supportedLocales: supportedLocales,
      fallbackLocale: fallbackLocale,
      child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Set your MaterialApp's locale to be retrieved via LocaleManager like this:
    return MaterialApp(
      locale: LocaleManager.of(context)?.getLocale() ?? fallbackLocale,
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: supportedLocales,
      home: Scaffold(
          appBar: AppBar(
            title: const Text('simple_locale Test App'),
          ),
          body: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                      margin: const EdgeInsets.fromLTRB(0, 0, 0, 12),
                      child: Text(
                        // The locale can be obtained during the build.
                        LocaleManager.of(context)?.getLanguageCode() == 'ja'
                            ? 'こんにちは'
                            : 'Hello',
                      )),
                  ElevatedButton(
                    onPressed: () {
                      if (LocaleManager.of(context)?.getLanguageCode() ==
                          'en') {
                        // Changing the locale is done in a button callback, etc.
                        // It is prohibited to change the locale during a build.
                        LocaleManager.of(context)
                            ?.changeLocale(const Locale('ja'));
                      } else {
                        LocaleManager.of(context)
                            ?.changeLocale(const Locale('en'));
                      }
                    },
                    child: Text(
                        LocaleManager.of(context)?.getLanguageCode() == 'ja'
                            ? 'ロケール変更'
                            : 'Change Locale'),
                  ),
                ],
              )
            ],
          )),
    );
  }
}
