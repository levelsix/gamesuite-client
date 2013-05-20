//
//  AMQPConnectionThread.m
//  Icon-Blitz
//
//  Created by Danny on 4/18/13.
//
//

#import "AMQPConnectionThread.h"
#import "StaticProperties.h"

#import "amqp.h"
#import "amqp_framing.h"
#import "UserInfo.h"

#define UDID_KEY = [NSString stringWithFormat:@"client_udid_%@",_udid];
#define USER_ID_KEY [NSString stringWithFormat:@"client_userid_%d", gs.userId]

@implementation AMQPConnectionThread 

static int sessionId;

- (void)connect:(NSString *)udid {
  self.udid = udid;
  [self performSelector:@selector(initConnection) onThread:self withObject:nil waitUntilDone:NO];
}

- (void)initConnection {
  @try {
    sessionId = arc4random();
    [self endConnection];
    _connection = [[AMQPConnection alloc] init];
    [_connection connectToHost:HOST_NAME onPort:HOST_PORT];
    [_connection loginAsUser:MQ_USERNAME withPassword:MQ_PASSWORD onVHost:MQ_VHOST];
    AMQPChannel *channel = [_connection openChannel];
    
    _directExchange = [[AMQPExchange alloc] initDirectExchangeWithName:@"gamemessages" onChannel:channel isPassive:NO isDurable:YES];
    
    _topicExchange = [[AMQPExchange alloc] initTopicExchangeWithName:@"chatmessages" onChannel:channel isPassive:NO isDurable:YES];
    
    NSString *udidKey = @"whatever"; //udid
    _udidQueue = [[AMQPQueue alloc] initWithName:[udidKey stringByAppendingFormat:@"_%d_queue", sessionId] onChannel:channel isPassive:NO isExclusive:NO isDurable:YES getsAutoDeleted:YES];
    [_udidQueue bindToExchange:_directExchange withKey:udidKey];
    _udidConsumer  = [_udidQueue startConsumerWithAcknowledgements:NO isExclusive:NO receiveLocalMessages:YES];
    
    if ([_delegate respondsToSelector:@selector(connectedToHost)]) {
      [_delegate performSelectorOnMainThread:@selector(connectedToHost) withObject:nil waitUntilDone:NO];
    }
  } @catch (NSException *exception) {
    _connection = nil;
    if ([_delegate respondsToSelector:@selector(unableToConnectToHost:)]) {
      [_delegate performSelectorOnMainThread:@selector(unableToConnectToHost:) withObject:exception.reason waitUntilDone:NO];
    }
  }
}

- (void)startUserIdQueue {
  [self performSelector:@selector(initUserIdMessageQueue) onThread:self withObject:nil waitUntilDone:YES];
}

- (void)initUserIdMessageQueue {
  NSString *useridKey = @"whatever"; // userid
  _useridQueue = [[AMQPQueue alloc] initWithName:[useridKey stringByAppendingFormat:@"_%d_queue", sessionId]  onChannel:_udidConsumer.channel  isPassive:NO isExclusive:NO isDurable:YES getsAutoDeleted:YES];
  [_useridQueue bindToExchange:_directExchange withKey:useridKey];
  _useridConsumer = [_useridQueue startConsumerWithAcknowledgements:NO isExclusive:NO receiveLocalMessages:YES];
  
}

- (void)endConnection {
  @try {
  }
  @catch (NSException *exception) {
    NSLog(@"%@",exception);
  }
  @finally {
    _useridConsumer = nil;
    _udidConsumer = nil;
    _udidQueue = nil;
    _useridQueue = nil;
    _directExchange = nil;
    _topicExchange = nil;
    _connection = nil;
    
  }
}

- (void)closeDownConnection {
  [self performSelector:@selector(endConnection) onThread:self withObject:nil waitUntilDone:NO];
}

- (void)sendData:(NSData *)data {
  [self performSelector:@selector(postDataToExchange:) onThread:self withObject:data waitUntilDone:NO];
}

- (void)postDataToExchange:(NSData *)data {
  [_directExchange publishMessageWithData:data usingRoutingKey:@"messageFromPlayers"];
}

- (void)end {
  [self closeDownConnection];
  [self cancel];
}

- (void)main {
	
	while(![self isCancelled])
	{
		@autoreleasepool {
		
    [[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:0.1]];
    
    if (_connection) {
      if (amqp_data_available(_connection.internalConnection) || amqp_data_in_buffer(_connection.internalConnection)) {
        AMQPMessage *message = [_udidConsumer pop];
        if(message)
        {
          [_delegate performSelectorOnMainThread:@selector(amqpConsumerThreadReceivedNewMessage:) withObject:message waitUntilDone:NO];
        }
      }
    }
		
		}
	}
  
  
  [[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:10]];
  
}

@end
