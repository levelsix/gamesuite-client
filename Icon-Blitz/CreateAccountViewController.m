//
//  CreateAccountViewController.m
//  Icon-Blitz
//
//  Created by Danny on 4/24/13.
//
//

#import "CreateAccountViewController.h"
#import "LoginViewController.h"
#import "UserInfo.h"
#import "SocketCommunication.h"
#import "TextFieldIndentation.h"
#import "HomeViewController.h"

typedef enum {
  kUserNameField = 1,
  kEmailField,
  kPasswordField,
}TextFieldTypes;

#define Minimum_Pasword_Count 5
#define Maximum_Password_Count 15
#define Minimum_UserName_Count 4
#define Maximum_UserName_Count 15


#define SignUpProto 2
#define LoginProto 3

@interface CreateAccountViewController () {
  int protoType;
}

@end

@implementation CreateAccountViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
  self.emailTextField.horizontalPadding = 15;
  self.usernameTextField.horizontalPadding = 15;
  self.passwordTextField.horizontalPadding = 15;
  protoType = SignUpProto;
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(usernameChanged) name:UITextFieldTextDidChangeNotification object:self.usernameTextField];
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(passwordChanged) name:UITextFieldTextDidChangeNotification object:self.passwordTextField];
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(emailChanged) name:UITextFieldTextDidChangeNotification object:self.emailTextField];

  listOfNonValidChar = [[NSArray alloc] initWithObjects:@"#",@"%",@"$",@"~",@"!",@"&",@"^",@"*",@"-",@"+",@"[",@"]",@"<",@">",@"?",@"/",@":",@";",@"=",@"(",@")",@"{",@"}",@"|",@"'", nil];

}

- (void)usernameChanged {
  self.username = self.usernameTextField.text;
}

- (void)passwordChanged {
  self.password = self.passwordTextField.text;
}

- (void)emailChanged {
  self.email = self.emailTextField.text;
}

