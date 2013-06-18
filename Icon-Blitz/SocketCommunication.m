//
//  SocketCommunication.m
//  Icon-Blitz
//
//  Created by Danny on 4/16/13.
//
//

#import "SocketCommunication.h"
#import "SingletonMacro.h"
#import "UserInfo.h"
#import "SignUpViewController.h"
#import "CreateAccountViewController.h"
#import "FullEvent.h"
#import "ClientProperties.h"

#define HEADER_SIZE 12

@implementation SocketCommunication

- (Class) getClassForType:(int)type {
  Class responseClass;
  switch (type) {
    case CommonEventProtocolResponseSCreateAccountViaEmailEvent:
      responseClass = [CreateAccountResponseProto class];
      break;
      
    case CommonEventProtocolResponseSCreateAccountViaFacebookEvent:
      responseClass = [CreateAccountResponseProto class];
      break;
      
    case CommonEventProtocolResponseSCreateAccountViaNoCredentialsEvent:
      responseClass = [CreateAccountResponseProto class];
      break;
      
    case CommonEventProtocolResponseSLoginEvent:
      responseClass = [LoginResponseProto class];
      break;
      
    case CommonEventProtocolResponseSForceLogoutEvent:
      responseClass = [ForceLogoutResponseProto class];
      break;
      
    case PicturesEventProtocolRequestCStartRoundEvent:
      responseClass = [StartRoundResponseProto class];
      break;
      
    case PicturesEventProtocolRequestCCompletedRoundEvent:
      responseClass = [CompletedRoundResponseProto class];
      break;
      
    case PicturesEventProtocolRequestCSpendRubiesEvent:
      responseClass = [SpendRubiesResponseProto class];
      break;
      
    case PicturesEventProtocolResponseSRefillTokensByWaitingEvent:
      responseClass = [RefillTokensByWaitingResponseProto class];
      break;
      
    case PicturesEventProtocolResponseSSearchForUserEvent:
      responseClass = [SearchForUserResponseProto class];
      break;
      
    case PicturesEventProtocolResponseSRetrieveNewQuestionsEvent:
      responseClass = [RetrieveNewQuestionsResponseProto class];
      break;
      
      
    default:
      responseClass = nil;
      break;
  }
  return responseClass;
}

SINGLETON_GCD(SocketCommunication);
static NSString *udid = nil;

- (id)init {
  if ((self = [super init])) {
    udid = UDID;
  }
  return self;
}

- (int)sendCreateAccountViaFacebookMessage:(NSDictionary *)facebookInfo{
  UserInfo *ui = [[UserInfo alloc] init];
  NSString *facebookId = [facebookInfo objectForKey:@"facebookId"];
  NSString *name = [facebookInfo objectForKey:@"name"];
  NSString *email = [facebookInfo objectForKey:@"email"];
  NSString *udid = [ui getUDID];
  NSString *deviceId = [ui getMacAddress];
  CreateAccountViaFacebookRequestProto *req = [[[[[[[CreateAccountViaFacebookRequestProto builder] setFacebookId:facebookId] setNameFriendsSee:name] setEmail:email]setUdid:udid]setDeviceId:deviceId] build];
  return [self sendData:req withMessageType:CommonEventProtocolRequestCCreateAccountViaFacebookEvent];
}

- (int)sendCreateAccountViaEmailMessage:(NSDictionary *)userInfo {
  NSString *name = [userInfo objectForKey:@"name"];
  NSString *email = [userInfo objectForKey:@"email"];
  NSString *password = [userInfo objectForKey:@"password"];
  NSString *udid = [userInfo objectForKey:@"udid"];
  NSString *deviceId = [userInfo objectForKey:@"deviceId"];
  
  CreateAccountViaEmailRequestProto *req = [[[[[[[CreateAccountViaEmailRequestProto builder] setNameStrangersSee:name] setEmail:email] setPassword:password] setUdid:udid] setDeviceId:deviceId] build];
  return [self sendData:req withMessageType:CommonEventProtocolRequestCCreateAccountViaEmailEvent];
}

