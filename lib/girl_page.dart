import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:gank_app/options.dart';

class GirlPage extends StatefulWidget {
  @override
  _GirlPageState createState() => new _GirlPageState();
}

class _GirlPageState extends State<GirlPage> {
  List<dynamic> list = List<dynamic>();

  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();
  GlobalKey<RefreshIndicatorState> _refreshIndicatorKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    getData();
  }

  Future<Null> _handleRefresh() {
    final Completer<Null> completer = new Completer<Null>();
    new Timer(const Duration(seconds: 3), () {
      completer.complete(null);
    });
    return completer.future;
  }

  @override
  Widget build(BuildContext context) {
    if (list.isEmpty) {
      return Center(
        child: CircularProgressIndicator(),
      );
    } else {
      return new Scaffold(
        key: _scaffoldKey,
        body: new RefreshIndicator(
          key: _refreshIndicatorKey,
          child: StaggeredGridView.countBuilder(
            padding: const EdgeInsets.all(1.0),
            crossAxisCount: 2,
            mainAxisSpacing: 1.0,
            itemCount: list.length,
            crossAxisSpacing: 1.0,
            itemBuilder: (BuildContext context, int index) =>
                _buildImageItem(list.elementAt(index)),
            staggeredTileBuilder: (int index) => StaggeredTile.fit(1),
          ),
          onRefresh:_handleRefresh,
        ),
//        body: new ListView.builder(
//          itemCount: list.length,
//          itemBuilder: (BuildContext context, int index) {
//            if (list.elementAt(index)['type'] == '福利') {
//              return _buildImageItem(list.elementAt(index));
//            } else {
//              return _buildTextItem(list.elementAt(index));
//            }
//          },
//        ),
        floatingActionButton: new FloatingActionButton(
          onPressed: () {
            _refreshIndicatorKey.currentState.show();
          },
          tooltip: 'refresh',
          child: new Icon(Icons.refresh),
        ),
      );
    }
  }

  Future getData() async {
    Dio dio = new Dio();
    Response response = await dio.get("http://gank.io/api/data/福利/$pageSize/1");

    Map<String, dynamic> map = response.data;
    List<dynamic> ganhuos = map['results'];

    setState(() {
      list.clear();
      list.addAll(ganhuos);
    });
  }

  Widget _buildImageItem(dynamic ganHuo) {
    return new Hero(
      tag: ganHuo['url'],
//          child: Image.network(ganHuo['url'])
      child: new InkWell(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    new ImagePreViewWidget(url: ganHuo['url']),
              ));
        },
        child: CachedNetworkImage(
          imageUrl: ganHuo['url'],
        ),
      ),
    );
  }
}

class ImagePreViewWidget extends StatelessWidget {
  final String url;

  const ImagePreViewWidget({
    Key key,
    @required this.url,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        body: new Center(
            child: new GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Hero(
                  tag: url,
                  child: CachedNetworkImage(imageUrl: url),
                ))));
  }
}
