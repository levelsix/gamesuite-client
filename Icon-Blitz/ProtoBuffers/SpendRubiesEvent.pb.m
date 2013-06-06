// Generated by the protocol buffer compiler.  DO NOT EDIT!

#import "SpendRubiesEvent.pb.h"

@implementation SpendRubiesEventRoot
static PBExtensionRegistry* extensionRegistry = nil;
+ (PBExtensionRegistry*) extensionRegistry {
  return extensionRegistry;
}

+ (void) initialize {
  if (self == [SpendRubiesEventRoot class]) {
    PBMutableExtensionRegistry* registry = [PBMutableExtensionRegistry registry];
    [self registerAllExtensions:registry];
    [UserRoot registerAllExtensions:registry];
    extensionRegistry = [registry retain];
  }
}
+ (void) registerAllExtensions:(PBMutableExtensionRegistry*) registry {
}
@end

@interface SpendRubiesRequestProto ()
@property (retain) BasicUserProto* sender;
@property int32_t amountSpent;
@end

@implementation SpendRubiesRequestProto

- (BOOL) hasSender {
  return !!hasSender_;
}
- (void) setHasSender:(BOOL) value {
  hasSender_ = !!value;
}
@synthesize sender;
- (BOOL) hasAmountSpent {
  return !!hasAmountSpent_;
}
- (void) setHasAmountSpent:(BOOL) value {
  hasAmountSpent_ = !!value;
}
@synthesize amountSpent;
- (void) dealloc {
  self.sender = nil;
  [super dealloc];
}
- (id) init {
  if ((self = [super init])) {
    self.sender = [BasicUserProto defaultInstance];
    self.amountSpent = 0;
  }
  return self;
}
static SpendRubiesRequestProto* defaultSpendRubiesRequestProtoInstance = nil;
+ (void) initialize {
  if (self == [SpendRubiesRequestProto class]) {
    defaultSpendRubiesRequestProtoInstance = [[SpendRubiesRequestProto alloc] init];
  }
}
+ (SpendRubiesRequestProto*) defaultInstance {
  return defaultSpendRubiesRequestProtoInstance;
}
- (SpendRubiesRequestProto*) defaultInstance {
  return defaultSpendRubiesRequestProtoInstance;
}
- (BOOL) isInitialized {
  return YES;
}
- (void) writeToCodedOutputStream:(PBCodedOutputStream*) output {
  if (self.hasSender) {
    [output writeMessage:1 value:self.sender];
  }
  if (self.hasAmountSpent) {
    [output writeInt32:2 value:self.amountSpent];
  }
  [self.unknownFields writeToCodedOutputStream:output];
}
- (int32_t) serializedSize {
  int32_t size = memoizedSerializedSize;
  if (size != -1) {
    return size;
  }

  size = 0;
  if (self.hasSender) {
    size += computeMessageSize(1, self.sender);
  }
  if (self.hasAmountSpent) {
    size += computeInt32Size(2, self.amountSpent);
  }
  size += self.unknownFields.serializedSize;
  memoizedSerializedSize = size;
  return size;
}
+ (SpendRubiesRequestProto*) parseFromData:(NSData*) data {
  return (SpendRubiesRequestProto*)[[[SpendRubiesRequestProto builder] mergeFromData:data] build];
}
+ (SpendRubiesRequestProto*) parseFromData:(NSData*) data extensionRegistry:(PBExtensionRegistry*) extensionRegistry {
  return (SpendRubiesRequestProto*)[[[SpendRubiesRequestProto builder] mergeFromData:data extensionRegistry:extensionRegistry] build];
}
+ (SpendRubiesRequestProto*) parseFromInputStream:(NSInputStream*) input {
  return (SpendRubiesRequestProto*)[[[SpendRubiesRequestProto builder] mergeFromInputStream:input] build];
}
+ (SpendRubiesRequestProto*) parseFromInputStream:(NSInputStream*) input extensionRegistry:(PBExtensionRegistry*) extensionRegistry {
  return (SpendRubiesRequestProto*)[[[SpendRubiesRequestProto builder] mergeFromInputStream:input extensionRegistry:extensionRegistry] build];
}
+ (SpendRubiesRequestProto*) parseFromCodedInputStream:(PBCodedInputStream*) input {
  return (SpendRubiesRequestProto*)[[[SpendRubiesRequestProto builder] mergeFromCodedInputStream:input] build];
}
+ (SpendRubiesRequestProto*) parseFromCodedInputStream:(PBCodedInputStream*) input extensionRegistry:(PBExtensionRegistry*) extensionRegistry {
  return (SpendRubiesRequestProto*)[[[SpendRubiesRequestProto builder] mergeFromCodedInputStream:input extensionRegistry:extensionRegistry] build];
}
+ (SpendRubiesRequestProto_Builder*) builder {
  return [[[SpendRubiesRequestProto_Builder alloc] init] autorelease];
}
+ (SpendRubiesRequestProto_Builder*) builderWithPrototype:(SpendRubiesRequestProto*) prototype {
  return [[SpendRubiesRequestProto builder] mergeFrom:prototype];
}
- (SpendRubiesRequestProto_Builder*) builder {
  return [SpendRubiesRequestProto builder];
}
@end

