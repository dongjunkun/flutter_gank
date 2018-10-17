import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:gank_app/model/app_model.dart';
import 'package:gank_app/options.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ReorderAndSwitchPage extends StatefulWidget {
  static const realName = "/reorderAndSwitch";

  @override
  _ReorderAndSwitchPageState createState() => new _ReorderAndSwitchPageState();
}

class _ReorderAndSwitchPageState extends State<ReorderAndSwitchPage> {

  List<AppModel> allAppModel = [];

  @override
  void initState() {
    _loadAppModel();
    super.initState();
  }

  Future<Null> _loadAppModel() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String json = prefs.getString("appModels") ?? null;

    if (json == null) {
      allAppModel = getDefaultAppModels();
    } else {
      allAppModel = jsonDecode(json);
    }
    setState(() {

    });
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
        title: Text('模块排序及开关'),
      ),
      body: ReorderableListView(children: allAppModel.map(buildListTile).toList(), onReorder: _onReorder),
    );
  }


  void _onReorder(int oldIndex, int newIndex){
    setState(() {
      if(newIndex > oldIndex){
        newIndex -= 1;
      }
      final AppModel item = allAppModel.removeAt(oldIndex);
      allAppModel.insert(newIndex, item);
    });
  }

  Widget buildListTile(AppModel item) {
    return CheckboxListTile(
      key: Key(item.nameEn) ,
      value: item.enable ?? false,

      onChanged: (bool newValue) {
        setState(() {
          item.enable = newValue;
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
