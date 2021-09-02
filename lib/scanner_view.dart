import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';

class FlutterScanView extends StatelessWidget {
  final ValueChanged<String> scanResult;
  const FlutterScanView({
    Key? key,
    required this.scanResult,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) {
        return Stack(
          children: [
            _NativeView(
              scanResult: (value) {
                scanResult.call(value);
              },
            ),
            Positioned(
              left: 0,
              right: 0,
              top: 0,
              bottom: 0,
              child: Container(
                alignment: Alignment.center,
                child: SizedBox(
                  width: MediaQuery.of(context).size.width - 50,
                  child: _ScannerBox(),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

class _NativeView extends StatefulWidget {
  final ValueChanged<String> scanResult;
  const _NativeView({Key? key, required this.scanResult}) : super(key: key);

  @override
  State<_NativeView> createState() => _NativeViewState();
}

class _NativeViewState extends State<_NativeView> {
  MethodChannel methodChannel = MethodChannel("com.vv.scanner.scanner_view");

  @override
  void initState() {
    super.initState();
    methodChannel.setMethodCallHandler((call) async {
      switch (call.method) {
        case 'ON_NOTIFY_QR_CODE':
          final args = call.arguments as String;
          if (args.isNotEmpty) {
            widget.scanResult.call(args);
          }
          break;
      }
    });
  }

  @override
  void dispose() {
    if (methodChannel != null) {
      methodChannel.setMethodCallHandler(null);
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final String viewType = 'DEMO';

    final Map<String, dynamic> creationParams = <String, dynamic>{};
    if (Platform.isAndroid) {
      return PlatformViewLink(
        viewType: viewType,
        surfaceFactory:
            (BuildContext context, PlatformViewController controller) {
          return AndroidViewSurface(
            controller: controller as AndroidViewController,
            gestureRecognizers: Set.from([]),
            hitTestBehavior: PlatformViewHitTestBehavior.opaque,
          );
        },
        onCreatePlatformView: (PlatformViewCreationParams params) {
          return PlatformViewsService.initSurfaceAndroidView(
            id: params.id,
            viewType: viewType,
            layoutDirection: TextDirection.rtl,
            creationParams: creationParams,
            creationParamsCodec: const StandardMessageCodec(),
          )
            ..addOnPlatformViewCreatedListener(params.onPlatformViewCreated)
            ..addOnPlatformViewCreatedListener((id) {})
            ..create();
        },
      );
    } else {
      return UiKitView(
        viewType: viewType,
        layoutDirection: TextDirection.ltr,
        creationParams: creationParams,
        creationParamsCodec: const StandardMessageCodec(),
      );
    }
  }
}

class _ScannerBox extends StatefulWidget {
  const _ScannerBox({Key? key}) : super(key: key);

  @override
  _ScannerBoxState createState() => _ScannerBoxState();
}

class _ScannerBoxState extends State<_ScannerBox>
    with TickerProviderStateMixin {
  late AnimationController controller = AnimationController(
      duration: const Duration(milliseconds: 2000), vsync: this)
    ..addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        controller.reverse();
      } else if (status == AnimationStatus.dismissed) {
        controller.forward();
      }
    });

  late Animation<Offset> animation =
      Tween(begin: Offset.zero, end: const Offset(0, 1)).animate(controller);

  @override
  void initState() {
    super.initState();
    controller.forward();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 240,
        width: double.infinity,
        // color: Colors.black38,
        child: SlideTransition(
          position: animation,
          child: Container(
            alignment: Alignment.topLeft,
            height: double.infinity,
            width: double.infinity,
            child: Container(
              height: 2,
              // color: Color.fromARGB(1, 76, 208, 128),
              // color: Color(0xFF4CD080),
              decoration: const BoxDecoration(
                  gradient: LinearGradient(
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                      colors: [
                    Color(0x004cd080),
                    Color(0xFF4CD080),
                    Color(0x004cd080)
                  ])),
            ),
          ),
        ));
  }
}
