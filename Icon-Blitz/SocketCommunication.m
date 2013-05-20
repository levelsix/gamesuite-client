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

#define HEADER_SIZE 12

@implementation SocketCommunication

- (Class) getClassForType:(CommonEventProtocolResponse)type {
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
      
    default:
      responseClass = nil;
      break;
  }
  return responseClass;
}

SINGLETON_GCD(SocketCommunication);
static NSString *udid = nil;

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

- (int)sendLoginRequestEventViaToken:(BasicUserProto *)proto {
  LoginRequestProto *req = [[[[LoginRequestProto builder] setSender:proto] setLoginType:LoginRequestProto_LoginTypeLoginToken] build];
  return [self sendData:req withMessageType:LoginRequestProto_LoginTypeLoginToken];
}

- (int)sendLoginRequestEventViaFacebook:(BasicUserProto *)proto facebookFriends:(NSArray *)facebookFriendId {
  LoginRequestProto *req = [[[[[LoginRequestProto builder] setSender:proto] addAllFacebookFriendIds:facebookFriendId] setLoginType:LoginRequestProto_LoginTypeFacebook] build];
  return [self sendData:req withMessageType:LoginRequestProto_LoginTypeFacebook];
}

- (int)sendLoginRequestEventViaEmail:(BasicUserProto *)proto {
  LoginRequestProto *req = [[[[LoginRequestProto builder] setSender:proto] setLoginType:LoginRequestProto_LoginTypeEmailPassword] build];
  return [self sendData:req withMessageType:LoginRequestProto_LoginTypeEmailPassword];
}

- (int)sendLoginRequestEventViaNoCredentials:(BasicUserProto *)proto {
  LoginRequestProto *req = [[[[LoginRequestProto builder] setSender:proto] setLoginType:LoginRequestProto_LoginTypeNoCredentials] build];
  return [self sendData:req withMessageType:LoginRequestProto_LoginTypeNoCredentials];
}

- (void)amqpConsumerThreadReceivedNewMessage:(AMQPMessage *)theMessage {
  NSData *data = theMessage.body;
  uint8_t *header = (uint8_t *)[data bytes];
  //get the next 4 bytes for the payload size
  int nextMsgType = *(int *)(header);
  int tag = *(int *)(header+4);
  NSData *payload = [data subdataWithRange:NSMakeRange(HEADER_SIZE, data.length-HEADER_SIZE)];
  
  [self messageReceived:payload withType:nextMsgType tag:tag];
}

-(void) messageReceived:(NSData *)data withType:(CommonEventProtocolRequest)eventType tag:(int)tag {
  Class typeClass = [self getClassForType:eventType];

  if ([self.delegate respondsToSelector:@selector(receivedProtoResponse:)]) {
    FullEvent *fe = [FullEvent createWithEvent:(PBGeneratedMessage *)[typeClass parseFromData:data] tag:tag];
    [self.delegate receivedProtoResponse:fe.event];
  }
}

- (void)rebuildSender {
}

- (void)initNetworkCommunication {
  _connectionThread = [[AMQPConnectionThread alloc] init];
  [_connectionThread start];
  [_connectionThread connect:udid];
  
  [self rebuildSender];
  
  _currentTagNum = 1;
  _shouldReconnect = YES;
  _numDisconnects = 0;  
}

- (void)connectedToHost {
  //UserInfo *us = [UserInfo sharedUserInfo];
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
