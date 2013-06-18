// Generated by the protocol buffer compiler.  DO NOT EDIT!

#import "TriviaRoundFormat.pb.h"

@implementation TriviaRoundFormatRoot
static PBExtensionRegistry* extensionRegistry = nil;
+ (PBExtensionRegistry*) extensionRegistry {
  return extensionRegistry;
}

+ (void) initialize {
  if (self == [TriviaRoundFormatRoot class]) {
    PBMutableExtensionRegistry* registry = [PBMutableExtensionRegistry registry];
    [self registerAllExtensions:registry];
    [TriviaQuestionFormatRoot registerAllExtensions:registry];
    extensionRegistry = [registry retain];
  }
}
+ (void) registerAllExtensions:(PBMutableExtensionRegistry*) registry {
}
@end

@interface BasicRoundResultsProto ()
@property (retain) NSString* id;
@property int32_t score;
@property int32_t roundNumber;
@end

@implementation BasicRoundResultsProto

- (BOOL) hasId {
  return !!hasId_;
}
- (void) setHasId:(BOOL) value {
  hasId_ = !!value;
}
@synthesize id;
- (BOOL) hasScore {
  return !!hasScore_;
}
- (void) setHasScore:(BOOL) value {
  hasScore_ = !!value;
}
@synthesize score;
- (BOOL) hasRoundNumber {
  return !!hasRoundNumber_;
}
- (void) setHasRoundNumber:(BOOL) value {
  hasRoundNumber_ = !!value;
}
@synthesize roundNumber;
- (void) dealloc {
  self.id = nil;
  [super dealloc];
}
- (id) init {
  if ((self = [super init])) {
    self.id = @"";
    self.score = 0;
    self.roundNumber = 0;
  }
  return self;
}
static BasicRoundResultsProto* defaultBasicRoundResultsProtoInstance = nil;
+ (void) initialize {
  if (self == [BasicRoundResultsProto class]) {
    defaultBasicRoundResultsProtoInstance = [[BasicRoundResultsProto alloc] init];
  }
}
+ (BasicRoundResultsProto*) defaultInstance {
  return defaultBasicRoundResultsProtoInstance;
}
- (BasicRoundResultsProto*) defaultInstance {
  return defaultBasicRoundResultsProtoInstance;
}
- (BOOL) isInitialized {
  return YES;
}
- (void) writeToCodedOutputStream:(PBCodedOutputStream*) output {
  if (self.hasId) {
    [output writeString:1 value:self.id];
  }
  if (self.hasScore) {
    [output writeSInt32:2 value:self.score];
  }
  if (self.hasRoundNumber) {
    [output writeInt32:3 value:self.roundNumber];
  }
  [self.unknownFields writeToCodedOutputStream:output];
}
- (int32_t) serializedSize {
  int32_t size = memoizedSerializedSize;
  if (size != -1) {
    return size;
  }

  size = 0;
  if (self.hasId) {
    size += computeStringSize(1, self.id);
  }
  if (self.hasScore) {
    size += computeSInt32Size(2, self.score);
  }
  if (self.hasRoundNumber) {
    size += computeInt32Size(3, self.roundNumber);
  }
  size += self.unknownFields.serializedSize;
  memoizedSerializedSize = size;
  return size;
}
+ (BasicRoundResultsProto*) parseFromData:(NSData*) data {
  return (BasicRoundResultsProto*)[[[BasicRoundResultsProto builder] mergeFromData:data] build];
}
+ (BasicRoundResultsProto*) parseFromData:(NSData*) data extensionRegistry:(PBExtensionRegistry*) extensionRegistry {
  return (BasicRoundResultsProto*)[[[BasicRoundResultsProto builder] mergeFromData:data extensionRegistry:extensionRegistry] build];
}
+ (BasicRoundResultsProto*) parseFromInputStream:(NSInputStream*) input {
  return (BasicRoundResultsProto*)[[[BasicRoundResultsProto builder] mergeFromInputStream:input] build];
}
+ (BasicRoundResultsProto*) parseFromInputStream:(NSInputStream*) input extensionRegistry:(PBExtensionRegistry*) extensionRegistry {
  return (BasicRoundResultsProto*)[[[BasicRoundResultsProto builder] mergeFromInputStream:input extensionRegistry:extensionRegistry] build];
}
+ (BasicRoundResultsProto*) parseFromCodedInputStream:(PBCodedInputStream*) input {
  return (BasicRoundResultsProto*)[[[BasicRoundResultsProto builder] mergeFromCodedInputStream:input] build];
}
+ (BasicRoundResultsProto*) parseFromCodedInputStream:(PBCodedInputStream*) input extensionRegistry:(PBExtensionRegistry*) extensionRegistry {
  return (BasicRoundResultsProto*)[[[BasicRoundResultsProto builder] mergeFromCodedInputStream:input extensionRegistry:extensionRegistry] build];
}
+ (BasicRoundResultsProto_Builder*) builder {
  return [[[BasicRoundResultsProto_Builder alloc] init] autorelease];
}
+ (BasicRoundResultsProto_Builder*) builderWithPrototype:(BasicRoundResultsProto*) prototype {
  return [[BasicRoundResultsProto builder] mergeFrom:prototype];
}
- (BasicRoundResultsProto_Builder*) builder {
  return [BasicRoundResultsProto builder];
}
@end

