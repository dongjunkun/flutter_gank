part of 'app_model.dart';

AppModel _$AppModelFromJson(Map<String, dynamic> json) => AppModel(
    json['modelIndex'] as int,
    json['nameCn'] as String,
    json['nameEn'] as String,
    json['enable'] as int);

abstract class _AppModelSerializerMiXin {
  int get modelIndex;

  String get nameCn;

  String get nameEn;

  int get enable;

  Map<String, dynamic> toJson() => <String, dynamic>{
        'modelIndex': modelIndex,
        'nameCn': nameCn,
        'nameEn': nameEn,
        'enable': enable
      };
}
