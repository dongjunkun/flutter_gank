import 'package:flutter/foundation.dart';

enum ThemeType { light, dark, brown, pink, teal, blue }
enum PlatForm { android, iOS }

class GankConfiguration {
  ThemeType themeType;
  PlatForm platForm;

  GankConfiguration({@required this.platForm, @required this.themeType})
      : assert(themeType != null),
        assert(platForm != null);

  GankConfiguration copyWith({
    ThemeType themeType,
    PlatForm platForm,
  }) {
    return GankConfiguration(
        themeType: themeType ?? this.themeType,
        platForm: platForm ?? this.platForm);
  }
}
