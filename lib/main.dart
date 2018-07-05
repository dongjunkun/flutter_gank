import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gank_app/gank_configuration.dart';
import 'package:gank_app/home_page.dart';
import 'package:gank_app/search_page.dart';
import 'package:gank_app/options.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:connectivity/connectivity.dart';

void main() => runApp(new MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => new _MyAppState();
}

class _MyAppState extends State<MyApp> {
  GankConfiguration _configuration = GankConfiguration(
      platForm: PlatForm.android,
      themeType: ThemeType.light,
      random: false);

  StreamSubscription<ConnectivityResult> _streamSubscription;

  void configurationUpdater(GankConfiguration value) {
    setState(() {
      _configuration = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    MaterialPageRoute.debugEnableFadingRoutes = true;
    return MaterialApp(
      title: '干货集中营',
      theme: theme,
      initialRoute: '/',
      routes: {
        '/': (context) => HomePage(_configuration, configurationUpdater),
        '/search': (context) => SearchPage()
      },
    );
  }

  @override
  void initState() {
    super.initState();
    _loadConfig();
    _streamSubscription = Connectivity()
        .onConnectivityChanged
        .listen((ConnectivityResult result) {
      if (result == ConnectivityResult.none) {
        networkEnable = false;
      } else {
        networkEnable = true;
      }
      setState(() {});
    });

  }

  @override
  void dispose() {
    _streamSubscription?.cancel();
    super.dispose();
  }

  Future<Null> _loadConfig() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    ThemeType themeType =
        ThemeType.values.elementAt(prefs.getInt('theme') ?? 0);
    PlatForm platForm =
        PlatForm.values.elementAt(prefs.getInt('platform') ?? 0);
    bool random = prefs.getBool('random' ?? false);
    configurationUpdater(_configuration.copyWith(
        themeType: themeType, platForm: platForm, random: random));
  }

  TargetPlatform get platform {
    switch (_configuration.platForm) {
      case PlatForm.android:
        return TargetPlatform.android;
      case PlatForm.iOS:
        return TargetPlatform.iOS;
    }
    assert(_configuration.platForm != null);
    return null;
  }

  ThemeData get theme {
    switch (_configuration.themeType) {
      case ThemeType.brown:
        return ThemeData(
          primarySwatch: Colors.brown,
          brightness: Brightness.light,
          indicatorColor:Colors.white,
          platform: platform,
        );
      case ThemeType.light:
        return ThemeData(
          primaryColor: Colors.white,
          brightness: Brightness.light,
          platform: platform,
        );
      case ThemeType.dark:
        return ThemeData(
          brightness: Brightness.dark,
          accentColor: Colors.red,
          platform: platform,
        );
      case ThemeType.pink:
        return ThemeData(
          primarySwatch: Colors.pink,
          brightness: Brightness.light,
          indicatorColor:Colors.white,
          platform: platform,
        );
      case ThemeType.teal:
        return ThemeData(
          primarySwatch: Colors.teal,
          indicatorColor:Colors.white,
          platform: platform,
        );
      case ThemeType.blue:
        return ThemeData(
          indicatorColor:Colors.white,
          primarySwatch: Colors.blue,
          platform: platform,
        );
    }
    assert(_configuration.themeType != null);

    return null;
  }
}
