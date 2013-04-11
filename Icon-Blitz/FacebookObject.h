//
//  FacebookObject.h
//  Icon-Blitz
//
//  Created by Danny on 4/5/13.
//
//

#import <Foundation/Foundation.h>
#import <FacebookSDK/FacebookSDK.h>

@interface FacebookObject : NSObject {
  dispatch_queue_t _asyncQueue;
}

- (void)facebookLogin;
- (void)publish;
- (void)getFriends;
- (void)getFriendscompletion:(void (^) (void))completed;
@end
