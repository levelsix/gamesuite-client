//
//  ChallengeTypeViewController.m
//  Icon-Blitz
//
//  Created by Danny on 4/8/13.
//
//

#import "ChallengeTypeViewController.h"
#import "InviteFriendsViewController.h"
#import "FacebookObject.h"
#import "UINavigationController+PushPopRotated.h"
#import "UserInfo.h"
#import <Twitter/Twitter.h>
#import "AppDelegate.h"
#import "SocketCommunication.h"

@interface ChallengeTypeViewController () {
  BOOL fromHomeView;
}

@end

@implementation ChallengeTypeViewController

- (id)initWithUserInfo:(UserInfo *)userInfo {
  if ((self = [super init])) {
    self.userInfo = userInfo;
    fromHomeView = YES;
  }
  return self;
}

- (void)passUserData:(UserInfo *)userInfo {
  self.userInfo = userInfo;
  self.facebookFriendsLabel.text = [NSString stringWithFormat:@"%d friends playing",self.userInfo.listOfFacebookFriends.count];
}

- (void)viewWillAppear:(BOOL)animated {
  self.facebookFriendsLabel.text = [NSString stringWithFormat:@"%d friends playing",self.userInfo.listOfFacebookFriends.count];
}

- (void)viewDidLoad
{
  [super viewDidLoad];
  self.facebookData = [NSMutableArray array];
}

- (IBAction)back:(UIButton *)sender {
  [self.navigationController popViewControllerRotated:YES];
  if ([self.delegate respondsToSelector:@selector(passDataBackToRootView:)]) {
    [self.delegate passDataBackToRootView:self.userInfo];
  }
}

- (IBAction)facebookClicked:(UIButton *)sender {
  [self.spinner startAnimating];
  self.view.userInteractionEnabled = NO;
  if (!FBSession.activeSession.isOpen) {
    
    AppDelegate *delegate = [[UIApplication sharedApplication] delegate];
    delegate.delegate = self;
    FacebookObject *fb = [[FacebookObject alloc] init];
    [fb facebookLogin];
  }
  else {
    [self requestForFriend];
  }
}

- (void)finishedFBLogin {
  [self requestForFriend];
}

- (void)requestForFriend {
  __block NSMutableArray *friendIds = [[NSMutableArray alloc] init];
  __block NSMutableArray *haveGameIdObject = [[NSMutableArray alloc] init];
  
  NSMutableArray *haveGameIds = [NSMutableArray array];
  for (BasicUserProto *proto in self.userInfo.listOfFacebookFriends) {
    [haveGameIds addObject:proto.facebookId];
  }
    
  FBRequest* friendsRequest = [FBRequest requestForMyFriends];
  [friendsRequest startWithCompletionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
    if (!error) {
      self.facebookData = [result objectForKey:@"data"];
      for (NSDictionary<FBGraphUser>* friend in self.facebookData) {
        for (NSString *fId in haveGameIds) {
          if ([fId isEqualToString:friend.id]) {
            [haveGameIdObject addObject:friend];
            break;
          }
          [friendIds addObject:friend];
        }
      }
      
      [self showFriends:haveGameIdObject andInviteArray:friendIds];
      [self.spinner stopAnimating];
    }
    else {
      NSLog(@"%@",error);
    }
  }];
}

- (void)showFriends:(NSArray *)friendData  andInviteArray:(NSArray *)inviteArray{
  self.view.userInteractionEnabled = YES;
  InviteFriendsViewController *vc = [[InviteFriendsViewController alloc] initWithUserInfo:self.userInfo andFriendArray:friendData inviteArray:inviteArray];
  vc.delegate = self;
  [self.navigationController pushViewController:vc rotated:YES];
}

- (IBAction)twitterClicked:(UIButton *)sender {
  if ([TWTweetComposeViewController canSendTweet]) {
    TWTweetComposeViewController *tweetSheet = [[TWTweetComposeViewController alloc] init];
    [tweetSheet setInitialText:@"Download Trivia Blitz"];
    [self presentModalViewController:tweetSheet animated:YES];
  }
  else {
    UIAlertView *alertView = [[UIAlertView alloc]
                              initWithTitle:@"Sorry"
                              message:@"You can't send a tweet right now, make sure your device has an internet connection and you have at least one Twitter account setup"
                              delegate:self
                              cancelButtonTitle:@"OK"
                              otherButtonTitles:nil];
    [alertView show];
  }
}

- (IBAction)userNameClicked:(UIButton *)sender {
  UIAlertView *alert = [[ UIAlertView alloc] initWithTitle:@"Enter username" message:nil delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:@"cancel", nil];
  alert.alertViewStyle = UIAlertViewStylePlainTextInput;
  [alert show];
}

- (IBAction)randomClicked:(UIButton *)sender {
  
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
  switch (buttonIndex) {
    case 0:
      [self searchForUser:[alertView textFieldAtIndex:0].text];
      break;
  }
}

- (void)searchForUser:(NSString *)name {
  [self.spinner startAnimating];
  self.loadingLabel.hidden = NO;
  self.loadingLabel.text = [NSString stringWithFormat:@"Search for '%@'",name];
  SocketCommunication *sc = [SocketCommunication sharedSocketCommunication];
  sc.delegate = self;
  BasicUserProto *user = [sc buildSender];
  [sc sendSearchForUser:user nameOfPerson:name];
}

#pragma mark - Protocol Buffer Methods

- (void)receivedProtoResponse:(PBGeneratedMessage *)message {
  NSLog(@"received event");
}

@end
