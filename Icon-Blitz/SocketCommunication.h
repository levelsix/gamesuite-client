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
- (void)rebuildSender;
- (int)sendCreateAccountViaFacebookMessage:(NSDictionary *)facebookInfo;
- (int)sendCreateAccountViaEmailMessage:(NSDictionary *)userInfo;
- (int)sendCreateAccountViaNoCredentialsRequestProto: (NSDictionary *)deviceInfo;
- (int)sendLoginRequestEventViaToken:(BasicUserProto *)proto;
- (int)sendLoginRequestEventViaFacebook:(BasicUserProto *)proto facebookFriends:(NSArray *)facebookFriendId;
- (int)sendLoginRequestEventViaEmail:(BasicUserProto *)proto;
- (int)sendLoginRequestEventViaNoCredentials:(BasicUserProto *)proto;

@end
