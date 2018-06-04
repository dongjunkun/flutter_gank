import 'package:flutter/material.dart';

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
            hintText: 'input key word'
          ),
        ),
      ),
    );
  }
}
