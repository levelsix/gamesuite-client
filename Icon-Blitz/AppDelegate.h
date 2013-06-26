//
//  AppDelegate.h
//  Icon-Blitz
//
//  Created by Danny on 3/12/13.
//
//

#import <UIKit/UIKit.h>
#import <FacebookSDK/FacebookSDK.h>

@protocol FinishFacebookLogin <NSObject>

- (void)finishedFBLogin;
@end

@class HomeViewController;

extern NSString *const FBSessionStateChangedNotification;

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) IBOutlet UIWindow *window;
@property (nonatomic, strong) UINavigationController *navController;
@property (strong, nonatomic) UIViewController *viewController;
@property (nonatomic, weak) id delegate;
- (BOOL)openSessionWithAllowLoginUI:(BOOL)allowLoginUI;
- (void) closeSession;

@end
