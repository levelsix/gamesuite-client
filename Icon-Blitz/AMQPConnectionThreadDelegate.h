//
//  AMQPConnectionThreadDelegate.h
//  Icon-Blitz
//
//  Created by Danny on 4/18/13.
//
//

#import <Foundation/Foundation.h>
#import "AMQPConsumerThreadDelegate.h"

@protocol AMQPConnectionThreadDelegate <AMQPConsumerThreadDelegate>

@optional
- (void)connectedToHost;
- (void)unableToConnectToHost:(NSString *)error;

@end
