import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

/// (en) A InheritedWidget for controlling locale within an app.
/// /// Any widget that calls LocaleManager.of(context) from this
/// class will automatically be rebuilt and updated when the locale is changed.
///
/// (ja) アプリ内でロケールをコントロールするためのInheritedWidgetです。
/// このクラスのLocaleManager.of(context)を呼び出したウィジェットは、
/// ロケールが変更されると自動で再ビルドされて反映されます。
class LocaleManager extends InheritedWidget {
  final ValueNotifier<Locale> localeNotifier;
  final List<Locale> supportedLocales;
  final Locale? defLocale;
  final Locale fallbackLocale;

  /// (en) Note: Do not call this constructor directly.
  /// This is meant to be called via LocalizedApp.
  ///
  /// Initializes the locale settings.
  /// Normally, it is initialized with the device's own locale,
  /// but if the device locale is not included in allowedLocales,
  /// fallbackLocale will be set.
  /// If defLocale is set, calculations will be performed with defLocale
  /// as the top priority.
  ///
  /// (ja) 注：このコンストラクタを直接呼び出さないでください。
  /// これは、LocalizedApp経由で呼び出されることを想定しています。
  ///
  /// ロケール設定を初期化します。
  /// 通常はデバイス本体ロケールで初期化されますが、
  /// allowedLocalesにデバイスロケールが含まれない場合はfallbackLocaleが設定されます。
  /// defLocaleの設定がある場合はdefLocaleを最優先にした計算が実行されます。
  ///
  /// * [localeNotifier] : Notifier for detecting widget changes.
  /// * [defLocale] : The default locale. If this locale is not null,
  /// and the device supports it, this locale will be forced,
  /// ignoring the device locale.
  /// * [supportedLocales] : An array of app supported locales.
  /// * [fallbackLocale] : The locale used when the app does not support
  /// the device's locale.
  const LocaleManager(
      {required this.localeNotifier,
      required this.supportedLocales,
      required this.defLocale,
      required this.fallbackLocale,
      required super.child,
      super.key});

  @override
  bool updateShouldNotify(covariant LocaleManager oldWidget) {
    // 注：localeNotifier経由のため、差分チェックは変更時に行っており、ここでは常にtrue。
    return true;
  }

  /// (en) Widgets that access locale information via this method will be
  /// tracked for changes and will be rebuilt when the locale changes.
  ///
  /// (ja) このメソッドを経由してロケール情報にアクセスしたウィジェットは変更の追跡対象となり、
  /// ロケールの変更時に再ビルドされるようになります。
  static LocaleManager? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<LocaleManager>();
  }

  /// (en)Initializes the locale settings.
  /// Normally, it is initialized with the device's own locale,
  /// but if the device locale is not included in allowedLocales,
  /// fallbackLocale will be set.
  /// If defLocale is set, calculations will be performed with defLocale
  /// as the top priority.
  ///
  /// (ja) ロケール設定を初期化します。
  /// 通常はデバイスロケールで初期化されますが、
  /// allowedLocalesにデバイスロケールが含まれない場合はfallbackLocaleが設定されます。
  /// defLocaleの設定がある場合はdefLocaleを最優先にした計算が実行されます。
  void reset() {
    if (defLocale != null) {
      if (supportedLocales.contains(defLocale!)) {
        changeLocale(defLocale!);
      } else {
        _setDeviceLocale();
      }
    } else {
      _setDeviceLocale();
    }
  }

  /// (en) Set the device locale as the preferred setting.
  ///
  /// (ja) デバイスのロケールを優先的に設定します。
  void _setDeviceLocale() {
    final Locale deviceLocale = PlatformDispatcher.instance.locale;
    if (supportedLocales.contains(deviceLocale)) {
      changeLocale(deviceLocale);
    } else {
      changeLocale(fallbackLocale);
    }
  }

  /// (en) Change the app locale.
  ///
  /// (ja) アプリのロケールを変更します。
  ///
  /// * [locale] : Changed locale.
  void changeLocale(Locale locale) {
    if (localeNotifier.value != locale) {
      localeNotifier.value = locale;
    }
  }

  /// (en) Get now app locale.
  ///
  /// (ja) アプリの現在のロケールを取得します。
  Locale getLocale() {
    return localeNotifier.value;
  }

  /// (en) Gets the current language code for the app.
  ///
  /// (ja) アプリの現在の言語コードを取得します。
  String getLanguageCode() {
    return localeNotifier.value.languageCode;
  }
}
