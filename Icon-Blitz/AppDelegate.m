//
//  AppDelegate.m
//  Icon-Blitz
//
//  Created by Danny on 3/12/13.
//
//

#import "AppDelegate.h"
#import "FacebookObject.h"
#import "HomeViewController.h"
#import "GameViewController.h"
#import "Chartboost.h"
#import "SignUpViewController.h"
#import "HomeViewController.h"
#import "TriviaBlitzIAPHelper.h"
#import "SocketCommunication.h" 
#import "StaticProperties.h"

NSString *const FBSessionStateChangedNotification =
@"com.bestfunfreegames.Icon-Blitz:FBSessionStateChangedNotification";

#define kFirstTime @"FirstTime"

@implementation AppDelegate

/*
 * Callback for session changes.
 */
- (void)sessionStateChanged:(FBSession *)session
                      state:(FBSessionState) state
                      error:(NSError *)error
{
  switch (state) {
    case FBSessionStateOpen:
      if ([self.delegate respondsToSelector:@selector(finishedFBLogin)]) {
        [self.delegate finishedFBLogin];
      }
      break;
    case FBSessionStateClosed:
    case FBSessionStateClosedLoginFailed:
      [FBSession.activeSession closeAndClearTokenInformation];
      break;
    default:
      break;
  }
  
  [[NSNotificationCenter defaultCenter]
   postNotificationName:FBSessionStateChangedNotification
   object:session];
  
  if (error) {
    UIAlertView *alertView = [[UIAlertView alloc]
                              initWithTitle:@"Error"
                              message:error.localizedDescription
                              delegate:nil
                              cancelButtonTitle:@"OK"
                              otherButtonTitles:nil];
    [alertView show];
  }
}

/*
 * Opens a Facebook session and optionally shows the login UX.
 */
- (BOOL)openSessionWithAllowLoginUI:(BOOL)allowLoginUI {
  NSArray *permissions = [[NSArray alloc] initWithObjects:@"email",@"user_birthday", nil];
  return [FBSession openActiveSessionWithReadPermissions:permissions
                                            allowLoginUI:allowLoginUI
                                       completionHandler:^(FBSession *session,
                                                           FBSessionState state,
                                                           NSError *error) {
                                         [self sessionStateChanged:session state:state error:error];
                                       }];
}

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation {
  // attempt to extract a token from the url
  return [FBSession.activeSession handleOpenURL:url];
}

- (void) closeSession {
  [FBSession.activeSession closeAndClearTokenInformation];
}



- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
  [TriviaBlitzIAPHelper sharedInstance];
  self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
  // Override point for customization after application launch.
  
  
  BOOL isLoggedin = [[NSUserDefaults standardUserDefaults] boolForKey:IS_LOGGED_IN];
  if (isLoggedin) {
    self.viewController = [[HomeViewController alloc] initWithNibName:@"HomeViewController" bundle:nil];
    [[self window] setRootViewController:self.viewController];
  }
  else {
    [[self window] setRootViewController:self.navController];
  }
  
  SocketCommunication *sc = [SocketCommunication sharedSocketCommunication];
  [sc initNetworkCommunication];
  
  [self.window makeKeyAndVisible];
  return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
  // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
  // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
  
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
  // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
  
  NSString *currentView = NSStringFromClass([self.navController.visibleViewController class]);
  if ([currentView isEqualToString:@"HomeViewController"]) {
    NSLog(@"refrshing data");
    HomeViewController *vc = (HomeViewController *)self.navController.visibleViewController;
    [vc loginWithToken];
  }
  
  Chartboost *cb = [Chartboost sharedChartboost];
  cb.appId = @"516c632616ba47e621000006";
  cb.appSignature = @"880b5192eaa11e1e9ad617ee5bb55af22ebf31d0";
  
  [cb startSession];
  [cb showInterstitial];
  
  [FBSession.activeSession handleDidBecomeActive];

}

- (void)applicationWillTerminate:(UIApplication *)application
{
  // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
