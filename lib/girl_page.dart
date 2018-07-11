import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_advanced_networkimage/flutter_advanced_networkimage.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:gank_app/common_view/error_view.dart';
import 'package:gank_app/common_view/no_network_view.dart';
import 'package:gank_app/model/ganhuo.dart';
import 'package:gank_app/options.dart';
import 'package:cached_network_image/cached_network_image.dart';

class GirlPage extends StatefulWidget {
  bool random = false;

  GirlPage({Key key, @required this.random}) : super(key: key);

  @override
  _GirlPageState createState() => new _GirlPageState();
}

class _GirlPageState extends State<GirlPage> {
  List<GanHuo> list = [];

  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();
  GlobalKey<RefreshIndicatorState> _refreshIndicatorKey = GlobalKey();

  String _pageIdentifier;
  String _dataIdentifier;
  String _scrollDistanceIdentifier;

  int _page;
  bool isError = false;
  ScrollController _scrollController;

  CancelToken _token = new CancelToken();

  double scrollDistance = 0.0;

  @override
  void initState() {
    super.initState();
    _pageIdentifier = '福利_pageIdentifier';
    _dataIdentifier = '福利_dataIdentifier';
    _scrollDistanceIdentifier = 'scrollDistanceIndentifier';
    _page = PageStorage
            .of(context)
            .readState(context, identifier: _pageIdentifier) ??
        1;
    scrollDistance = PageStorage
            .of(context)
            .readState(context, identifier: _scrollDistanceIdentifier) ??
        0.0;

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

  void _handleScroll() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      getData(false);
    }
    scrollDistance = _scrollController.position.pixels;
    PageStorage.of(context).writeState(context, scrollDistance,
        identifier: _scrollDistanceIdentifier);
    setState(() {});
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
    _scrollController?.removeListener(_handleScroll);
    _token?.cancel();
    super.dispose();
  }

  Widget _buildFloatActionButton() {
    double screenHeight = MediaQuery.of(context).size.height;
    if (scrollDistance > screenHeight / 2) {
      return FloatingActionButton(
        onPressed: () {
          _scrollController.animateTo(0.0,
              duration: Duration(milliseconds: 300), curve: Curves.easeOut);
        },
        tooltip: 'top',
        child: new Icon(Icons.arrow_upward),
      );
    } else {
      return FloatingActionButton(
        onPressed: () {
          _refreshIndicatorKey.currentState.show();
        },
        tooltip: 'refresh',
        child: new Icon(Icons.refresh),
      );
    }
  }

  Widget _buildRefreshContent() {
    if (list.isEmpty) {
      if (!networkEnable) {
        return NoNetworkView();
      } else if (isError) {
        return ErrorView();
      } else {
        getData(true);
        return Center(
          child: CircularProgressIndicator(),
        );
      }
    } else {
      return StaggeredGridView.countBuilder(
        controller: _scrollController,
        padding: const EdgeInsets.all(1.0),
        crossAxisCount:
            MediaQuery.of(context).orientation == Orientation.portrait ? 2 : 4,
        mainAxisSpacing: 1.0,
        itemCount: list.length,
        crossAxisSpacing: 1.0,
        itemBuilder: (BuildContext context, int index) =>
            _buildImageItem(list.elementAt(index)),
        staggeredTileBuilder: (int index) => StaggeredTile.fit(1),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      key: _scaffoldKey,
      body: new RefreshIndicator(
        key: _refreshIndicatorKey,
        child: _buildRefreshContent(),
        onRefresh: _handleRefresh,
      ),
      floatingActionButton: _buildFloatActionButton(),
    );
  }

  Future<Null> getData(bool isClean) async {
    if (!networkEnable) {
      _scaffoldKey.currentState
          .showSnackBar(SnackBar(content: Text('网络开小差了~~')));
      return;
    }
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
    Response response = await dio.get(url, cancelToken: _token);

    GanHuos ganHuos = GanHuos.fromJson(response.data);
    _page++;
    if (isClean) {
      list.clear();
    } else {}

    list.addAll(ganHuos.results);
//    list = list.toSet().toList(growable: true);
    PageStorage
        .of(context)
        .writeState(context, list, identifier: _dataIdentifier);
    PageStorage
        .of(context)
        .writeState(context, _page, identifier: _pageIdentifier);
    setState(() {});
  }

  Widget _buildImageItem(GanHuo ganHuo) {
    return new GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => new ImagePreViewWidget(url: ganHuo.url),
            ));
      },
      child: new Hero(
        tag: ganHuo.url,
//          child: Image.network(ganHuo['url'])
//        child: Image(
//          image: AdvancedNetworkImage(ganHuo.url),
//        ),
      child: CachedNetworkImage(imageUrl: ganHuo.url),
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
//                    child: Image(
//                      image: AdvancedNetworkImage(url),
//                    )
                  child: CachedNetworkImage(imageUrl:url),
                ))));
  }
}
