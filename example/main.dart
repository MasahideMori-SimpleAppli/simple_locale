import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:simple_locale/simple_locale.dart';

// Uncomment this when AppLocalizations is ready.
// import 'package:flutter_gen/gen_l10n/app_localizations.dart';

const supportedLocales = [
  Locale('en'),
  Locale('ja'),
];

void main() async {
  // Even if you use riverpod etc., please place LocalizedApp directly under
  // RunApp (it will be the parent widget of ProviderScope).
  runApp(const LocalizedApp(
      supportedLocales: supportedLocales, child: AppParent(MyApp())));
}

class AppParent extends StatelessWidget {
  final Widget child;

  const AppParent(this.child, {super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        // Set your MaterialApp's locale to be retrieved via LocaleManager like this:
        locale: LocaleManager.of(context)?.getLocaleForApp(),
        localizationsDelegates: const [
          // Uncomment this when AppLocalizations is ready.
          // AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: supportedLocales,
        home: child);
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // Uncomment this when AppLocalizations is ready.
        // title: Text(AppLocalizations.of(context)!.appName),
        title: const Text("simple_locale"),
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
                  if (LocaleManager.of(context)?.getLanguageCode() == 'en') {
                    // Changing the locale is done in a button callback, etc.
                    // It is prohibited to change the locale during a build.
                    LocaleManager.of(context)?.changeLocale(const Locale('ja'));
                  } else {
                    LocaleManager.of(context)?.changeLocale(const Locale('en'));
                  }
                },
                child: Text(LocaleManager.of(context)?.getLanguageCode() == 'ja'
                    ? 'ロケール変更'
                    : 'Change Locale'),
              ),
              Container(
                margin: const EdgeInsets.fromLTRB(0, 12, 0, 0),
                child: ElevatedButton(
                  onPressed: () {
                    LocaleManager.of(context)?.reset();
                  },
                  child: Text(
                      LocaleManager.of(context)?.getLanguageCode() == 'ja'
                          ? 'デバイスロケールにリセット'
                          : 'Reset to device locale'),
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}
