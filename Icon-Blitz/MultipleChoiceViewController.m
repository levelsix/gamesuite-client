//
//  MultipleChoiceViewController.m
//  Icon-Blitz
//
//  Created by Danny on 4/4/13.
//
//

#import "MultipleChoiceViewController.h"
#import "UserInfo.h"

@interface MultipleChoiceViewController () {
  CGPoint originalCenter;
  UIView *touchedView;
  BOOL dragging;
  int usedCount;
}

@end

@implementation MultipleChoiceViewController

+ (id)initWithGameInfo:(GameViewController *)game {
  return [[self alloc] initWithGame:game];
}

- (id)initWithGame:(GameViewController *)game {
  if ((self = [super init])) {
    self.game = game;
    self.correctChoice = kChoiceA;
    self.takenAwayAnswers = [[NSMutableArray alloc] init];
    question = (MultipleChoiceQuestionProto *)[self.game.userData.questions objectAtIndex:self.game.currentQuestion];
    //[self implementInfo];
  }
  return self;
}

- (void)implementInfo {
  self.questionLabel.text = question.question;
  [self.game.questionsId addObject:question.id];
  
  //looks like bad practice, but i have to do it this way
    
  MultipleChoiceAnswerProto *answer = [question.answersList objectAtIndex:0];
  self.answerALabel.text = answer.answer;
  
  if ([answer.id isEqualToString:question.answerId]) {
    self.correctChoice = kChoiceA;
  }
  
  answer = [question.answersList objectAtIndex:1];
  self.answerBLabel.text = answer.answer;
  
  if ([answer.id isEqualToString:question.answerId]) {
    self.correctChoice = kChoiceB;
  }

  answer = [question.answersList objectAtIndex:2];
  self.answerCLabel.text = answer.answer;
  
  if ([answer.id isEqualToString:question.answerId]) {
    self.correctChoice = kChoiceC;
  }
  
  answer = [question.answersList objectAtIndex:3];
  self.answerDLabel.text = answer.answer;
  
  if ([answer.id isEqualToString:question.answerId]) {
    self.correctChoice = kChoiceD;
  }
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
  //QuestionType type = [self.game getQuestiontype];

  if (selectedAnswer == self.correctChoice) {
    [self.game transitionWithConclusion:YES skipping:NO andNextQuestionType:kFillIn];
  }else {
    [self.game transitionWithConclusion:NO skipping:NO andNextQuestionType:kMultipleChoice];
  }
}

- (void)removeOptions {
  if (usedCount == 3) {
    return;
  }
  int random;
  int tag = 0;
  if (self.takenAwayAnswers.count == 0) {
    do {
      random = 1 + arc4random() % 4;
      tag++;
      NSLog(@"%d",self.correctChoice);
      NSLog(@"%d",random);
      [self.takenAwayAnswers addObject:[NSNumber numberWithInt:random]];
      [self takeAwayOptionsWithTag:random];
    } while (random != self.correctChoice);
  }
  else {
    BOOL repeated;
    do {
      random = 1 + arc4random() % 4;
      for (NSNumber *removed in self.takenAwayAnswers) {
        if ([removed integerValue] == random) {
          repeated = YES;
        }
      }
      tag++;
      if (tag == 1) {
        usedCount++;
        [self.takenAwayAnswers addObject:[NSNumber numberWithInt:random]];
        [self takeAwayOptionsWithTag:random];
        break;
      }
    } while (random != self.correctChoice || !repeated);
  }
}

- (void)takeAwayOptionsWithTag:(int)tag {
  switch (tag) {
    case kChoiceA:
      self.answerAView.hidden = YES;
      self.answerALabel.hidden = YES;
      self.answerABottom.hidden = YES;
      break;
      
    case kChoiceB:
      self.answerBView.hidden = YES;
      self.answerBLabel.hidden = YES;
      self.answerBBottom.hidden = YES;
      break;
      
    case kChoiceC:
      self.answerCView.hidden = YES;
      self.answerCLabel.hidden = YES;
      self.answerCBottom.hidden = YES;
      break;
      
    case kChoiceD:
      self.answerDView.hidden = YES;
      self.answerDLabel.hidden = YES;
      self.answerDBottom.hidden = YES;

      break;
      
    default:
      break;
  }
}


@end
