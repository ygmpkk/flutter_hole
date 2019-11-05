import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hole/hole.dart';

void main() {
  const MethodChannel channel = MethodChannel('hole');

  setUp(() {
    channel.setMockMethodCallHandler((MethodCall methodCall) async {
      return '42';
    });
  });

  tearDown(() {
    channel.setMockMethodCallHandler(null);
  });

  test('getPlatformVersion', () async {
    expect(await Hole.platformVersion, '42');
  });
}
