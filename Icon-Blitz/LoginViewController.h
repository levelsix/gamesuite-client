//
//  LoginViewController.h
//  Icon-Blitz
//
//  Created by Danny on 4/23/13.
//
//

#import <UIKit/UIKit.h>
#import "ProtoHeaders.h"
#import "ServerCallbackDelegate.h"

@class TextFieldIndentation;

@interface LoginViewController : UIViewController <UITextFieldDelegate, UIAlertViewDelegate, ServerCallbackDelegate> {
  NSArray *listOfNonValidChar;
}
@property (nonatomic, strong) NSString *email;
@property (nonatomic, strong) NSString *password;
@property (nonatomic, weak) id<ServerCallbackDelegate> delegate;
@property (nonatomic, strong) IBOutlet TextFieldIndentation *emailTextField;
@property (nonatomic, strong) IBOutlet TextFieldIndentation *passwordTextField;

- (IBAction)back:(id)sender;
- (IBAction)login:(id)sender;

@end
