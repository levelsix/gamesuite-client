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

@interface ChallengeTypeViewController ()

@end

@implementation ChallengeTypeViewController

- (id)initWithUserInfo:(UserInfo *)userInfo {
  if ((self = [super init])) {
    self.userInfo = userInfo;
  }
  return self;
}

- (void)viewDidLoad
{
  [super viewDidLoad];
  self.facebookData = [NSMutableArray array];
}

- (IBAction)back:(UIButton *)sender {
  [self.navigationController popViewControllerRotated:YES];
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
  FBRequest* friendsRequest = [FBRequest requestForMyFriends];
  [friendsRequest startWithCompletionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
    if (!error) {
      self.facebookData = [result objectForKey:@"data"];
      for (NSDictionary<FBGraphUser>* friend in self.facebookData) {
        [friendIds addObject:friend.id];
      }
      self.userInfo.listOfFacebookFriends = friendIds;
      [self showFriends:self.facebookData];
      [self.spinner stopAnimating];
    }
    else {
      NSLog(@"%@",error);
    }
  }];
}

- (void)showFriends:(NSArray *)friendData {
  self.view.userInteractionEnabled = YES;
  InviteFriendsViewController *viewController = [[InviteFriendsViewController alloc] initWithNibName:nil bundle:nil userInfo:self.userInfo andFriendArray:friendData];
  [self.navigationController pushViewController:viewController rotated:YES];
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
  
}

- (IBAction)randomClicked:(UIButton *)sender {
  
}

@end
