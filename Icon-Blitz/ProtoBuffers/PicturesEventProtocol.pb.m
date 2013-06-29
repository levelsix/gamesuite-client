// Generated by the protocol buffer compiler.  DO NOT EDIT!

#import "PicturesEventProtocol.pb.h"

@implementation PicturesEventProtocolRoot
static PBExtensionRegistry* extensionRegistry = nil;
+ (PBExtensionRegistry*) extensionRegistry {
  return extensionRegistry;
}

+ (void) initialize {
  if (self == [PicturesEventProtocolRoot class]) {
    PBMutableExtensionRegistry* registry = [PBMutableExtensionRegistry registry];
    [self registerAllExtensions:registry];
    extensionRegistry = [registry retain];
  }
}
+ (void) registerAllExtensions:(PBMutableExtensionRegistry*) registry {
}
@end

BOOL PicturesEventProtocolRequestIsValidValue(PicturesEventProtocolRequest value) {
  switch (value) {
    case PicturesEventProtocolRequestCRefillTokensByWaitingEvent:
    case PicturesEventProtocolRequestCCompletedRoundEvent:
    case PicturesEventProtocolRequestCRetrieveNewQuestionsEvent:
    case PicturesEventProtocolRequestCStartRoundEvent:
    case PicturesEventProtocolRequestCSpendRubiesEvent:
    case PicturesEventProtocolRequestCSearchForUserEvent:
    case PicturesEventProtocolRequestCSaveRoundProgressEvent:
      return YES;
    default:
      return NO;
  }
}
BOOL PicturesEventProtocolResponseIsValidValue(PicturesEventProtocolResponse value) {
  switch (value) {
    case PicturesEventProtocolResponseSRefillTokensByWaitingEvent:
    case PicturesEventProtocolResponseSCompletedRoundEvent:
    case PicturesEventProtocolResponseSRetrieveNewQuestionsEvent:
    case PicturesEventProtocolResponseSStartRoundEvent:
    case PicturesEventProtocolResponseSSpendRubiesEvent:
    case PicturesEventProtocolResponseSSearchForUserEvent:
    case PicturesEventProtocolResponseSSaveRoundProgressEvent:
      return YES;
    default:
      return NO;
  }
}
