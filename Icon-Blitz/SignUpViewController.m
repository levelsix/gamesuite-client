//
//  SignUpViewController.m
//  Icon-Blitz
//
//  Created by Danny on 4/15/13.
//
//

#import "SignUpViewController.h"
#import "LoginViewController.h"
#import "CreateAccountViewController.h"
#import "FacebookObject.h"
#import "SingletonMacro.h"
#import "HomeViewController.h"
#import "AppDelegate.h"
#import "UserInfo.h"
#import "SocketCommunication.h"

@interface SignUpViewController () {
  NSMutableArray *friendIds;
}

@end


@implementation SignUpViewController

- (void)viewDidLoad
{
  [super viewDidLoad];
  friendIds = [[NSMutableArray alloc] init];
  protoType = kSignUp;
}

- (IBAction)signUpWithFacebook:(id)sender {
  [self.spinner startAnimating];
  self.loadingLabel.hidden = NO;
  if (FBSession.activeSession.isOpen == YES) {
    [FBSession.activeSession closeAndClearTokenInformation];
  }
  else {
    FacebookObject *fb = [[FacebookObject alloc] init];
    AppDelegate *ad = [[UIApplication sharedApplication] delegate];
    ad.delegate = self;
    [fb facebookLogin];
    signUpType = kFacebook;
  }
}

- (void)finishedFBLogin {
  [self sendOverFacebookData];
}

- (void)sendOverFacebookData {
  SocketCommunication *sc = [SocketCommunication sharedSocketCommunication]; 
  sc.delegate = self;
  
  [self.spinner startAnimating];
  
  __block NSString *name = @"";
  __block NSString *facebookId = @"";
  __block NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
  FBRequest *me = [FBRequest requestForMe];
  [me startWithCompletionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
    if (!error) {
      [self.spinner stopAnimating];
      NSDictionary <FBGraphUser> *my = (NSDictionary<FBGraphUser>*)result;
      name = [NSString stringWithFormat:@"%@ %@", my.first_name, my.last_name];
      facebookId = my.id;
      [dict setObject:name forKey:@"name"];
      [dict setObject:facebookId forKey:@"facebookId"];
      [sc sendCreateAccountViaFacebookMessage:[dict copy]];
    }
    else {
      [self.spinner stopAnimating];
      UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Login Error" message:@"Error logging in with Facebook, please try again" delegate:self cancelButtonTitle:@"Okay" otherButtonTitles:nil, nil];
      [alert show];
    }
  }];
}

- (void)goToHomeViewWithAnimationWithLoginResponse:(LoginResponseProto *)proto {
#warning initialize depending on the sign up tye
  HomeViewController *vc = [[HomeViewController alloc] initWithNibName:@"HomeViewController" bundle:nil];
  [self.view addSubview:vc.view];
  vc.view.frame = CGRectMake(0, -vc.view.frame.size.height, vc.view.frame.size.width, vc.view.frame.size.height);
  [UIView animateWithDuration:0.3f delay:0.f options:UIViewAnimationOptionCurveEaseInOut animations:^{
    vc.view.frame = CGRectMake(0, 0, vc.view.frame.size.width, vc.view.frame.size.height);
  } completion:^(BOOL finished) {
    [self.navigationController pushViewController:vc animated:NO];
  }];
}

- (void)loginWithNoCredential:(CreateAccountResponseProto *)proto {
  [[SocketCommunication sharedSocketCommunication] sendLoginRequestEventViaNoCredentials:proto.recipient];
}

- (void)receivedProtoResponse:(PBGeneratedMessage *)message {
  if (protoType == kSignUp) {
    CreateAccountResponseProto *proto = (CreateAccountResponseProto *)message;
    if (proto.status == CreateAccountResponseProto_CreateAccountStatusSuccessAccountCreated) {
      NSLog(@"succeeded");
      protoType = kLoginType;
      if (signUpType == kFacebook) {
        [self getFacebookAndSendDataWithProto:proto];
      }
      else {
        [self loginWithNoCredential:proto];
      }
    }
    else {
      NSLog(@"failed");
      [self.spinner stopAnimating];
      self.loadingLabel.hidden = YES;
      [self receivedFailedProto:proto];
    }
  }
  else {
    LoginResponseProto *proto = (LoginResponseProto *)message;
    [self goToHomeViewWithAnimationWithLoginResponse:proto];
  }
}

- (void)getFacebookAndSendDataWithProto:(CreateAccountResponseProto *)proto {
  FBRequest *friendsRequest = [FBRequest requestForMyFriends];
  [friendsRequest startWithCompletionHandler: ^(FBRequestConnection *connection,
                                                NSDictionary* result,
                                                NSError *error) {
    NSArray* friends = [result objectForKey:@"data"];
    for (NSDictionary<FBGraphUser>* friend in friends) {
      [friendIds addObject:friend.id];
    }
    SocketCommunication *sc = [SocketCommunication sharedSocketCommunication];
    sc.delegate = self;
    [sc sendLoginRequestEventViaFacebook:proto.recipient facebookFriends:friendIds];
  }];
}

- (void)receivedFailedProto:(CreateAccountResponseProto *)proto {
  UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"" delegate:self cancelButtonTitle:@"Okay" otherButtonTitles:@"Cancel", nil];
  switch ((int)proto.status) {
    case CreateAccountResponseProto_CreateAccountStatusFailDuplicateFacebookId:
      protoType = kLoginType;
      [self getFacebookAndSendDataWithProto:proto];
      NSLog(@"duplicate facebook id");
      return;
      break;
    case CreateAccountResponseProto_CreateAccountStatusFailDuplicateUdid:
      alert.title = @"Please sign In!";
      alert.message = @"You are already signed up, please sign in using the login page";
      signedIn = YES;
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

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
  if (buttonIndex == 0) {
    if (signedIn) {
      signedIn = NO;
      [self login:self];
    }    
  }
}

- (IBAction)signUpWithEmail:(id)sender {
  CreateAccountViewController *vc = [[CreateAccountViewController alloc] initWithNibName:@"CreateAccountViewController" bundle:nil];
  [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)skipSignUp:(id)sender {
  SocketCommunication *sc = [SocketCommunication sharedSocketCommunication];
  sc.delegate = self;
  UserInfo *ui = [[UserInfo alloc] init];
  NSString *udid = [ui getUDID];
  NSString *macAddress = [ui getMacAddress];
  NSString *name = [self randomName];
  NSMutableDictionary *dict = [NSMutableDictionary dictionary];

  [dict setObject:udid forKey:@"udid"];
  [dict setObject:macAddress forKey:@"deviceId"];
  [dict setObject:name forKey:@"name"];
  
  [[SocketCommunication sharedSocketCommunication] sendCreateAccountViaNoCredentialsRequestProto:[dict copy]];
}

- (NSString *)randomName {
  NSString *prefix = @"User";
  int ran = arc4random() % 100000;
  NSString *name = [NSString stringWithFormat:@"%@%d",prefix,ran];
  return name;
}

- (IBAction)login:(id)sender {
  LoginViewController *vc = [[LoginViewController alloc]initWithNibName:@"LoginViewController" bundle:nil];
  [self.navigationController pushViewController:vc animated:YES];
}
@end
