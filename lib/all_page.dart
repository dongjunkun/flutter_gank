import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_advanced_networkimage/flutter_advanced_networkimage.dart';
import 'package:gank_app/options.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:gank_app/model/ganhuo.dart';

class AllPage extends StatefulWidget {
  final String type;
  bool random = false;

  AllPage({Key key, @required this.type, @required this.random})
      : super(key: key);

  @override
  _AllPageState createState() => new _AllPageState();
}

class _AllPageState extends State<AllPage> {
  List<GanHuo> list = [];
  GlobalKey<ScaffoldState> _globalKey = GlobalKey();
  GlobalKey<RefreshIndicatorState> _refreshIndicatorKey = GlobalKey();

  String _pageIdentifier;
  String _dataIdentifier;

  int _page;

  ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _pageIdentifier = '${widget.type}_pageIdentifier';
    _dataIdentifier = '${widget.type}_dataIdentifier';

    _page =
        PageStorage.of(context).readState(context, identifier: _pageIdentifier);
    list.addAll(PageStorage
            .of(context)
            .readState(context, identifier: _dataIdentifier) ??
        []);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _scrollController = ScrollController();
    _scrollController.addListener(_handleScroll);
  }

  Future<Null> _handleRefresh() {
    return getData(true, widget.type);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_handleScroll);
    super.dispose();
  }

  void _handleScroll() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      getData(false, widget.type);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (list.isEmpty) {
      getData(true, widget.type);
      return Center(
        child: CircularProgressIndicator(),
      );
    } else {
      return new Scaffold(
        key: _globalKey,
        body: RefreshIndicator(
          key: _refreshIndicatorKey,
          child: new ListView.builder(
            controller: _scrollController,
            itemCount: list.length,
            itemBuilder: (BuildContext context, int index) {
              if (list.elementAt(index).type == '福利') {
                return _buildImageItem(list.elementAt(index).url);
              } else {
                return _buildTextItem(list.elementAt(index));
              }
            },
          ),
          onRefresh: _handleRefresh,
        ),
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

  Future<Null> launcherUrl(String url) async {
    if (await canLaunch(url)) {
      await launch(url, forceSafariVC: false, forceWebView: false);
    } else {
      throw 'Could not launch $url';
    }
  }

  Future<Null> getData(bool isClean, String type) async {
    if (isClean) {
      _page = 1;
    }
    Dio dio = new Dio();
    String url;
    if (widget.random) {
      url = 'http://gank.io/api/random/data/$type/$pageSize';
    } else {
      url = 'http://gank.io/api/data/$type/$pageSize/$_page';
    }
    Response response = await dio.get(url);

//    Map<String, dynamic> map = response.data
    GanHuos  ganHuos = GanHuos.fromJson(response.data);
//    List<dynamic> ganhuos = map['results'];

    _page++;
    if (isClean) {
      list.clear();
    }
    list.addAll(ganHuos.results);

    PageStorage
        .of(context)
        .writeState(context, list, identifier: _dataIdentifier);
    PageStorage
        .of(context)
        .writeState(context, _page, identifier: _pageIdentifier);

    setState(() {});
  }

  Widget _buildTextItem(GanHuo ganHuo) {
//    List<dynamic> urls = ganHuo['images'];
//
//    if (urls != null && urls.length > 0) {
//      return new Column(
//        children: <Widget>[
//          new InkWell(
//            onTap: () {
//              _globalKey.currentState.showSnackBar(
//                  SnackBar(content: Text(ganHuo['desc'])));
//            },
//            child: new ListTile(
//              title: Text(
//                ganHuo['desc'],
//                textAlign: TextAlign.justify,
//                style: TextStyle(decoration: TextDecoration.none),
//              ),
//            ),
//          ),
//          new SizedBox.fromSize(
//            size: Size.fromHeight(200.0),
//            child: new ListView.builder(
//              scrollDirection: Axis.horizontal,
//              itemCount: urls.length,
//              shrinkWrap: false,
//              padding: const EdgeInsets.only(left: 8.0,right: 8.0),
//              itemBuilder: (context, index) {
//               return _buildImageItem(urls.elementAt(index));
////                new Container(
////                    color: Colors.red,
////                    child: new Text('aaaaaaaaaaaaaaaa'));
//              },
//            ),
//          ),
//        ],
//      );
//    } else {
    return new InkWell(
      onTap: () {
//        _globalKey.currentState
//            .showSnackBar(SnackBar(content: Text(ganHuo['desc'])));
        launcherUrl(ganHuo.url);
      },
      child: new ListTile(
//        leading: Icon(Icons.android,
//          size: 16.0,
//
//        ),
        title: Text(
          ganHuo.desc,
          textAlign: TextAlign.justify,
          style: TextStyle(decoration: TextDecoration.none),
        ),
      ),
    );
//    }
  }

  Widget _buildImageItem(String url) {
    return Padding(
      padding: const EdgeInsets.only(left: 12.0, right: 100.0),
      child: new Card(
        child: new Hero(
          tag: url,
//          child: Image.network(ganHuo['url'])
          child: new InkWell(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => new ImagePreViewWidget(url: url),
                  ));
            },
            child: Image(
              image: AdvancedNetworkImage(url),
            ),
          ),
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
                    child: Image(
                      image: AdvancedNetworkImage(url),
                    )))));
  }
}
