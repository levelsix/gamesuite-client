//
//  ServerCallbackDelegate.h
//  Icon-Blitz
//
//  Created by Danny on 4/23/13.
//
//

#import <Foundation/Foundation.h>

@protocol ServerCallbackDelegate <NSObject>

@optional
- (void)receivedProtoResponse:(PBGeneratedMessage *)message;
@end
