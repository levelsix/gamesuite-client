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
@class FillInViewController;
@class MultipleChoiceViewController;

@interface GameViewController : UIViewController {
  NSTimer *gameTimer;
}

@property (nonatomic, assign) int currentQuestion;
@property (nonatomic, assign) int timeLeft;
@property (nonatomic, assign) int points;
@property (nonatomic, retain) NSArray *gameData;
@property (nonatomic, assign) QuestionType currentType;
@property (nonatomic, retain) UIViewController *currentController;

@property (nonatomic, retain) IBOutlet UILabel *timeLeftLabel;
@property (nonatomic, retain) IBOutlet UILabel *pointsLabel;
@property (nonatomic, retain) IBOutlet UIView *questionView;
@property (nonatomic, retain) IBOutlet UIButton *freezeButton;

- (IBAction)skipSelected:(id)sender;
- (IBAction)cheatOneClicked:(id)sender;
- (IBAction)cheatTwoClicked:(id)sender;

- (void)transitionWithConclusion:(BOOL)conclusion skipping:(BOOL)didSkip andNextQuestionType:(QuestionType)type;
@end
