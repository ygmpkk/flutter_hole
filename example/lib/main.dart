import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:hole/hole.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _platformVersion = 'Unknown';

  @override
  void initState() {
    super.initState();

    // Hole.eventCh.receiveBroadcastStream().listen((message) {
    //   print('success: $message');
    // }, onError: (error) {
    //   print('error: $error');
    // });

    // Hole.messageChannel.setMessageHandler((value) {
    //   print("value => $value");
    //   return;
    // });
  }

  demo() async {
    bool isinstall = await Hole.isAlipInstalled();
    print('isinstall: $isinstall');

    var ret = Hole.aOrder(
        "app_id=2019051364517380&biz_content=%7B%22subject%22%3A%22%E4%BA%91%E5%AE%A2%E6%9D%A5-%E5%85%85%E5%80%BC%E5%8D%A1%C2%A5888%E5%85%83%22%2C%22out_trade_no%22%3A%225dc0e9c7d28cf070db683512%22%2C%22timeout_express%22%3A%2220m%22%2C%22total_amount%22%3A%22888.00%22%2C%22product_code%22%3A%22QUICK_MSECURITY_PAY%22%2C%22goods_type%22%3A%220%22%7D&charset=utf-8&format=JSON&method=alipay.trade.app.pay&notify_url=https%3A%2F%2Fstaging.b.hilyeah.cn%2Flambda%2Fpay%2Falipay%2Fnotify&sign_type=RSA2&timestamp=2019-11-05%2011%3A17%3A27&version=1.0&sign=fytxDaYiP0OlagXkV2saLR31BxSvvS1P6aNnb03Z2733sCLwU3tFG0H3YINGgJv%2FgMUDeXsOvmox9fqSsXNcLkY%2BaLatPJ9sUFPN22WXYmFjVJTyGdgkr%2FP9CKbneoAFbdaPOJ7aBw4g4h62hj9nFLsmlmnOw69wIXJywCIaXkztnFIWBXQCQNm4QxqhYtq6P3aMhj4NNfVLlzhw%2BPtTU%2Fz69ni4DWHUO2R9xUIsRZKeODXuumXjQDaPqzqqc0oE9HZW%2FCCzld2boUCdYYFVQ28Bbc0kVgDyuho0KPfwqyc%2BHMxshPiQZU%2Fe%2B7gdhhf1qCjeeYS1XDogb4VnmrSOxg%3D%3D",
        evn: AliEvn.ONLINE);
    print(ret);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
          appBar: AppBar(
            title: const Text('Plugin app'),
          ),
          body: Column(
            children: <Widget>[
              Container(
                child: Text('Running on: $_platformVersion\n'),
              ),
              Container(
                child: RaisedButton(
                  onPressed: demo,
                  child: Text('按钮'),
                ),
              ),
            ],
          )),
    );
  }
}
