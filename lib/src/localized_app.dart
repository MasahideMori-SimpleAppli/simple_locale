import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'locale_manager.dart';

/// (en)　A base widget for propagating locale changes to child widget.
/// If you want to change the locale dynamically within your app,
/// use this as a parent widget such as MaterialApp.
///
/// (ja) 下位ウィジェットにロケール変更を伝播するためのベースのウィジェットです。
/// 動的にアプリ内でロケールを変更したい場合、MaterialAppなどの上位ウィジェットとして使用します。
class LocalizedApp extends StatefulWidget {
  final List<Locale> supportedLocales;
  final Locale? defLocale;
  final Widget child;

  /// (en)Initializes the locale settings.
  /// Normally, it is initialized with the device's own locale,
  /// but if the device locale is not included in allowedLocales,
  /// fallbackLocale will be set.
  /// If defLocale is set, calculations will be performed with defLocale
  /// as the top priority.
  ///
  /// (ja) ロケール設定を初期化します。
  /// 通常はデバイス本体ロケールで初期化されますが、
  /// allowedLocalesにデバイスロケールが含まれない場合はfallbackLocaleが設定されます。
  /// defLocaleの設定がある場合はdefLocaleを最優先にした計算が実行されます。
  ///
  /// * [supportedLocales] : An array of app supported locales.
  /// If no locale is available, the first locale in this set will be used
  /// as a fallback locale.
  /// * [defLocale] : The default locale. If this locale is not null,
  /// and the device supports it, this locale will be forced,
  /// ignoring the device locale.
  /// This locale must be an element of supportedLocales.
  /// * [child] : The child widget. e.g. MaterialApp.
  const LocalizedApp(
      {required this.supportedLocales,
      this.defLocale,
      required this.child,
      super.key});

  @override
  State<LocalizedApp> createState() => _LocalizedAppState();
}

class _LocalizedAppState extends State<LocalizedApp> {
  late final ValueNotifier<Locale> _localeNotifier;

  @override
  void initState() {
    super.initState();
    _initLocale();
  }

  /// (en)Initializes the locale settings.
  /// Normally, it is initialized with the device's own locale,
  /// but if the device locale is not included in allowedLocales,
  /// fallbackLocale will be set.
  /// If defLocale is not null, it will be set.
  ///
  /// (ja) ロケール設定を初期化します。
  /// 通常はデバイスロケールで初期化されますが、
  /// allowedLocalesにデバイスロケールが含まれない場合はfallbackLocaleが設定されます。
  /// defLocaleの設定がある場合はdefLocaleが設定されます。
  void _initLocale() {
    if (widget.defLocale != null) {
      _localeNotifier = ValueNotifier(widget.defLocale!);
    } else {
      _setDeviceLocale();
    }
  }

  /// (en) Set the device locale as the preferred setting.
  ///
  /// (ja) デバイスのロケールを優先的に設定します。
  void _setDeviceLocale() {
    final Locale deviceLocale = PlatformDispatcher.instance.locale;
    if (widget.supportedLocales.contains(deviceLocale)) {
      _localeNotifier = ValueNotifier(deviceLocale);
    } else {
      _localeNotifier = ValueNotifier(widget.supportedLocales.first);
    }
  }

  /// (en)　If the locale is changed from the LocaleManager,
  /// it will be detected and rebuilt.
  /// This reconfigures the LocaleManager so that it can check for changes and
  /// update its child widgets.
  ///
  /// (ja) LocaleManagerからロケールが変更された場合、検出して再ビルドされます。
  /// これによってLocaleManagerが再構成され、子ウィジェットの変更チェックと更新が行われます。
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<Locale>(
      valueListenable: _localeNotifier,
      builder: (context, locale, _) {
        return LocaleManager(
            localeNotifier: _localeNotifier,
            supportedLocales: widget.supportedLocales,
            defLocale: widget.defLocale,
            child: widget.child);
      },
    );
  }
}
