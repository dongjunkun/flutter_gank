import 'package:flutter/foundation.dart';

enum ThemeType { light, dark, brown, pink, teal, blue }
enum PlatForm { android, iOS }

class GankConfiguration {
  ThemeType themeType;
  PlatForm platForm;
  bool randomMeizhi = false;

  GankConfiguration(
      {@required this.platForm,
      @required this.themeType,
      @required this.randomMeizhi})
      : assert(themeType != null),
        assert(randomMeizhi != null),
        assert(platForm != null);

  GankConfiguration copyWith({
    ThemeType themeType,
    PlatForm platForm,
    bool ramdomMeizhi,
  }) {
    return GankConfiguration(
        themeType: themeType ?? this.themeType,
        platForm: platForm ?? this.platForm,
        randomMeizhi: ramdomMeizhi ?? this.randomMeizhi);
  }
}
