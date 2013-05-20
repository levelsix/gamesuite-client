//
//  CreateAccountViewController.h
//  Icon-Blitz
//
//  Created by Danny on 4/24/13.
//
//

#import <UIKit/UIKit.h>
#import "ServerCallbackDelegate.h"
#import "ProtoHeaders.h"

@class TextFieldIndentation;

@interface CreateAccountViewController : UIViewController <UITextFieldDelegate, UIAlertViewDelegate, ServerCallbackDelegate> {
  NSArray *listOfNonValidChar;
}

@property (nonatomic, strong) IBOutlet TextFieldIndentation *usernameTextField;
@property (nonatomic, strong) IBOutlet TextFieldIndentation *passwordTextField;
@property (nonatomic, strong) IBOutlet TextFieldIndentation *emailTextField;
@property (nonatomic, strong) IBOutlet TextFieldIndentation *confirmPasswordTextField;
@property (nonatomic, strong) NSString *username;
@property (nonatomic, strong) NSString *password;
@property (nonatomic, strong) NSString *email;

- (IBAction)back:(id)sender;
- (IBAction)createAccount:(id)sender;
- (void)goToHomeView:(LoginResponseProto *)proto;

@end
