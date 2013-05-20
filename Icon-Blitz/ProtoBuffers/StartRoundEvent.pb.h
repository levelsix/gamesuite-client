// Generated by the protocol buffer compiler.  DO NOT EDIT!

#import "ProtocolBuffers.h"

#import "User.pb.h"
#import "TriviaQuestionFormat.pb.h"

@class BasicAuthorizedDeviceProto;
@class BasicAuthorizedDeviceProto_Builder;
@class BasicUserProto;
@class BasicUserProto_Builder;
@class CompleteUserProto;
@class CompleteUserProto_Builder;
@class MultipleChoiceAnswerProto;
@class MultipleChoiceAnswerProto_Builder;
@class MultipleChoiceQuestionProto;
@class MultipleChoiceQuestionProto_Builder;
@class PictureQuestionProto;
@class PictureQuestionProto_Builder;
@class QuestionProto;
@class QuestionProto_Builder;
@class StartRoundRequestProto;
@class StartRoundRequestProto_Builder;
@class StartRoundResponseProto;
@class StartRoundResponseProto_Builder;
typedef enum {
  StartRoundResponseProto_StartRoundResponseStatusSuccess = 1,
  StartRoundResponseProto_StartRoundResponseStatusFailClientTooApartFromServerTime = 2,
  StartRoundResponseProto_StartRoundResponseStatusFailOther = 3,
} StartRoundResponseProto_StartRoundResponseStatus;

BOOL StartRoundResponseProto_StartRoundResponseStatusIsValidValue(StartRoundResponseProto_StartRoundResponseStatus value);


@interface StartRoundEventRoot : NSObject {
}
+ (PBExtensionRegistry*) extensionRegistry;
+ (void) registerAllExtensions:(PBMutableExtensionRegistry*) registry;
@end

@interface StartRoundRequestProto : PBGeneratedMessage {
@private
  BOOL hasIsPlayerOne_:1;
  BOOL hasStartTime_:1;
  BOOL hasRoundNumber_:1;
  BOOL hasGameId_:1;
  BOOL hasSender_:1;
  BOOL isPlayerOne_:1;
  int64_t startTime;
  int32_t roundNumber;
  NSString* gameId;
  BasicUserProto* sender;
  NSMutableArray* mutableQuestionsList;
}
- (BOOL) hasSender;
- (BOOL) hasGameId;
- (BOOL) hasRoundNumber;
- (BOOL) hasIsPlayerOne;
- (BOOL) hasStartTime;
@property (readonly, retain) BasicUserProto* sender;
@property (readonly, retain) NSString* gameId;
@property (readonly) int32_t roundNumber;
- (BOOL) isPlayerOne;
@property (readonly) int64_t startTime;
- (NSArray*) questionsList;
- (QuestionProto*) questionsAtIndex:(int32_t) index;

+ (StartRoundRequestProto*) defaultInstance;
- (StartRoundRequestProto*) defaultInstance;

- (BOOL) isInitialized;
- (void) writeToCodedOutputStream:(PBCodedOutputStream*) output;
- (StartRoundRequestProto_Builder*) builder;
+ (StartRoundRequestProto_Builder*) builder;
+ (StartRoundRequestProto_Builder*) builderWithPrototype:(StartRoundRequestProto*) prototype;

+ (StartRoundRequestProto*) parseFromData:(NSData*) data;
+ (StartRoundRequestProto*) parseFromData:(NSData*) data extensionRegistry:(PBExtensionRegistry*) extensionRegistry;
+ (StartRoundRequestProto*) parseFromInputStream:(NSInputStream*) input;
+ (StartRoundRequestProto*) parseFromInputStream:(NSInputStream*) input extensionRegistry:(PBExtensionRegistry*) extensionRegistry;
+ (StartRoundRequestProto*) parseFromCodedInputStream:(PBCodedInputStream*) input;
+ (StartRoundRequestProto*) parseFromCodedInputStream:(PBCodedInputStream*) input extensionRegistry:(PBExtensionRegistry*) extensionRegistry;
@end

@interface StartRoundRequestProto_Builder : PBGeneratedMessage_Builder {
@private
  StartRoundRequestProto* result;
}

- (StartRoundRequestProto*) defaultInstance;

- (StartRoundRequestProto_Builder*) clear;
- (StartRoundRequestProto_Builder*) clone;

- (StartRoundRequestProto*) build;
- (StartRoundRequestProto*) buildPartial;

- (StartRoundRequestProto_Builder*) mergeFrom:(StartRoundRequestProto*) other;
- (StartRoundRequestProto_Builder*) mergeFromCodedInputStream:(PBCodedInputStream*) input;
- (StartRoundRequestProto_Builder*) mergeFromCodedInputStream:(PBCodedInputStream*) input extensionRegistry:(PBExtensionRegistry*) extensionRegistry;

