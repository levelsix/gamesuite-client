//
//  ScoreViewController.h
//  Icon-Blitz
//
//  Created by Danny on 4/19/13.
//
//

#import <UIKit/UIKit.h>
#import "ProtoHeaders.h"

typedef enum {
  kNewGameState = 100,
  kOnGoingGameState,
  kCompletedGameState,
  kStateNone
}ScoreStates;

@class UserInfo;
@class ScoreShopMenu;

@interface ScoreViewController : UIViewController

@property (nonatomic, strong) IBOutlet UIImageView *userImage;
@property (nonatomic, strong) IBOutlet UIImageView *opponentImage;
@property (nonatomic, strong) IBOutlet UIImageView *spinningBackground;
@property (nonatomic, strong) IBOutlet UIButton *backButton;
@property (nonatomic, strong) IBOutlet UILabel *userName;
@property (nonatomic, strong) IBOutlet UILabel *opponentName;
@property (nonatomic, strong) IBOutlet UILabel *userRoundOneScore;
@property (nonatomic, strong) IBOutlet UILabel *opponentRoundOneScore;
@property (nonatomic, strong) IBOutlet UILabel *userRoundTwoScore;
@property (nonatomic, strong) IBOutlet UILabel *opponentRoundTwoScore;
@property (nonatomic, strong) IBOutlet UILabel *userRoundThreeScore;
@property (nonatomic, strong) IBOutlet UILabel *opponentRoundThreeScore;
@property (nonatomic, strong) IBOutlet UILabel *userTotalScore;
@property (nonatomic, strong) IBOutlet UILabel *opponentTotalScore;
@property (nonatomic, strong) IBOutlet UILabel *whosTurn;
@property (nonatomic, strong) IBOutlet UILabel *doneLabel;
@property (nonatomic, strong) IBOutlet UILabel *backLabel;
@property (nonatomic, strong) IBOutlet UIView *buyMoreRubyView;
@property (nonatomic, strong) IBOutlet UIImageView *glow;
@property (nonatomic, strong) IBOutlet ScoreShopMenu *shopMenu;

@property (nonatomic, assign) int userScore;
@property (nonatomic, strong) UIActivityIndicatorView *spinner;
@property (nonatomic, strong) GameResultsProto *proto;
@property (nonatomic, strong) BasicUserProto *userProto;
@property (nonatomic, strong) UserInfo *userInfo;
@property (nonatomic, strong) OngoingGameProto *gameStats;
@property (nonatomic, strong) GameResultsProto *completedGameStats;
@property (nonatomic, strong) CompletedRoundResponseProto *completedRoundResponse;

- (id)initWithOngoingGameProto:(OngoingGameProto *)gameStats userInfo:(UserInfo *)userInfo myTurn:(BOOL)isMyTurn;
- (id)initWithGameResultsProto:(GameResultsProto *)completedGames userInfo:(UserInfo *)userInfo;
- (id)initWithNewGameUserInfo:(UserInfo *)userInfo completedRoundResponse:(CompletedRoundResponseProto *)proto needRubies:(BOOL)needRubies;

- (void)receievedRetrieveScoreResponse:(Class)proto;
- (IBAction)done:(id)sender;
- (IBAction)back:(id)sender;
- (IBAction)closeShopView:(id)sender;
- (IBAction)goToShop:(id)sender;

- (void)updateGoldCoins:(int)amount;
- (void)updateRubies:(int)amount;

@end
