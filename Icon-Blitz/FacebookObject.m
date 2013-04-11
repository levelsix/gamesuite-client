//
//  FacebookObject.m
//  Icon-Blitz
//
//  Created by Danny on 4/5/13.
//
//

#import "FacebookObject.h"
#import "AppDelegate.h"

@implementation FacebookObject

- (void)facebookLogin {
  AppDelegate *ad = [[UIApplication sharedApplication] delegate];
  if (FBSession.activeSession.isOpen) {
    //[ad closeSession];
  }
  else {
    [ad openSessionWithAllowLoginUI:YES];
  }
}

- (void)getFriends {
  __block NSMutableArray *facebookData = [NSMutableArray array];
  FBRequest* friendsRequest = [FBRequest requestForMyFriends];
  [friendsRequest startWithCompletionHandler: ^(FBRequestConnection *connection,
                                                NSDictionary* result,
                                                NSError *error) {
    facebookData = [result objectForKey:@"data"];
    
  }];
}

- (void)getFriendscompletion:(void (^) (void))completed {
  __block NSMutableArray *facebookData = [NSMutableArray array];
  dispatch_async(_asyncQueue, ^{
    [self facebookLogin];
    FBRequest* friendsRequest = [FBRequest requestForMyFriends];
    [friendsRequest startWithCompletionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
      facebookData = [result objectForKey:@"data"];
    }];
    dispatch_async(dispatch_get_main_queue(), ^(void) {
    
    });
  });
}

- (void)publish {
  
}

@end
