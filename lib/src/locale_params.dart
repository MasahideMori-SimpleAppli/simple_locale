import 'package:flutter/cupertino.dart';

/// 内部的に使用される、シングルトンのパラメータ管理用オブジェクト。
class LocaleParams {
  static final LocaleParams _instance = LocaleParams._internal();
  LocaleParams._internal();
  factory LocaleParams() {
    return _instance;
  }

  // ロケールが手動で変更されたかどうか。
  bool useChangeLocale = false;
  // BuildContextの一時バッファ。
  BuildContext? context;
}
