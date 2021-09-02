#import "ScannerViewPlugin.h"
#if __has_include(<scanner_view/scanner_view-Swift.h>)
#import <scanner_view/scanner_view-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "scanner_view-Swift.h"
#endif

@implementation ScannerViewPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftScannerViewPlugin registerWithRegistrar:registrar];
}
@end