@interface BasicRoundResultsProto_Builder()
@property (retain) BasicRoundResultsProto* result;
@end

@implementation BasicRoundResultsProto_Builder
@synthesize result;
- (void) dealloc {
  self.result = nil;
  [super dealloc];
}
- (id) init {
  if ((self = [super init])) {
    self.result = [[[BasicRoundResultsProto alloc] init] autorelease];
  }
  return self;
}
- (PBGeneratedMessage*) internalGetResult {
  return result;
}
- (BasicRoundResultsProto_Builder*) clear {
  self.result = [[[BasicRoundResultsProto alloc] init] autorelease];
  return self;
}
- (BasicRoundResultsProto_Builder*) clone {
  return [BasicRoundResultsProto builderWithPrototype:result];
}
- (BasicRoundResultsProto*) defaultInstance {
  return [BasicRoundResultsProto defaultInstance];
}
- (BasicRoundResultsProto*) build {
  [self checkInitialized];
  return [self buildPartial];
}
- (BasicRoundResultsProto*) buildPartial {
  BasicRoundResultsProto* returnMe = [[result retain] autorelease];
  self.result = nil;
  return returnMe;
}
- (BasicRoundResultsProto_Builder*) mergeFrom:(BasicRoundResultsProto*) other {
  if (other == [BasicRoundResultsProto defaultInstance]) {
    return self;
  }
  if (other.hasId) {
    [self setId:other.id];
  }
  if (other.hasScore) {
    [self setScore:other.score];
  }
  if (other.hasRoundNumber) {
    [self setRoundNumber:other.roundNumber];
  }
  [self mergeUnknownFields:other.unknownFields];
  return self;
}
- (BasicRoundResultsProto_Builder*) mergeFromCodedInputStream:(PBCodedInputStream*) input {
  return [self mergeFromCodedInputStream:input extensionRegistry:[PBExtensionRegistry emptyRegistry]];
}
- (BasicRoundResultsProto_Builder*) mergeFromCodedInputStream:(PBCodedInputStream*) input extensionRegistry:(PBExtensionRegistry*) extensionRegistry {
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
        [self setId:[input readString]];
        break;
      }
      case 16: {
        [self setScore:[input readSInt32]];
        break;
      }
      case 24: {
        [self setRoundNumber:[input readInt32]];
        break;
      }
    }
  }
}
- (BOOL) hasId {
  return result.hasId;
}
- (NSString*) id {
  return result.id;
}
- (BasicRoundResultsProto_Builder*) setId:(NSString*) value {
  result.hasId = YES;
  result.id = value;
  return self;
}
- (BasicRoundResultsProto_Builder*) clearId {
  result.hasId = NO;
  result.id = @"";
  return self;
}
- (BOOL) hasScore {
  return result.hasScore;
}
- (int32_t) score {
  return result.score;
}
- (BasicRoundResultsProto_Builder*) setScore:(int32_t) value {
  result.hasScore = YES;
  result.score = value;
  return self;
}
- (BasicRoundResultsProto_Builder*) clearScore {
  result.hasScore = NO;
  result.score = 0;
  return self;
}
- (BOOL) hasRoundNumber {
  return result.hasRoundNumber;
}
- (int32_t) roundNumber {
  return result.roundNumber;
}
- (BasicRoundResultsProto_Builder*) setRoundNumber:(int32_t) value {
  result.hasRoundNumber = YES;
  result.roundNumber = value;
  return self;
}
- (BasicRoundResultsProto_Builder*) clearRoundNumber {
  result.hasRoundNumber = NO;
  result.roundNumber = 0;
  return self;
}
@end

