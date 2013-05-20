//
//  AMQPConnectionThread.h
//  Icon-Blitz
//
//  Created by Danny on 4/18/13.
//
//

#import <Foundation/Foundation.h>
#import "AMQPWrapper.h"
#import "AMQPConnectionThreadDelegate.h"

@interface AMQPConnectionThread : NSThread {
  AMQPExchange *_directExchange;
  AMQPExchange *_topicExchange;
  AMQPConnection *_connection;
  
  AMQPQueue *_udidQueue;
  AMQPQueue *_useridQueue;
  AMQPConsumer *_udidConsumer;
  AMQPConsumer *_useridConsumer;
}

@property (weak) NSObject<AMQPConnectionThreadDelegate> *delegate;

@property (copy) NSString *udid;

- (void) connect:(NSString *)udid;
- (void) sendData:(NSData *)data;
- (void) startUserIdQueue;
- (void) closeDownConnection;
- (void) end;

@end
