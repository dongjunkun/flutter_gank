import 'package:flutter/foundation.dart';

enum ThemeType { dark, light, brown, pink, pure }
enum PlatForm { android, iOS }

class GankConfiguration {
  final ThemeType themeType;
  final PlatForm platForm;

  GankConfiguration({@required this.platForm, @required this.themeType})
      : assert(themeType != null),
        assert(platForm != null);

  GankConfiguration copyWith({
    ThemeType themeType,
  }) {
    return GankConfiguration(
        themeType: themeType ?? this.themeType,
        platForm: platForm ?? this.themeType);
  }
}
