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
#import "TutorialViewController.h"

NSString *const FBSessionStateChangedNotification =
@"com.bestfunfreegames.Icon-Blitz:FBSessionStateChangedNotification";

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
      if ([self.delegate respondsToSelector:@selector(finishedFBLoginWithAllowAccess:)]) {
        [self.delegate finishedFBLoginWithAllowAccess:YES];
      }
      break;
    case FBSessionStateClosed:
    case FBSessionStateClosedLoginFailed:
      if ([self.delegate respondsToSelector:@selector(finishedFBLoginWithAllowAccess:)]) {
        [self.delegate finishedFBLoginWithAllowAccess:NO];
      }
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
    //self.viewController  = [[TutorialViewController alloc] initWithNibName:@"TutorialViewController" bundle:nil];
    //self.viewController = [[GameViewController alloc] initWithNibName:nil bundle:nil];
  }
  else {
    self.viewController = [[SignUpViewController alloc] initWithNibName:@"SignUpViewController" bundle:nil];
  }
  self.navController = [[UINavigationController alloc] initWithRootViewController:self.viewController];
  self.window.rootViewController = self.navController;

  self.navController.navigationBar.hidden = YES;
  
  SocketCommunication *sc = [SocketCommunication sharedSocketCommunication];
  [sc initNetworkCommunication];
  
  [[UIApplication sharedApplication] registerForRemoteNotificationTypes:
   (UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeAlert)];
  
  [self.window makeKeyAndVisible];
  return YES;
}

- (void)application:(UIApplication*)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData*)deviceToken
{
	NSLog(@"My token is: %@", deviceToken);
}

- (void)application:(UIApplication*)application didFailToRegisterForRemoteNotificationsWithError:(NSError*)error
{
	NSLog(@"Failed to get token, error: %@", error);
}

- (void)applicationWillResignActive:(UIApplication *)application
{
  
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
  SocketCommunication *sc = [SocketCommunication sharedSocketCommunication];
  [sc sendLogoutRequest];

  BOOL isLoggedin = [[NSUserDefaults standardUserDefaults] boolForKey:IS_LOGGED_IN];
  BOOL changedRootViewOnce = [[NSUserDefaults standardUserDefaults] boolForKey:CHANGED_ROOT_ONCE];
  if (isLoggedin && !changedRootViewOnce) {
    UIViewController *rootViewController = self.navController.viewControllers[0];
    NSString *classString =  NSStringFromClass([rootViewController class]);
    if (![classString isEqualToString:@"HomeViewController"]) {
      self.viewController = [[HomeViewController alloc] initWithNibName:@"HomeViewController" bundle:nil];
      self.navController = [[UINavigationController alloc] initWithRootViewController:self.viewController];
      self.window.rootViewController = self.navController;
      self.navController.navigationBar.hidden = YES;
      [[NSUserDefaults standardUserDefaults] setBool:YES forKey:CHANGED_ROOT_ONCE];
    }
  }

  NSString *currentView = NSStringFromClass([self.navController.visibleViewController class]);
  if (![currentView isEqualToString:@"HomeViewController"]) {
    [self.navController popToRootViewControllerAnimated:NO];
  }
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
  
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
  // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
  
  NSString *currentView = NSStringFromClass([self.navController.visibleViewController class]);
  if ([currentView isEqualToString:@"HomeViewController"]){
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
  SocketCommunication *sc = [SocketCommunication sharedSocketCommunication];
  [sc sendLogoutRequest];}

- (void)forceLogout {
  [self.navController popToRootViewControllerAnimated:NO];
}

@end
