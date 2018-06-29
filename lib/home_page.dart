import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gank_app/all_page.dart';
import 'package:gank_app/gank_configuration.dart';
import 'package:gank_app/girl_page.dart';
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

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 9, vsync: this);
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

  Future<Null> _handlerandomChange(bool value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    if (widget.updater != null) {
      prefs.setBool('random', value);
      widget.updater(widget.configuration.copyWith(random: value));
    }
  }

  @override
  Widget build(BuildContext context) {
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
                indicatorSize: TabBarIndicatorSize.label,
                tabs: <Widget>[
                  Tab(text: '全部'),
//                Tab(text: '推荐'),
                  Tab(text: '妹纸图'),
                  Tab(text: 'Android'),
                  Tab(text: 'iOS'),
                  Tab(text: '休息视频'),
                  Tab(text: '前端'),
                  Tab(text: '拓展资源'),
                  Tab(text: 'App'),
                  Tab(text: '瞎推荐'),
                ],
              ),
            ),
            body: TabBarView(controller: tabController, children: <Widget>[
              AllPage(type: 'all',random: widget.configuration.random),
//            RecommendPage(),
              GirlPage(random: widget.configuration.random),
              AllPage(type: 'Android',random: widget.configuration.random),
              AllPage(type: 'iOS',random: widget.configuration.random),
              AllPage(type: '休息视频',random: widget.configuration.random),
              AllPage(type: '前端',random: widget.configuration.random),
              AllPage(type: '拓展资源',random: widget.configuration.random),
              AllPage(type: 'App',random: widget.configuration.random),
              AllPage(type: '瞎推荐',random: widget.configuration.random),
            ]),
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
                  title: Text('Pink'),
                  trailing: Radio<ThemeType>(
                    value: ThemeType.pink,
                    groupValue: widget.configuration.themeType,
                    onChanged: _handleThemeChange,
                  ),
                  onTap: () {
                    _handleThemeChange(ThemeType.pink);
                  },
                ),
                ListTile(
                  title: Text('Teal'),
                  trailing: Radio<ThemeType>(
                    value: ThemeType.teal,
                    groupValue: widget.configuration.themeType,
                    onChanged: _handleThemeChange,
                  ),
                  onTap: () {
                    _handleThemeChange(ThemeType.teal);
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
                      _handlerandomChange(value);
                    }),
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
        });
  }
}