- (void)dealloc {
  [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidAppear:(BOOL)animated {
  [self.usernameTextField becomeFirstResponder];
}

#pragma mark - Outlet Methods

- (IBAction)createAccount:(id)sender {
  BOOL valid = YES;
  if (![self checkIfUserNameIsValid]) {
    valid = NO;
  }
  if (![self checkIfEmailIsValid]) {
    valid = NO;
  }
  if (![self checkIfPasswordIsValid]) {
    valid = NO;
  }
  
  if (valid) {
    [self.view endEditing:YES];
    [self.spinner startAnimating];
    self.loadingLabel.hidden = NO;
    SocketCommunication *sc = [SocketCommunication sharedSocketCommunication];
    self.view.userInteractionEnabled = NO;
    sc.delegate = self;
    UserInfo *ui = [[UserInfo alloc] init];
    NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
    [userInfo setObject:self.username forKey:@"name"];
    [userInfo setObject:self.email forKey:@"email"];
    [userInfo setObject:[ui getUDID] forKey:@"udid"];
    [userInfo setObject:self.password forKey:@"password"];
    [userInfo setObject:[ui getMacAddress] forKey:@"deviceId"];
    [sc sendCreateAccountViaEmailMessage:[userInfo copy]];
  }
}

- (IBAction)back:(id)sender {
  [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)goToHomeView:(LoginResponseProto *)proto {
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
  self.view.userInteractionEnabled = YES;
  [self.spinner stopAnimating];
  self.loadingLabel.hidden = YES;
  if (protoType == SignUpProto) {
    CreateAccountResponseProto *proto = (CreateAccountResponseProto *)message;
    if (proto.status == CreateAccountResponseProto_CreateAccountStatusSuccessAccountCreated) {
      protoType = LoginProto;
      [self.spinner startAnimating];
      [[SocketCommunication sharedSocketCommunication] sendLoginRequestEventViaToken:proto.recipient facebookFriends:NULL];
    }
    else {
      [self receivedFailedProto:proto];
    }
  }
  else {
    [self.spinner startAnimating];
    self.loadingLabel.hidden = NO;
    self.loadingLabel.text = [NSString stringWithFormat:@"Logging in"];
    LoginResponseProto *proto = (LoginResponseProto *)message;
    if (proto.status == LoginResponseProto_LoginResponseStatusSuccessLoginToken) {
      [self goToHomeView:proto];
    }
    else {
      [self receivedLoginFailedProto:proto];
    }
  }
}

- (void)receivedLoginFailedProto:(LoginResponseProto *)proto {
  NSLog(@"error");
}

- (void)receivedFailedProto:(CreateAccountResponseProto *)proto {
  UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"" delegate:self cancelButtonTitle:@"Okay" otherButtonTitles:nil, nil];
  switch ((int)proto.status) {
    case CreateAccountResponseProto_CreateAccountStatusFailDuplicateFacebookId:
    case CreateAccountResponseProto_CreateAccountStatusFailDuplicateUdid:
      alert.title = @"Please sign In!";
      alert.message = @"You are already signed up, please sign in using the login page";
      break;
      
    case CreateAccountResponseProto_CreateAccountStatusFailMissingFacebookId:
      alert.title = @"An error has occured!";
      alert.message = @"An error has occured while signing up, please try again or sign up using email or skip";
      break;
      
    case CreateAccountResponseProto_CreateAccountStatusFailInvalidName:
      alert.title = @"Invalid username";
      alert.message = @"Please check your username if it's not using invalid characters";
      break;
      
    case CreateAccountResponseProto_CreateAccountStatusFailInvalidUdid:
      alert.title = @"An error has occured!";
      alert.message = @"An error has occured while signing up, please try again or sign up using facebook or skip";
      break;
      
    case CreateAccountResponseProto_CreateAccountStatusFailInvalidPassword:
      alert.title = @"Invalid Password";
      alert.message = @"Please check your password if it's not using invalid characters";
      break;
      
    case CreateAccountResponseProto_CreateAccountStatusFailDuplicateEmail:
      alert.title = @"Email is in use";
      alert.message = @"Please sign in or enter another email";
      break;
      
    case CreateAccountResponseProto_CreateAccountStatusFailInvalidEmail:
      alert.title = @"Invalid Email";
      alert.message = @"Please check your email if it's not using invalid characters";
      break;
      
    case CreateAccountResponseProto_CreateAccountStatusFailDuplicateName:
      alert.title = @"Username is in use";
      alert.message = @"Please sign in or enter another username";
      break;
      
    case CreateAccountResponseProto_CreateAccountStatusFailOther:
      alert.title = @"Failed to contact server";
      alert.message = @"Please try again later";
      break;
  }
  [alert show];
}

#pragma mark - Helper Methods

- (BOOL)checkIfUserNameIsValid {
  BOOL valid = YES;
  
  if ([self.username length] < Minimum_UserName_Count || [self.username length] > Maximum_UserName_Count) {
    valid = NO;
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Incorrect username length" message:@"Please check if your username length is more than 3 and less than 16" delegate:self cancelButtonTitle:@"Okay" otherButtonTitles:nil, nil];
    [alert show];
  }
  else {
    for (NSString *s in listOfNonValidChar) {
      for (int i = 0; i < [self.username length]; i++) {
        char c = [self.username characterAtIndex:i];
        NSString *cString = [NSString stringWithFormat:@"%c",c];
        if ([cString isEqualToString:s]) {
          valid = NO;
          UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Incorrect username " message:@"Please check if your username is it correct format" delegate:self cancelButtonTitle:@"Okay" otherButtonTitles:nil, nil];
          [alert show];
          break;
        }
      }
    }
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
          UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Incorrect password" message:@"Please check if your username is in correct format" delegate:self cancelButtonTitle:@"Okay" otherButtonTitles:nil, nil];
          [alert show];
          break;
        }
      }
    }
  }
  return valid;
}

-(BOOL) NSStringIsValidEmail:(NSString *)checkString
{
  BOOL stricterFilter = YES; // Discussion http://blog.logichigh.com/2010/09/02/validating-an-e-mail-address/
  NSString *stricterFilterString = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
  NSString *laxString = @".+@.+\\.[A-Za-z]{2}[A-Za-z]*";
  NSString *emailRegex = stricterFilter ? stricterFilterString : laxString;
  NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
  return [emailTest evaluateWithObject:checkString];
}

- (BOOL)checkIfEmailIsValid {
  BOOL valid = YES;
  
  if (![self NSStringIsValidEmail:self.email]) {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Incorrect email" message:@"Please check if your email is in correct format" delegate:self cancelButtonTitle:@"Okay" otherButtonTitles:nil, nil];
    [alert show];
    valid = NO;
  }
  return valid;
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

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
  switch (textField.tag) {
    case kUserNameField:
      [self.emailTextField becomeFirstResponder];
      break;
      
    case kEmailField:
      [self.passwordTextField becomeFirstResponder];
      break;
      
    case kPasswordField:
      [self createAccount:self];
      break;
      
  }
  return YES;
}

@end