@interface SpendRubiesRequestProto_Builder()
@property (retain) SpendRubiesRequestProto* result;
@end

@implementation SpendRubiesRequestProto_Builder
@synthesize result;
- (void) dealloc {
  self.result = nil;
  [super dealloc];
}
- (id) init {
  if ((self = [super init])) {
    self.result = [[[SpendRubiesRequestProto alloc] init] autorelease];
  }
  return self;
}
- (PBGeneratedMessage*) internalGetResult {
  return result;
}
- (SpendRubiesRequestProto_Builder*) clear {
  self.result = [[[SpendRubiesRequestProto alloc] init] autorelease];
  return self;
}
- (SpendRubiesRequestProto_Builder*) clone {
  return [SpendRubiesRequestProto builderWithPrototype:result];
}
- (SpendRubiesRequestProto*) defaultInstance {
  return [SpendRubiesRequestProto defaultInstance];
}
- (SpendRubiesRequestProto*) build {
  [self checkInitialized];
  return [self buildPartial];
}
- (SpendRubiesRequestProto*) buildPartial {
  SpendRubiesRequestProto* returnMe = [[result retain] autorelease];
  self.result = nil;
  return returnMe;
}
- (SpendRubiesRequestProto_Builder*) mergeFrom:(SpendRubiesRequestProto*) other {
  if (other == [SpendRubiesRequestProto defaultInstance]) {
    return self;
  }
  if (other.hasSender) {
    [self mergeSender:other.sender];
  }
  if (other.hasAmountSpent) {
    [self setAmountSpent:other.amountSpent];
  }
  [self mergeUnknownFields:other.unknownFields];
  return self;
}
- (SpendRubiesRequestProto_Builder*) mergeFromCodedInputStream:(PBCodedInputStream*) input {
  return [self mergeFromCodedInputStream:input extensionRegistry:[PBExtensionRegistry emptyRegistry]];
}
- (SpendRubiesRequestProto_Builder*) mergeFromCodedInputStream:(PBCodedInputStream*) input extensionRegistry:(PBExtensionRegistry*) extensionRegistry {
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
        BasicUserProto_Builder* subBuilder = [BasicUserProto builder];
        if (self.hasSender) {
          [subBuilder mergeFrom:self.sender];
        }
        [input readMessage:subBuilder extensionRegistry:extensionRegistry];
        [self setSender:[subBuilder buildPartial]];
        break;
      }
      case 16: {
        [self setAmountSpent:[input readInt32]];
        break;
      }
    }
  }
}
- (BOOL) hasSender {
  return result.hasSender;
}
- (BasicUserProto*) sender {
  return result.sender;
}
- (SpendRubiesRequestProto_Builder*) setSender:(BasicUserProto*) value {
  result.hasSender = YES;
  result.sender = value;
  return self;
}
- (SpendRubiesRequestProto_Builder*) setSenderBuilder:(BasicUserProto_Builder*) builderForValue {
  return [self setSender:[builderForValue build]];
}
- (SpendRubiesRequestProto_Builder*) mergeSender:(BasicUserProto*) value {
  if (result.hasSender &&
      result.sender != [BasicUserProto defaultInstance]) {
    result.sender =
      [[[BasicUserProto builderWithPrototype:result.sender] mergeFrom:value] buildPartial];
  } else {
    result.sender = value;
  }
  result.hasSender = YES;
  return self;
}
- (SpendRubiesRequestProto_Builder*) clearSender {
  result.hasSender = NO;
  result.sender = [BasicUserProto defaultInstance];
  return self;
}
- (BOOL) hasAmountSpent {
  return result.hasAmountSpent;
}
- (int32_t) amountSpent {
  return result.amountSpent;
}
- (SpendRubiesRequestProto_Builder*) setAmountSpent:(int32_t) value {
  result.hasAmountSpent = YES;
  result.amountSpent = value;
  return self;
}
- (SpendRubiesRequestProto_Builder*) clearAmountSpent {
  result.hasAmountSpent = NO;
  result.amountSpent = 0;
  return self;
}
@end

