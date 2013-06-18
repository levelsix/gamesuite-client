// Generated by the protocol buffer compiler.  DO NOT EDIT!

#import "ProtocolBuffers.h"

#import "TriviaRoundFormat.pb.h"
#import "TriviaQuestionFormat.pb.h"
#import "User.pb.h"

@class BasicAuthorizedDeviceProto;
@class BasicAuthorizedDeviceProto_Builder;
@class BasicRoundResultsProto;
@class BasicRoundResultsProto_Builder;
@class BasicUserProto;
@class BasicUserProto_Builder;
@class CompleteRoundResultsProto;
@class CompleteRoundResultsProto_Builder;
@class CompleteUserProto;
@class CompleteUserProto_Builder;
@class GameResultsProto;
@class GameResultsProto_Builder;
@class MultipleChoiceAnswerProto;
@class MultipleChoiceAnswerProto_Builder;
@class MultipleChoiceQuestionProto;
@class MultipleChoiceQuestionProto_Builder;
@class OngoingGameProto;
@class OngoingGameProto_Builder;
@class PictureQuestionProto;
@class PictureQuestionProto_Builder;
@class PlayerGameResultsProto;
@class PlayerGameResultsProto_Builder;
@class QuestionAnsweredProto;
@class QuestionAnsweredProto_Builder;
@class QuestionProto;
@class QuestionProto_Builder;
@class UnfinishedRoundProto;
@class UnfinishedRoundProto_Builder;
@class UserCurrencyProto;
@class UserCurrencyProto_Builder;

@interface TriviaGameFormatRoot : NSObject {
}
+ (PBExtensionRegistry*) extensionRegistry;
+ (void) registerAllExtensions:(PBMutableExtensionRegistry*) registry;
@end

@interface OngoingGameProto : PBGeneratedMessage {
@private
  BOOL hasGameSoFar_:1;
  BOOL hasMyNewRound_:1;
  GameResultsProto* gameSoFar;
  UnfinishedRoundProto* myNewRound;
}
- (BOOL) hasGameSoFar;
- (BOOL) hasMyNewRound;
@property (readonly, retain) GameResultsProto* gameSoFar;
@property (readonly, retain) UnfinishedRoundProto* myNewRound;

+ (OngoingGameProto*) defaultInstance;
- (OngoingGameProto*) defaultInstance;

- (BOOL) isInitialized;
- (void) writeToCodedOutputStream:(PBCodedOutputStream*) output;
- (OngoingGameProto_Builder*) builder;
+ (OngoingGameProto_Builder*) builder;
+ (OngoingGameProto_Builder*) builderWithPrototype:(OngoingGameProto*) prototype;

+ (OngoingGameProto*) parseFromData:(NSData*) data;
+ (OngoingGameProto*) parseFromData:(NSData*) data extensionRegistry:(PBExtensionRegistry*) extensionRegistry;
+ (OngoingGameProto*) parseFromInputStream:(NSInputStream*) input;
+ (OngoingGameProto*) parseFromInputStream:(NSInputStream*) input extensionRegistry:(PBExtensionRegistry*) extensionRegistry;
+ (OngoingGameProto*) parseFromCodedInputStream:(PBCodedInputStream*) input;
+ (OngoingGameProto*) parseFromCodedInputStream:(PBCodedInputStream*) input extensionRegistry:(PBExtensionRegistry*) extensionRegistry;
@end

@interface OngoingGameProto_Builder : PBGeneratedMessage_Builder {
@private
  OngoingGameProto* result;
}

- (OngoingGameProto*) defaultInstance;

- (OngoingGameProto_Builder*) clear;
- (OngoingGameProto_Builder*) clone;

- (OngoingGameProto*) build;
- (OngoingGameProto*) buildPartial;

- (OngoingGameProto_Builder*) mergeFrom:(OngoingGameProto*) other;
- (OngoingGameProto_Builder*) mergeFromCodedInputStream:(PBCodedInputStream*) input;
- (OngoingGameProto_Builder*) mergeFromCodedInputStream:(PBCodedInputStream*) input extensionRegistry:(PBExtensionRegistry*) extensionRegistry;

