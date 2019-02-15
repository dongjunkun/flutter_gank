part of 'app_model.dart';

AppModel _$AppModelFromJson(Map<String, dynamic> json) => AppModel(
    json['nameCn'] as String, json['nameEn'] as String, json['enable'] as int);

abstract class _AppModelSerializerMiXin {
  String get nameCn;

  String get nameEn;

  int get enable;

  Map<String, dynamic> toJson() =>
      <String, dynamic>{'nameCn': nameCn, 'nameEn': nameEn, 'enable': enable};
}
