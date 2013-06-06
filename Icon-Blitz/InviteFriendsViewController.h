//
//  InviteFriendsViewController.h
//  Icon-Blitz
//
//  Created by Danny on 4/4/13.
//
//

#import <UIKit/UIKit.h>
#import "ServerCallbackDelegate.h"

@class InviteFriendsCell;
@class UserInfo;

@interface InviteFriendsViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, ServerCallbackDelegate>

@property (nonatomic, strong) IBOutlet UITableView *inviteTableView;
@property (nonatomic, strong) IBOutlet InviteFriendsCell *inviteCell;
@property (nonatomic, strong) NSArray *friendsData;
@property (nonatomic, strong) UserInfo *userInfo;
@property (nonatomic, strong) NSArray *questions;

- (IBAction)challengeFriend:(UIButton *)sender;
- (IBAction)back:(id)sender;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil userInfo:(UserInfo *)userInfo andFriendArray:(NSArray *)friendArray;
- (id)initWithQuestions:(NSArray *)questions userInfo:(UserInfo *)userInfo andFriendArray:(NSArray *)friendArray;
@end
