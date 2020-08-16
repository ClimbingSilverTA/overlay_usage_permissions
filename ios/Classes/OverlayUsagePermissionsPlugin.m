#import "OverlayUsagePermissionsPlugin.h"
#if __has_include(<overlay_usage_permissions/overlay_usage_permissions-Swift.h>)
#import <overlay_usage_permissions/overlay_usage_permissions-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "overlay_usage_permissions-Swift.h"
#endif

@implementation OverlayUsagePermissionsPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftOverlayUsagePermissionsPlugin registerWithRegistrar:registrar];
}
@end