- (int)sendCreateAccountViaNoCredentialsRequestProto: (NSDictionary *)deviceInfo {
  NSString *udid = [deviceInfo objectForKey:@"udid"];
  NSString *deviceId = [deviceInfo objectForKey:@"deviceId"];
  NSString *name = [deviceInfo objectForKey:@"name"];
  
  CreateAccountViaNoCredentialsRequestProto *req = [[[[[CreateAccountViaNoCredentialsRequestProto builder]setUdid:udid]setDeviceId:deviceId] setNameStrangersSee:name ] build];
  return [self sendData:req withMessageType:CommonEventProtocolRequestCCreateAccountViaNoCredentialsEvent];
}

- (int)sendLoginRequestEventViaToken:(BasicUserProto *)proto facebookFriends:(NSArray *)facebookFriendId {
  if (facebookFriendId) {
    LoginRequestProto *req = [[[[[[LoginRequestProto builder] setSender:proto] setLoginType:LoginRequestProto_LoginTypeLoginToken] setInitializeAccount:YES] addAllFacebookFriendIds:facebookFriendId]build];
    return [self sendData:req withMessageType:CommonEventProtocolRequestCLoginEvent];
  }
  else {
    LoginRequestProto *req = [[[[[LoginRequestProto builder] setSender:proto] setLoginType:LoginRequestProto_LoginTypeLoginToken] setInitializeAccount:YES] build];
    return [self sendData:req withMessageType:CommonEventProtocolRequestCLoginEvent];
  }
  return 0;
}

- (int)sendLoginRequestEventViaFacebook:(BasicUserProto *)proto facebookFriends:(NSArray *)facebookFriendId {
  LoginRequestProto *req = [[[[[[LoginRequestProto builder] setSender:proto] addAllFacebookFriendIds:facebookFriendId] setLoginType:LoginRequestProto_LoginTypeFacebook] setInitializeAccount:YES] build];
  return [self sendData:req withMessageType:CommonEventProtocolRequestCLoginEvent];
}

- (int)sendLoginRequestEventViaEmail:(BasicUserProto *)proto {
  LoginRequestProto *req = [[[[[LoginRequestProto builder] setSender:proto] setLoginType:LoginRequestProto_LoginTypeEmailPassword]setInitializeAccount:YES] build];
  return [self sendData:req withMessageType:CommonEventProtocolRequestCLoginEvent];
}

- (int)sendLoginRequestEventViaNoCredentials:(BasicUserProto *)proto {
  LoginRequestProto *req = [[[[LoginRequestProto builder] setSender:proto] setLoginType:LoginRequestProto_LoginTypeNoCredentials] build];
  return [self sendData:req withMessageType:CommonEventProtocolRequestCLoginEvent];
}

- (int)sendRetrieveNewQuestions:(BasicUserProto *)sender numQuestionsWanted:(int32_t)numberWanted {
  RetrieveNewQuestionsRequestProto *req = [[[[RetrieveNewQuestionsRequestProto builder] setSender:sender] setNumQuestionsWanted:numberWanted] build];
  return [self sendData:req withMessageType:PicturesEventProtocolRequestCRetrieveNewQuestionsEvent];
}

- (int)sendCompleteRoundRequest:(BasicUserProto *)sender gameId:(NSString *)gameId results:(CompleteRoundResultsProto *)results {
  CompletedRoundRequestProto *req = [[[[[CompletedRoundRequestProto builder]setSender:sender] setGameId:gameId] setResults:results]build];
  return [self sendData:req withMessageType:PicturesEventProtocolRequestCCompletedRoundEvent];
} 

- (int)sendStartRoundRequest:(BasicUserProto *)sender isRandomPlayer:(BOOL)isRandomPlayer opponent:(NSString *)opponent gameId:(NSString *)gameId roundNumber:(int32_t)roundNumber isPlayerOne:(BOOL)isPlayerOne startTime:(int64_t)startTime questions:(NSArray *)questions{
  StartRoundRequestProto *req = [[[[[[[[[[StartRoundRequestProto builder] setSender:sender] setIsRandomPlayer:isRandomPlayer] setOpponent:opponent] setGameId:gameId] setRoundNumber:roundNumber] setIsPlayerOne:isPlayerOne] setStartTime:startTime] addAllQuestions:questions] build];
  return [self sendData:req withMessageType:PicturesEventProtocolRequestCStartRoundEvent];
}

