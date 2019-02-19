import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:gank_app/model/ganhuo.dart';
import 'package:gank_app/options.dart';
import 'package:gank_app/ui/common_view/error_view.dart';
import 'package:gank_app/ui/common_view/no_network_view.dart';
import 'package:url_launcher/url_launcher.dart';

class AllPage extends StatefulWidget {
  final String type;
  bool random = false;
  bool enableGif = false;

  AllPage(
      {Key key,
      @required this.type,
      @required this.random,
      @required this.enableGif})
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
  String _scrollDistanceIdentifier;

  int _page;

  ScrollController _scrollController;

  double scrollDistance = 0.0;

  bool isError = false;
  bool isLoading = false;

  CancelToken _token = new CancelToken();

  @override
  void initState() {
    super.initState();

    _pageIdentifier = '${widget.type}_pageIdentifier';
    _dataIdentifier = '${widget.type}_dataIdentifier';
    _scrollDistanceIdentifier = '${widget.type}_scrollDistanceIndentifier';
    scrollDistance = PageStorage.of(context)
            .readState(context, identifier: _scrollDistanceIdentifier) ??
        0.0;

    _page =
        PageStorage.of(context).readState(context, identifier: _pageIdentifier);
    list.addAll(PageStorage.of(context)
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
    _scrollController?.removeListener(_handleScroll);
    _token?.cancel();
    super.dispose();
  }

  void _handleScroll() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      getData(false, widget.type);
    }
    scrollDistance = _scrollController.position.pixels;
    PageStorage.of(context).writeState(context, scrollDistance,
        identifier: _scrollDistanceIdentifier);
    setState(() {});
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
        getData(true, widget.type);
        return Center(
          child: CircularProgressIndicator(),
        );
      }
    } else {
      return ListView.builder(
          controller: _scrollController,
          itemCount: list.length,
          itemBuilder: (BuildContext context, int index) {
            if (list.elementAt(index).type == '福利') {
              return _buildImageItem(list.elementAt(index).url);
            } else {
              if (widget.enableGif) {
                return _buildTextAndImageItem(list.elementAt(index));
              } else {
                return _buildTextItem(list.elementAt(index));
              }
            }
          });
    }
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      key: _globalKey,
      body: RefreshIndicator(
        key: _refreshIndicatorKey,
        child: _buildRefreshContent(),
        onRefresh: _handleRefresh,
      ),
      floatingActionButton: _buildFloatActionButton(),
    );
  }

  Future<Null> launcherUrl(String url) async {
    if (await canLaunch(url)) {
      await launch(url, forceSafariVC: false, forceWebView: false);
    } else {
      throw 'Could not launch $url';
    }
  }

  Future<Null> getData(bool isClean, String type) async {
    if (!networkEnable) {
      _globalKey.currentState.showSnackBar(SnackBar(content: Text('网络开小差了~~')));
      return;
    }
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
    print(url);
    Response response = await dio.get(url, cancelToken: _token);

//    Map<String, dynamic> map = response.data
    GanHuos ganHuos = GanHuos.fromJson(response.data);
//    List<dynamic> ganhuos = map['results'];

    _page++;
    if (isClean) {
      list.clear();
    }

    if (!widget.random && type == 'all') {
      ganHuos.results.sort((a, b) {
        if (a.publishedAt == b.publishedAt) {
          if (b.type == '福利' || b.type == '休息视频') {
            if (b.type == '福利' && a.type == '休息视频') return -1;
            return 1;
          }
        }
        return b.publishedAt.compareTo(a.publishedAt);
      });
    }
    list.addAll(ganHuos.results);

    PageStorage.of(context)
        .writeState(context, list, identifier: _dataIdentifier);
    PageStorage.of(context)
        .writeState(context, _page, identifier: _pageIdentifier);

    setState(() {});
  }

  Widget _buildTextAndImageItem(GanHuo ganHuo) {
    List<dynamic> urls = ganHuo.images;

    if (urls != null && urls.length > 0) {
      return new Column(
        children: <Widget>[
          new InkWell(
            onTap: () {
              _globalKey.currentState
                  .showSnackBar(SnackBar(content: Text(ganHuo.desc)));
            },
            child: new ListTile(
              title: Text(
                ganHuo.desc,
                textAlign: TextAlign.justify,
                style: TextStyle(decoration: TextDecoration.none),
              ),
            ),
          ),
          new SizedBox.fromSize(
            size: Size.fromHeight(200.0),
            child: new ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: urls.length,
              shrinkWrap: true,
              padding: const EdgeInsets.only(left: 8.0, right: 8.0),
              itemBuilder: (context, index) {
                return _buildWrapImageItem(urls.elementAt(index));
              },
            ),
          ),
        ],
      );
    } else {
      return _buildTextItem(ganHuo);
    }
  }

  Widget _buildTextItem(GanHuo ganHuo) {
    return new InkWell(
      onTap: () {
        launcherUrl(ganHuo.url);
      },
      child: new ListTile(
        title: Text(
          ganHuo.desc,
          textAlign: TextAlign.start,
          style: TextStyle(decoration: TextDecoration.none),
        ),
      ),
    );
  }

  Widget _buildImageItem(String url) {
    return Padding(
      padding: const EdgeInsets.only(left: 12.0, right: 100.0),
      child: new GestureDetector(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => new ImagePreViewWidget(url: url),
              ));
        },
        child: new Card(
          child: new Hero(
            tag: url,
//          child: Image.network(ganHuo['url'])
//            child: Image(
//              image: AdvancedNetworkImage(url),
//            ),
            child: CachedNetworkImage(imageUrl: url),
          ),
        ),
      ),
    );
  }

  Widget _buildWrapImageItem(String url) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 0.0, horizontal: 5.0),
      child: new GestureDetector(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => new ImagePreViewWidget(url: url),
              ));
        },
        child: new Card(
          child: new Hero(
            tag: url,
//          child: Image.network(ganHuo['url'])
//            child: Image(
//              image: AdvancedNetworkImage(url),
//            ),
            child: CachedNetworkImage(imageUrl: url),
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
//                    child: Image(
//                      image: AdvancedNetworkImage(url),
//                    )
                  child: CachedNetworkImage(imageUrl: url),
                ))));
  }
}
