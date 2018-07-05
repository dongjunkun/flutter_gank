import 'package:flutter/material.dart';
import 'package:gank_app/all_page.dart';

class SearchPage extends StatefulWidget {
  static const realName = '/search';

  @override
  _SearchPageState createState() => new _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();

  final controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: TextField(
          controller: controller,
          autofocus: true,
          decoration: InputDecoration(
            hintText: '搜索真的好了，不骗你',
            border: InputBorder.none,
//            hintStyle: TextStyle(
//              color: Colors.white.withAlpha(100)
//            )
          ),
//          style: TextStyle(
//            color: Colors.white
//          ),
          onChanged: (text){
            print(text);
          },
        ),
        actions: <Widget>[
          new IconButton(icon: Icon(Icons.search), onPressed: (){
            _scaffoldKey.currentState.showSnackBar(SnackBar(content:Text(controller.text) ));
          })
        ],
      ),
    );
  }
  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}
