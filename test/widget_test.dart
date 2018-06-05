// This is a basic Flutter widget test.
// To perform an interaction with a widget in your test, use the WidgetTester utility that Flutter
// provides. For example, you can send tap and scroll gestures. You can also use WidgetTester to
// find child widgets in the widget tree, read text, and verify that the values of widget properties
// are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:dio/dio.dart';
import 'dart:convert';

import 'package:gank_app/main.dart';

Future main() async {

    Dio dio = new Dio();
//    String url = 'http://shici.51tvbao.cn/Api/banner';
    String url = 'http://gank.io/api/data/Android/10/1';
    Response response = await dio.get(url);

    print(response.data.toString());

    Map<String,dynamic> map = response.data;

    print(map['results']);

}