@interface SpendRubiesResponseProto ()
@property (retain) BasicUserProto* recipient;
@property SpendRubiesResponseProto_SpendRubiesStatus status;
@property (retain) UserCurrencyProto* currentFunds;
@end

@implementation SpendRubiesResponseProto

- (BOOL) hasRecipient {
  return !!hasRecipient_;
}
- (void) setHasRecipient:(BOOL) value {
  hasRecipient_ = !!value;
}
@synthesize recipient;
- (BOOL) hasStatus {
  return !!hasStatus_;
}
- (void) setHasStatus:(BOOL) value {
  hasStatus_ = !!value;
}
@synthesize status;
- (BOOL) hasCurrentFunds {
  return !!hasCurrentFunds_;
}
- (void) setHasCurrentFunds:(BOOL) value {
  hasCurrentFunds_ = !!value;
}
@synthesize currentFunds;
- (void) dealloc {
  self.recipient = nil;
  self.currentFunds = nil;
  [super dealloc];
}
- (id) init {
  if ((self = [super init])) {
    self.recipient = [BasicUserProto defaultInstance];
    self.status = SpendRubiesResponseProto_SpendRubiesStatusSuccess;
    self.currentFunds = [UserCurrencyProto defaultInstance];
  }
  return self;
}
static SpendRubiesResponseProto* defaultSpendRubiesResponseProtoInstance = nil;
+ (void) initialize {
  if (self == [SpendRubiesResponseProto class]) {
    defaultSpendRubiesResponseProtoInstance = [[SpendRubiesResponseProto alloc] init];
  }
}
+ (SpendRubiesResponseProto*) defaultInstance {
  return defaultSpendRubiesResponseProtoInstance;
}
- (SpendRubiesResponseProto*) defaultInstance {
  return defaultSpendRubiesResponseProtoInstance;
}
- (BOOL) isInitialized {
  return YES;
}
- (void) writeToCodedOutputStream:(PBCodedOutputStream*) output {
  if (self.hasRecipient) {
    [output writeMessage:1 value:self.recipient];
  }
  if (self.hasStatus) {
    [output writeEnum:2 value:self.status];
  }
  if (self.hasCurrentFunds) {
    [output writeMessage:3 value:self.currentFunds];
  }
  [self.unknownFields writeToCodedOutputStream:output];
}
- (int32_t) serializedSize {
  int32_t size = memoizedSerializedSize;
  if (size != -1) {
    return size;
  }

  size = 0;
  if (self.hasRecipient) {
    size += computeMessageSize(1, self.recipient);
  }
  if (self.hasStatus) {
    size += computeEnumSize(2, self.status);
  }
  if (self.hasCurrentFunds) {
    size += computeMessageSize(3, self.currentFunds);
  }
  size += self.unknownFields.serializedSize;
  memoizedSerializedSize = size;
  return size;
}
+ (SpendRubiesResponseProto*) parseFromData:(NSData*) data {
  return (SpendRubiesResponseProto*)[[[SpendRubiesResponseProto builder] mergeFromData:data] build];
}
+ (SpendRubiesResponseProto*) parseFromData:(NSData*) data extensionRegistry:(PBExtensionRegistry*) extensionRegistry {
  return (SpendRubiesResponseProto*)[[[SpendRubiesResponseProto builder] mergeFromData:data extensionRegistry:extensionRegistry] build];
}
+ (SpendRubiesResponseProto*) parseFromInputStream:(NSInputStream*) input {
  return (SpendRubiesResponseProto*)[[[SpendRubiesResponseProto builder] mergeFromInputStream:input] build];
}
+ (SpendRubiesResponseProto*) parseFromInputStream:(NSInputStream*) input extensionRegistry:(PBExtensionRegistry*) extensionRegistry {
  return (SpendRubiesResponseProto*)[[[SpendRubiesResponseProto builder] mergeFromInputStream:input extensionRegistry:extensionRegistry] build];
}
+ (SpendRubiesResponseProto*) parseFromCodedInputStream:(PBCodedInputStream*) input {
  return (SpendRubiesResponseProto*)[[[SpendRubiesResponseProto builder] mergeFromCodedInputStream:input] build];
}
+ (SpendRubiesResponseProto*) parseFromCodedInputStream:(PBCodedInputStream*) input extensionRegistry:(PBExtensionRegistry*) extensionRegistry {
  return (SpendRubiesResponseProto*)[[[SpendRubiesResponseProto builder] mergeFromCodedInputStream:input extensionRegistry:extensionRegistry] build];
}
+ (SpendRubiesResponseProto_Builder*) builder {
  return [[[SpendRubiesResponseProto_Builder alloc] init] autorelease];
}
+ (SpendRubiesResponseProto_Builder*) builderWithPrototype:(SpendRubiesResponseProto*) prototype {
  return [[SpendRubiesResponseProto builder] mergeFrom:prototype];
}
- (SpendRubiesResponseProto_Builder*) builder {
  return [SpendRubiesResponseProto builder];
}
@end

