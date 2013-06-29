//
//  LoginViewController.m
//  Icon-Blitz
//
//  Created by Danny on 4/23/13.
//
//

#import "LoginViewController.h"
#import "FacebookObject.h"
#import "UserInfo.h"
#import "HomeViewController.h"
#import "StaticProperties.h"
#import "SocketCommunication.h" 
#import "TextFieldIndentation.h"

typedef enum {
  kEmailField = 1,
  kPasswordField,
}TextFieldTypes;

#define Minimum_Pasword_Count 5
#define Maximum_Password_Count 15
#define Minimum_UserName_Count 4
#define Maximum_UserName_Count 15

@implementation LoginViewController

- (void)dealloc {
  [[NSNotificationCenter defaultCenter] removeObserver:self];
}


- (void)viewDidAppear:(BOOL)animated {
  [self.emailTextField becomeFirstResponder];
}

- (void)viewDidLoad
{
  [super viewDidLoad];
  self.emailTextField.horizontalPadding = 15;
  self.passwordTextField.horizontalPadding = 15;
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(emailChanged) name:UITextFieldTextDidChangeNotification object:self.emailTextField];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(passwordChanged) name:UITextFieldTextDidChangeNotification object:self.passwordTextField];
  listOfNonValidChar = [[NSArray alloc] initWithObjects:@"#",@"%",@"$",@"~",@"!",@"&",@"^",@"*",@"-",@"+",@"[",@"]",@"<",@">",@"?",@"/",@":",@";",@"=",@"(",@")",@"{",@"}",@"|",@"'", nil];
  
}

- (void)emailChanged {
  self.email = self.emailTextField.text;
}

- (void)passwordChanged {
  self.password = self.passwordTextField.text;
}

- (IBAction)back:(id)sender {
  [self.navigationController popToRootViewControllerAnimated:YES];
}

- (IBAction)login:(id)sender {
  if ([self checkIfEmailIsValid] && [self checkIfPasswordIsValid]) {
    SocketCommunication *sc = [SocketCommunication sharedSocketCommunication];
    sc.delegate = self;
    BasicUserProto *proto = [[[[BasicUserProto builder] setEmail:self.email] setPassword:self.password] build];
    [sc sendLoginRequestEventViaEmail:proto];
  }
}

-(BOOL) NSStringIsValidEmail:(NSString *)checkString
{
  BOOL stricterFilter = YES;
  NSString *stricterFilterString = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
  NSString *laxString = @".+@.+\\.[A-Za-z]{2}[A-Za-z]*";
  NSString *emailRegex = stricterFilter ? stricterFilterString : laxString;
  NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
  return [emailTest evaluateWithObject:checkString];
}

- (BOOL)checkIfEmailIsValid {
  BOOL valid = YES;
  if (![self NSStringIsValidEmail:self.email]) {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Incorrect username " message:@"Please check if your username is in correct format" delegate:self cancelButtonTitle:@"Okay" otherButtonTitles:nil, nil];
    [alert show];
    valid = NO;
  }
  
  return valid;
}

- (BOOL)checkIfPasswordIsValid {
  BOOL valid = YES;
  if ([self.password length] < Minimum_Pasword_Count || [self.password length] > Maximum_Password_Count) {
    valid = NO;
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Incorrect password length" message:@"Please check if your password length is more than 4 and less than 16" delegate:self cancelButtonTitle:@"Okay" otherButtonTitles:nil, nil];
    [alert show];
  }
  else {
    for (NSString *s in listOfNonValidChar) {
      for (int i = 0 ;i <[self.password length]; i++) {
        char c = [self.password characterAtIndex:i];
        NSString *cString = [NSString stringWithFormat:@"%c",c];
        if ([cString isEqualToString:s]) {
          valid = NO;
          UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Invalid password" message:@"Please check your password if it's correct" delegate:self cancelButtonTitle:@"Okay" otherButtonTitles:nil, nil];
          [alert show];
          break;
        }
      }
    }
  }
  return valid;
}

#pragma mark - Protocol Methods

- (void)goToHomeView:(LoginResponseProto *)proto {
  [[NSUserDefaults standardUserDefaults] setBool:YES forKey:IS_LOGGED_IN];
  [[NSUserDefaults standardUserDefaults] synchronize];
  
  HomeViewController *vc = [[HomeViewController alloc] initWithLoginResponse:proto];
  [self.view addSubview:vc.view];
  vc.view.frame = CGRectMake(0, -vc.view.frame.size.height, vc.view.frame.size.width, vc.view.frame.size.height);
  [UIView animateWithDuration:0.3f delay:0.f options:UIViewAnimationOptionCurveEaseInOut animations:^{
    vc.view.frame = CGRectMake(0, 0, vc.view.frame.size.width, vc.view.frame.size.height);
  } completion:^(BOOL finished) {
    [self.navigationController pushViewController:vc animated:NO];
  }];
}

- (void)receivedProtoResponse:(PBGeneratedMessage *)message {
  LoginResponseProto *proto = (LoginResponseProto *)message;
  if (proto.status == LoginResponseProto_LoginResponseStatusSuccessFacebookId || proto.status == LoginResponseProto_LoginResponseStatusSuccessEmailPassword || proto.status == LoginResponseProto_LoginResponseStatusSuccessNoCredentials || proto.status == LoginResponseProto_LoginResponseStatusSuccessLoginToken) {
    [self goToHomeView:proto];
  }
  else {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Invalid email or password" message:@"Please check if your email or password is correct" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [alert show];
  }
}

#pragma mark - UITextFieldDelegate Methods

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
  return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
 
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField {
  return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
  
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
  for (NSString *s in listOfNonValidChar) {
    if ([string isEqualToString:s]) {
      return NO;
      break;
    }
  }
  return YES;
}

- (BOOL)textFieldShouldClear:(UITextField *)textField {
  switch (textField.tag) {
    case kPasswordField:
      self.passwordTextField.text = @"";
      self.password = @"";
      break;
      
    case kEmailField:
      self.emailTextField.text = @"";
      self.email = @"";
  }
  return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
  switch (textField.tag) {
    case kEmailField:
      [self.passwordTextField becomeFirstResponder];
      break;
      
    case kPasswordField:
      [self login:self];
      break;
      
  }
  return YES;
}

@end
