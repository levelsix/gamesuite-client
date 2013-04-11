//
//  ViewController.m
//  Icon-Blitz
//
//  Created by Danny on 3/12/13.
//
//

#import "ViewController.h"
#import "PublishDataView.h"
#import "AppDelegate.h"
#import "FriendsViewController.h"
#import "InviteFriendsViewController.h"

@interface ViewController ()

@end

@implementation ViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
  [[NSNotificationCenter defaultCenter]
   addObserver:self
   selector:@selector(sessionStateChanged:)
   name:FBSessionStateChangedNotification
   object:nil];
  [self facebookLogin:self];
  [self queryButtonAction:self];
  // Do any additional setup after loading the view, typically from a nib.
}

- (IBAction)facebookLogin:(id)sender {
  AppDelegate *ad = [[UIApplication sharedApplication] delegate];
  // If the user is authenticated, log out when the button is clicked.
  // If the user is not authenticated, log in when the button is clicked.
  if (FBSession.activeSession.isOpen) {
    //[ad closeSession];
  } else {
    // The user has initiated a login, so call the openSession method
    // and show the login UX if necessary.
    [ad openSessionWithAllowLoginUI:YES];
  }
}

- (void)sessionStateChanged:(NSNotification*)notification {
  if (FBSession.activeSession.isOpen) {
    [self.authButton setTitle:@"Logout" forState:UIControlStateNormal];
    self.queryButton.hidden = NO;
    self.multiQueryButton.hidden = NO;
  } else {
    [self.authButton setTitle:@"Login" forState:UIControlStateNormal];
    self.queryButton.hidden = YES;
    self.multiQueryButton.hidden = YES;
  }
}

- (void)publish:(id)sender {
  [[NSBundle mainBundle] loadNibNamed:@"PublishData" owner:self options:nil];
  [self.publishView init];
  self.publishView.center = CGPointMake(160, 240);
  [self.view addSubview:self.publishView];
}

- (IBAction)multiQueryButtonACtion:(id)sender {
  // Multi-query to fetch the active user's friends, limit to 25.
  // The initial query is stored in reference named "friends".
  // The second query picks up the "uid2" info from the first
  // query and gets the friend details.
  NSString *query =
  @"{"
  @"'friends':'SELECT uid2 FROM friend WHERE uid1 = me() LIMIT 25',"
  @"'friendinfo':'SELECT uid, name, pic_square FROM user WHERE uid IN (SELECT uid2 FROM #friends)',"
  @"}";
  // Set up the query parameter
  NSDictionary *queryParam = [NSDictionary dictionaryWithObjectsAndKeys:
                              query, @"q", nil];
  // Make the API request that uses FQL
  [FBRequestConnection startWithGraphPath:@"/fql"
                               parameters:queryParam
                               HTTPMethod:@"GET"
                        completionHandler:^(FBRequestConnection *connection,
                                            id result,
                                            NSError *error) {
                          if (error) {
                            NSLog(@"Error: %@", [error localizedDescription]);
                          } else {
                            NSLog(@"Result: %@", result);
                            NSArray *friendInfo =
                            (NSArray *) [[[result objectForKey:@"data"]
                                          objectAtIndex:1]
                                         objectForKey:@"fql_result_set"];
                            [self showFriends:friendInfo];
                          }
                        }];
}

- (void) showFriends:(NSArray *)friendData
{
  // Set up the view controller that will show friend information
  InviteFriendsViewController *viewController =
  [[InviteFriendsViewController alloc] initWithNibName:nil bundle:nil andFriendArray:self.facebookFriendsArray];
  // Present view controller modally.
  if ([self
       respondsToSelector:@selector(presentViewController:animated:completion:)]) {
    // iOS 5+
    [self presentViewController:viewController animated:YES completion:nil];
  } else {
    [self presentModalViewController:viewController animated:YES];
  }
}

- (IBAction)queryButtonAction:(id)sender {
  FBRequest* friendsRequest = [FBRequest requestForMyFriends];
  [friendsRequest startWithCompletionHandler: ^(FBRequestConnection *connection,
                                                NSDictionary* result,
                                                NSError *error) {
    self.facebookFriendsArray = [result objectForKey:@"data"];
    NSLog(@"Found: %i friends", self.facebookFriendsArray.count);
    [self showFriends:self.facebookFriendsArray];
  }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
  [[NSNotificationCenter defaultCenter] removeObserver:self];

    // Dispose of any resources that can be recreated.
}

@end