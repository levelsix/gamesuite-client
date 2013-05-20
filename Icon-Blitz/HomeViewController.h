//
//  HomeViewController.h
//  Icon-Blitz
//
//  Created by Danny on 3/20/13.
//
//

#import <UIKit/UIKit.h>
#import "ProtoHeaders.h"
#import "Utilities.h"
#import <iAd/iAd.h>

typedef enum {
  kNewGame = 0,
  kYourTurn,
  kTheirTurn,
  kCompletedGames,
  kOtherStuff
}SectionTypes;

@class StartGameCell;
@class TurnCells;
@class LastCell;
@class ShopMenu;
@class UserInfo;

@interface HomeViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, UIAlertViewDelegate, ADBannerViewDelegate>

@property (nonatomic, strong) IBOutlet UITableView *tableView;
@property (nonatomic, strong) IBOutlet StartGameCell *startCell;
@property (nonatomic, strong) IBOutlet TurnCells *turnCell;
@property (nonatomic, strong) IBOutlet LastCell *lastCell;
@property (nonatomic, strong) IBOutlet ShopMenu *shopMenu;
@property (nonatomic, strong) IBOutlet UILabel *coinTimeLabel;
@property (nonatomic, strong) IBOutlet UILabel *rubyLabel;
@property (nonatomic, strong) NSArray *completedGames;
@property (nonatomic, strong) NSArray *myTurns;
@property (nonatomic, strong) NSArray *notMyTurns;
@property (nonatomic, strong) NSArray *questions;
@property (nonatomic, strong) NSMutableArray *wholeArray;
@property (nonatomic, strong) LoginResponseProto *loginProto;
@property (nonatomic, strong) UserInfo *userInfo;

@property (nonatomic) BOOL inAppPurchasedLoaded;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil event:(LoginResponseProto *)proto;
- (IBAction)startNewGame:(id)sender;
- (IBAction)goToGame:(id)sender;
- (IBAction)goToShop:(id)sender;
- (IBAction)closeView:(id)sender;

- (void)updateGoldCoin:(int)value;
- (void)updateRuby:(int)value;

@end
