import 'package:flutter/foundation.dart';

enum ThemeType { light, dark, brown, blue }
enum PlatForm { android, iOS }

class GankConfiguration {
  ThemeType themeType;
  PlatForm platForm;
  bool random = false;
  bool gifEnable = false;

  GankConfiguration(
      {@required this.platForm,
      @required this.themeType,
      @required this.random,
      @required this.gifEnable})
      : assert(themeType != null),
        assert(random != null),
        assert(gifEnable != null),
        assert(platForm != null);

  GankConfiguration copyWith({
    ThemeType themeType,
    PlatForm platForm,
    bool random,
    bool gifEnable,
  }) {
    return GankConfiguration(
        themeType: themeType ?? this.themeType,
        platForm: platForm ?? this.platForm,
        random: random ?? this.random,
        gifEnable: gifEnable ?? this.gifEnable);
  }
}
