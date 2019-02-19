part 'package:gank_app/model/app_model.g.dart';

class AppModel extends Object with _AppModelSerializerMiXin{
  int modelIndex;
  String nameCn;
  String nameEn;
  int enable;

  AppModel(this.modelIndex,this.nameCn, this.nameEn, this.enable);

  factory AppModel.formJson(Map<String,dynamic> json)
   => _$AppModelFromJson(json);

}