@interface CompleteRoundResultsProto ()
@property (retain) NSString* id;
@property int32_t score;
@property int32_t roundNumber;
@property (retain) NSMutableArray* mutableAnswersList;
@property int64_t startTime;
@property int64_t endTime;
@end

@implementation CompleteRoundResultsProto

- (BOOL) hasId {
  return !!hasId_;
}
- (void) setHasId:(BOOL) value {
  hasId_ = !!value;
}
@synthesize id;
- (BOOL) hasScore {
  return !!hasScore_;
}
- (void) setHasScore:(BOOL) value {
  hasScore_ = !!value;
}
@synthesize score;
- (BOOL) hasRoundNumber {
  return !!hasRoundNumber_;
}
- (void) setHasRoundNumber:(BOOL) value {
  hasRoundNumber_ = !!value;
}
@synthesize roundNumber;
@synthesize mutableAnswersList;
- (BOOL) hasStartTime {
  return !!hasStartTime_;
}
- (void) setHasStartTime:(BOOL) value {
  hasStartTime_ = !!value;
}
@synthesize startTime;
- (BOOL) hasEndTime {
  return !!hasEndTime_;
}
- (void) setHasEndTime:(BOOL) value {
  hasEndTime_ = !!value;
}
@synthesize endTime;
- (void) dealloc {
  self.id = nil;
  self.mutableAnswersList = nil;
  [super dealloc];
}
- (id) init {
  if ((self = [super init])) {
    self.id = @"";
    self.score = 0;
    self.roundNumber = 0;
    self.startTime = 0L;
    self.endTime = 0L;
  }
  return self;
}
static CompleteRoundResultsProto* defaultCompleteRoundResultsProtoInstance = nil;
+ (void) initialize {
  if (self == [CompleteRoundResultsProto class]) {
    defaultCompleteRoundResultsProtoInstance = [[CompleteRoundResultsProto alloc] init];
  }
}
+ (CompleteRoundResultsProto*) defaultInstance {
  return defaultCompleteRoundResultsProtoInstance;
}
- (CompleteRoundResultsProto*) defaultInstance {
  return defaultCompleteRoundResultsProtoInstance;
}
- (NSArray*) answersList {
  return mutableAnswersList;
}
- (QuestionAnsweredProto*) answersAtIndex:(int32_t) index {
  id value = [mutableAnswersList objectAtIndex:index];
  return value;
}
- (BOOL) isInitialized {
  return YES;
}
- (void) writeToCodedOutputStream:(PBCodedOutputStream*) output {
  if (self.hasId) {
    [output writeString:1 value:self.id];
  }
  if (self.hasScore) {
    [output writeSInt32:2 value:self.score];
  }
  if (self.hasRoundNumber) {
    [output writeInt32:3 value:self.roundNumber];
  }
  for (QuestionAnsweredProto* element in self.answersList) {
    [output writeMessage:4 value:element];
  }
  if (self.hasStartTime) {
    [output writeInt64:5 value:self.startTime];
  }
  if (self.hasEndTime) {
    [output writeInt64:6 value:self.endTime];
  }
  [self.unknownFields writeToCodedOutputStream:output];
}
- (int32_t) serializedSize {
  int32_t size = memoizedSerializedSize;
  if (size != -1) {
    return size;
  }

  size = 0;
  if (self.hasId) {
    size += computeStringSize(1, self.id);
  }
  if (self.hasScore) {
    size += computeSInt32Size(2, self.score);
  }
  if (self.hasRoundNumber) {
    size += computeInt32Size(3, self.roundNumber);
  }
  for (QuestionAnsweredProto* element in self.answersList) {
    size += computeMessageSize(4, element);
  }
  if (self.hasStartTime) {
    size += computeInt64Size(5, self.startTime);
  }
  if (self.hasEndTime) {
    size += computeInt64Size(6, self.endTime);
  }
  size += self.unknownFields.serializedSize;
  memoizedSerializedSize = size;
  return size;
}
+ (CompleteRoundResultsProto*) parseFromData:(NSData*) data {
  return (CompleteRoundResultsProto*)[[[CompleteRoundResultsProto builder] mergeFromData:data] build];
}
+ (CompleteRoundResultsProto*) parseFromData:(NSData*) data extensionRegistry:(PBExtensionRegistry*) extensionRegistry {
  return (CompleteRoundResultsProto*)[[[CompleteRoundResultsProto builder] mergeFromData:data extensionRegistry:extensionRegistry] build];
}
+ (CompleteRoundResultsProto*) parseFromInputStream:(NSInputStream*) input {
  return (CompleteRoundResultsProto*)[[[CompleteRoundResultsProto builder] mergeFromInputStream:input] build];
}
+ (CompleteRoundResultsProto*) parseFromInputStream:(NSInputStream*) input extensionRegistry:(PBExtensionRegistry*) extensionRegistry {
  return (CompleteRoundResultsProto*)[[[CompleteRoundResultsProto builder] mergeFromInputStream:input extensionRegistry:extensionRegistry] build];
}
+ (CompleteRoundResultsProto*) parseFromCodedInputStream:(PBCodedInputStream*) input {
  return (CompleteRoundResultsProto*)[[[CompleteRoundResultsProto builder] mergeFromCodedInputStream:input] build];
}
+ (CompleteRoundResultsProto*) parseFromCodedInputStream:(PBCodedInputStream*) input extensionRegistry:(PBExtensionRegistry*) extensionRegistry {
  return (CompleteRoundResultsProto*)[[[CompleteRoundResultsProto builder] mergeFromCodedInputStream:input extensionRegistry:extensionRegistry] build];
}
+ (CompleteRoundResultsProto_Builder*) builder {
  return [[[CompleteRoundResultsProto_Builder alloc] init] autorelease];
}
+ (CompleteRoundResultsProto_Builder*) builderWithPrototype:(CompleteRoundResultsProto*) prototype {
  return [[CompleteRoundResultsProto builder] mergeFrom:prototype];
}
- (CompleteRoundResultsProto_Builder*) builder {
  return [CompleteRoundResultsProto builder];
}
@end

