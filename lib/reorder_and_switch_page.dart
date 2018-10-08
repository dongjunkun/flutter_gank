import 'package:flutter/material.dart';

class ReorderAndSwitchPage extends StatefulWidget {
  static const realName = "/reorderAndSwitch";

  @override
  _ReorderAndSwitchPageState createState() => new _ReorderAndSwitchPageState();
}

class _ReorderAndSwitchPageState extends State<ReorderAndSwitchPage> {
  final List<_ListItem> _items = <String>[
    '全部',
    '妹纸图',
    'Android',
    'iOS',
    '休息视频',
    '前端',
    '拓展资源',
    'App',
    '瞎推荐'
  ].map((String item) => new _ListItem(item, true)).toList();

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
        title: Text('模块排序及开关'),
      ),
      body: ReorderableListView(children: _items.map(buildListTile).toList(), onReorder: _onReorder),
    );
  }


  void _onReorder(int oldIndex, int newIndex){
    setState(() {
      if(newIndex > oldIndex){
        newIndex -= 1;
      }
      final _ListItem item = _items.removeAt(oldIndex);
      _items.insert(newIndex, item);
    });
  }

  Widget buildListTile(_ListItem item) {
    return CheckboxListTile(
      key: Key(item.value) ,
      value: item.checkState ?? false,
      onChanged: (bool newValue) {
        setState(() {
          item.checkState = newValue;
        });
      },
      title: Text(item.value),
    );
  }
}

class _ListItem {
  _ListItem(this.value, this.checkState);

  final String value;
  bool checkState;
}