- (int)sendRefillTokenByWaiting:(BasicUserProto *)sender currentTime:(int64_t)curTime {
  RefillTokensByWaitingRequestProto *req = [[[[RefillTokensByWaitingRequestProto builder] setSender:sender] setCurTime:curTime] build];
  return [self sendData:req withMessageType:PicturesEventProtocolRequestCRefillTokensByWaitingEvent];
}

- (int)sendSearchForUser:(BasicUserProto *)sender nameOfPerson:(NSString *)nameOfPerson {
  SearchForUserRequestProto *req = [[[[SearchForUserRequestProto builder] setSender:sender] setNameOfPerson:nameOfPerson] build];
  return [self sendData:req withMessageType:PicturesEventProtocolRequestCSearchForUserEvent];
}

- (int)sendSpendRubies:(BasicUserProto *)sender amountSpent:(int32_t)amountSpent {
  SpendRubiesRequestProto *req = [[[[SpendRubiesRequestProto builder] setSender:sender] setAmountSpent:amountSpent] build];
  return [self sendData:req withMessageType:PicturesEventProtocolRequestCSpendRubiesEvent];
}

- (void)amqpConsumerThreadReceivedNewMessage:(AMQPMessage *)theMessage {
  NSData *data = theMessage.body;
  uint8_t *header = (uint8_t *)[data bytes];
  //get the next 4 bytes for the payload size
  int nextMsgType = *(int *)(header);
  int tag = *(int *)(header+4);
  NSData *payload = [data subdataWithRange:NSMakeRange(HEADER_SIZE, data.length-HEADER_SIZE)];
  
  [self messageReceived:payload withEvent:nextMsgType tag:tag];
}


-(void) messageReceived:(NSData *)data withEvent:(int)eventType tag:(int)tag {
  Class typeClass = [self getClassForType:eventType];
  if ([self.delegate respondsToSelector:@selector(receivedProtoResponse:)]) {
    FullEvent *fe = [FullEvent createWithEvent:(PBGeneratedMessage *)[typeClass parseFromData:data] tag:tag];
    [self.delegate receivedProtoResponse:fe.event];
  }
}
- (void)initNetworkCommunication {
  _connectionThread = [[AMQPConnectionThread alloc] init];
  [_connectionThread start];
  _connectionThread.delegate = self;
  [_connectionThread connect:udid];
    
  _currentTagNum = 1;
  _shouldReconnect = YES;
  _numDisconnects = 0;  
}

- (void)connectedToHost {

}


- (int)sendData:(PBGeneratedMessage *)msg withMessageType:(int)type {
  if (_sender.userId == 0) {
    
  }
  
  NSMutableData *messageWithHeader = [NSMutableData data];
  NSData *data = [msg data];
  
  uint8_t header[HEADER_SIZE];
  
  header[3] = type & 0xFF;
  header[2] = (type & 0xFF00) >> 8;
  header[1] = (type & 0xFF0000) >> 16;
  header[0] = (type & 0xFF000000) >> 24;
  
  header[7] = _currentTagNum & 0xFF;
  header[6] = (_currentTagNum & 0xFF00) >> 8;
  header[5] = (_currentTagNum & 0xFF0000) >> 16;
  header[4] = (_currentTagNum & 0xFF000000) >> 24;
  
  int size = [data length];
  header[11] = size & 0xFF;
  header[10] = (size & 0xFF00) >> 8;
  header[9] = (size & 0xFF0000) >> 16;
  header[8] = (size & 0xFF000000) >> 24;
  
  [messageWithHeader appendBytes:header length:sizeof(header)];
  [messageWithHeader appendData:data];
  
  [_connectionThread sendData:messageWithHeader];
  int tag = _currentTagNum;
  _currentTagNum++;
  return tag;
}


- (void)closeDownConnection {
  [_connectionThread end];
  _connectionThread = nil;
  _sender = nil;
}

- (void)dealloc {
  udid = nil;
  [self closeDownConnection];
}

@end
