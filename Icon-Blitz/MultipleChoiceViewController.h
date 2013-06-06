//
//  MultipleChoiceViewController.h
//  Icon-Blitz
//
//  Created by Danny on 4/4/13.
//
//

#import <UIKit/UIKit.h>
#import "ProtoHeaders.h"
#import "GameViewController.h"

typedef enum {
  kChoiceA = 1,
  kChoiceB,
  kChoiceC,
  kChoiceD
}MultipleChoices;

@interface MultipleChoiceViewController : UIViewController {
  NSString *answerAString;
  NSString *answerBString;
  NSString *answerCString;
  NSString *answerDString;
  MultipleChoices selectedAnswer;
  MultipleChoiceQuestionProto *question;

  BOOL selected;
}

@property (nonatomic, strong) NSDictionary *tutorialQuestion;

- (id)initWithGame:(GameViewController *)game;
- (id)initWithTutorial:(GameViewController *)game question:(NSDictionary *)tutorialQuestion;

@property (nonatomic, assign) MultipleChoices correctChoice;
@property (nonatomic, strong) GameViewController *game;
@property (nonatomic, strong) IBOutlet UIView *answerAView;
@property (nonatomic, strong) IBOutlet UIView *answerBView;
@property (nonatomic, strong) IBOutlet UIView *answerCView;
@property (nonatomic, strong) IBOutlet UIView *answerDView;
@property (nonatomic, strong) IBOutlet UILabel *answerALabel;
@property (nonatomic, strong) IBOutlet UILabel *answerBLabel;
@property (nonatomic, strong) IBOutlet UILabel *answerCLabel;
@property (nonatomic, strong) IBOutlet UILabel *answerDLabel;
@property (nonatomic, strong) IBOutlet UIImageView *answerABottom;
@property (nonatomic, strong) IBOutlet UIImageView *answerBBottom;
@property (nonatomic, strong) IBOutlet UIImageView *answerCBottom;
@property (nonatomic, strong) IBOutlet UIImageView *answerDBottom;
@property (nonatomic, strong) IBOutlet UILabel *questionLabel;

- (void)removeOptions;

@end
