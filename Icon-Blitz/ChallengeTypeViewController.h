//
//  ChallengeTypeViewController.h
//  Icon-Blitz
//
//  Created by Danny on 4/8/13.
//
//

#import <UIKit/UIKit.h>

@class UserInfo;

@interface ChallengeTypeViewController : UIViewController {

}

@property (nonatomic, strong) NSMutableArray *facebookData;
@property (nonatomic, assign) BOOL loaded;
@property (nonatomic, strong) UserInfo *userInfo;
@property (nonatomic, strong) NSArray *questions;
@property (nonatomic, strong) NSArray *facebookFriends;

- (id)initWithQuestions:(NSArray *)questions facebookFriends:(NSArray *)facebookFriends userInfo:(UserInfo *)userInfo;
- (IBAction)facebookClicked:(UIButton *)sender;
- (IBAction)twitterClicked:(UIButton *)sender;
- (IBAction)userNameClicked:(UIButton *)sender;
- (IBAction)randomClicked:(UIButton *)sender;
- (IBAction)back:(UIButton *)sender;

@end
