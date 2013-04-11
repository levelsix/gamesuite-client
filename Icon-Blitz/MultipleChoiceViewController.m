//
//  MultipleChoiceViewController.m
//  Icon-Blitz
//
//  Created by Danny on 4/4/13.
//
//

#import "MultipleChoiceViewController.h"
#import "GameViewController.h"

@interface MultipleChoiceViewController () {
  CGPoint originalCenter;
  UIView *touchedView;
  BOOL dragging;
}

@end

@implementation MultipleChoiceViewController

+ (id)initWithGameInfo:(GameViewController *)game {
  return [[[self alloc] initWithGame:game] autorelease];
}

- (id)initWithGame:(GameViewController *)game {
  if ((self = [super init])) {
    self.game = game;
    self.correctChoice = kChoiceA;
    //[self implementInfo];
  }
  return self;
}


- (void)implementInfo {
  self.answerInfo = [self.game.gameData objectAtIndex:self.game.currentQuestion];
  self.correctChoice = [[self.answerInfo objectForKey:@"CorrectAnswer"] integerValue];
  self.questionLabel.text = [self.answerInfo objectForKey:@"QuestionString"];
  self.answerALabel.text = [self.answerInfo objectForKey:@"AnswerAString"];
  self.answerBLabel.text = [self.answerInfo objectForKey:@"AnswerBString"];
  self.answerCLabel.text = [self.answerInfo objectForKey:@"AnswerCString"];
  self.answerDLabel.text = [self.answerInfo objectForKey:@"AnswerDString"];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
  UITouch *touch = [[event allTouches] anyObject];
  CGPoint touchLocation = [touch locationInView:self.view];
  selected  = YES;
  if (CGRectContainsPoint(self.answerAView.frame, touchLocation)) {
    selectedAnswer = kChoiceA;
    originalCenter = self.answerAView.center;
    touchedView = self.answerAView;
  }else if (CGRectContainsPoint(self.answerBView.frame, touchLocation)) {
    selectedAnswer = kChoiceB;
    originalCenter = self.answerBView.center;
    touchedView = self.answerBView;
  }
  else if (CGRectContainsPoint(self.answerCView.frame, touchLocation)) {
    selectedAnswer = kChoiceC;
    originalCenter = self.answerCView.center;
    touchedView = self.answerCView;
  }
  else if (CGRectContainsPoint(self.answerDView.frame, touchLocation)) {
    selectedAnswer = kChoiceD;
    originalCenter = self.answerDView.center;
    touchedView = self.answerDView;
  }
  [self moveTouchedView];
}

- (void)moveTouchedView{
  [UIView animateWithDuration:0.05 animations:^{
    touchedView.center = CGPointMake(touchedView.center.x, touchedView.center.y+4);
  }];
}

- (void)resumeTouchedView {
  [UIView animateWithDuration:0.05 animations:^{
    touchedView.center = originalCenter;
  }];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
  dragging = YES;
  selected = NO;
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
  if (selected) {
    [self checkCorrectAnswer];
    selected = NO;
  }
  if (dragging) {
    [self resumeTouchedView];
    dragging = NO;
  }
  touchedView = nil;
  
}

- (void)checkCorrectAnswer {
  if (selectedAnswer == self.correctChoice) {
    [self.game transitionWithConclusion:YES skipping:NO andNextQuestionType:kFillIn];
  }else {
    [self.game transitionWithConclusion:NO skipping:NO andNextQuestionType:kMultipleChoice];
  }
}

- (void)removeOptions {
  
}


@end
