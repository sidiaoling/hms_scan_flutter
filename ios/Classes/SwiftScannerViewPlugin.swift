import Flutter
import UIKit

public class SwiftScannerViewPlugin: NSObject, FlutterPlugin {
  public static func register(with registrar: FlutterPluginRegistrar) {
//    let channel = FlutterMethodChannel(name: "scanner_view", binaryMessenger: registrar.messenger())
//    let instance = SwiftScannerViewPlugin()
//    registrar.addMethodCallDelegate(instance, channel: channel)
    
    let factory = ScannerNativeViewFactory(messenger: registrar.messenger())
    registrar.register(factory, withId: "DEMO")
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    result("iOS " + UIDevice.current.systemVersion)
  }
}