@interface CompleteRoundResultsProto_Builder()
@property (retain) CompleteRoundResultsProto* result;
@end

@implementation CompleteRoundResultsProto_Builder
@synthesize result;
- (void) dealloc {
  self.result = nil;
  [super dealloc];
}
- (id) init {
  if ((self = [super init])) {
    self.result = [[[CompleteRoundResultsProto alloc] init] autorelease];
  }
  return self;
}
- (PBGeneratedMessage*) internalGetResult {
  return result;
}
- (CompleteRoundResultsProto_Builder*) clear {
  self.result = [[[CompleteRoundResultsProto alloc] init] autorelease];
  return self;
}
- (CompleteRoundResultsProto_Builder*) clone {
  return [CompleteRoundResultsProto builderWithPrototype:result];
}
- (CompleteRoundResultsProto*) defaultInstance {
  return [CompleteRoundResultsProto defaultInstance];
}
- (CompleteRoundResultsProto*) build {
  [self checkInitialized];
  return [self buildPartial];
}
- (CompleteRoundResultsProto*) buildPartial {
  CompleteRoundResultsProto* returnMe = [[result retain] autorelease];
  self.result = nil;
  return returnMe;
}
- (CompleteRoundResultsProto_Builder*) mergeFrom:(CompleteRoundResultsProto*) other {
  if (other == [CompleteRoundResultsProto defaultInstance]) {
    return self;
  }
  if (other.hasId) {
    [self setId:other.id];
  }
  if (other.hasScore) {
    [self setScore:other.score];
  }
  if (other.hasRoundNumber) {
    [self setRoundNumber:other.roundNumber];
  }
  if (other.mutableAnswersList.count > 0) {
    if (result.mutableAnswersList == nil) {
      result.mutableAnswersList = [NSMutableArray array];
    }
    [result.mutableAnswersList addObjectsFromArray:other.mutableAnswersList];
  }
  if (other.hasStartTime) {
    [self setStartTime:other.startTime];
  }
  if (other.hasEndTime) {
    [self setEndTime:other.endTime];
  }
  [self mergeUnknownFields:other.unknownFields];
  return self;
}
- (CompleteRoundResultsProto_Builder*) mergeFromCodedInputStream:(PBCodedInputStream*) input {
  return [self mergeFromCodedInputStream:input extensionRegistry:[PBExtensionRegistry emptyRegistry]];
}
- (CompleteRoundResultsProto_Builder*) mergeFromCodedInputStream:(PBCodedInputStream*) input extensionRegistry:(PBExtensionRegistry*) extensionRegistry {
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
        [self setId:[input readString]];
        break;
      }
      case 16: {
        [self setScore:[input readSInt32]];
        break;
      }
      case 24: {
        [self setRoundNumber:[input readInt32]];
        break;
      }
      case 34: {
        QuestionAnsweredProto_Builder* subBuilder = [QuestionAnsweredProto builder];
        [input readMessage:subBuilder extensionRegistry:extensionRegistry];
        [self addAnswers:[subBuilder buildPartial]];
        break;
      }
      case 40: {
        [self setStartTime:[input readInt64]];
        break;
      }
      case 48: {
        [self setEndTime:[input readInt64]];
        break;
      }
    }
  }
}
- (BOOL) hasId {
  return result.hasId;
}
- (NSString*) id {
  return result.id;
}
- (CompleteRoundResultsProto_Builder*) setId:(NSString*) value {
  result.hasId = YES;
  result.id = value;
  return self;
}
- (CompleteRoundResultsProto_Builder*) clearId {
  result.hasId = NO;
  result.id = @"";
  return self;
}
- (BOOL) hasScore {
  return result.hasScore;
}
- (int32_t) score {
  return result.score;
}
- (CompleteRoundResultsProto_Builder*) setScore:(int32_t) value {
  result.hasScore = YES;
  result.score = value;
  return self;
}
- (CompleteRoundResultsProto_Builder*) clearScore {
  result.hasScore = NO;
  result.score = 0;
  return self;
}
- (BOOL) hasRoundNumber {
  return result.hasRoundNumber;
}
- (int32_t) roundNumber {
  return result.roundNumber;
}
- (CompleteRoundResultsProto_Builder*) setRoundNumber:(int32_t) value {
  result.hasRoundNumber = YES;
  result.roundNumber = value;
  return self;
}
- (CompleteRoundResultsProto_Builder*) clearRoundNumber {
  result.hasRoundNumber = NO;
  result.roundNumber = 0;
  return self;
}
- (NSArray*) answersList {
  if (result.mutableAnswersList == nil) { return [NSArray array]; }
  return result.mutableAnswersList;
}
- (QuestionAnsweredProto*) answersAtIndex:(int32_t) index {
  return [result answersAtIndex:index];
}
- (CompleteRoundResultsProto_Builder*) replaceAnswersAtIndex:(int32_t) index with:(QuestionAnsweredProto*) value {
  [result.mutableAnswersList replaceObjectAtIndex:index withObject:value];
  return self;
}
- (CompleteRoundResultsProto_Builder*) addAllAnswers:(NSArray*) values {
  if (result.mutableAnswersList == nil) {
    result.mutableAnswersList = [NSMutableArray array];
  }
  [result.mutableAnswersList addObjectsFromArray:values];
  return self;
}
- (CompleteRoundResultsProto_Builder*) clearAnswersList {
  result.mutableAnswersList = nil;
  return self;
}
- (CompleteRoundResultsProto_Builder*) addAnswers:(QuestionAnsweredProto*) value {
  if (result.mutableAnswersList == nil) {
    result.mutableAnswersList = [NSMutableArray array];
  }
  [result.mutableAnswersList addObject:value];
  return self;
}
- (BOOL) hasStartTime {
  return result.hasStartTime;
}
- (int64_t) startTime {
  return result.startTime;
}
- (CompleteRoundResultsProto_Builder*) setStartTime:(int64_t) value {
  result.hasStartTime = YES;
  result.startTime = value;
  return self;
}
- (CompleteRoundResultsProto_Builder*) clearStartTime {
  result.hasStartTime = NO;
  result.startTime = 0L;
  return self;
}
- (BOOL) hasEndTime {
  return result.hasEndTime;
}
- (int64_t) endTime {
  return result.endTime;
}
- (CompleteRoundResultsProto_Builder*) setEndTime:(int64_t) value {
  result.hasEndTime = YES;
  result.endTime = value;
  return self;
}
- (CompleteRoundResultsProto_Builder*) clearEndTime {
  result.hasEndTime = NO;
  result.endTime = 0L;
  return self;
}
@end

