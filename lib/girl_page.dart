import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_advanced_networkimage/flutter_advanced_networkimage.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:gank_app/options.dart';

class GirlPage extends StatefulWidget {
  bool random = false;

  GirlPage({Key key, @required this.random}) : super(key: key);

  @override
  _GirlPageState createState() => new _GirlPageState();
}

class _GirlPageState extends State<GirlPage> {
  List<dynamic> list =[];

  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();
  GlobalKey<RefreshIndicatorState> _refreshIndicatorKey = GlobalKey();

  String _pageIdentifier;
  String _dataIdentifier;

  int _page;

  ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _pageIdentifier = '福利_pageIdentifier';
    _dataIdentifier = '福利_dataIdentifier';
    _page = PageStorage
            .of(context)
            .readState(context, identifier: _pageIdentifier) ??
        1;
    list.addAll(PageStorage
            .of(context)
            .readState(context, identifier: _dataIdentifier) ??
        []);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // 获取到 NestedScrollView 为子 ScrollView 添加的特殊 ScrollController
    // 如果自己为 ScrollView 添加一个新的 ScrollController 会导致
    // NestedScrollView 和 SliverAppBar 带来的自动隐藏 AppBar 失效
    _scrollController = ScrollController();
    _scrollController.addListener(_handleScroll);
  }

  void _handleScroll() {
    print('_GirlPageState._handleScroll');
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      getData(false);
    }
  }

  Future<Null> _handleRefresh() {
//    final Completer<Null> completer = new Completer<Null>();
//    new Timer(const Duration(seconds: 3), () {
//      completer.complete(null);
//    });
//    return completer.future;
    return getData(true);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_handleScroll);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (list.isEmpty) {
      getData(true);
      return Center(
        child: CircularProgressIndicator(),
      );
    } else {
      return new Scaffold(
        key: _scaffoldKey,
        body: new RefreshIndicator(
          key: _refreshIndicatorKey,
          child: StaggeredGridView.countBuilder(
            controller: _scrollController,
            padding: const EdgeInsets.all(1.0),
            crossAxisCount: 2,
            mainAxisSpacing: 1.0,
            itemCount: list.length,
            crossAxisSpacing: 1.0,
            itemBuilder: (BuildContext context, int index) =>
                _buildImageItem(list.elementAt(index)),
            staggeredTileBuilder: (int index) => StaggeredTile.fit(1),
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

  Future<Null> getData(bool isClean) async {
    if (isClean) {
      _page = 1;
    }
    Dio dio = new Dio();
    String url;
    if (widget.random) {
      url = 'http://gank.io/api/random/data/福利/$pageSize';
    } else {
      url = 'http://gank.io/api/data/福利/$pageSize/$_page';
    }
    Response response = await dio.get(url);

    Map<String, dynamic> map = response.data;
    List<dynamic> ganhuos = map['results'];

    _page++;
    if (isClean) {
      list.clear();
    } else {}

    list.addAll(ganhuos);
//    list = list.toSet().toList(growable: true);
    PageStorage
        .of(context)
        .writeState(context, list, identifier: _dataIdentifier);
    PageStorage
        .of(context)
        .writeState(context, _page, identifier: _pageIdentifier);
    setState(() {});
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
        child: Image(
          image: AdvancedNetworkImage(ganHuo['url']),
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
