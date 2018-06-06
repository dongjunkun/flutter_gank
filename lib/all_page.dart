import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
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

  @override
  void initState() {
    super.initState();
    getData(widget.type);
  }

  @override
  Widget build(BuildContext context) {
    if (list.isEmpty) {
      return Center(
        child: CircularProgressIndicator(),
      );
    } else {
      return new Scaffold(
        key: _globalKey,
        body: new ListView.builder(
          itemCount: list.length,
          itemBuilder: (BuildContext context, int index) {
            if (list.elementAt(index)['type'] == '福利') {
              return _buildImageItem(list.elementAt(index));
            } else {
              return _buildTextItem(list.elementAt(index));
            }
          },
        ),
        floatingActionButton: new FloatingActionButton(
          onPressed: () {
            getData(widget.type);
          },
          tooltip: 'refresh',
          child: new Icon(Icons.refresh),
        ),
      );
    }
  }

  getData(String type) async {
    Dio dio = new Dio();
    Response response =
        await dio.get("http://gank.io/api/data/$type/$pageSize/1");

    Map<String, dynamic> map = response.data;
    List<dynamic> ganhuos = map['results'];

    setState(() {
      list.clear();
      list.addAll(ganhuos);
    });
  }

  Widget _buildTextItem(dynamic ganHuo) {
    TextDecoration.underline;
    return new Card(
      child: new InkWell(
        onTap: (){
          _globalKey.currentState.showSnackBar(SnackBar(content: Text(ganHuo['desc'])));
        },
        child: new ListTile(
          title: Text(
            ganHuo['desc'],
            textAlign: TextAlign.justify,
            style: TextStyle(decoration: TextDecoration.none),
          ),
        ),
      ),
    );
  }

  Widget _buildImageItem(dynamic ganHuo) {
    return new Card(

      child: new Hero(
        tag: ganHuo['url'],
//          child: Image.network(ganHuo['url'])
        child: new InkWell(
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => new ImagePreViewWidget(url: ganHuo['url']),
                ));
          },
          child: CachedNetworkImage(
            imageUrl: ganHuo['url'],
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
                  child: CachedNetworkImage(imageUrl: url),
                ))));
  }
}
