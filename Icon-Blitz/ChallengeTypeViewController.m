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

@interface ChallengeTypeViewController ()

@end

@implementation ChallengeTypeViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (IBAction)back:(UIButton *)sender {
  [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)facebookClicked:(UIButton *)sender {
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
        [self showFriends:self.facebookData];
        [spinner stopAnimating];
        [spinner removeFromSuperview];
        [spinner release];
        self.loaded = YES;
      }
      else {
        NSLog(@"%@",error);
      }
    }];
  }
  else {
    [self showFriends:self.facebookData];
  }
}

- (void)showFriends:(NSArray *)friendData {
  self.view.userInteractionEnabled = YES;
  InviteFriendsViewController *viewController = [[InviteFriendsViewController alloc] initWithNibName:nil bundle:nil andFriendArray:friendData];
  [self.navigationController pushViewController:viewController animated:YES];
  [viewController release];
}

- (IBAction)twitterClicked:(UIButton *)sender {
  
}

- (IBAction)userNameClicked:(UIButton *)sender {
  
}

- (IBAction)randomClicked:(UIButton *)sender {
  
}

@end
