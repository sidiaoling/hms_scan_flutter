package com.subway_basic.scanner_view

import android.content.Context
import android.graphics.Rect
import android.view.View
import androidx.lifecycle.DefaultLifecycleObserver
import androidx.lifecycle.LifecycleOwner
import com.huawei.hms.hmsscankit.OnResultCallback
import com.huawei.hms.hmsscankit.RemoteView
import com.huawei.hms.ml.scan.HmsScan
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.platform.PlatformView


class ScannerView(
    context: Context,
    id: Int,
    creationParams: Map<String?, Any?>?,
    binaryMessenger: BinaryMessenger
) :
    PlatformView, DefaultLifecycleObserver, OnResultCallback, MethodChannel.MethodCallHandler {


    private val resources = context.resources
    var mScreenWidth = 0
    var mScreenHeight = 0
    private val SCAN_FRAME_SIZE = 240
    private var remoteView: RemoteView? = null


    /// 插件回调
    var channel: MethodChannel = MethodChannel(binaryMessenger, PLUGIN_NAME)

    init {
        channel.setMethodCallHandler(this)
    }


    override fun getView(): View {
        if (remoteView == null) {
            Locator.activity!!.lifecycle.addObserver(this)
            remoteView =
                RemoteView.Builder()
                    .setContext(Locator.activity!!)
//                    .setBoundingBox(initRectInfo())
                    .setContinuouslyScan(true)
                    .setFormat(HmsScan.ALL_SCAN_TYPE).build()
            remoteView!!.setOnResultCallback(this)
            remoteView?.onCreate(null)
        } else {
            remoteView!!.onResume()
        }

        return remoteView!!
    }

    override fun dispose() {
        remoteView?.onDestroy()
        Locator.activity!!.lifecycle.removeObserver(this)
    }


    override fun onResume(owner: LifecycleOwner) {
        remoteView?.onResume()
    }


    override fun onStart(owner: LifecycleOwner) {
        remoteView?.onStart()
    }

    override fun onPause(owner: LifecycleOwner) {
        remoteView?.onPause()
    }


    override fun onStop(owner: LifecycleOwner) {
        remoteView?.onStop()
    }


    override fun onDestroy(owner: LifecycleOwner) {
        dispose()
    }

    /**
     * 初始化绘制信息
     */
    private fun initRectInfo(): Rect {
        val dm = resources.displayMetrics
        val density = dm.density
        mScreenWidth = resources.displayMetrics.widthPixels
        mScreenHeight = resources.displayMetrics.heightPixels
        val scanFrameSize = (SCAN_FRAME_SIZE * density).toInt()
        val rect = Rect()
        rect.left = mScreenWidth / 2 - scanFrameSize / 2
        rect.right = mScreenWidth / 2 + scanFrameSize / 2
        rect.top = (mScreenHeight * 0.2).toInt() - scanFrameSize / 2
        rect.bottom = (mScreenHeight * 0.2).toInt() + scanFrameSize / 2
        return rect
    }

    override fun onResult(result: Array<out HmsScan>?) {
        result?.let {
//            println("hello--->${it[0].getOriginalValue()}")
            channel.invokeMethod(ON_NOTIFY_QR_CODE, it[0].getOriginalValue())
        }
    }

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        when (call.method) {
            OPEN_FLASH -> {
                remoteView?.switchLight()
            }
        }
    }


}