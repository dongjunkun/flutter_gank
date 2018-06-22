import 'package:flutter/material.dart';
import 'package:gank_app/all_page.dart';

class SearchPage extends StatefulWidget {
  static const realName = '/search';

  @override
  _SearchPageState createState() => new _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
        title: TextField(
          decoration: InputDecoration(
            hintText: '搜索真的好了，不骗你',
            hintStyle: TextStyle(
              color: Colors.white.withAlpha(100)
            )
          ),
          style: TextStyle(
            color: Colors.white
          ),
        ),
      ),
    );
  }
}
