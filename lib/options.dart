import 'package:gank_app/model/app_model.dart';

int pageSize = 30;
bool networkEnable = true;

List<AppModel> getDefaultAppModels() {
  List<AppModel> appModels = [];
  appModels.add(AppModel('全部', 'all', true));
  appModels.add(AppModel('妹纸图', 'girl', true));
  appModels.add(AppModel('Android', 'Android', true));
  appModels.add(AppModel('iOS', 'iOS', true));
  appModels.add(AppModel('前端', '前端', true));
  appModels.add(AppModel('休息视频', '休息视频', false));
  appModels.add(AppModel('拓展资源', '拓展资源', false));
  appModels.add(AppModel('App', 'App', false));
  appModels.add(AppModel('瞎推荐', '瞎推荐', false));

  return appModels;
}
