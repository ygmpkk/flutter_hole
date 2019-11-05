import 'dart:async';

import 'package:flutter/services.dart';

class HoleResult {}

class Hole {
  static const MethodChannel _channel = const MethodChannel('com.ygmpkk/hole');
  // static const BasicMessageChannel messageChannel = const BasicMessageChannel('com.ygmpkk/hole_message', const StandardMessageCodec());

  static Future<Map> aOrder(String order, {AliEvn evn = AliEvn.ONLINE}) async {
    return await _channel
        .invokeMethod("aOrder", {"order": order, "payEnv": evn.index});
  }

  static Future<bool> isAlipInstalled() async {
    final bool installed = await _channel.invokeMethod("isAlipInstalled");
    return installed;
  }
}

enum AliEvn { ONLINE, SANDBOX }
