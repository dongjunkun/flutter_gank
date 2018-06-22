import 'package:flutter/material.dart';

class NoNetworkView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Icon(
            Icons.signal_wifi_off,
            size: 80.0,
          ),
          Text('暂无网络连接！！')
        ],
      )),
    );
  }
}
