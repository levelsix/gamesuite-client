//
//  MultipleChoiceViewController.h
//  Icon-Blitz
//
//  Created by Danny on 4/4/13.
//
//

#import <UIKit/UIKit.h>
#import "FontLabel.h"

@class GameViewController;

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
  BOOL selected;
}

+ (id)initWithGameInfo:(GameViewController *)game;
- (id)initWithGame:(GameViewController *)game;

@property (nonatomic, retain) GameViewController *game;
@property (nonatomic, retain) IBOutlet UIView *answerAView;
@property (nonatomic, retain) IBOutlet UIView *answerBView;
@property (nonatomic, retain) IBOutlet UIView *answerCView;
@property (nonatomic, retain) IBOutlet UIView *answerDView;
@property (nonatomic, retain) IBOutlet UILabel *answerALabel;
@property (nonatomic, retain) IBOutlet UILabel *answerBLabel;
@property (nonatomic, retain) IBOutlet UILabel *answerCLabel;
@property (nonatomic, retain) IBOutlet UILabel *answerDLabel;
@property (nonatomic, retain) IBOutlet UILabel *questionLabel;
@property (nonatomic, assign) MultipleChoices correctChoice;
@property (nonatomic, retain) NSDictionary *answerInfo;

- (void)implementInfo;
- (void)removeOptions;

@end
