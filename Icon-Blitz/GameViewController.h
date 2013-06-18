//
//  GameViewController.h
//  Icon-Blitz
//
//  Created by Danny on 3/18/13.
//
//

#import <UIKit/UIKit.h>
#import "FontLabel.h"
#import "ServerCallbackDelegate.h"
#import "ProtoHeaders.h"

#define FreezeCost 10
#define CheatCost 10

@protocol TutorialAnswerDelegate <NSObject>

@optional
- (void)answerSelection:(BOOL)correct;
- (void)nextLetterCallback;
- (void)fillInAnswerCallBack:(BOOL)correct;
- (void)tutorialCheatClicked;
- (void)tutorialFreezeClicked;
@end

typedef enum {
  kMultipleChoice = 1,
  kFillIn
}QuestionType;

typedef enum {
  kPointType = 5,
  kTimeType,
  kRubyType
}NumberType;

@class HomeViewController;
@class UserInfo;

@interface GameViewController : UIViewController <ServerCallbackDelegate> 

@property (nonatomic, assign) int currentQuestion;
@property (nonatomic, assign) int timeLeft;
@property (nonatomic, assign) int points;
@property (nonatomic, assign) BOOL isTutorial;
@property (nonatomic, assign) QuestionType currentType;
@property (nonatomic, strong) UserInfo *userData;
@property (nonatomic, strong) UnfinishedRoundProto *proto;
@property (nonatomic, strong) UIViewController *currentController;
@property (nonatomic, strong) NSArray *questions;
@property (nonatomic, strong) NSMutableArray *questionsId;
@property (nonatomic, strong) NSString *gameId;

@property (nonatomic, strong) IBOutlet UILabel *triviaType;
@property (nonatomic, strong) IBOutlet UIView *triviaContainer;
@property (nonatomic, strong) IBOutlet UILabel *timeLeftLabel;
@property (nonatomic, strong) IBOutlet UILabel *pointsLabel;
@property (nonatomic, strong) IBOutlet UILabel *rubyLabel;
@property (nonatomic, strong) IBOutlet UILabel *freezeCountDownLabel;
@property (nonatomic, strong) IBOutlet UIView *questionView;
@property (nonatomic, strong) IBOutlet UIButton *freezeButton;
@property (nonatomic, strong) IBOutlet UIButton *removeCheatButon;
@property (nonatomic, strong) IBOutlet UIButton *skipButton;
@property (nonatomic, strong) IBOutlet UIImageView *timerImage;
@property (nonatomic, strong) IBOutlet UILabel *freezeCost;
@property (nonatomic, strong) IBOutlet UILabel *optionCost;
@property (nonatomic, strong) NSTimer *gameTimer;
@property (nonatomic, strong) id<TutorialAnswerDelegate> delegate;

           
- (IBAction)skipSelected:(id)sender;
- (IBAction)cheatOneClicked:(id)sender;
- (IBAction)cheatTwoClicked:(id)sender;
- (QuestionType)getQuestiontype;
- (void)animateTriviaTypeLabel;

- (id)initWithTutorial;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil userData:(UserInfo *)userData;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil userData:(UserInfo *)userData gameId:(NSString *)gameId;

- (void)transitionWithConclusion:(BOOL)conclusion skipping:(BOOL)didSkip andNextQuestionType:(QuestionType)type;

//tutorial methods
- (void)tutorialCorrectionAnimationWithCorrect:(BOOL)isCorrect fromQuestionType:(QuestionType)type;
- (void)animatePointsLabel;
- (void)pushNewViewControllersWithType:(QuestionType)type;
- (void)showNextLetterCallBack;
- (void)resetLettersOnTutorial;
- (void)pushToTutorialFillInIconView;
- (void)pushToLyricsView;
- (void)disableLetterInteraction:(int)tag;
- (void)pushtoLastQuestion;
- (void)enableTimer;
@end