- (BOOL) hasGameSoFar;
- (GameResultsProto*) gameSoFar;
- (OngoingGameProto_Builder*) setGameSoFar:(GameResultsProto*) value;
- (OngoingGameProto_Builder*) setGameSoFarBuilder:(GameResultsProto_Builder*) builderForValue;
- (OngoingGameProto_Builder*) mergeGameSoFar:(GameResultsProto*) value;
- (OngoingGameProto_Builder*) clearGameSoFar;

- (BOOL) hasMyNewRound;
- (UnfinishedRoundProto*) myNewRound;
- (OngoingGameProto_Builder*) setMyNewRound:(UnfinishedRoundProto*) value;
- (OngoingGameProto_Builder*) setMyNewRoundBuilder:(UnfinishedRoundProto_Builder*) builderForValue;
- (OngoingGameProto_Builder*) mergeMyNewRound:(UnfinishedRoundProto*) value;
- (OngoingGameProto_Builder*) clearMyNewRound;
@end

@interface GameResultsProto : PBGeneratedMessage {
@private
  BOOL hasGameId_:1;
  BOOL hasFirstPlayer_:1;
  BOOL hasSecondPlayer_:1;
  NSString* gameId;
  PlayerGameResultsProto* firstPlayer;
  PlayerGameResultsProto* secondPlayer;
}
- (BOOL) hasGameId;
- (BOOL) hasFirstPlayer;
- (BOOL) hasSecondPlayer;
@property (readonly, retain) NSString* gameId;
@property (readonly, retain) PlayerGameResultsProto* firstPlayer;
@property (readonly, retain) PlayerGameResultsProto* secondPlayer;

+ (GameResultsProto*) defaultInstance;
- (GameResultsProto*) defaultInstance;

- (BOOL) isInitialized;
- (void) writeToCodedOutputStream:(PBCodedOutputStream*) output;
- (GameResultsProto_Builder*) builder;
+ (GameResultsProto_Builder*) builder;
+ (GameResultsProto_Builder*) builderWithPrototype:(GameResultsProto*) prototype;

+ (GameResultsProto*) parseFromData:(NSData*) data;
+ (GameResultsProto*) parseFromData:(NSData*) data extensionRegistry:(PBExtensionRegistry*) extensionRegistry;
+ (GameResultsProto*) parseFromInputStream:(NSInputStream*) input;
+ (GameResultsProto*) parseFromInputStream:(NSInputStream*) input extensionRegistry:(PBExtensionRegistry*) extensionRegistry;
+ (GameResultsProto*) parseFromCodedInputStream:(PBCodedInputStream*) input;
+ (GameResultsProto*) parseFromCodedInputStream:(PBCodedInputStream*) input extensionRegistry:(PBExtensionRegistry*) extensionRegistry;
@end

@interface GameResultsProto_Builder : PBGeneratedMessage_Builder {
@private
  GameResultsProto* result;
}

- (GameResultsProto*) defaultInstance;

- (GameResultsProto_Builder*) clear;
- (GameResultsProto_Builder*) clone;

- (GameResultsProto*) build;
- (GameResultsProto*) buildPartial;

- (GameResultsProto_Builder*) mergeFrom:(GameResultsProto*) other;
- (GameResultsProto_Builder*) mergeFromCodedInputStream:(PBCodedInputStream*) input;
- (GameResultsProto_Builder*) mergeFromCodedInputStream:(PBCodedInputStream*) input extensionRegistry:(PBExtensionRegistry*) extensionRegistry;

- (BOOL) hasGameId;
- (NSString*) gameId;
- (GameResultsProto_Builder*) setGameId:(NSString*) value;
- (GameResultsProto_Builder*) clearGameId;

- (BOOL) hasFirstPlayer;
- (PlayerGameResultsProto*) firstPlayer;
- (GameResultsProto_Builder*) setFirstPlayer:(PlayerGameResultsProto*) value;
- (GameResultsProto_Builder*) setFirstPlayerBuilder:(PlayerGameResultsProto_Builder*) builderForValue;
- (GameResultsProto_Builder*) mergeFirstPlayer:(PlayerGameResultsProto*) value;
- (GameResultsProto_Builder*) clearFirstPlayer;

