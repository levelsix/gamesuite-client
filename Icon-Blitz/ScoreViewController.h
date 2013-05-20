//
//  ScoreViewController.h
//  Icon-Blitz
//
//  Created by Danny on 4/19/13.
//
//

#import <UIKit/UIKit.h>
#import "ProtoHeaders.h"

@interface ScoreViewController : UIViewController {
  int uScoreOne;
  int uScoreTwo;
  int uScoreThree;
  int oScoreOne;
  int oScoreTwo;
  int oScoreThree;
  int uTotalScore;
  int oTotalScore;
}

@property (nonatomic, assign) int userScore;
@property (nonatomic, strong) UIActivityIndicatorView *spinner;
@property (nonatomic, strong) IBOutlet UIImageView *userImage;
@property (nonatomic, strong) IBOutlet UIImageView *opponentImage;
@property (nonatomic, strong) IBOutlet UIImageView *spinningBackground;
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
@property (nonatomic, strong) GameResultsProto *proto;
@property (nonatomic, strong) BasicUserProto *userProto;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil gameResultProto:(GameResultsProto *)proto basicUserProto:(BasicUserProto *)userProto completed:(BOOL)completed currentRound:(int)round;
- (void)receievedRetrieveScoreResponse:(Class)proto;
- (IBAction)done:(id)sender;
- (IBAction)back:(id)sender;

@end
