// Generated by the protocol buffer compiler.  DO NOT EDIT!

#import "ProtocolBuffers.h"

typedef enum {
  PicturesEventProtocolRequestCRefillTokensByWaitingEvent = 1000,
} PicturesEventProtocolRequest;

BOOL PicturesEventProtocolRequestIsValidValue(PicturesEventProtocolRequest value);

typedef enum {
  PicturesEventProtocolResponseSRefillTokensByWaitingEvent = 1000,
} PicturesEventProtocolResponse;

BOOL PicturesEventProtocolResponseIsValidValue(PicturesEventProtocolResponse value);


@interface PicturesEventProtocolRoot : NSObject {
}
+ (PBExtensionRegistry*) extensionRegistry;
+ (void) registerAllExtensions:(PBMutableExtensionRegistry*) registry;
@end
