import 'package:gank_app/blocs/bloc_provider.dart';
import 'package:gank_app/model/app_model.dart';
import 'package:gank_app/resources/repository.dart';
import 'package:rxdart/rxdart.dart';

class AppModelBloc implements BlocBase {
  final _repository = Repository();

  List<AppModel> _appModels = [];

  final _appModelController = BehaviorSubject<List<AppModel>>();

  Function(List<AppModel>) get sink => _appModelController.sink.add;

  Observable<List<AppModel>> get appModelStream => _appModelController.stream;

  Future<List> getAll() async {
    final res = await _repository.getALl('appModel');
    _appModels = res.map((item) => AppModel.formJson(item)).toList();
    _appModelController.add(_appModels);
    return _appModels;
  }

  insert(AppModel item) async {
    await _repository.insert('appModel', item);
    _appModels.add(item);
    _appModelController.add(_appModels);
  }

  update(AppModel item) async {
    final index =
        _appModels.indexWhere((appModel) => appModel.nameEn == item.nameEn);
    _appModels[index] = item;
    await _repository.update("appModel", item);
    _appModelController.add(_appModels);
  }

  delete(AppModel item) async {
    await _repository.delete('appModel', item);
    _appModels.remove(item);
    _appModelController.add(_appModels);
  }

  @override
  void dispose() {
    _appModelController.close();
  }
}
