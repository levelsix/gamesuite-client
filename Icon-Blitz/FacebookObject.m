//
//  FacebookObject.m
//  Icon-Blitz
//
//  Created by Danny on 4/5/13.
//
//

#import "FacebookObject.h"
#import "AppDelegate.h"
#import "PublishDataView.h"

@implementation FacebookObject


- (void)facebookLogin {
  AppDelegate *ad = [[UIApplication sharedApplication] delegate];
  if (FBSession.activeSession.isOpen) {
    
  }
  else {
    [ad openSessionWithAllowLoginUI:YES];
  }
}

- (BOOL)fbDidLogin {
  return FBSession.activeSession.isOpen;
}

- (void)signUpWithFacebook {
  [self facebookLogin];
}

- (UIView *)publishWithPostParams:(NSMutableDictionary *)postParams {
  [[NSBundle mainBundle] loadNibNamed:@"PublishData" owner:self options:nil];
  PublishDataView *view = [[PublishDataView alloc] initWithPostParams:postParams];
  return view;
}

- (void)publishWithoutUIAndParams:(NSMutableDictionary *)postParams {
  PublishDataView *view = [[PublishDataView alloc] initWithPostParams:postParams];
  [view publishWithoutUI];
}

@end
