//
//  InviteFriendsViewController.h
//  Icon-Blitz
//
//  Created by Danny on 4/4/13.
//
//

#import <UIKit/UIKit.h>

@class InviteFriendsCell;

@interface InviteFriendsViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, retain) IBOutlet UITableView *inviteTableView;
@property (nonatomic, retain) IBOutlet InviteFriendsCell *inviteCell;
@property (nonatomic, retain) NSArray *friendsData;

- (IBAction)challengeFriend:(UIButton *)sender;
- (IBAction)back:(id)sender;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil andFriendArray:(NSArray *)friendArray;

@end
