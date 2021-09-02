package com.subway_basic.scanner_view

import androidx.annotation.NonNull
import io.flutter.embedding.android.FlutterActivity

import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result

/** ScannerViewPlugin */
class ScannerViewPlugin : FlutterPlugin, ActivityAware {
    /// The MethodChannel that will the communication between Flutter and native Android
    ///
    /// This local reference serves to register the plugin with the Flutter Engine and unregister it
    /// when the Flutter Engine is detached from the Activity
    private lateinit var channel: MethodChannel

    override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {

        flutterPluginBinding
            .platformViewRegistry
            .registerViewFactory(NATIVE_VIEW, NativeViewFactory(flutterPluginBinding.binaryMessenger))
    }
//
//    override fun onMethodCall(@NonNull call: MethodCall, @NonNull result: Result) {
//        if (call.method == "getPlatformVersion") {
//            result.success("Android ${android.os.Build.VERSION.RELEASE}")
//        } else {
//            result.notImplemented()
//        }
//    }

    override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
        channel.setMethodCallHandler(null)
    }

    override fun onAttachedToActivity(binding: ActivityPluginBinding) {
        if (binding.activity is FlutterActivity) {
            Locator.activity = binding.activity as FlutterActivity
        }
    }

    override fun onDetachedFromActivityForConfigChanges() {
        println("hello world")
    }

    override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {
        println("hello world")
    }

    override fun onDetachedFromActivity() {
        println("hello world")
    }
}
