//
//  TutorialMultipleChoiceViewController.m
//  Icon-Blitz
//
//  Created by Danny on 5/30/13.
//
//

#import "TutorialMultipleChoiceViewController.h"
#import "GameViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "TutorialViewController.h"
#import "MultipleChoiceViewController.h"
#import "FillInTypeViewController.h"
#import "ScoreViewController.h"

@interface TutorialMultipleChoiceViewController ()

@end

@implementation TutorialMultipleChoiceViewController

#pragma mark - DELEGATION

- (void)answerSelection:(BOOL)correct {
  if ([self.delegate respondsToSelector:@selector(multipleChoiceCallBack:)]) {
      [self.delegate multipleChoiceCallBack:correct];
  }
}

- (void)nextLetterCallback {
  if ([self.delegate respondsToSelector:@selector(showNextLetterCallBack)]) {
    [self.delegate showNextLetterCallBack];
  }
}

- (void)fillInAnswerCallBack:(BOOL)correct {
  if ([self.delegate respondsToSelector:@selector(fillInFinishedCallBack:)]) {
    [self.delegate fillInFinishedCallBack:correct];
  }
}

- (void)tutorialCheatClicked {
  if ([self.delegate respondsToSelector:@selector(cheatClicked)]) {
    [self.delegate cheatClicked];
  }
}

- (void)tutorialFreezeClicked {
  if ([self.delegate respondsToSelector:@selector(freezeClicked)]) {
    [self.delegate freezeClicked];
  }
}

#pragma mark - Changing Views and other methods

- (void)viewDidLoad
{
  [super viewDidLoad];
  self.gameView = [[GameViewController alloc] initWithTutorial];
  [self.view addSubview:self.gameView.view];
  
  if ([self.gameView.gameTimer isValid]) {
    [self.gameView.gameTimer invalidate];
  }
  self.gameView.delegate = self;
}

- (void)pushToIconFillInTutorialView {
  [self.gameView pushToTutorialFillInIconView];
}

- (void)pushToLastQuestion {
  [self.gameView pushtoLastQuestion];
}

- (void)pushToFillInView {
  [self.gameView pushNewViewControllersWithType:kFillIn];
}

- (void)pushToLyricsView {
  [self.gameView pushToLyricsView];
}

- (void)enableGameTimer {
  [self.gameView enableTimer];
}

- (CGPoint)getFillInLettersCenter:(int)answerTag {
  FillInTypeViewController *vc = (FillInTypeViewController *)self.gameView.currentController;
  UIView *letter = [vc.view viewWithTag:answerTag];
  [self.gameView disableLetterInteraction:answerTag];
  letter.userInteractionEnabled = YES;
  return letter.center;
}

- (CGPoint)getCorrectMultipleChoiceCenter:(int)answerTag {
  MultipleChoiceViewController *vc = (MultipleChoiceViewController *)self.gameView.currentController;
  CGPoint center;
  switch (answerTag) {
    case 1:
      center = vc.answerAView.center;
      break;
      
    case 2:
      center = vc.answerBView.center;
      break;
      
    case 3:
      center = vc.answerCView.center;
      break;
   
    case 4:
      center = vc.answerCView.center;
      break;
      
    default:
      break;
  }
  return center;
}


- (void)disableButtons {
  self.gameView.freezeButton.userInteractionEnabled = NO;
  self.gameView.skipButton.userInteractionEnabled = NO;
  self.gameView.removeCheatButon.userInteractionEnabled = NO;
}

- (void)enableButtons {
  self.gameView.freezeButton.userInteractionEnabled = YES;
  self.gameView.skipButton.userInteractionEnabled = YES;
  self.gameView.removeCheatButon.userInteractionEnabled = YES;
}


@end
