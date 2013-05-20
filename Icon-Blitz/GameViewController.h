//
//  GameViewController.h
//  Icon-Blitz
//
//  Created by Danny on 3/18/13.
//
//

#import <UIKit/UIKit.h>
#import "FontLabel.h"

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

@interface GameViewController : UIViewController {
  NSTimer *gameTimer;
}

@property (nonatomic, assign) int currentQuestion;
@property (nonatomic, assign) int timeLeft;
@property (nonatomic, assign) int points;
@property (nonatomic, assign) QuestionType currentType;
@property (nonatomic, strong) UIViewController *currentController;
@property (nonatomic, strong) UserInfo *userData;
@property (nonatomic, strong) NSMutableArray *questionsId;

@property (nonatomic, strong) IBOutlet UILabel *timeLeftLabel;
@property (nonatomic, strong) IBOutlet UILabel *pointsLabel;
@property (nonatomic, strong) IBOutlet UILabel *rubyLabel;
@property (nonatomic, strong) IBOutlet UIView *questionView;
@property (nonatomic, strong) IBOutlet UIButton *freezeButton;

- (IBAction)skipSelected:(id)sender;
- (IBAction)cheatOneClicked:(id)sender;
- (IBAction)cheatTwoClicked:(id)sender;
- (QuestionType)getQuestiontype;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil userData:(UserInfo *)userData;
- (void)transitionWithConclusion:(BOOL)conclusion skipping:(BOOL)didSkip andNextQuestionType:(QuestionType)type;

@end
