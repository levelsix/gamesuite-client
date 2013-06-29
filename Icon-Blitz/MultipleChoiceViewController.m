//
//  MultipleChoiceViewController.m
//  Icon-Blitz
//
//  Created by Danny on 4/4/13.
//
//

#import "MultipleChoiceViewController.h"
#import "UserInfo.h"

#define Fade_Out_Duration 0.5f

@interface MultipleChoiceViewController () {
  CGPoint originalCenter;
  UIView *touchedView;
  BOOL dragging;
  int usedCount;
  NSMutableArray *cheatArray;
  NSMutableArray *usedCheatArray;
  BOOL selecteNewAnswer;
  BOOL isTutorialView;
}

@end

@implementation MultipleChoiceViewController

- (id)initWithTutorial:(GameViewController *)game question:(NSDictionary *)tutorialQuestion {
  if (self == [super init]) {
    self.game = game ;
    isTutorialView = YES;
    self.tutorialQuestion = tutorialQuestion;
  }
  return self;
}

- (id)initWithGame:(GameViewController *)game {
  if (self == [super init]) {
    self.game = game;
    self.correctChoice = kChoiceA;
    [self setUpCheatArray];
    question = (MultipleChoiceQuestionProto *)[self.game.userData.questions objectAtIndex:self.game.currentQuestion];
  }
  return self;
}

- (void)setUpTutorialQuestion {
  self.correctChoice = [[self.tutorialQuestion objectForKey:@"correctChoice"]integerValue];
  self.questionLabel.text = [self.tutorialQuestion objectForKey:@"question"];
  self.answerALabel.text = [self.tutorialQuestion objectForKey:@"answerA"];
  self.answerBLabel.text = [self.tutorialQuestion objectForKey:@"answerB"];
  self.answerCLabel.text = [self.tutorialQuestion objectForKey:@"answerC"];
  self.answerDLabel.text = [self.tutorialQuestion objectForKey:@"answerD"];
  [self setUpCheatArray];
}

- (void)viewDidLoad {
  if (isTutorialView) {
    [self setUpTutorialQuestion];
  }
}

- (void)viewDidAppear:(BOOL)animated {
  self.game.removeCheatButon.userInteractionEnabled = YES;
}

- (void)setUpCheatArray {
  usedCheatArray = [NSMutableArray array];
  switch (self.correctChoice) {
    case kChoiceA:
      cheatArray = [[NSMutableArray alloc] initWithObjects:[NSNumber numberWithInt:kChoiceB], [NSNumber numberWithInt:kChoiceC], [NSNumber numberWithInt:kChoiceD], nil];
      break;
      
    case kChoiceB:
      cheatArray = [[NSMutableArray alloc] initWithObjects:[NSNumber numberWithInt:kChoiceA], [NSNumber numberWithInt:kChoiceC], [NSNumber numberWithInt:kChoiceD], nil];
      break;
      
    case kChoiceC:
      cheatArray = [[NSMutableArray alloc] initWithObjects:[NSNumber numberWithInt:kChoiceB], [NSNumber numberWithInt:kChoiceA], [NSNumber numberWithInt:kChoiceD], nil];
      break;
      
    case kChoiceD:
      cheatArray = [[NSMutableArray alloc] initWithObjects:[NSNumber numberWithInt:kChoiceB], [NSNumber numberWithInt:kChoiceC], [NSNumber numberWithInt:kChoiceA], nil];
      break;
      
    default:
      break;
  }
}

