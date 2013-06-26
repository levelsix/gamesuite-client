//
//  ScoreViewController.h
//  Icon-Blitz
//
//  Created by Danny on 4/19/13.
//
//

#import <UIKit/UIKit.h>
#import "ProtoHeaders.h"

@class UserInfo;

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

@property (nonatomic, assign) int userScore;
@property (nonatomic, strong) UIActivityIndicatorView *spinner;
@property (nonatomic, strong) GameResultsProto *proto;
@property (nonatomic, strong) BasicUserProto *userProto;
@property (nonatomic, strong) UserInfo *userInfo;
@property (nonatomic, strong) OngoingGameProto *gameStats;
@property (nonatomic, strong) GameResultsProto *completedGameStats;

- (id)initWithOngoingGameProto:(OngoingGameProto *)gameStats userInfo:(UserInfo *)userInfo myTurn:(BOOL)isMyTurn;
- (id)initWithGameResultsProto:(GameResultsProto *)completedGames userInfo:(UserInfo *)userInfo;
- (id)initWithRoundOneUserInfo:(UserInfo *)userInfo completedRoundResponse:(CompletedRoundResponseProto *)proto;

- (void)receievedRetrieveScoreResponse:(Class)proto;
- (IBAction)done:(id)sender;
- (IBAction)back:(id)sender;

@end
