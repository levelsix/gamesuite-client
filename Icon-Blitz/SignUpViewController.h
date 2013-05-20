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

@interface SignUpViewController : UIViewController <UIAlertViewDelegate, ServerCallbackDelegate, TestingDelegate> {
  BOOL signedIn;
  NSMutableDictionary *signupInfo;
  UserInfo *userinfo;

}

@property (nonatomic, assign) BOOL signingUp;
@property (nonatomic, strong) IBOutlet UIButton *noCredentialLoginButton;
@property (nonatomic, strong) IBOutlet UIButton *signInWithEmailButotn;

- (IBAction)signUpWithFacebook:(id)sender;
- (IBAction)signUpWithEmail:(id)sender;
- (IBAction)skipSignUp:(id)sender;
- (IBAction)login:(id)sender;
- (void)sendOverFacebookData;
- (void)goToHomeView:(LoginResponseProto *)response;
@end
