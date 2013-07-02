//
//  SignUpViewController.h
//  Icon-Blitz
//
//  Created by Danny on 4/15/13.
//
//

#import <UIKit/UIKit.h>
#import "ProtoHeaders.h"
#import "ServerCallbackDelegate.h"
#import "AppDelegate.h"

@class UserInfo;

typedef enum {
  kSignUp = 1,
  kLoginType
}ProtoTypeRequestType;

typedef enum {
  kNoCredential = 5,
  kFacebook
}SignUpType;

@interface SignUpViewController : UIViewController <UIAlertViewDelegate, ServerCallbackDelegate, FinishFacebookLogin> {
  BOOL signedIn;
  NSMutableDictionary *signupInfo;
  UserInfo *userinfo;
  ProtoTypeRequestType protoType;
  SignUpType signUpType;
}

@property (nonatomic, strong) IBOutlet UIButton *noCredentialLoginButton;
@property (nonatomic, strong) IBOutlet UIButton *signInWithEmailButotn;
@property (nonatomic, strong) IBOutlet UIActivityIndicatorView *spinner;
@property (nonatomic, strong) IBOutlet UILabel *loadingLabel;
@property (nonatomic, strong) NSMutableDictionary *facebookInfo;

- (IBAction)signUpWithFacebook:(id)sender;
- (IBAction)signUpWithEmail:(id)sender;
- (IBAction)skipSignUp:(id)sender;
- (IBAction)login:(id)sender;
- (void)sendOverFacebookData;

@end
