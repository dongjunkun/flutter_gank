part 'package:gank_app/model/app_model.g.dart';

class AppModel extends Object with _AppModelSerializerMiXin{
  String nameCn;
  String nameEn;
  bool enable;

  AppModel(this.nameCn, this.nameEn, this.enable);

  factory AppModel.formJson(Map<String,dynamic> json)
   => _$AppModelFromJson(json);

}