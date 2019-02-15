import 'package:flutter/material.dart';
import 'package:gank_app/blocs/app_model_bloc.dart';
import 'package:gank_app/blocs/bloc_provider.dart';
import 'package:gank_app/model/app_model.dart';

class ReorderSwitchPage extends StatelessWidget {
  static const realName = "/reorderSwitch";

  @override
  Widget build(BuildContext context) {
    return BlocProvider<AppModelBloc>(
      bloc: AppModelBloc(),
      child: ReorderAndSwitchPage(),
    );
  }
}

class ReorderAndSwitchPage extends StatefulWidget {
  @override
  _ReorderAndSwitchPageState createState() => new _ReorderAndSwitchPageState();
}

class _ReorderAndSwitchPageState extends State<ReorderAndSwitchPage> {
  List<AppModel> allAppModel = [];

  AppModelBloc appModelBloc;

  @override
  void initState() {
    appModelBloc = BlocProvider.of<AppModelBloc>(context);
    _read();
    super.initState();
  }

  _read() async {
    final List<AppModel> appModels = await appModelBloc.getAll();
    print(appModels.length);
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
        title: Text('模块排序及开关'),
      ),
      body: StreamBuilder(
        stream: appModelBloc.appModelStream,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            final List<AppModel> allAppModel = snapshot.data;
            return ReorderableListView(
                children: allAppModel.map(buildListTile).toList(),
                onReorder: _onReorder);
          } else {
            return Container();
          }
        },
      ),
    );
  }

  void _onReorder(int oldIndex, int newIndex) {
    setState(() {
      if (newIndex > oldIndex) {
        newIndex -= 1;
      }
      final AppModel item = allAppModel.removeAt(oldIndex);
      allAppModel.insert(newIndex, item);
    });
  }

  Widget buildListTile(AppModel item) {
    return CheckboxListTile(
      key: Key(item.nameEn),
      value: (item.enable == 1) ? true : false,
      onChanged: (bool newValue) {
        setState(() {
          item.enable = newValue ? 1 : 0;
          appModelBloc.update(item);
          print(item);
        });
      },
      title: Text(item.nameCn),
      secondary: Icon(Icons.drag_handle),
    );
  }
}

class _ListItem {
  _ListItem(this.value, this.checkState);

  final String value;
  bool checkState;
}
