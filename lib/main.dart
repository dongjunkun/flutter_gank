import 'package:flutter/material.dart';
import 'package:gank_app/search_page.dart';
import 'package:gank_app/all_page.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    MaterialPageRoute.debugEnableFadingRoutes = true;
    return new MaterialApp(
      title: '干货集中营',
      theme: new ThemeData(
        primarySwatch: Colors.brown,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => MyHomePage(),
        '/search': (context) => SearchPage()
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  GlobalKey<ScaffoldState> _globalKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return new DefaultTabController(
      length: 9,

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
            )
          ],
          bottom: TabBar(
            isScrollable: true,

            indicatorSize: TabBarIndicatorSize.label,
            tabs: <Widget>[
              Tab(text: '全部'),
              Tab(text: '福利'),
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
        body: TabBarView(children: <Widget>[
          AllPage(type: 'all'),
          AllPage(type: '福利'),
          AllPage(type: 'Android'),
          AllPage(type: 'iOS'),
          AllPage(type: '休息视频'),
          AllPage(type: '前端'),
          AllPage(type: '拓展资源'),
          AllPage(type: 'App'),
          AllPage(type: '瞎推荐'),
        ]),

        drawer: Container(
          color: Colors.white,
          height: double.infinity,
          width: MediaQuery.of(context).size.width - 56,
        ),
      ),
    );
  }
}
