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
  StartRoundType startRoundType;
  BOOL startedRequest;
  BOOL searchFunctionClicked;
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
  startRoundType = kStartRoundNone;
}

- (IBAction)back:(UIButton *)sender {
  if (startedRequest) {
    SocketCommunication *sc = [SocketCommunication sharedSocketCommunication];
    sc.delegate = nil;
  }
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
  __block NSArray *sortedArray;
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
      sortedArray = [friendIds sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
      [self showFriends:haveGameIdObject andInviteArray:sortedArray];
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
  searchFunctionClicked = YES;
}

- (IBAction)randomClicked:(UIButton *)sender {
  startedRequest = YES;
  startRoundType = kStartRoundRandom;
  SocketCommunication *sc = [SocketCommunication sharedSocketCommunication];
  sc.delegate = self;
  [self.spinner startAnimating];
  self.loadingLabel.hidden = NO;
  [self disableButtons];

  BasicUserProto *user = [sc buildSender];
  self.loadingLabel.text = [NSString stringWithFormat:@"Searching for random opponent"];
  self.loadingLabel.numberOfLines = 0;
  int64_t startTime = (int64_t)[self getUsersTimeInSeconds];
  [sc sendStartRoundRequest:user isRandomPlayer:YES opponent:NULL gameId:NULL roundNumber:1 isPlayerOne:YES startTime:startTime*1000 questions:self.userInfo.questions];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
  switch (buttonIndex) {
    case 0:
      if (searchFunctionClicked) {
        [self searchForUser:[alertView textFieldAtIndex:0].text];
        searchFunctionClicked = NO;
      }
      break;
      
    case 1:
      searchFunctionClicked = NO;
      break;
      
  }
}

- (void)searchForUser:(NSString *)name {
  startRoundType = kStartRoundSearch;
  [self.spinner startAnimating];
  self.loadingLabel.hidden = NO;
  [self disableButtons];
  self.loadingLabel.text = [NSString stringWithFormat:@"Searching for '%@'",name];
  SocketCommunication *sc = [SocketCommunication sharedSocketCommunication];
  sc.delegate = self;
  BasicUserProto *user = [sc buildSender];
  [sc sendSearchForUser:user nameOfPerson:name];
}

- (NSTimeInterval)getUsersTimeInSeconds {
  NSTimeZone* local = [NSTimeZone localTimeZone];
  NSInteger secondsOffset = [local secondsFromGMTForDate:[NSDate date]];
  NSDate *date = [[NSDate alloc] init];
  NSTimeInterval time = [date timeIntervalSince1970];
  return time + secondsOffset;
}

- (void)disableButtons {
  for (UIButton *buttons in self.view.subviews) {
    buttons.userInteractionEnabled = NO;
  }
  self.backButton.userInteractionEnabled = YES;
}

- (void)enableButtons {
  for (UIButton *buttons in self.view.subviews) {
    buttons.userInteractionEnabled = YES;
  }
}

#pragma mark - Protocol Buffer Methods

- (void)receivedProtoResponse:(PBGeneratedMessage *)message {
  [self enableButtons];
  startedRequest = NO;
  StartRoundResponseProto *proto = (StartRoundResponseProto *)message;
  if (startRoundType == kStartRoundRandom) {
    if (proto.status == StartRoundResponseProto_StartRoundStatusSuccess) {
      
    }
  }
  else if (startRoundType == kStartRoundSearch) {
    
  }
}

@end
