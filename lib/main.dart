import 'dart:async';

import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gank_app/blocs/app_model_bloc.dart';
import 'package:gank_app/blocs/bloc_provider.dart';
import 'package:gank_app/gank_configuration.dart';
import 'package:gank_app/pages/home_page.dart';
import 'package:gank_app/options.dart';
import 'package:gank_app/pages/reorder_and_switch_page.dart';
import 'package:gank_app/pages/search_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_stetho/flutter_stetho.dart';

void main() {
  Stetho.initialize();
  runApp(App());
}

class App extends StatelessWidget {


  @override
  Widget build(BuildContext context) {
    return BlocProvider<AppModelBloc>(
      bloc: AppModelBloc(),
      child: MyApp(),
    );
  }
}


class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => new _MyAppState();
}

class _MyAppState extends State<MyApp> {
  GankConfiguration _configuration = GankConfiguration(
      platForm: PlatForm.android, themeType: ThemeType.light, random: false);

  StreamSubscription<ConnectivityResult> _streamSubscription;

  void configurationUpdater(GankConfiguration value) {
    setState(() {
      _configuration = value;
    });
  }

  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      title: '干货集中营',
      theme: theme,
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/': (context) => HomePage(_configuration, configurationUpdater),
        '/search': (context) => SearchPage(),
        '/reorderAndSwitch': (context) => ReorderAndSwitchPage()
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
          indicatorColor: Colors.white,
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
      case ThemeType.blue:
        return ThemeData(
          indicatorColor: Colors.white,
          primarySwatch: Colors.blue,
          platform: platform,
        );
    }
    assert(_configuration.themeType != null);

    return null;
  }
}
