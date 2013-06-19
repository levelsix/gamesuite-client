//
//  ChallengeTypeViewController.h
//  Icon-Blitz
//
//  Created by Danny on 4/8/13.
//
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

@class UserInfo;

@interface ChallengeTypeViewController : UIViewController <FinishFacebookLogin> {

}

@property (nonatomic, strong) NSMutableArray *facebookData;
@property (nonatomic, strong) UserInfo *userInfo;
@property (nonatomic, strong) IBOutlet UIActivityIndicatorView *spinner;

- (id)initWithUserInfo:(UserInfo *)userInfo;
- (IBAction)facebookClicked:(UIButton *)sender;
- (IBAction)twitterClicked:(UIButton *)sender;
- (IBAction)userNameClicked:(UIButton *)sender;
- (IBAction)randomClicked:(UIButton *)sender;
- (IBAction)back:(UIButton *)sender;

@end
