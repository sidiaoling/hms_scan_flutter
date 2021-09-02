import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:scanner_view/scanner_view.dart';

void main() {
  const MethodChannel channel = MethodChannel('scanner_view');

  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    channel.setMockMethodCallHandler((MethodCall methodCall) async {
      return '42';
    });
  });

  tearDown(() {
    channel.setMockMethodCallHandler(null);
  });

  test('getPlatformVersion', () async {
    // expect(await ScannerView.platformVersion, '42');
  });
}
