import 'package:flutter_test/flutter_test.dart';
import 'package:simple_locale/simple_locale.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() {
  testWidgets('defLocale test', (WidgetTester tester) async {
    // ロケールを初期化
    const supportedLocales = [
      Locale('en'),
      Locale('ja'),
    ];
    const defLocale = Locale("en");

    // アプリをテスト環境にロード
    await tester.pumpWidget(LocalizedApp(
        supportedLocales: supportedLocales,
        defLocale: defLocale,
        child: Builder(builder: (BuildContext context) {
          return MaterialApp(
            locale: LocaleManager.of(context)?.getLocaleForApp(),
            localizationsDelegates: const [
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: supportedLocales,
            home: Scaffold(
              appBar: AppBar(
                title: const Text('Locale Test App'),
              ),
              body: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    LocaleManager.of(context)?.getLanguageCode() == 'en'
                        ? 'Hello'
                        : 'こんにちは',
                  ),
                  ElevatedButton(
                    onPressed: () {
                      LocaleManager.of(context)
                          ?.changeLocale(const Locale('ja'));
                    },
                    child: const Text('Change to Japanese'),
                  ),
                ],
              ),
            ),
          );
        })));

    // 初期状態のテキスト（英語）が表示されているか確認
    expect(find.text('Hello'), findsOneWidget);
    expect(find.text('こんにちは'), findsNothing);

    // ボタンをタップしてロケールを日本語に変更
    await tester.tap(find.byType(ElevatedButton));
    // 状態変化を反映させるためにpump
    await tester.pump();

    // 日本語が表示されているか確認
    expect(find.text('Hello'), findsNothing);
    expect(find.text('こんにちは'), findsOneWidget);
  });
}