BOOL SpendRubiesResponseProto_SpendRubiesStatusIsValidValue(SpendRubiesResponseProto_SpendRubiesStatus value) {
  switch (value) {
    case SpendRubiesResponseProto_SpendRubiesStatusSuccess:
    case SpendRubiesResponseProto_SpendRubiesStatusFailNotEnoughRubies:
    case SpendRubiesResponseProto_SpendRubiesStatusFailOther:
      return YES;
    default:
      return NO;
  }
}
@interface SpendRubiesResponseProto_Builder()
@property (retain) SpendRubiesResponseProto* result;
@end

@implementation SpendRubiesResponseProto_Builder
@synthesize result;
- (void) dealloc {
  self.result = nil;
  [super dealloc];
}
- (id) init {
  if ((self = [super init])) {
    self.result = [[[SpendRubiesResponseProto alloc] init] autorelease];
  }
  return self;
}
- (PBGeneratedMessage*) internalGetResult {
  return result;
}
- (SpendRubiesResponseProto_Builder*) clear {
  self.result = [[[SpendRubiesResponseProto alloc] init] autorelease];
  return self;
}
- (SpendRubiesResponseProto_Builder*) clone {
  return [SpendRubiesResponseProto builderWithPrototype:result];
}
- (SpendRubiesResponseProto*) defaultInstance {
  return [SpendRubiesResponseProto defaultInstance];
}
- (SpendRubiesResponseProto*) build {
  [self checkInitialized];
  return [self buildPartial];
}
- (SpendRubiesResponseProto*) buildPartial {
  SpendRubiesResponseProto* returnMe = [[result retain] autorelease];
  self.result = nil;
  return returnMe;
}
- (SpendRubiesResponseProto_Builder*) mergeFrom:(SpendRubiesResponseProto*) other {
  if (other == [SpendRubiesResponseProto defaultInstance]) {
    return self;
  }
  if (other.hasRecipient) {
    [self mergeRecipient:other.recipient];
  }
  if (other.hasStatus) {
    [self setStatus:other.status];
  }
  if (other.hasCurrentFunds) {
    [self mergeCurrentFunds:other.currentFunds];
  }
  [self mergeUnknownFields:other.unknownFields];
  return self;
}
- (SpendRubiesResponseProto_Builder*) mergeFromCodedInputStream:(PBCodedInputStream*) input {
  return [self mergeFromCodedInputStream:input extensionRegistry:[PBExtensionRegistry emptyRegistry]];
}
- (SpendRubiesResponseProto_Builder*) mergeFromCodedInputStream:(PBCodedInputStream*) input extensionRegistry:(PBExtensionRegistry*) extensionRegistry {
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
        BasicUserProto_Builder* subBuilder = [BasicUserProto builder];
        if (self.hasRecipient) {
          [subBuilder mergeFrom:self.recipient];
        }
        [input readMessage:subBuilder extensionRegistry:extensionRegistry];
        [self setRecipient:[subBuilder buildPartial]];
        break;
      }
      case 16: {
        int32_t value = [input readEnum];
        if (SpendRubiesResponseProto_SpendRubiesStatusIsValidValue(value)) {
          [self setStatus:value];
        } else {
          [unknownFields mergeVarintField:2 value:value];
        }
        break;
      }
      case 26: {
        UserCurrencyProto_Builder* subBuilder = [UserCurrencyProto builder];
        if (self.hasCurrentFunds) {
          [subBuilder mergeFrom:self.currentFunds];
        }
        [input readMessage:subBuilder extensionRegistry:extensionRegistry];
        [self setCurrentFunds:[subBuilder buildPartial]];
        break;
      }
    }
  }
}
- (BOOL) hasRecipient {
  return result.hasRecipient;
}
- (BasicUserProto*) recipient {
  return result.recipient;
}
- (SpendRubiesResponseProto_Builder*) setRecipient:(BasicUserProto*) value {
  result.hasRecipient = YES;
  result.recipient = value;
  return self;
}
- (SpendRubiesResponseProto_Builder*) setRecipientBuilder:(BasicUserProto_Builder*) builderForValue {
  return [self setRecipient:[builderForValue build]];
}
- (SpendRubiesResponseProto_Builder*) mergeRecipient:(BasicUserProto*) value {
  if (result.hasRecipient &&
      result.recipient != [BasicUserProto defaultInstance]) {
    result.recipient =
      [[[BasicUserProto builderWithPrototype:result.recipient] mergeFrom:value] buildPartial];
  } else {
    result.recipient = value;
  }
  result.hasRecipient = YES;
  return self;
}
- (SpendRubiesResponseProto_Builder*) clearRecipient {
  result.hasRecipient = NO;
  result.recipient = [BasicUserProto defaultInstance];
  return self;
}
- (BOOL) hasStatus {
  return result.hasStatus;
}
- (SpendRubiesResponseProto_SpendRubiesStatus) status {
  return result.status;
}
- (SpendRubiesResponseProto_Builder*) setStatus:(SpendRubiesResponseProto_SpendRubiesStatus) value {
  result.hasStatus = YES;
  result.status = value;
  return self;
}
- (SpendRubiesResponseProto_Builder*) clearStatus {
  result.hasStatus = NO;
  result.status = SpendRubiesResponseProto_SpendRubiesStatusSuccess;
  return self;
}
- (BOOL) hasCurrentFunds {
  return result.hasCurrentFunds;
}
- (UserCurrencyProto*) currentFunds {
  return result.currentFunds;
}
- (SpendRubiesResponseProto_Builder*) setCurrentFunds:(UserCurrencyProto*) value {
  result.hasCurrentFunds = YES;
  result.currentFunds = value;
  return self;
}
- (SpendRubiesResponseProto_Builder*) setCurrentFundsBuilder:(UserCurrencyProto_Builder*) builderForValue {
  return [self setCurrentFunds:[builderForValue build]];
}
- (SpendRubiesResponseProto_Builder*) mergeCurrentFunds:(UserCurrencyProto*) value {
  if (result.hasCurrentFunds &&
      result.currentFunds != [UserCurrencyProto defaultInstance]) {
    result.currentFunds =
      [[[UserCurrencyProto builderWithPrototype:result.currentFunds] mergeFrom:value] buildPartial];
  } else {
    result.currentFunds = value;
  }
  result.hasCurrentFunds = YES;
  return self;
}
- (SpendRubiesResponseProto_Builder*) clearCurrentFunds {
  result.hasCurrentFunds = NO;
  result.currentFunds = [UserCurrencyProto defaultInstance];
  return self;
}
@end
