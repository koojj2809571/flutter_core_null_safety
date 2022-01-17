#import "FlutterCorePlugin.h"
#if __has_include(<flutter_core/flutter_core-Swift.h>)
#import <flutter_core/flutter_core-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "flutter_core-Swift.h"
#endif

@implementation FlutterCorePlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftFlutterCorePlugin registerWithRegistrar:registrar];
}
@end
