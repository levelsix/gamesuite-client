// Generated by the protocol buffer compiler.  DO NOT EDIT!

#import "CommonEventProtocol.pb.h"

@implementation CommonEventProtocolRoot
static PBExtensionRegistry* extensionRegistry = nil;
+ (PBExtensionRegistry*) extensionRegistry {
  return extensionRegistry;
}

+ (void) initialize {
  if (self == [CommonEventProtocolRoot class]) {
    PBMutableExtensionRegistry* registry = [PBMutableExtensionRegistry registry];
    [self registerAllExtensions:registry];
    extensionRegistry = [registry retain];
  }
}
+ (void) registerAllExtensions:(PBMutableExtensionRegistry*) registry {
}
@end

BOOL CommonEventProtocolRequestIsValidValue(CommonEventProtocolRequest value) {
  switch (value) {
    case CommonEventProtocolRequestCCreateAccountViaFacebookEvent:
    case CommonEventProtocolRequestCCreateAccountViaEmailEvent:
    case CommonEventProtocolRequestCCreateAccountViaNoCredentialsEvent:
    case CommonEventProtocolRequestCLoginEvent:
    case CommonEventProtocolRequestCInAppPurchaseEvent:
    case CommonEventProtocolRequestCLogoutEvent:
      return YES;
    default:
      return NO;
  }
}
BOOL CommonEventProtocolResponseIsValidValue(CommonEventProtocolResponse value) {
  switch (value) {
    case CommonEventProtocolResponseSCreateAccountViaFacebookEvent:
    case CommonEventProtocolResponseSCreateAccountViaEmailEvent:
    case CommonEventProtocolResponseSCreateAccountViaNoCredentialsEvent:
    case CommonEventProtocolResponseSLoginEvent:
    case CommonEventProtocolResponseSInAppPurchaseEvent:
    case CommonEventProtocolResponseSForceLogoutEvent:
      return YES;
    default:
      return NO;
  }
}