- (void)implementInfo {
  self.questionLabel.text = question.question;
  //[self.game.questionsId addObject:question.id];
      
  MultipleChoiceAnswerProto *answer = [question.answersList objectAtIndex:0];
  self.answerALabel.text = answer.answer;
  
//  if ([answer.id isEqualToString:question.answerId]) {
//    self.correctChoice = kChoiceA;
//  }
//  
//  answer = [question.answersList objectAtIndex:1];
//  self.answerBLabel.text = answer.answer;
//  
//  if ([answer.id isEqualToString:question.answerId]) {
//    self.correctChoice = kChoiceB;
//  }
//
//  answer = [question.answersList objectAtIndex:2];
//  self.answerCLabel.text = answer.answer;
//  
//  if ([answer.id isEqualToString:question.answerId]) {
//    self.correctChoice = kChoiceC;
//  }
//  
//  answer = [question.answersList objectAtIndex:3];
//  self.answerDLabel.text = answer.answer;
//  
//  if ([answer.id isEqualToString:question.answerId]) {
//    self.correctChoice = kChoiceD;
//  }
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
  UITouch *touch = [[event allTouches] anyObject];
  CGPoint touchLocation = [touch locationInView:self.view];

  if (CGRectContainsPoint(self.answerAView.frame, touchLocation)) {
    selectedAnswer = kChoiceA;
    originalCenter = self.answerAView.center;
    touchedView = self.answerAView;
    selected  = YES;
  }else if (CGRectContainsPoint(self.answerBView.frame, touchLocation)) {
    selectedAnswer = kChoiceB;
    originalCenter = self.answerBView.center;
    touchedView = self.answerBView;
    selected  = YES;
  }
  else if (CGRectContainsPoint(self.answerCView.frame, touchLocation)) {
    selectedAnswer = kChoiceC;
    originalCenter = self.answerCView.center;
    touchedView = self.answerCView;
    selected  = YES;
  }
  else if (CGRectContainsPoint(self.answerDView.frame, touchLocation)) {
    selectedAnswer = kChoiceD;
    originalCenter = self.answerDView.center;
    touchedView = self.answerDView;
    selected  = YES;
  }
  [self moveTouchedView];
  for (NSNumber *num in usedCheatArray) {
    if ([num integerValue] == selectedAnswer) {
      selected = NO;
      touchedView = nil;
    }
  }
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
  if (self.game.isTutorial) return;
  else touchedView = nil;
}

- (void)resetAnswer {
  [UIView animateWithDuration:0.05 animations:^{
    touchedView.center = originalCenter;
  }];
  touchedView = nil;
}

- (void)checkCorrectAnswer {
  //QuestionType type = [self.game getQuestiontype];
  if (selectedAnswer == self.correctChoice) {
    if (self.game.isTutorial) {
      [self.game tutorialCorrectionAnimationWithCorrect:YES fromQuestionType:kMultipleChoice];
      [self performSelector:@selector(resetAnswer) withObject:nil afterDelay:0.5f];
    }
    else {
      [self.game transitionWithConclusion:YES skipping:NO andNextQuestionType:kFillIn];    
    }
  }
  else {
    if (self.game.isTutorial) {
      [self.game tutorialCorrectionAnimationWithCorrect:NO fromQuestionType:kMultipleChoice];
      [self performSelector:@selector(resetAnswer) withObject:nil afterDelay:0.5f];
    }
    else {
      [self.game transitionWithConclusion:NO skipping:NO andNextQuestionType:kMultipleChoice];
    }
  }
}

- (void)removeOptions {
  if (cheatArray.count < 1){
    return;
  }
  int random = arc4random() % cheatArray.count;
  int selectionTakenAway = [[cheatArray objectAtIndex:random] integerValue];
  [self takeAwayOptionsWithTag:selectionTakenAway];
  NSNumber *removed = [cheatArray objectAtIndex:random];
  [cheatArray removeObjectAtIndex:random];
  [usedCheatArray addObject:removed];
}

- (void)takeAwayOptionsWithTag:(int)tag {
  if (tag == kChoiceA) {
    [UIView animateWithDuration:Fade_Out_Duration animations:^{
      self.answerAView.alpha = 0.0;;
      self.answerALabel.alpha = 0.0f;
      self.answerABottom.alpha = 0.0f;
    }completion:^(BOOL finished) {
      self.answerAView.hidden = YES;
      self.answerALabel.hidden = YES;
      self.answerABottom.hidden = YES;
    }];
  }
  else if (tag == kChoiceB) {
    [UIView animateWithDuration:Fade_Out_Duration animations:^{
      self.answerBView.alpha = 0.0f;
      self.answerBLabel.alpha = 0.0f;
      self.answerBBottom.alpha = 0.0f;
    }completion:^(BOOL finished) {
      self.answerBView.hidden = YES;
      self.answerBLabel.hidden = YES;
      self.answerBBottom.hidden = YES;
    }];
  }
  
  else if (tag == kChoiceC) {
    [UIView animateWithDuration:Fade_Out_Duration animations:^{
      self.answerCView.alpha = 0.0f;
      self.answerCLabel.alpha = 0.0f;
      self.answerCBottom.alpha = 0.0f;
    }completion:^(BOOL finished) {
      self.answerCView.hidden = YES;
      self.answerCLabel.hidden = YES;
      self.answerCBottom.hidden = YES;
    }];
  }
  else if (tag == kChoiceD) {
    [UIView animateWithDuration:Fade_Out_Duration animations:^{
      self.answerDView.alpha = 0.0f;
      self.answerDLabel.alpha = 0.0f;
      self.answerDBottom.alpha = 0.0f;
    }completion:^(BOOL finished) {
      self.answerDView.hidden = YES;
      self.answerDLabel.hidden = YES;
      self.answerDBottom.hidden = YES;
    }];
  }
}


@end
