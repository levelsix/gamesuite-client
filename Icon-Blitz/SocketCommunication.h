//
//  SocketCommunication.h
//  Icon-Blitz
//
//  Created by Danny on 4/16/13.
//
//

#import <UIKit/UIKit.h>
#import "ProtoHeaders.h"
#import "AMQPWrapper.h"
#import "AMQPConnectionThread.h"
#import "AMQPConnectionThreadDelegate.h"
#import "ServerCallbackDelegate.h"

@interface SocketCommunication : NSObject <ServerCallbackDelegate, AMQPConnectionThreadDelegate>{
  BasicUserProto *_sender;
  int _currentTagNum;
  AMQPConnectionThread *_connectionThread;
  
  BOOL _shouldReconnect;
  int _numDisconnects;
  
}

@property (nonatomic, weak) id<ServerCallbackDelegate> delegate;

+ (SocketCommunication *)sharedSocketCommunication;
- (void)initNetworkCommunication;
- (int)sendCreateAccountViaFacebookMessage:(NSDictionary *)facebookInfo;
- (int)sendCreateAccountViaEmailMessage:(NSDictionary *)userInfo;
- (int)sendCreateAccountViaNoCredentialsRequestProto: (NSDictionary *)deviceInfo;
- (int)sendLoginRequestEventViaToken:(BasicUserProto *)proto facebookFriends:(NSArray *)facebookFriendId;
- (int)sendLoginRequestEventViaFacebook:(BasicUserProto *)proto facebookFriends:(NSArray *)facebookFriendId;
- (int)sendLoginRequestEventViaEmail:(BasicUserProto *)proto;
- (int)sendLoginRequestEventViaNoCredentials:(BasicUserProto *)proto;
- (int)sendRetrieveNewQuestions:(BasicUserProto *)sender numQuestionsWanted:(int32_t)numberWanted;
- (int)sendCompleteRoundRequest:(BasicUserProto *)sender opponent:(BasicUserProto *)opponent gameId:(NSString *)gameId results:(CompleteRoundResultsProto  *)results;
- (int)sendStartRoundRequest:(BasicUserProto *)sender isRandomPlayer:(BOOL)isRandomPlayer opponent:(NSString *)opponent gameId:(NSString *)gameId roundNumber:(int32_t)roundNumber isPlayerOne:(BOOL)isPlayerOne startTime:(int64_t)startTime questions:(NSArray *)questions;
- (int)sendRefillTokenByWaiting:(BasicUserProto *)sender currentTime:(int64_t)curTime;
- (int)sendSearchForUser:(BasicUserProto *)sender nameOfPerson:(NSString *)nameOfPerson;
- (int)sendSpendRubies:(BasicUserProto *)sender amountSpent:(int32_t)amountSpent;
- (int)sendLogoutRequest;

- (BasicUserProto *)buildSender;

@end