- (BOOL) hasSender;
- (BasicUserProto*) sender;
- (StartRoundRequestProto_Builder*) setSender:(BasicUserProto*) value;
- (StartRoundRequestProto_Builder*) setSenderBuilder:(BasicUserProto_Builder*) builderForValue;
- (StartRoundRequestProto_Builder*) mergeSender:(BasicUserProto*) value;
- (StartRoundRequestProto_Builder*) clearSender;

- (BOOL) hasGameId;
- (NSString*) gameId;
- (StartRoundRequestProto_Builder*) setGameId:(NSString*) value;
- (StartRoundRequestProto_Builder*) clearGameId;

- (BOOL) hasRoundNumber;
- (int32_t) roundNumber;
- (StartRoundRequestProto_Builder*) setRoundNumber:(int32_t) value;
- (StartRoundRequestProto_Builder*) clearRoundNumber;

- (BOOL) hasIsPlayerOne;
- (BOOL) isPlayerOne;
- (StartRoundRequestProto_Builder*) setIsPlayerOne:(BOOL) value;
- (StartRoundRequestProto_Builder*) clearIsPlayerOne;

- (BOOL) hasStartTime;
- (int64_t) startTime;
- (StartRoundRequestProto_Builder*) setStartTime:(int64_t) value;
- (StartRoundRequestProto_Builder*) clearStartTime;

- (NSArray*) questionsList;
- (QuestionProto*) questionsAtIndex:(int32_t) index;
- (StartRoundRequestProto_Builder*) replaceQuestionsAtIndex:(int32_t) index with:(QuestionProto*) value;
- (StartRoundRequestProto_Builder*) addQuestions:(QuestionProto*) value;
- (StartRoundRequestProto_Builder*) addAllQuestions:(NSArray*) values;
- (StartRoundRequestProto_Builder*) clearQuestionsList;
@end

@interface StartRoundResponseProto : PBGeneratedMessage {
@private
  BOOL hasGameId_:1;
  BOOL hasRecipient_:1;
  NSString* gameId;
  BasicUserProto* recipient;
}
- (BOOL) hasRecipient;
- (BOOL) hasGameId;
@property (readonly, retain) BasicUserProto* recipient;
@property (readonly, retain) NSString* gameId;

+ (StartRoundResponseProto*) defaultInstance;
- (StartRoundResponseProto*) defaultInstance;

- (BOOL) isInitialized;
- (void) writeToCodedOutputStream:(PBCodedOutputStream*) output;
- (StartRoundResponseProto_Builder*) builder;
+ (StartRoundResponseProto_Builder*) builder;
+ (StartRoundResponseProto_Builder*) builderWithPrototype:(StartRoundResponseProto*) prototype;

+ (StartRoundResponseProto*) parseFromData:(NSData*) data;
+ (StartRoundResponseProto*) parseFromData:(NSData*) data extensionRegistry:(PBExtensionRegistry*) extensionRegistry;
+ (StartRoundResponseProto*) parseFromInputStream:(NSInputStream*) input;
+ (StartRoundResponseProto*) parseFromInputStream:(NSInputStream*) input extensionRegistry:(PBExtensionRegistry*) extensionRegistry;
+ (StartRoundResponseProto*) parseFromCodedInputStream:(PBCodedInputStream*) input;
+ (StartRoundResponseProto*) parseFromCodedInputStream:(PBCodedInputStream*) input extensionRegistry:(PBExtensionRegistry*) extensionRegistry;
@end

@interface StartRoundResponseProto_Builder : PBGeneratedMessage_Builder {
@private
  StartRoundResponseProto* result;
}

- (StartRoundResponseProto*) defaultInstance;

- (StartRoundResponseProto_Builder*) clear;
- (StartRoundResponseProto_Builder*) clone;

- (StartRoundResponseProto*) build;
- (StartRoundResponseProto*) buildPartial;

- (StartRoundResponseProto_Builder*) mergeFrom:(StartRoundResponseProto*) other;
- (StartRoundResponseProto_Builder*) mergeFromCodedInputStream:(PBCodedInputStream*) input;
- (StartRoundResponseProto_Builder*) mergeFromCodedInputStream:(PBCodedInputStream*) input extensionRegistry:(PBExtensionRegistry*) extensionRegistry;

- (BOOL) hasRecipient;
- (BasicUserProto*) recipient;
- (StartRoundResponseProto_Builder*) setRecipient:(BasicUserProto*) value;
- (StartRoundResponseProto_Builder*) setRecipientBuilder:(BasicUserProto_Builder*) builderForValue;
- (StartRoundResponseProto_Builder*) mergeRecipient:(BasicUserProto*) value;
- (StartRoundResponseProto_Builder*) clearRecipient;

- (BOOL) hasGameId;
- (NSString*) gameId;
- (StartRoundResponseProto_Builder*) setGameId:(NSString*) value;
- (StartRoundResponseProto_Builder*) clearGameId;
@end
