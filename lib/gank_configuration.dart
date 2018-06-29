import 'package:flutter/foundation.dart';

enum ThemeType { light, dark, brown, pink, teal, blue }
enum PlatForm { android, iOS }

class GankConfiguration {
  ThemeType themeType;
  PlatForm platForm;
  bool random = false;

  GankConfiguration(
      {@required this.platForm,
      @required this.themeType,
      @required this.random})
      : assert(themeType != null),
        assert(random != null),
        assert(platForm != null);

  GankConfiguration copyWith({
    ThemeType themeType,
    PlatForm platForm,
    bool random,
  }) {
    return GankConfiguration(
        themeType: themeType ?? this.themeType,
        platForm: platForm ?? this.platForm,
        random: random ?? this.random);
  }
}
