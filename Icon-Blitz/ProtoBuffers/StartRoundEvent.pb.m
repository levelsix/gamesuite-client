// Generated by the protocol buffer compiler.  DO NOT EDIT!

#import "StartRoundEvent.pb.h"

@implementation StartRoundEventRoot
static PBExtensionRegistry* extensionRegistry = nil;
+ (PBExtensionRegistry*) extensionRegistry {
  return extensionRegistry;
}

+ (void) initialize {
  if (self == [StartRoundEventRoot class]) {
    PBMutableExtensionRegistry* registry = [PBMutableExtensionRegistry registry];
    [self registerAllExtensions:registry];
    [UserRoot registerAllExtensions:registry];
    [TriviaQuestionFormatRoot registerAllExtensions:registry];
    extensionRegistry = [registry retain];
  }
}
+ (void) registerAllExtensions:(PBMutableExtensionRegistry*) registry {
}
@end

@interface StartRoundRequestProto ()
@property (retain) BasicUserProto* sender;
@property (retain) NSString* gameId;
@property int32_t roundNumber;
@property BOOL isPlayerOne;
@property int64_t startTime;
@property (retain) NSMutableArray* mutableQuestionsList;
@end

@implementation StartRoundRequestProto

- (BOOL) hasSender {
  return !!hasSender_;
}
- (void) setHasSender:(BOOL) value {
  hasSender_ = !!value;
}
@synthesize sender;
- (BOOL) hasGameId {
  return !!hasGameId_;
}
- (void) setHasGameId:(BOOL) value {
  hasGameId_ = !!value;
}
@synthesize gameId;
- (BOOL) hasRoundNumber {
  return !!hasRoundNumber_;
}
- (void) setHasRoundNumber:(BOOL) value {
  hasRoundNumber_ = !!value;
}
@synthesize roundNumber;
- (BOOL) hasIsPlayerOne {
  return !!hasIsPlayerOne_;
}
- (void) setHasIsPlayerOne:(BOOL) value {
  hasIsPlayerOne_ = !!value;
}
- (BOOL) isPlayerOne {
  return !!isPlayerOne_;
}
- (void) setIsPlayerOne:(BOOL) value {
  isPlayerOne_ = !!value;
}
- (BOOL) hasStartTime {
  return !!hasStartTime_;
}
- (void) setHasStartTime:(BOOL) value {
  hasStartTime_ = !!value;
}
@synthesize startTime;
@synthesize mutableQuestionsList;
- (void) dealloc {
  self.sender = nil;
  self.gameId = nil;
  self.mutableQuestionsList = nil;
  [super dealloc];
}
- (id) init {
  if ((self = [super init])) {
    self.sender = [BasicUserProto defaultInstance];
    self.gameId = @"";
    self.roundNumber = 0;
    self.isPlayerOne = NO;
    self.startTime = 0L;
  }
  return self;
}
static StartRoundRequestProto* defaultStartRoundRequestProtoInstance = nil;
+ (void) initialize {
  if (self == [StartRoundRequestProto class]) {
    defaultStartRoundRequestProtoInstance = [[StartRoundRequestProto alloc] init];
  }
}
+ (StartRoundRequestProto*) defaultInstance {
  return defaultStartRoundRequestProtoInstance;
}
- (StartRoundRequestProto*) defaultInstance {
  return defaultStartRoundRequestProtoInstance;
}
- (NSArray*) questionsList {
  return mutableQuestionsList;
}
- (QuestionProto*) questionsAtIndex:(int32_t) index {
  id value = [mutableQuestionsList objectAtIndex:index];
  return value;
}
- (BOOL) isInitialized {
  return YES;
}
- (void) writeToCodedOutputStream:(PBCodedOutputStream*) output {
  if (self.hasSender) {
    [output writeMessage:1 value:self.sender];
  }
  if (self.hasGameId) {
    [output writeString:2 value:self.gameId];
  }
  if (self.hasRoundNumber) {
    [output writeInt32:3 value:self.roundNumber];
  }
  if (self.hasIsPlayerOne) {
    [output writeBool:4 value:self.isPlayerOne];
  }
  if (self.hasStartTime) {
    [output writeInt64:5 value:self.startTime];
  }
  for (QuestionProto* element in self.questionsList) {
    [output writeMessage:6 value:element];
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
  if (self.hasGameId) {
    size += computeStringSize(2, self.gameId);
  }
  if (self.hasRoundNumber) {
    size += computeInt32Size(3, self.roundNumber);
  }
  if (self.hasIsPlayerOne) {
    size += computeBoolSize(4, self.isPlayerOne);
  }
  if (self.hasStartTime) {
    size += computeInt64Size(5, self.startTime);
  }
  for (QuestionProto* element in self.questionsList) {
    size += computeMessageSize(6, element);
  }
  size += self.unknownFields.serializedSize;
  memoizedSerializedSize = size;
  return size;
}
+ (StartRoundRequestProto*) parseFromData:(NSData*) data {
  return (StartRoundRequestProto*)[[[StartRoundRequestProto builder] mergeFromData:data] build];
}
+ (StartRoundRequestProto*) parseFromData:(NSData*) data extensionRegistry:(PBExtensionRegistry*) extensionRegistry {
  return (StartRoundRequestProto*)[[[StartRoundRequestProto builder] mergeFromData:data extensionRegistry:extensionRegistry] build];
}
+ (StartRoundRequestProto*) parseFromInputStream:(NSInputStream*) input {
  return (StartRoundRequestProto*)[[[StartRoundRequestProto builder] mergeFromInputStream:input] build];
}
+ (StartRoundRequestProto*) parseFromInputStream:(NSInputStream*) input extensionRegistry:(PBExtensionRegistry*) extensionRegistry {
  return (StartRoundRequestProto*)[[[StartRoundRequestProto builder] mergeFromInputStream:input extensionRegistry:extensionRegistry] build];
}
+ (StartRoundRequestProto*) parseFromCodedInputStream:(PBCodedInputStream*) input {
  return (StartRoundRequestProto*)[[[StartRoundRequestProto builder] mergeFromCodedInputStream:input] build];
}
+ (StartRoundRequestProto*) parseFromCodedInputStream:(PBCodedInputStream*) input extensionRegistry:(PBExtensionRegistry*) extensionRegistry {
  return (StartRoundRequestProto*)[[[StartRoundRequestProto builder] mergeFromCodedInputStream:input extensionRegistry:extensionRegistry] build];
}
+ (StartRoundRequestProto_Builder*) builder {
  return [[[StartRoundRequestProto_Builder alloc] init] autorelease];
}
+ (StartRoundRequestProto_Builder*) builderWithPrototype:(StartRoundRequestProto*) prototype {
  return [[StartRoundRequestProto builder] mergeFrom:prototype];
}
- (StartRoundRequestProto_Builder*) builder {
  return [StartRoundRequestProto builder];
}
@end

@interface StartRoundRequestProto_Builder()
@property (retain) StartRoundRequestProto* result;
@end

@implementation StartRoundRequestProto_Builder
@synthesize result;
- (void) dealloc {
  self.result = nil;
  [super dealloc];
}
- (id) init {
  if ((self = [super init])) {
    self.result = [[[StartRoundRequestProto alloc] init] autorelease];
  }
  return self;
}
- (PBGeneratedMessage*) internalGetResult {
  return result;
}
- (StartRoundRequestProto_Builder*) clear {
  self.result = [[[StartRoundRequestProto alloc] init] autorelease];
  return self;
}
- (StartRoundRequestProto_Builder*) clone {
  return [StartRoundRequestProto builderWithPrototype:result];
}
- (StartRoundRequestProto*) defaultInstance {
  return [StartRoundRequestProto defaultInstance];
}
- (StartRoundRequestProto*) build {
  [self checkInitialized];
  return [self buildPartial];
}
- (StartRoundRequestProto*) buildPartial {
  StartRoundRequestProto* returnMe = [[result retain] autorelease];
  self.result = nil;
  return returnMe;
}
- (StartRoundRequestProto_Builder*) mergeFrom:(StartRoundRequestProto*) other {
  if (other == [StartRoundRequestProto defaultInstance]) {
    return self;
  }
  if (other.hasSender) {
    [self mergeSender:other.sender];
  }
  if (other.hasGameId) {
    [self setGameId:other.gameId];
  }
  if (other.hasRoundNumber) {
    [self setRoundNumber:other.roundNumber];
  }
  if (other.hasIsPlayerOne) {
    [self setIsPlayerOne:other.isPlayerOne];
  }
  if (other.hasStartTime) {
    [self setStartTime:other.startTime];
  }
  if (other.mutableQuestionsList.count > 0) {
    if (result.mutableQuestionsList == nil) {
      result.mutableQuestionsList = [NSMutableArray array];
    }
    [result.mutableQuestionsList addObjectsFromArray:other.mutableQuestionsList];
  }
  [self mergeUnknownFields:other.unknownFields];
  return self;
}
- (StartRoundRequestProto_Builder*) mergeFromCodedInputStream:(PBCodedInputStream*) input {
  return [self mergeFromCodedInputStream:input extensionRegistry:[PBExtensionRegistry emptyRegistry]];
}
- (StartRoundRequestProto_Builder*) mergeFromCodedInputStream:(PBCodedInputStream*) input extensionRegistry:(PBExtensionRegistry*) extensionRegistry {
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
      case 18: {
        [self setGameId:[input readString]];
        break;
      }
      case 24: {
        [self setRoundNumber:[input readInt32]];
        break;
      }
      case 32: {
        [self setIsPlayerOne:[input readBool]];
        break;
      }
      case 40: {
        [self setStartTime:[input readInt64]];
        break;
      }
      case 50: {
        QuestionProto_Builder* subBuilder = [QuestionProto builder];
        [input readMessage:subBuilder extensionRegistry:extensionRegistry];
        [self addQuestions:[subBuilder buildPartial]];
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
- (StartRoundRequestProto_Builder*) setSender:(BasicUserProto*) value {
  result.hasSender = YES;
  result.sender = value;
  return self;
}
- (StartRoundRequestProto_Builder*) setSenderBuilder:(BasicUserProto_Builder*) builderForValue {
  return [self setSender:[builderForValue build]];
}
- (StartRoundRequestProto_Builder*) mergeSender:(BasicUserProto*) value {
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
- (StartRoundRequestProto_Builder*) clearSender {
  result.hasSender = NO;
  result.sender = [BasicUserProto defaultInstance];
  return self;
}
- (BOOL) hasGameId {
  return result.hasGameId;
}
- (NSString*) gameId {
  return result.gameId;
}
- (StartRoundRequestProto_Builder*) setGameId:(NSString*) value {
  result.hasGameId = YES;
  result.gameId = value;
  return self;
}
- (StartRoundRequestProto_Builder*) clearGameId {
  result.hasGameId = NO;
  result.gameId = @"";
  return self;
}
- (BOOL) hasRoundNumber {
  return result.hasRoundNumber;
}
- (int32_t) roundNumber {
  return result.roundNumber;
}
- (StartRoundRequestProto_Builder*) setRoundNumber:(int32_t) value {
  result.hasRoundNumber = YES;
  result.roundNumber = value;
  return self;
}
- (StartRoundRequestProto_Builder*) clearRoundNumber {
  result.hasRoundNumber = NO;
  result.roundNumber = 0;
  return self;
}
- (BOOL) hasIsPlayerOne {
  return result.hasIsPlayerOne;
}
- (BOOL) isPlayerOne {
  return result.isPlayerOne;
}
- (StartRoundRequestProto_Builder*) setIsPlayerOne:(BOOL) value {
  result.hasIsPlayerOne = YES;
  result.isPlayerOne = value;
  return self;
}
- (StartRoundRequestProto_Builder*) clearIsPlayerOne {
  result.hasIsPlayerOne = NO;
  result.isPlayerOne = NO;
  return self;
}
- (BOOL) hasStartTime {
  return result.hasStartTime;
}
- (int64_t) startTime {
  return result.startTime;
}
- (StartRoundRequestProto_Builder*) setStartTime:(int64_t) value {
  result.hasStartTime = YES;
  result.startTime = value;
  return self;
}
- (StartRoundRequestProto_Builder*) clearStartTime {
  result.hasStartTime = NO;
  result.startTime = 0L;
  return self;
}
- (NSArray*) questionsList {
  if (result.mutableQuestionsList == nil) { return [NSArray array]; }
  return result.mutableQuestionsList;
}
- (QuestionProto*) questionsAtIndex:(int32_t) index {
  return [result questionsAtIndex:index];
}
- (StartRoundRequestProto_Builder*) replaceQuestionsAtIndex:(int32_t) index with:(QuestionProto*) value {
  [result.mutableQuestionsList replaceObjectAtIndex:index withObject:value];
  return self;
}
- (StartRoundRequestProto_Builder*) addAllQuestions:(NSArray*) values {
  if (result.mutableQuestionsList == nil) {
    result.mutableQuestionsList = [NSMutableArray array];
  }
  [result.mutableQuestionsList addObjectsFromArray:values];
  return self;
}
- (StartRoundRequestProto_Builder*) clearQuestionsList {
  result.mutableQuestionsList = nil;
  return self;
}
- (StartRoundRequestProto_Builder*) addQuestions:(QuestionProto*) value {
  if (result.mutableQuestionsList == nil) {
    result.mutableQuestionsList = [NSMutableArray array];
  }
  [result.mutableQuestionsList addObject:value];
  return self;
}
@end

@interface StartRoundResponseProto ()
@property (retain) BasicUserProto* recipient;
@property (retain) NSString* gameId;
@end

@implementation StartRoundResponseProto

- (BOOL) hasRecipient {
  return !!hasRecipient_;
}
- (void) setHasRecipient:(BOOL) value {
  hasRecipient_ = !!value;
}
@synthesize recipient;
- (BOOL) hasGameId {
  return !!hasGameId_;
}
- (void) setHasGameId:(BOOL) value {
  hasGameId_ = !!value;
}
@synthesize gameId;
- (void) dealloc {
  self.recipient = nil;
  self.gameId = nil;
  [super dealloc];
}
- (id) init {
  if ((self = [super init])) {
    self.recipient = [BasicUserProto defaultInstance];
    self.gameId = @"";
  }
  return self;
}
static StartRoundResponseProto* defaultStartRoundResponseProtoInstance = nil;
+ (void) initialize {
  if (self == [StartRoundResponseProto class]) {
    defaultStartRoundResponseProtoInstance = [[StartRoundResponseProto alloc] init];
  }
}
+ (StartRoundResponseProto*) defaultInstance {
  return defaultStartRoundResponseProtoInstance;
}
- (StartRoundResponseProto*) defaultInstance {
  return defaultStartRoundResponseProtoInstance;
}
- (BOOL) isInitialized {
  return YES;
}
- (void) writeToCodedOutputStream:(PBCodedOutputStream*) output {
  if (self.hasRecipient) {
    [output writeMessage:1 value:self.recipient];
  }
  if (self.hasGameId) {
    [output writeString:2 value:self.gameId];
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
  if (self.hasGameId) {
    size += computeStringSize(2, self.gameId);
  }
  size += self.unknownFields.serializedSize;
  memoizedSerializedSize = size;
  return size;
}
+ (StartRoundResponseProto*) parseFromData:(NSData*) data {
  return (StartRoundResponseProto*)[[[StartRoundResponseProto builder] mergeFromData:data] build];
}
+ (StartRoundResponseProto*) parseFromData:(NSData*) data extensionRegistry:(PBExtensionRegistry*) extensionRegistry {
  return (StartRoundResponseProto*)[[[StartRoundResponseProto builder] mergeFromData:data extensionRegistry:extensionRegistry] build];
}
+ (StartRoundResponseProto*) parseFromInputStream:(NSInputStream*) input {
  return (StartRoundResponseProto*)[[[StartRoundResponseProto builder] mergeFromInputStream:input] build];
}
+ (StartRoundResponseProto*) parseFromInputStream:(NSInputStream*) input extensionRegistry:(PBExtensionRegistry*) extensionRegistry {
  return (StartRoundResponseProto*)[[[StartRoundResponseProto builder] mergeFromInputStream:input extensionRegistry:extensionRegistry] build];
}
+ (StartRoundResponseProto*) parseFromCodedInputStream:(PBCodedInputStream*) input {
  return (StartRoundResponseProto*)[[[StartRoundResponseProto builder] mergeFromCodedInputStream:input] build];
}
+ (StartRoundResponseProto*) parseFromCodedInputStream:(PBCodedInputStream*) input extensionRegistry:(PBExtensionRegistry*) extensionRegistry {
  return (StartRoundResponseProto*)[[[StartRoundResponseProto builder] mergeFromCodedInputStream:input extensionRegistry:extensionRegistry] build];
}
+ (StartRoundResponseProto_Builder*) builder {
  return [[[StartRoundResponseProto_Builder alloc] init] autorelease];
}
+ (StartRoundResponseProto_Builder*) builderWithPrototype:(StartRoundResponseProto*) prototype {
  return [[StartRoundResponseProto builder] mergeFrom:prototype];
}
- (StartRoundResponseProto_Builder*) builder {
  return [StartRoundResponseProto builder];
}
@end

BOOL StartRoundResponseProto_StartRoundResponseStatusIsValidValue(StartRoundResponseProto_StartRoundResponseStatus value) {
  switch (value) {
    case StartRoundResponseProto_StartRoundResponseStatusSuccess:
    case StartRoundResponseProto_StartRoundResponseStatusFailClientTooApartFromServerTime:
    case StartRoundResponseProto_StartRoundResponseStatusFailOther:
      return YES;
    default:
      return NO;
  }
}
@interface StartRoundResponseProto_Builder()
@property (retain) StartRoundResponseProto* result;
@end

@implementation StartRoundResponseProto_Builder
@synthesize result;
- (void) dealloc {
  self.result = nil;
  [super dealloc];
}
- (id) init {
  if ((self = [super init])) {
    self.result = [[[StartRoundResponseProto alloc] init] autorelease];
  }
  return self;
}
- (PBGeneratedMessage*) internalGetResult {
  return result;
}
- (StartRoundResponseProto_Builder*) clear {
  self.result = [[[StartRoundResponseProto alloc] init] autorelease];
  return self;
}
- (StartRoundResponseProto_Builder*) clone {
  return [StartRoundResponseProto builderWithPrototype:result];
}
- (StartRoundResponseProto*) defaultInstance {
  return [StartRoundResponseProto defaultInstance];
}
- (StartRoundResponseProto*) build {
  [self checkInitialized];
  return [self buildPartial];
}
- (StartRoundResponseProto*) buildPartial {
  StartRoundResponseProto* returnMe = [[result retain] autorelease];
  self.result = nil;
  return returnMe;
}
- (StartRoundResponseProto_Builder*) mergeFrom:(StartRoundResponseProto*) other {
  if (other == [StartRoundResponseProto defaultInstance]) {
    return self;
  }
  if (other.hasRecipient) {
    [self mergeRecipient:other.recipient];
  }
  if (other.hasGameId) {
    [self setGameId:other.gameId];
  }
  [self mergeUnknownFields:other.unknownFields];
  return self;
}
- (StartRoundResponseProto_Builder*) mergeFromCodedInputStream:(PBCodedInputStream*) input {
  return [self mergeFromCodedInputStream:input extensionRegistry:[PBExtensionRegistry emptyRegistry]];
}
- (StartRoundResponseProto_Builder*) mergeFromCodedInputStream:(PBCodedInputStream*) input extensionRegistry:(PBExtensionRegistry*) extensionRegistry {
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
      case 18: {
        [self setGameId:[input readString]];
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
- (StartRoundResponseProto_Builder*) setRecipient:(BasicUserProto*) value {
  result.hasRecipient = YES;
  result.recipient = value;
  return self;
}
- (StartRoundResponseProto_Builder*) setRecipientBuilder:(BasicUserProto_Builder*) builderForValue {
  return [self setRecipient:[builderForValue build]];
}
- (StartRoundResponseProto_Builder*) mergeRecipient:(BasicUserProto*) value {
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
- (StartRoundResponseProto_Builder*) clearRecipient {
  result.hasRecipient = NO;
  result.recipient = [BasicUserProto defaultInstance];
  return self;
}
- (BOOL) hasGameId {
  return result.hasGameId;
}
- (NSString*) gameId {
  return result.gameId;
}
- (StartRoundResponseProto_Builder*) setGameId:(NSString*) value {
  result.hasGameId = YES;
  result.gameId = value;
  return self;
}
- (StartRoundResponseProto_Builder*) clearGameId {
  result.hasGameId = NO;
  result.gameId = @"";
  return self;
}
@end