@interface UnfinishedRoundProto ()
@property (retain) NSString* id;
@property (retain) NSMutableArray* mutableQuestionsList;
@property int32_t roundNumber;
@property int32_t secondsRemaning;
@property int32_t currentQuestionNumber;
@property int32_t currentScore;
@end

@implementation UnfinishedRoundProto

- (BOOL) hasId {
  return !!hasId_;
}
- (void) setHasId:(BOOL) value {
  hasId_ = !!value;
}
@synthesize id;
@synthesize mutableQuestionsList;
- (BOOL) hasRoundNumber {
  return !!hasRoundNumber_;
}
- (void) setHasRoundNumber:(BOOL) value {
  hasRoundNumber_ = !!value;
}
@synthesize roundNumber;
- (BOOL) hasSecondsRemaning {
  return !!hasSecondsRemaning_;
}
- (void) setHasSecondsRemaning:(BOOL) value {
  hasSecondsRemaning_ = !!value;
}
@synthesize secondsRemaning;
- (BOOL) hasCurrentQuestionNumber {
  return !!hasCurrentQuestionNumber_;
}
- (void) setHasCurrentQuestionNumber:(BOOL) value {
  hasCurrentQuestionNumber_ = !!value;
}
@synthesize currentQuestionNumber;
- (BOOL) hasCurrentScore {
  return !!hasCurrentScore_;
}
- (void) setHasCurrentScore:(BOOL) value {
  hasCurrentScore_ = !!value;
}
@synthesize currentScore;
- (void) dealloc {
  self.id = nil;
  self.mutableQuestionsList = nil;
  [super dealloc];
}
- (id) init {
  if ((self = [super init])) {
    self.id = @"";
    self.roundNumber = 0;
    self.secondsRemaning = 0;
    self.currentQuestionNumber = 0;
    self.currentScore = 0;
  }
  return self;
}
static UnfinishedRoundProto* defaultUnfinishedRoundProtoInstance = nil;
+ (void) initialize {
  if (self == [UnfinishedRoundProto class]) {
    defaultUnfinishedRoundProtoInstance = [[UnfinishedRoundProto alloc] init];
  }
}
+ (UnfinishedRoundProto*) defaultInstance {
  return defaultUnfinishedRoundProtoInstance;
}
- (UnfinishedRoundProto*) defaultInstance {
  return defaultUnfinishedRoundProtoInstance;
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
  if (self.hasId) {
    [output writeString:1 value:self.id];
  }
  for (QuestionProto* element in self.questionsList) {
    [output writeMessage:2 value:element];
  }
  if (self.hasRoundNumber) {
    [output writeInt32:3 value:self.roundNumber];
  }
  if (self.hasSecondsRemaning) {
    [output writeInt32:4 value:self.secondsRemaning];
  }
  if (self.hasCurrentQuestionNumber) {
    [output writeInt32:5 value:self.currentQuestionNumber];
  }
  if (self.hasCurrentScore) {
    [output writeInt32:6 value:self.currentScore];
  }
  [self.unknownFields writeToCodedOutputStream:output];
}
- (int32_t) serializedSize {
  int32_t size = memoizedSerializedSize;
  if (size != -1) {
    return size;
  }

  size = 0;
  if (self.hasId) {
    size += computeStringSize(1, self.id);
  }
  for (QuestionProto* element in self.questionsList) {
    size += computeMessageSize(2, element);
  }
  if (self.hasRoundNumber) {
    size += computeInt32Size(3, self.roundNumber);
  }
  if (self.hasSecondsRemaning) {
    size += computeInt32Size(4, self.secondsRemaning);
  }
  if (self.hasCurrentQuestionNumber) {
    size += computeInt32Size(5, self.currentQuestionNumber);
  }
  if (self.hasCurrentScore) {
    size += computeInt32Size(6, self.currentScore);
  }
  size += self.unknownFields.serializedSize;
  memoizedSerializedSize = size;
  return size;
}
+ (UnfinishedRoundProto*) parseFromData:(NSData*) data {
  return (UnfinishedRoundProto*)[[[UnfinishedRoundProto builder] mergeFromData:data] build];
}
+ (UnfinishedRoundProto*) parseFromData:(NSData*) data extensionRegistry:(PBExtensionRegistry*) extensionRegistry {
  return (UnfinishedRoundProto*)[[[UnfinishedRoundProto builder] mergeFromData:data extensionRegistry:extensionRegistry] build];
}
+ (UnfinishedRoundProto*) parseFromInputStream:(NSInputStream*) input {
  return (UnfinishedRoundProto*)[[[UnfinishedRoundProto builder] mergeFromInputStream:input] build];
}
+ (UnfinishedRoundProto*) parseFromInputStream:(NSInputStream*) input extensionRegistry:(PBExtensionRegistry*) extensionRegistry {
  return (UnfinishedRoundProto*)[[[UnfinishedRoundProto builder] mergeFromInputStream:input extensionRegistry:extensionRegistry] build];
}
+ (UnfinishedRoundProto*) parseFromCodedInputStream:(PBCodedInputStream*) input {
  return (UnfinishedRoundProto*)[[[UnfinishedRoundProto builder] mergeFromCodedInputStream:input] build];
}
+ (UnfinishedRoundProto*) parseFromCodedInputStream:(PBCodedInputStream*) input extensionRegistry:(PBExtensionRegistry*) extensionRegistry {
  return (UnfinishedRoundProto*)[[[UnfinishedRoundProto builder] mergeFromCodedInputStream:input extensionRegistry:extensionRegistry] build];
}
+ (UnfinishedRoundProto_Builder*) builder {
  return [[[UnfinishedRoundProto_Builder alloc] init] autorelease];
}
+ (UnfinishedRoundProto_Builder*) builderWithPrototype:(UnfinishedRoundProto*) prototype {
  return [[UnfinishedRoundProto builder] mergeFrom:prototype];
}
- (UnfinishedRoundProto_Builder*) builder {
  return [UnfinishedRoundProto builder];
}
@end

