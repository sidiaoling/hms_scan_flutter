import ScanKitFrameWork


class ScannerNativeViewFactory: NSObject, FlutterPlatformViewFactory {
    private var messenger: FlutterBinaryMessenger
    

    init(messenger: FlutterBinaryMessenger) {
        self.messenger = messenger
        super.init()
    }

    func create(
        withFrame frame: CGRect,
        viewIdentifier viewId: Int64,
        arguments args: Any?
    ) -> FlutterPlatformView {
        return ScannerNativeView(
            frame: frame,
            viewIdentifier: viewId,
            arguments: args,
            binaryMessenger: messenger)
    }
}


class ScannerNativeView: NSObject, FlutterPlatformView, CustomizedScanDelegate {
    
    
//    private var _view: UIView
    private var hmsCustomScanViewController: HmsCustomScanViewController
    private var nativeMethodsChannel: FlutterMethodChannel
//    private let scanAreaSize = 240
//    private let screenW = UIScreen.main.bounds.size.width
//    private let screenH = UIScreen.main.bounds.size.height

    init(
        frame: CGRect,
        viewIdentifier viewId: Int64,
        arguments args: Any?,
        binaryMessenger messenger: FlutterBinaryMessenger
    ) {
        hmsCustomScanViewController = HmsCustomScanViewController()
        nativeMethodsChannel = FlutterMethodChannel(name: "com.vv.scanner.scanner_view", binaryMessenger: messenger)
        super.init()
        
        
//        setupEventChannel(viewId: viewId, messenger: messenger, instance: self)

//        setupMethodChannel(viewId: viewId, messenger: messenger)
        nativeMethodsChannel.setMethodCallHandler { [weak self] call, result in
            if(call.method == "OPEN_FLASH") {
                self?.toggleFlash()
            }
        }
        
        
        
        createNativeView()
    }
    
    func toggleFlash() {
        guard let device = AVCaptureDevice.default(for: AVMediaType.video) else { return }
        guard device.hasTorch else { return }

        do {
            try device.lockForConfiguration()

            if (device.torchMode == AVCaptureDevice.TorchMode.on) {
                device.torchMode = AVCaptureDevice.TorchMode.off
            } else {
                do {
                    try device.setTorchModeOn(level: 1.0)
                } catch {
                    print(error)
                }
            }

            device.unlockForConfiguration()
        } catch {
            print(error)
        }
    }

    func view() -> UIView {
        return hmsCustomScanViewController.view
    }

    func createNativeView(){
//        _view.backgroundColor = UIColor.blue
//        let nativeLabel = UILabel()
//        nativeLabel.text = "Native text from iOS"
//        nativeLabel.textColor = UIColor.white
//        nativeLabel.textAlignment = .center
//        nativeLabel.frame = CGRect(x: 0, y: 0, width: 180, height: 48.0)
//        _view.addSubview(nativeLabel)
        
        hmsCustomScanViewController.customizedScanDelegate = self
        //hmsCustomScanViewController.backButtonHiden = true // You can hide back button, if you want
//        hmsCustomScanViewController.cutArea = CGRect(x: Int(screenW) / 2 - scanAreaSize / 2, y:screenH, width: 240, height: 240)
        hmsCustomScanViewController.backButtonHidden = true
        hmsCustomScanViewController.continuouslyScan = true
    }
    
    func customizedScanDelegate(forResult resultDic: [AnyHashable : Any]!) {
        DispatchQueue.main.async {
            if let dictionary = resultDic, let text = dictionary["text"] {
//                print("*** Text: \(text)")
                self.nativeMethodsChannel.invokeMethod("ON_NOTIFY_QR_CODE", arguments: text)
            } else {
                print("*** Scanning code not recognized!")
            }
            
        }
    }
}
