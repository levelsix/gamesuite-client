//
//  LoadingViewController.m
//  Icon-Blitz
//
//  Created by Danny on 5/8/13.
//
//

#import "LoadingView.h"
#import "SocketCommunication.h"
#import "SignUpViewController.h"
#import "CreateAccountViewController.h"

@implementation LoadingView

- (id)initWithFriends:(NSArray *)facebookFriends proto:(BasicUserProto *)proto signUp:(SignUpViewController *)vc loadingType:(LoadingType)type
{
  if ((self = [super init])) {
    self.signup = vc;
    self.type = type;
    spinner = [[UIActivityIndicatorView alloc] init];
    [spinner startAnimating];
    SocketCommunication *sc = [SocketCommunication sharedSocketCommunication];
    [sc sendLoginRequestEventViaFacebook:proto facebookFriends:facebookFriends];
    sc.delegate = self;

  }
    return self;
}

- (id)initWithProto:(BasicUserProto *)proto createAccount:(CreateAccountViewController *)vc loadingType:(LoadingType)type {
  if ((self = [super init])) {
    self.createAccount = vc;
    self.type = type;
    spinner = [[UIActivityIndicatorView alloc] init];
    [spinner startAnimating];
    SocketCommunication *sc = [SocketCommunication sharedSocketCommunication];
    [sc sendLoginRequestEventViaEmail:proto];
    sc.delegate = self;
  }
  return self;
}

- (void)receivedProtoResponse:(PBGeneratedMessage *)message {
  SocketCommunication *sc = [SocketCommunication sharedSocketCommunication];
  sc.delegate = nil;

  [spinner stopAnimating];
  
  LoginResponseProto *proto = (LoginResponseProto *)message;
  
  if (proto.status == LoginResponseProto_LoginResponseStatusSuccessNoCredentials || proto.status == LoginResponseProto_LoginResponseStatusSuccessFacebookId || proto.status == LoginResponseProto_LoginResponseStatusSuccessEmailPassword || proto.status == LoginResponseProto_LoginResponseStatusSuccessLoginToken) {
    [self removeFromSuperview];
    if (self.type = kFromSignUpViewController) {
      [self.signup goToHomeView:proto];
    }
    else if (self.type = kFromCreateUpViewController) {
      [self.createAccount goToHomeView:proto];
    }
  }
  else {
    [self failProtoResponse:proto];
  }
  
}

- (void)failProtoResponse:(LoginResponseProto *)proto {
  UIAlertView *alert;

  if (proto.status == LoginResponseProto_LoginResponseStatusInvalidFacebookId) {
    alert = [[UIAlertView alloc] initWithTitle:@"Invalid FacebookId" message:@"Please relog into facebook or try again later" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
   
  }
  else if (proto.status == LoginResponseProto_LoginResponseStatusInvalidLoginToken) {
    alert = [[UIAlertView alloc] initWithTitle:@"Expired Token" message:@"An unexpected error has occured, please log in again" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
  }
  else if (proto.status == LoginResponseProto_LoginResponseStatusInvalidEmailPassword) {
    alert = [[UIAlertView alloc] initWithTitle:@"Invalid Email or password" message:@"Please check if your email or password is correct" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
  }
  [alert show];
}

@end
