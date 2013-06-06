//
//  TutorialMultipleChoiceViewController.h
//  Icon-Blitz
//
//  Created by Danny on 5/30/13.
//
//

#import <UIKit/UIKit.h>
#import "GameViewController.h"

@protocol CallMainTutorialViewDelegate <NSObject>


@optional
- (void)showNextLetterCallBack;
- (void)multipleChoiceCallBack:(BOOL)correct;
- (void)fillInFinishedCallBack:(BOOL)correct;
- (void)cheatClicked;
@end

@interface TutorialMultipleChoiceViewController : UIViewController <TutorialAnswerDelegate>

@property (nonatomic, strong) GameViewController *gameView;
@property (nonatomic, strong) id<CallMainTutorialViewDelegate> delegate;

- (CGPoint)getCorrectMultipleChoiceCenter:(int)answerTag;
- (CGPoint)getFillInLettersCenter:(int)answerTag;
- (void)disableButtons;
- (void)enableButtons;
- (void)pushToFillInView;
- (void)pushToLyricsView;

@end