@interface UnfinishedRoundProto_Builder()
@property (retain) UnfinishedRoundProto* result;
@end

@implementation UnfinishedRoundProto_Builder
@synthesize result;
- (void) dealloc {
  self.result = nil;
  [super dealloc];
}
- (id) init {
  if ((self = [super init])) {
    self.result = [[[UnfinishedRoundProto alloc] init] autorelease];
  }
  return self;
}
- (PBGeneratedMessage*) internalGetResult {
  return result;
}
- (UnfinishedRoundProto_Builder*) clear {
  self.result = [[[UnfinishedRoundProto alloc] init] autorelease];
  return self;
}
- (UnfinishedRoundProto_Builder*) clone {
  return [UnfinishedRoundProto builderWithPrototype:result];
}
- (UnfinishedRoundProto*) defaultInstance {
  return [UnfinishedRoundProto defaultInstance];
}
- (UnfinishedRoundProto*) build {
  [self checkInitialized];
  return [self buildPartial];
}
- (UnfinishedRoundProto*) buildPartial {
  UnfinishedRoundProto* returnMe = [[result retain] autorelease];
  self.result = nil;
  return returnMe;
}
- (UnfinishedRoundProto_Builder*) mergeFrom:(UnfinishedRoundProto*) other {
  if (other == [UnfinishedRoundProto defaultInstance]) {
    return self;
  }
  if (other.hasId) {
    [self setId:other.id];
  }
  if (other.mutableQuestionsList.count > 0) {
    if (result.mutableQuestionsList == nil) {
      result.mutableQuestionsList = [NSMutableArray array];
    }
    [result.mutableQuestionsList addObjectsFromArray:other.mutableQuestionsList];
  }
  if (other.hasRoundNumber) {
    [self setRoundNumber:other.roundNumber];
  }
  if (other.hasSecondsRemaning) {
    [self setSecondsRemaning:other.secondsRemaning];
  }
  if (other.hasCurrentQuestionNumber) {
    [self setCurrentQuestionNumber:other.currentQuestionNumber];
  }
  if (other.hasCurrentScore) {
    [self setCurrentScore:other.currentScore];
  }
  [self mergeUnknownFields:other.unknownFields];
  return self;
}
- (UnfinishedRoundProto_Builder*) mergeFromCodedInputStream:(PBCodedInputStream*) input {
  return [self mergeFromCodedInputStream:input extensionRegistry:[PBExtensionRegistry emptyRegistry]];
}
- (UnfinishedRoundProto_Builder*) mergeFromCodedInputStream:(PBCodedInputStream*) input extensionRegistry:(PBExtensionRegistry*) extensionRegistry {
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
        [self setId:[input readString]];
        break;
      }
      case 18: {
        QuestionProto_Builder* subBuilder = [QuestionProto builder];
        [input readMessage:subBuilder extensionRegistry:extensionRegistry];
        [self addQuestions:[subBuilder buildPartial]];
        break;
      }
      case 24: {
        [self setRoundNumber:[input readInt32]];
        break;
      }
      case 32: {
        [self setSecondsRemaning:[input readInt32]];
        break;
      }
      case 40: {
        [self setCurrentQuestionNumber:[input readInt32]];
        break;
      }
      case 48: {
        [self setCurrentScore:[input readInt32]];
        break;
      }
    }
  }
}
- (BOOL) hasId {
  return result.hasId;
}
- (NSString*) id {
  return result.id;
}
- (UnfinishedRoundProto_Builder*) setId:(NSString*) value {
  result.hasId = YES;
  result.id = value;
  return self;
}
- (UnfinishedRoundProto_Builder*) clearId {
  result.hasId = NO;
  result.id = @"";
  return self;
}
- (NSArray*) questionsList {
  if (result.mutableQuestionsList == nil) { return [NSArray array]; }
  return result.mutableQuestionsList;
}
- (QuestionProto*) questionsAtIndex:(int32_t) index {
  return [result questionsAtIndex:index];
}
- (UnfinishedRoundProto_Builder*) replaceQuestionsAtIndex:(int32_t) index with:(QuestionProto*) value {
  [result.mutableQuestionsList replaceObjectAtIndex:index withObject:value];
  return self;
}
- (UnfinishedRoundProto_Builder*) addAllQuestions:(NSArray*) values {
  if (result.mutableQuestionsList == nil) {
    result.mutableQuestionsList = [NSMutableArray array];
  }
  [result.mutableQuestionsList addObjectsFromArray:values];
  return self;
}
- (UnfinishedRoundProto_Builder*) clearQuestionsList {
  result.mutableQuestionsList = nil;
  return self;
}
- (UnfinishedRoundProto_Builder*) addQuestions:(QuestionProto*) value {
  if (result.mutableQuestionsList == nil) {
    result.mutableQuestionsList = [NSMutableArray array];
  }
  [result.mutableQuestionsList addObject:value];
  return self;
}
- (BOOL) hasRoundNumber {
  return result.hasRoundNumber;
}
- (int32_t) roundNumber {
  return result.roundNumber;
}
- (UnfinishedRoundProto_Builder*) setRoundNumber:(int32_t) value {
  result.hasRoundNumber = YES;
  result.roundNumber = value;
  return self;
}
- (UnfinishedRoundProto_Builder*) clearRoundNumber {
  result.hasRoundNumber = NO;
  result.roundNumber = 0;
  return self;
}
- (BOOL) hasSecondsRemaning {
  return result.hasSecondsRemaning;
}
- (int32_t) secondsRemaning {
  return result.secondsRemaning;
}
- (UnfinishedRoundProto_Builder*) setSecondsRemaning:(int32_t) value {
  result.hasSecondsRemaning = YES;
  result.secondsRemaning = value;
  return self;
}
- (UnfinishedRoundProto_Builder*) clearSecondsRemaning {
  result.hasSecondsRemaning = NO;
  result.secondsRemaning = 0;
  return self;
}
- (BOOL) hasCurrentQuestionNumber {
  return result.hasCurrentQuestionNumber;
}
- (int32_t) currentQuestionNumber {
  return result.currentQuestionNumber;
}
- (UnfinishedRoundProto_Builder*) setCurrentQuestionNumber:(int32_t) value {
  result.hasCurrentQuestionNumber = YES;
  result.currentQuestionNumber = value;
  return self;
}
- (UnfinishedRoundProto_Builder*) clearCurrentQuestionNumber {
  result.hasCurrentQuestionNumber = NO;
  result.currentQuestionNumber = 0;
  return self;
}
- (BOOL) hasCurrentScore {
  return result.hasCurrentScore;
}
- (int32_t) currentScore {
  return result.currentScore;
}
- (UnfinishedRoundProto_Builder*) setCurrentScore:(int32_t) value {
  result.hasCurrentScore = YES;
  result.currentScore = value;
  return self;
}
- (UnfinishedRoundProto_Builder*) clearCurrentScore {
  result.hasCurrentScore = NO;
  result.currentScore = 0;
  return self;
}
@end

