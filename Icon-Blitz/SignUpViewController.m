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
#import "StaticProperties.h"

@interface SignUpViewController () {
  NSMutableArray *friendIds;
  NSString *facebookId;
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
    self.view.userInteractionEnabled = NO;
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
  __block NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
  [[FBRequest requestForMe] startWithCompletionHandler:^(FBRequestConnection *connection, NSDictionary<FBGraphUser> *user, NSError *error) {
    if (!error) {
      facebookId = user.id;
      name = [NSString stringWithFormat:@"%@ %@",user.first_name, user.last_name];
      NSString *email = [user objectForKey:@"email"];
      [dict setObject:name forKey:@"name"];
      [dict setObject:facebookId forKey:@"facebookId"];
      [dict setObject:email forKey:@"email"];
      [sc sendCreateAccountViaFacebookMessage:[dict copy]];
    }
    else {
      [self.spinner stopAnimating];
      UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Login Error" message:@"Error logging in with Facebook, please try again" delegate:self cancelButtonTitle:@"Okay" otherButtonTitles:nil, nil];
      [alert show];
    }
  }];
}

- (void)getFacebookFriendsAndSendDataWithProto:(CreateAccountResponseProto *)proto {
  [[NSUserDefaults standardUserDefaults] setBool:YES forKey:DID_FACEBOOK_SIGNUP];
  [[NSUserDefaults standardUserDefaults] synchronize];
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
    [sc sendLoginRequestEventViaToken:proto.recipient facebookFriends:friendIds];
  }];
}

- (void)goToHomeViewWithAnimationWithLoginResponse:(LoginResponseProto *)proto {
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

- (void)loginWithToken:(CreateAccountResponseProto *)proto {
  [[SocketCommunication sharedSocketCommunication] sendLoginRequestEventViaToken:proto.recipient facebookFriends:nil];
}

- (void)receivedProtoResponse:(PBGeneratedMessage *)message {
  [self.spinner stopAnimating];
  self.loadingLabel.hidden = YES;
  if (protoType == kSignUp) {
    CreateAccountResponseProto *proto = (CreateAccountResponseProto *)message;
    if (proto.status == CreateAccountResponseProto_CreateAccountStatusSuccessAccountCreated) {
      NSLog(@"signed up success");
      [self.spinner startAnimating];
      self.loadingLabel.hidden = NO;
      self.loadingLabel.text = [NSString stringWithFormat:@"Logging in..."];
      self.view.userInteractionEnabled = NO;
      protoType = kLoginType;
      if (signUpType == kFacebook) {
        //login with facebook
        [self getFacebookFriendsAndSendDataWithProto:proto];
      }
      else {
        //login with no credential
        NSLog(@"signed up failed");
        [self loginWithToken:proto];
      }
    }
    else {
      //sign up failed
      self.view.userInteractionEnabled = YES;
      [self receivedFailedProto:proto];
    }
  }
  else {
    LoginResponseProto *proto = (LoginResponseProto *)message;
    if (proto.status == LoginResponseProto_LoginResponseStatusSuccessLoginToken ||
        proto.status == LoginResponseProto_LoginResponseStatusSuccessFacebookId ||
        proto.status == LoginResponseProto_LoginResponseStatusSuccessEmailPassword ||
        proto.status == LoginResponseProto_LoginResponseStatusSuccessNoCredentials)
    {
      [self goToHomeViewWithAnimationWithLoginResponse:proto];
    }
    else {
      self.view.userInteractionEnabled = YES;
      [self loginFailed:proto];
    }
  }
}

- (void)loginFailed:(LoginResponseProto *)proto {
  UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"" delegate:self cancelButtonTitle:@"Okay" otherButtonTitles:nil, nil];
  switch ((int)proto.status) {
    case LoginResponseProto_LoginResponseStatusInvalidEmailPassword:
      alert.title = @"Invalid email or password";
      alert.message = @"Please check if your email or password is correct";
      break;
      
    case LoginResponseProto_LoginResponseStatusInvalidFacebookId:
      alert.title = @"Invalid Facebook Id";
      alert.message = @"An error has occured while logging in with Facebook, please try again or send us an email";
      break;
      
    case LoginResponseProto_LoginResponseStatusInvalidLoginToken:
      alert.title = @"Invalid login token";
      alert.message = @"Invalid login token";
      break;
      
    case LoginResponseProto_LoginResponseStatusInvalidNoCredentials:
      alert.title = @"Invalid no credentials";
      alert.message = @"Invalid no credential";
      break;
      
    case LoginResponseProto_LoginResponseStatusFailOther:
      alert.title = @"Fail other";
      alert.message = @"I have no idea whats going on";
      break;

    default:
      break;
  }
  [alert show];
}

- (void)loginWithFacebook:(CreateAccountResponseProto *)proto {
  BasicUserProto *newProto = [[[[[[[[[BasicUserProto builder] setBadp:proto.recipient.badp] setEmail:proto.recipient.email] setFacebookId:facebookId] setPassword:proto.recipient.password] setNameFriendsSee:proto.recipient.nameFriendsSee] setNameStrangersSee:proto.recipient.nameStrangersSee] setUserId:proto.recipient.userId] build];
  FBRequest *friendsRequest = [FBRequest requestForMyFriends];
  friendIds = [NSMutableArray array];
  [friendsRequest startWithCompletionHandler: ^(FBRequestConnection *connection,
                                                NSDictionary* result,
                                                NSError *error) {
    NSArray* friends = [result objectForKey:@"data"];
    for (NSDictionary<FBGraphUser>* friend in friends) {
      [friendIds addObject:friend.id];
    }
    SocketCommunication *sc = [SocketCommunication sharedSocketCommunication];
    sc.delegate = self;
    [sc sendLoginRequestEventViaFacebook:newProto facebookFriends:friendIds];
  }];
}

- (void)receivedFailedProto:(CreateAccountResponseProto *)proto {
  UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"" delegate:self cancelButtonTitle:@"Okay" otherButtonTitles:nil, nil];
  switch ((int)proto.status) {
    case CreateAccountResponseProto_CreateAccountStatusFailDuplicateFacebookId:
      protoType = kLoginType;
      [self loginWithFacebook:proto];
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
  [self.spinner startAnimating];
  self.loadingLabel.hidden = NO;
  self.view.userInteractionEnabled = NO;
  SocketCommunication *sc = [SocketCommunication sharedSocketCommunication];
  sc.delegate = self;
  UserInfo *ui = [[UserInfo alloc] init];
  NSString *udid = [ui getUDID];
  NSString *macAddress = [ui getMacAddress];
  NSString *name = [self randomName];
  NSMutableDictionary *dict = [NSMutableDictionary dictionary];

  signUpType = kNoCredential;
  
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
