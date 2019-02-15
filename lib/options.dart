import 'package:gank_app/model/app_model.dart';

int pageSize = 50;
bool networkEnable = true;

List<AppModel> getDefaultAppModels() {
  List<AppModel> appModels = [];
  appModels.add(AppModel('全部', 'all', 1));
  appModels.add(AppModel('妹纸', 'girl', 1));
  appModels.add(AppModel('Android', 'Android', 1));
  appModels.add(AppModel('iOS', 'iOS', 1));
  appModels.add(AppModel('前端', '前端', 1));
  appModels.add(AppModel('休息视频', '休息视频', 0));
  appModels.add(AppModel('拓展资源', '拓展资源', 0));
  appModels.add(AppModel('App', 'App', 1));
  appModels.add(AppModel('瞎推荐', '瞎推荐', 0));

  return appModels;
}
