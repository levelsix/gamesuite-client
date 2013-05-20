// Generated by the protocol buffer compiler.  DO NOT EDIT!

#import "ForceLogout.pb.h"

@implementation ForceLogoutRoot
static PBExtensionRegistry* extensionRegistry = nil;
+ (PBExtensionRegistry*) extensionRegistry {
  return extensionRegistry;
}

+ (void) initialize {
  if (self == [ForceLogoutRoot class]) {
    PBMutableExtensionRegistry* registry = [PBMutableExtensionRegistry registry];
    [self registerAllExtensions:registry];
    extensionRegistry = [registry retain];
  }
}
+ (void) registerAllExtensions:(PBMutableExtensionRegistry*) registry {
}
@end

@interface ForceLogoutResponseProto ()
@property (retain) NSString* userId;
@end

@implementation ForceLogoutResponseProto

- (BOOL) hasUserId {
  return !!hasUserId_;
}
- (void) setHasUserId:(BOOL) value {
  hasUserId_ = !!value;
}
@synthesize userId;
- (void) dealloc {
  self.userId = nil;
  [super dealloc];
}
- (id) init {
  if ((self = [super init])) {
    self.userId = @"";
  }
  return self;
}
static ForceLogoutResponseProto* defaultForceLogoutResponseProtoInstance = nil;
+ (void) initialize {
  if (self == [ForceLogoutResponseProto class]) {
    defaultForceLogoutResponseProtoInstance = [[ForceLogoutResponseProto alloc] init];
  }
}
+ (ForceLogoutResponseProto*) defaultInstance {
  return defaultForceLogoutResponseProtoInstance;
}
- (ForceLogoutResponseProto*) defaultInstance {
  return defaultForceLogoutResponseProtoInstance;
}
- (BOOL) isInitialized {
  return YES;
}
- (void) writeToCodedOutputStream:(PBCodedOutputStream*) output {
  if (self.hasUserId) {
    [output writeString:1 value:self.userId];
  }
  [self.unknownFields writeToCodedOutputStream:output];
}
- (int32_t) serializedSize {
  int32_t size = memoizedSerializedSize;
  if (size != -1) {
    return size;
  }

  size = 0;
  if (self.hasUserId) {
    size += computeStringSize(1, self.userId);
  }
  size += self.unknownFields.serializedSize;
  memoizedSerializedSize = size;
  return size;
}
+ (ForceLogoutResponseProto*) parseFromData:(NSData*) data {
  return (ForceLogoutResponseProto*)[[[ForceLogoutResponseProto builder] mergeFromData:data] build];
}
+ (ForceLogoutResponseProto*) parseFromData:(NSData*) data extensionRegistry:(PBExtensionRegistry*) extensionRegistry {
  return (ForceLogoutResponseProto*)[[[ForceLogoutResponseProto builder] mergeFromData:data extensionRegistry:extensionRegistry] build];
}
+ (ForceLogoutResponseProto*) parseFromInputStream:(NSInputStream*) input {
  return (ForceLogoutResponseProto*)[[[ForceLogoutResponseProto builder] mergeFromInputStream:input] build];
}
+ (ForceLogoutResponseProto*) parseFromInputStream:(NSInputStream*) input extensionRegistry:(PBExtensionRegistry*) extensionRegistry {
  return (ForceLogoutResponseProto*)[[[ForceLogoutResponseProto builder] mergeFromInputStream:input extensionRegistry:extensionRegistry] build];
}
+ (ForceLogoutResponseProto*) parseFromCodedInputStream:(PBCodedInputStream*) input {
  return (ForceLogoutResponseProto*)[[[ForceLogoutResponseProto builder] mergeFromCodedInputStream:input] build];
}
+ (ForceLogoutResponseProto*) parseFromCodedInputStream:(PBCodedInputStream*) input extensionRegistry:(PBExtensionRegistry*) extensionRegistry {
  return (ForceLogoutResponseProto*)[[[ForceLogoutResponseProto builder] mergeFromCodedInputStream:input extensionRegistry:extensionRegistry] build];
}
+ (ForceLogoutResponseProto_Builder*) builder {
  return [[[ForceLogoutResponseProto_Builder alloc] init] autorelease];
}
+ (ForceLogoutResponseProto_Builder*) builderWithPrototype:(ForceLogoutResponseProto*) prototype {
  return [[ForceLogoutResponseProto builder] mergeFrom:prototype];
}
- (ForceLogoutResponseProto_Builder*) builder {
  return [ForceLogoutResponseProto builder];
}
@end

@interface ForceLogoutResponseProto_Builder()
@property (retain) ForceLogoutResponseProto* result;
@end

@implementation ForceLogoutResponseProto_Builder
@synthesize result;
- (void) dealloc {
  self.result = nil;
  [super dealloc];
}
- (id) init {
  if ((self = [super init])) {
    self.result = [[[ForceLogoutResponseProto alloc] init] autorelease];
  }
  return self;
}
- (PBGeneratedMessage*) internalGetResult {
  return result;
}
- (ForceLogoutResponseProto_Builder*) clear {
  self.result = [[[ForceLogoutResponseProto alloc] init] autorelease];
  return self;
}
- (ForceLogoutResponseProto_Builder*) clone {
  return [ForceLogoutResponseProto builderWithPrototype:result];
}
- (ForceLogoutResponseProto*) defaultInstance {
  return [ForceLogoutResponseProto defaultInstance];
}
- (ForceLogoutResponseProto*) build {
  [self checkInitialized];
  return [self buildPartial];
}
- (ForceLogoutResponseProto*) buildPartial {
  ForceLogoutResponseProto* returnMe = [[result retain] autorelease];
  self.result = nil;
  return returnMe;
}
- (ForceLogoutResponseProto_Builder*) mergeFrom:(ForceLogoutResponseProto*) other {
  if (other == [ForceLogoutResponseProto defaultInstance]) {
    return self;
  }
  if (other.hasUserId) {
    [self setUserId:other.userId];
  }
  [self mergeUnknownFields:other.unknownFields];
  return self;
}
- (ForceLogoutResponseProto_Builder*) mergeFromCodedInputStream:(PBCodedInputStream*) input {
  return [self mergeFromCodedInputStream:input extensionRegistry:[PBExtensionRegistry emptyRegistry]];
}
- (ForceLogoutResponseProto_Builder*) mergeFromCodedInputStream:(PBCodedInputStream*) input extensionRegistry:(PBExtensionRegistry*) extensionRegistry {
  PBUnknownFieldSet_Builder* unknownFields = [PBUnknownFieldSet builderWithUnknownFields:self.unknownFields];
  while (YES) {
    int32_t tag = [input readTag];
    switch (tag) {
      case 0:
        [self setUnknownFields:[unknownFields build]];
        return self;
      default: {
        if (![self parseUnknownField:input unknownFields:unknownFields extensionRegistry:extensionRegistry tag:tag]) {
          [self setUnknownFields:[unknownFields build]];
          return self;
        }
        break;
      }
      case 10: {
        [self setUserId:[input readString]];
        break;
      }
    }
  }
}
- (BOOL) hasUserId {
  return result.hasUserId;
}
- (NSString*) userId {
  return result.userId;
}
- (ForceLogoutResponseProto_Builder*) setUserId:(NSString*) value {
  result.hasUserId = YES;
  result.userId = value;
  return self;
}
- (ForceLogoutResponseProto_Builder*) clearUserId {
  result.hasUserId = NO;
  result.userId = @"";
  return self;
}
@end
