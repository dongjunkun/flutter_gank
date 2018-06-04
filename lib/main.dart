import 'package:flutter/material.dart';
import 'package:gank_app/search_page.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    MaterialPageRoute.debugEnableFadingRoutes = true;
    return new MaterialApp(
      title: 'Gank',
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
  int _counter = 0;
  GlobalKey<ScaffoldState> _globalKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return new DefaultTabController(
      length: 9,
      child: new Scaffold(
        key: _globalKey,
        appBar: new AppBar(
          title: new Text('gank'),
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
              Tab(text: 'all'),
              Tab(text: 'girl'),
              Tab(text: 'android'),
              Tab(text: 'ios'),
              Tab(text: 'video'),
              Tab(text: 'javaScript'),
              Tab(text: 'resource'),
              Tab(text: 'app'),
              Tab(text: 'recommend'),
            ],
          ),
        ),
        body: TabBarView(children: <Widget>[
          new Center(child: Text('all')),
          new Center(child: Text('girl')),
          new Center(child: Text('android')),
          new Center(child: Text('ios')),
          new Center(child: Text('video')),
          new Center(child: Text('javaScript')),
          new Center(child: Text('resource')),
          new Center(child: Text('app')),
          new Center(child: Text('recommend')),
        ]),
        floatingActionButton: new FloatingActionButton(
          onPressed: () {
            var snackBar = SnackBar(content: Text('come soon'));
            _globalKey.currentState.showSnackBar(snackBar);
          },
          tooltip: 'refresh',
          child: new Icon(Icons.refresh),
        ),
        drawer: Container(
          color: Colors.white,
          height: double.infinity,
          width: MediaQuery.of(context).size.width - 56,
        ),
      ),
    );
  }
}
