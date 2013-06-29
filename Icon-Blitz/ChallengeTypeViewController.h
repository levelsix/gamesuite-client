//
//  ChallengeTypeViewController.h
//  Icon-Blitz
//
//  Created by Danny on 4/8/13.
//
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "InviteFriendsViewController.h"
#import "ServerCallbackDelegate.h"

@class UserInfo;

typedef enum {
  kStartRoundNone = 10,
  kStartRoundRandom,
  kStartRoundSearch
}StartRoundType;

@protocol PopBackToRootViewDelegate <NSObject>

- (void)passDataBackToRootView:(UserInfo *)userInfo;

@end

@interface ChallengeTypeViewController : UIViewController <FinishFacebookLogin, PopViewControllerDelegate,ServerCallbackDelegate ,UIAlertViewDelegate>

@property (nonatomic, strong) NSMutableArray *facebookData;
@property (nonatomic, strong) UserInfo *userInfo;
@property (nonatomic, strong) IBOutlet UIActivityIndicatorView *spinner;
@property (nonatomic, strong) IBOutlet UILabel *loadingLabel;
@property (nonatomic, strong) IBOutlet UILabel *facebookFriendsLabel;
@property (nonatomic, strong) IBOutlet UIButton *backButton;
@property (nonatomic, strong) id<PopBackToRootViewDelegate> delegate;

- (id)initWithUserInfo:(UserInfo *)userInfo;
- (IBAction)facebookClicked:(UIButton *)sender;
- (IBAction)twitterClicked:(UIButton *)sender;
- (IBAction)userNameClicked:(UIButton *)sender;
- (IBAction)randomClicked:(UIButton *)sender;
- (IBAction)back:(UIButton *)sender;

@end
