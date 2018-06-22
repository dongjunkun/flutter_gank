import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_advanced_networkimage/flutter_advanced_networkimage.dart';
import 'package:gank_app/options.dart';

class AllPage extends StatefulWidget {
  final String type;

  AllPage({Key key, @required this.type}) : super(key: key);

  @override
  _AllPageState createState() => new _AllPageState();
}

class _AllPageState extends State<AllPage> {
  List<dynamic> list = List<dynamic>();
  GlobalKey<ScaffoldState> _globalKey = GlobalKey();

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
    // 获取到 NestedScrollView 为子 ScrollView 添加的特殊 ScrollController
    // 如果自己为 ScrollView 添加一个新的 ScrollController 会导致
    // NestedScrollView 和 SliverAppBar 带来的自动隐藏 AppBar 失效
    _scrollController = ScrollController();
    _scrollController.addListener(_handleScroll);
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
        body: new ListView.builder(
          controller: _scrollController,
          itemCount: list.length,
          itemBuilder: (BuildContext context, int index) {
            if (list.elementAt(index)['type'] == '福利') {
              return _buildImageItem(list.elementAt(index)['url']);
            } else {
              return _buildTextItem(list.elementAt(index));
            }
          },
        ),
        floatingActionButton: new FloatingActionButton(
          onPressed: () {
            getData(true, widget.type);
          },
          tooltip: 'refresh',
          child: new Icon(Icons.refresh),
        ),
      );
    }
  }

  getData(bool isClean, String type) async {
    if (isClean) {
      _page = 1;
    }
    Dio dio = new Dio();
    Response response =
        await dio.get("http://gank.io/api/data/$type/$pageSize/$_page");

    Map<String, dynamic> map = response.data;
    List<dynamic> ganhuos = map['results'];

    _page++;
    if (isClean) {
      list.clear();
    }
    list.addAll(ganhuos);
    PageStorage
        .of(context)
        .writeState(context, list, identifier: _dataIdentifier);
    PageStorage
        .of(context)
        .writeState(context, _page, identifier: _pageIdentifier);

    setState(() {});
  }

  Widget _buildTextItem(dynamic ganHuo) {
    List<dynamic> urls = ganHuo['images'];

    if (urls != null && urls.length > 0) {
      return new Column(
        children: <Widget>[
          new InkWell(
            onTap: () {
              _globalKey.currentState.showSnackBar(
                  SnackBar(content: Text(ganHuo['desc'])));
            },
            child: new ListTile(
              title: Text(
                ganHuo['desc'],
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
              shrinkWrap: false,
              padding: const EdgeInsets.only(left: 8.0,right: 8.0),
              itemBuilder: (context, index) {
               return _buildImageItem(urls.elementAt(index));
//                new Container(
//                    color: Colors.red,
//                    child: new Text('aaaaaaaaaaaaaaaa'));
              },
            ),
          ),
        ],
      );
    } else {
    return new InkWell(
      onTap: () {
        _globalKey.currentState
            .showSnackBar(SnackBar(content: Text(ganHuo['desc'])));
      },
      child: new ListTile(
        title: Text(
          ganHuo['desc'],
          textAlign: TextAlign.justify,
          style: TextStyle(decoration: TextDecoration.none),
        ),
      ),
    );
    }
  }

  Widget _buildImageItem(String url) {
    return new Card(
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
