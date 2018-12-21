import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gank_app/all_page.dart';
import 'package:gank_app/gank_configuration.dart';
import 'package:gank_app/girl_page.dart';
import 'package:gank_app/model/app_model.dart';
import 'package:gank_app/options.dart';
import 'package:gank_app/reorder_and_switch_page.dart';
import 'package:gank_app/search_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  HomePage(this.configuration, this.updater);

  final GankConfiguration configuration;
  final ValueChanged<GankConfiguration> updater;

  @override
  _HomePageState createState() => new _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  GlobalKey<ScaffoldState> _globalKey = GlobalKey();

  TabController tabController;
  int lastTime = 0;

  List<AppModel> appModels = [];

  @override
  void initState() {
    super.initState();
    _loadAppModel();
    tabController = TabController(initialIndex: 0, length: 9, vsync: this);
  }

  Future<Null> _loadAppModel() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String json = prefs.getString("appModels") ?? null;
    List<AppModel> allAppModel;
    if (json == null) {
      allAppModel = getDefaultAppModels();
    } else {
      allAppModel = jsonDecode(json);
    }
    allAppModel.forEach((appModel) {
      if (appModel.enable == true) appModels.add(appModel);
    });
  }

  Future<Null> _handleThemeChange(ThemeType value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    if (widget.updater != null) {
      prefs.setInt('theme', value.index);
      widget.updater(widget.configuration.copyWith(themeType: value));
    }
  }

  Future<Null> _handlePlatformChange(PlatForm value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    if (widget.updater != null) {
      prefs.setInt('platform', value.index);
      widget.updater(widget.configuration.copyWith(platForm: value));
    }
  }

  Future<Null> _handleRandomChange(bool value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    if (widget.updater != null) {
      prefs.setBool('random', value);
      widget.updater(widget.configuration.copyWith(random: value));
    }
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark.copyWith(
      statusBarColor: Colors.transparent, //or set color with: Color(0xFF0000FF)
    ));
    return new WillPopScope(
        child: new Scaffold(
            key: _globalKey,
            appBar: new AppBar(
              title: new Text('干货集中营'),
              leading: IconButton(
                onPressed: () {
                  setState(() {
                    _globalKey.currentState.openDrawer();
                  });
                },
                icon: Icon(Icons.menu),
              ),
              actions: <Widget>[
                IconButton(
                  onPressed: () {
                    Navigator.pushNamed(context, SearchPage.realName);
                  },
                  icon: Icon(Icons.search),
                ),
              ],
              bottom: TabBar(
                controller: tabController,
                isScrollable: true,
                labelPadding: EdgeInsets.only(left: 14.0,right: 14.0),
                indicatorSize: TabBarIndicatorSize.label,
                tabs: appModels.map((AppModel appModel) {
                  return Tab(text: appModel.nameCn);
                }).toList(),
              ),
            ),
            body: TabBarView(
                controller: tabController,
                children: appModels.map((AppModel appModel) {
                  if (appModel.nameEn == "girl") {
                    return GirlPage(
                        key: PageStorageKey<String>('girl'),
                        random: widget.configuration.random);
                  } else {
                    return AllPage(
                        key: PageStorageKey<String>(appModel.nameEn),
                        type: appModel.nameEn,
                        random: widget.configuration.random);
                  }
                }).toList()),
            drawer: Drawer(
                child: ListView(
              children: <Widget>[
                FlutterLogo(
                  size: 150.0,
//                colors: Theme.of(context).primaryColor,
                  style: FlutterLogoStyle.horizontal,
                ),
                Divider(),
                ListTile(
                  title: Text('Light'),
                  trailing: Radio<ThemeType>(
                    value: ThemeType.light,
                    groupValue: widget.configuration.themeType,
                    onChanged: _handleThemeChange,
                  ),
                  onTap: () {
                    _handleThemeChange(ThemeType.light);
                  },
                ),
                ListTile(
                  title: Text('Dark'),
                  trailing: Radio<ThemeType>(
                    value: ThemeType.dark,
                    groupValue: widget.configuration.themeType,
                    onChanged: _handleThemeChange,
                  ),
                  onTap: () {
                    _handleThemeChange(ThemeType.dark);
                  },
                ),
                ListTile(
                  title: Text('Brown'),
                  trailing: Radio<ThemeType>(
                    value: ThemeType.brown,
                    groupValue: widget.configuration.themeType,
                    onChanged: _handleThemeChange,
                  ),
                  onTap: () {
                    _handleThemeChange(ThemeType.brown);
                  },
                ),
                ListTile(
                  title: Text('Blue'),
                  trailing: Radio<ThemeType>(
                    value: ThemeType.blue,
                    groupValue: widget.configuration.themeType,
                    onChanged: _handleThemeChange,
                  ),
                  onTap: () {
                    _handleThemeChange(ThemeType.blue);
                  },
                ),
                Divider(),
                ListTile(
                  title: Text('Android'),
                  trailing: Radio<PlatForm>(
                    value: PlatForm.android,
                    groupValue: widget.configuration.platForm,
                    onChanged: _handlePlatformChange,
                  ),
                  onTap: () {
                    _handlePlatformChange(PlatForm.android);
                  },
                ),
                ListTile(
                  title: Text('iOS'),
                  trailing: Radio<PlatForm>(
                    value: PlatForm.iOS,
                    groupValue: widget.configuration.platForm,
                    onChanged: _handlePlatformChange,
                  ),
                  onTap: () {
                    _handlePlatformChange(PlatForm.iOS);
                  },
                ),
                Divider(),
                CheckboxListTile(
                    title: Text('随机模式'),
                    value: widget.configuration.random,
                    onChanged: (bool value) {
                      _handleRandomChange(value);
                    }),
                ListTile(
                  title: Text('模块排序及开关'),
                  onTap: () {
                    Navigator.pushNamed(context, ReorderAndSwitchPage.realName);
                  },
                ),
              ],
            ))),
        onWillPop: () {
          if (Navigator.canPop(context)) {
            Navigator.pop(context);
          } else {
            int newTime = DateTime.now().millisecondsSinceEpoch;
            int result = newTime - lastTime;
            lastTime = newTime;
            if (result > 2000) {
              _globalKey.currentState
                  .showSnackBar(SnackBar(content: Text('再按一次退出系统！')));
            } else {
              SystemNavigator.pop();
            }
          }
          return null;
        });
  }
}
