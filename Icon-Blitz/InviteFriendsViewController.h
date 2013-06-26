//
//  InviteFriendsViewController.h
//  Icon-Blitz
//
//  Created by Danny on 4/4/13.
//
//

#import <UIKit/UIKit.h>
#import "ServerCallbackDelegate.h"
#import "ProtoHeaders.h"

@class InviteFriendsCell;
@class UserInfo;

@protocol PopViewControllerDelegate <NSObject>

- (void)passUserData:(UserInfo *)userInfo;

@end


@interface InviteFriendsViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, ServerCallbackDelegate>

@property (nonatomic, strong) IBOutlet UITableView *inviteTableView;
@property (nonatomic, strong) IBOutlet InviteFriendsCell *inviteCell;
@property (nonatomic, strong) IBOutlet UIView *spinnerView;
@property (nonatomic, strong) IBOutlet UIActivityIndicatorView *spinner;
@property (nonatomic, strong) UserInfo *userInfo;
@property (nonatomic, strong) BasicUserProto *opponent;
@property (nonatomic, strong) NSArray *friendsData;
@property (nonatomic, strong) NSArray *questions;
@property (nonatomic, strong) NSArray *inviteArray;
@property (nonatomic, strong) NSMutableArray *totalArray;
@property (nonatomic, strong) id<PopViewControllerDelegate> delegate;
@property (nonatomic, assign) int64_t startTime;

- (IBAction)challengeFriend:(UIButton *)sender;
- (IBAction)back:(id)sender;
 - (id)initWithUserInfo:(UserInfo *)userInfo andFriendArray:(NSArray *)friendArray inviteArray:(NSArray *)inviteArray;

@end
