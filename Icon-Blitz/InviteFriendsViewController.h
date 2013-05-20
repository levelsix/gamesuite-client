//
//  InviteFriendsViewController.h
//  Icon-Blitz
//
//  Created by Danny on 4/4/13.
//
//

#import <UIKit/UIKit.h>

@class InviteFriendsCell;
@class UserInfo;

@interface InviteFriendsViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) IBOutlet UITableView *inviteTableView;
@property (nonatomic, strong) IBOutlet InviteFriendsCell *inviteCell;
@property (nonatomic, strong) NSArray *friendsData;
@property (nonatomic, strong) UserInfo *userInfo;

- (IBAction)challengeFriend:(UIButton *)sender;
- (IBAction)back:(id)sender;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil userInfo:(UserInfo *)userInfo andFriendArray:(NSArray *)friendArray;

@end
