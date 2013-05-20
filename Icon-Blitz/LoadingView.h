//
//  LoadingViewController.h
//  Icon-Blitz
//
//  Created by Danny on 5/8/13.
//
//

#import <UIKit/UIKit.h>
#import "ProtoHeaders.h"
#import "ServerCallbackDelegate.h"

@class SignUpViewController;
@class CreateAccountViewController;

typedef enum {
  kFromSignUpViewController,
  kFromCreateUpViewController
}LoadingType;

@interface LoadingView : UIView <ServerCallbackDelegate, UIAlertViewDelegate> {
  UIActivityIndicatorView *spinner;
}

@property (nonatomic, strong) SignUpViewController *signup;
@property (nonatomic, strong) CreateAccountViewController *createAccount;
@property (nonatomic, assign) LoadingType type;

- (id)initWithFriends:(NSArray *)facebookFriends proto:(BasicUserProto *)proto signUp:(SignUpViewController *)vc loadingType:(LoadingType)type;
- (id)initWithProto:(BasicUserProto *)proto createAccount:(CreateAccountViewController *)vc loadingType:(LoadingType)type;

@end
