//
//  FriendsViewController.h
//  Icon-Blitz
//
//  Created by Danny on 3/14/13.
//
//

#import <UIKit/UIKit.h>

@interface FriendsViewController : UIViewController <UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) NSArray *friendsData;
@property (nonatomic, strong) IBOutlet UITableView *myTableView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil andData:(NSArray *)data;
@end
