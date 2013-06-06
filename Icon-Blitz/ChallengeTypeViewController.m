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

@interface ChallengeTypeViewController ()

@end

@implementation ChallengeTypeViewController

- (id)initWithQuestions:(NSArray *)questions facebookFriends:(NSArray *)facebookFriends userInfo:(UserInfo *)userInfo {
  if ((self = [super init])) {
    self.questions = questions;
    self.facebookFriends = facebookFriends;
    self.userInfo = userInfo;
  }
  return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (IBAction)back:(UIButton *)sender {
  [self.navigationController popViewControllerRotated:YES];
}

- (IBAction)facebookClicked:(UIButton *)sender {
  //self.userInfo.goldCoins--;
  __block NSMutableArray *friendIds = [[NSMutableArray alloc] init];
  self.view.userInteractionEnabled = NO;
  if (!self.loaded) {
    UIActivityIndicatorView *spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    spinner.center = CGPointMake(160,360);
    [self.view addSubview:spinner];
    [spinner startAnimating];
    self.facebookData = [NSMutableArray array];
    FacebookObject *fb = [[FacebookObject alloc] init];
    [fb facebookLogin];
    FBRequest* friendsRequest = [FBRequest requestForMyFriends];
    
    [friendsRequest startWithCompletionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
      if (!error) {
        self.facebookData = [result objectForKey:@"data"];
        for (NSDictionary<FBGraphUser>* friend in self.facebookData) {
          [friendIds addObject:friend.id];
        }
        self.userInfo.listOfFacebookFriends = friendIds;
        [self showFriends:self.facebookData];
        [spinner stopAnimating];
        [spinner removeFromSuperview];
        self.loaded = YES;
      }
      else {
      }
    }];
  }
  else {
    [self showFriends:self.facebookData];
  }
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