- (BOOL) hasSecondPlayer;
- (PlayerGameResultsProto*) secondPlayer;
- (GameResultsProto_Builder*) setSecondPlayer:(PlayerGameResultsProto*) value;
- (GameResultsProto_Builder*) setSecondPlayerBuilder:(PlayerGameResultsProto_Builder*) builderForValue;
- (GameResultsProto_Builder*) mergeSecondPlayer:(PlayerGameResultsProto*) value;
- (GameResultsProto_Builder*) clearSecondPlayer;
@end

@interface PlayerGameResultsProto : PBGeneratedMessage {
@private
  BOOL hasBup_:1;
  BasicUserProto* bup;
  NSMutableArray* mutablePreviousRoundsStatsList;
}
- (BOOL) hasBup;
@property (readonly, retain) BasicUserProto* bup;
- (NSArray*) previousRoundsStatsList;
- (BasicRoundResultsProto*) previousRoundsStatsAtIndex:(int32_t) index;

+ (PlayerGameResultsProto*) defaultInstance;
- (PlayerGameResultsProto*) defaultInstance;

- (BOOL) isInitialized;
- (void) writeToCodedOutputStream:(PBCodedOutputStream*) output;
- (PlayerGameResultsProto_Builder*) builder;
+ (PlayerGameResultsProto_Builder*) builder;
+ (PlayerGameResultsProto_Builder*) builderWithPrototype:(PlayerGameResultsProto*) prototype;

+ (PlayerGameResultsProto*) parseFromData:(NSData*) data;
+ (PlayerGameResultsProto*) parseFromData:(NSData*) data extensionRegistry:(PBExtensionRegistry*) extensionRegistry;
+ (PlayerGameResultsProto*) parseFromInputStream:(NSInputStream*) input;
+ (PlayerGameResultsProto*) parseFromInputStream:(NSInputStream*) input extensionRegistry:(PBExtensionRegistry*) extensionRegistry;
+ (PlayerGameResultsProto*) parseFromCodedInputStream:(PBCodedInputStream*) input;
+ (PlayerGameResultsProto*) parseFromCodedInputStream:(PBCodedInputStream*) input extensionRegistry:(PBExtensionRegistry*) extensionRegistry;
@end

@interface PlayerGameResultsProto_Builder : PBGeneratedMessage_Builder {
@private
  PlayerGameResultsProto* result;
}

- (PlayerGameResultsProto*) defaultInstance;

- (PlayerGameResultsProto_Builder*) clear;
- (PlayerGameResultsProto_Builder*) clone;

- (PlayerGameResultsProto*) build;
- (PlayerGameResultsProto*) buildPartial;

- (PlayerGameResultsProto_Builder*) mergeFrom:(PlayerGameResultsProto*) other;
- (PlayerGameResultsProto_Builder*) mergeFromCodedInputStream:(PBCodedInputStream*) input;
- (PlayerGameResultsProto_Builder*) mergeFromCodedInputStream:(PBCodedInputStream*) input extensionRegistry:(PBExtensionRegistry*) extensionRegistry;

- (BOOL) hasBup;
- (BasicUserProto*) bup;
- (PlayerGameResultsProto_Builder*) setBup:(BasicUserProto*) value;
- (PlayerGameResultsProto_Builder*) setBupBuilder:(BasicUserProto_Builder*) builderForValue;
- (PlayerGameResultsProto_Builder*) mergeBup:(BasicUserProto*) value;
- (PlayerGameResultsProto_Builder*) clearBup;

- (NSArray*) previousRoundsStatsList;
- (BasicRoundResultsProto*) previousRoundsStatsAtIndex:(int32_t) index;
- (PlayerGameResultsProto_Builder*) replacePreviousRoundsStatsAtIndex:(int32_t) index with:(BasicRoundResultsProto*) value;
- (PlayerGameResultsProto_Builder*) addPreviousRoundsStats:(BasicRoundResultsProto*) value;
- (PlayerGameResultsProto_Builder*) addAllPreviousRoundsStats:(NSArray*) values;
- (PlayerGameResultsProto_Builder*) clearPreviousRoundsStatsList;
@end

