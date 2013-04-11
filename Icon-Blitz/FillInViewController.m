//
//  FillInViewController.m
//  Icon-Blitz
//
//  Created by Danny on 4/3/13.
//
//

#import "FillInViewController.h"
#import "GameViewController.h"
#import <QuartzCore/QuartzCore.h>

#define WidthDifference 40
#define MaxOneLineSlots 7

@interface FillInViewController () {
  BOOL dragging;
  BOOL allFilledIn;
  BOOL touched;
  BOOL moving;
  UIImageView *dragObject;
  CGPoint homePosition;
  CGPoint originalLetterLocations[14];
  /********* animating the selection slots ***************/
  int animationCounter;
  int bottomIndexCounter;
  /********* animating the selection slots ***************/
  NSMutableArray *submittedAnswers;
  NSMutableArray *slotsTakenArray;
  NSMutableArray *slotTakenTags;
  NSMutableArray *answerSelected;

}

@end

@implementation FillInViewController

+ (id)gameWithController:(GameViewController *)game {
  return [[[self alloc] initWithGame:game] autorelease];
}

- (id) initWithGame:(GameViewController *)game {
  if ((self = [super init])) {
    self.view.userInteractionEnabled = NO;
    self.game = game;
    [self loadNewData];
    self.correctAmtOfLetters = 7;
    [self createAnswerSlot];
    submittedAnswers = [[NSMutableArray alloc] init];
    slotsTakenArray = [[NSMutableArray alloc] init];
    slotTakenTags = [[NSMutableArray alloc] init];
    for (int i = 0; i <self.correctAmtOfLetters; i++) {
      BOOL open = NO;
      [submittedAnswers addObject:[NSNumber numberWithInt:i]];
      [slotsTakenArray addObject:[NSNumber numberWithBool:open]];
      [slotTakenTags addObject:[NSNumber numberWithInt:-1]];
    }
    self.answerSlots = [[NSMutableArray alloc] initWithObjects:@"A",@"B",@"C",@"D",@"E",@"F",@"G",@"H",@"I",@"J",@"K",@"L",@"M",@"N",nil];
    [self createSelectionWith:self.answerSlots];
    animationCounter = 0;
    bottomIndexCounter = 50;
    [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(animateSelectionSlots:) userInfo:nil repeats:YES];
  }
  return self;
}

- (void)viewDidLoad {
  
}

- (void)animateSelectionSlots:(NSTimer *)timer {
  int index;
  if (animationCounter == 0) index = 100;
  else index = animationCounter;
  
  
  UIImageView *bottomView = (UIImageView *)[self.view viewWithTag:bottomIndexCounter];
  UIImageView *topView = (UIImageView *)[self.view viewWithTag:index];
  [UIView animateWithDuration:0.1 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
    topView.transform = CGAffineTransformIdentity;
    bottomView.transform = CGAffineTransformIdentity;
  }completion:nil];
  animationCounter++;
  bottomIndexCounter++;
  if (animationCounter >= 14) {
    self.view.userInteractionEnabled = YES;
    [timer invalidate];
  }
}

- (void)removeOptions {
  for (int i = 0; i < self.answerSlots.count; i++) {
    NSString *letter = [self.answerSlots objectAtIndex:i];
    for (NSString *letters in self.answerArray) {
      if ([letter isEqualToString:letters]) {
        
      }
    }
  }
}

- (void)placeNewData {
  self.questionDict = [self.game.gameData objectAtIndex:self.game.currentQuestion];
  self.correctAmtOfLetters = [[self.questionDict objectForKey:@"Amount"] integerValue];
  self.answerArray = [self.questionDict objectForKey:@"Answer"];
  self.answerSlots = [self.questionDict objectForKey:@"AnswerSlots"];
  animationCounter = 0;
  [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(animateSelectionSlots:) userInfo:nil repeats:YES];
  
}

- (void)loadNewData {
  self.answerArray = [[NSArray alloc] initWithObjects:@"A",@"B",@"C",@"D",@"E",@"F",@"G", nil];
  //  self.questionDict = [self.game.gameData objectAtIndex:self.game.currentQuestion];
  //  correctAmtOfLetters = [[self.questionDict objectForKey:@"Amount"] integerValue];
  //  self.answerArray = [self.questionDict objectForKey:@"Answer"];
}

- (void)createAnswerSlot {
  int tag = 14;
  if (self.correctAmtOfLetters > 7) {
    for (int i = 0; i < 6; i++) {
      NSString *letterPath = [NSString stringWithFormat:@"unfilledblack.png"];
      UIImage *letters = [UIImage imageNamed:letterPath];
      UIImageView *view = [[UIImageView alloc] init];
      view.image = letters;
      view.tag = tag;
      tag++;
    }
    for (int i = 7 ; i < 14; i++) {
      NSString *letterPath = [NSString stringWithFormat:@"unfilledblack.png"];
      UIImage *letters = [UIImage imageNamed:letterPath];
      UIImageView *view = [[UIImageView alloc] init];
      view.image = letters;
      view.tag = tag;
    }
  }
  else if (self.correctAmtOfLetters <= 7){
    for (int i = 0; i < self.correctAmtOfLetters; i++) {
      NSString *letterPath = [NSString stringWithFormat:@"unfilledblack.png"];
      UIImage *letters = [UIImage imageNamed:letterPath];
      UIImageView *view = [[UIImageView alloc] initWithFrame:CGRectMake(23 + (i * WidthDifference), 180, 37, 38)];
      view.image = letters;
      view.tag = tag;
      tag++;
      [self.view addSubview:view];
    }
  }
  self.maxCounter = tag;
}

- (void)createSelectionWith:(NSArray *)array {
  int counter = 0;
  int bottomTag = 50;
  for (int i = 0; i < 7; i++) {
    UIImage *bottom = [UIImage imageNamed:@"buttonbottom.png"];
    UIImageView *view = [[UIImageView alloc] initWithFrame:CGRectMake(23 + (i * WidthDifference), 275, 37, 11)];
    view.image = bottom;
    [self.view addSubview:view];
    
    view.transform = CGAffineTransformMakeScale(0.01,0.01);
    
    view.tag = bottomTag;
    
    UIImage *top = [UIImage imageNamed:@"buttontop.png"];
    UIImageView *topView = [[UIImageView alloc] initWithFrame:CGRectMake(23 + (i * WidthDifference), 245, 37, 37)];
    topView.image = top;
    [self.view addSubview:topView];
    
    if (counter == 0) topView.tag = 100;
    else topView.tag = counter;
    
    NSString *letter = [array objectAtIndex:counter];
    UILabel *letterLabel = [[UILabel alloc] initWithFrame:CGRectMake(9.5, 5, 37, 37)];
    letterLabel.font = [UIFont fontWithName:@"Avenir Next Lt Pro" size:23];
    letterLabel.text = letter;
    letterLabel.backgroundColor = [UIColor clearColor];
    
    [letterLabel setFrame:CGRectMake(0,5,letterLabel.frame.size.width,letterLabel.frame.size.height)];
    letterLabel.textAlignment = UITextAlignmentCenter;
    [topView addSubview:letterLabel];
    originalLetterLocations[counter] = topView.center;
    counter++;
    bottomTag++;
    
    topView.transform = CGAffineTransformMakeScale(0.01, 0.01);
    
  }
  for (int i = 0; i < 7; i++) {
    UIImage *bottom = [UIImage imageNamed:@"buttonbottom.png"];
    UIImageView *view = [[UIImageView alloc] initWithFrame:CGRectMake(23 + (i * WidthDifference), 325, 37, 11)];
    view.image = bottom;
    [self.view addSubview:view];
    
    view.transform = CGAffineTransformMakeScale(0.01,0.01);
    view.tag = bottomTag;
    
    UIImage *top = [UIImage imageNamed:@"buttontop.png"];
    UIImageView *topView = [[UIImageView alloc] initWithFrame:CGRectMake(23 + (i * WidthDifference), 295, 37, 37)];
    topView.image = top;
    [self.view addSubview:topView];
    topView.tag = counter;
    
    NSString *letter = [array objectAtIndex:counter];
    UILabel *letterLabel = [[UILabel alloc] initWithFrame:CGRectMake(9.5, 5, 37, 37)];
    letterLabel.font = [UIFont fontWithName:@"Avenir Next Lt Pro" size:23];
    letterLabel.text = letter;
    letterLabel.backgroundColor = [UIColor clearColor];
    
    [letterLabel setFrame:CGRectMake(0,5,letterLabel.frame.size.width,letterLabel.frame.size.height)];
    letterLabel.textAlignment = UITextAlignmentCenter;
    [topView addSubview:letterLabel];
    originalLetterLocations[counter] = topView.center;
    topView.transform = CGAffineTransformMakeScale(0.01, 0.01);
    counter++;
    bottomTag++;
  }
}


- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
  UITouch *touch = [[event allTouches] anyObject];
  CGPoint touchLocation = [touch locationInView:self.view];
  
  for (UIView *view in self.view.subviews) {
    if ([view isKindOfClass:[UIImageView class]] && CGRectContainsPoint(view.frame, touchLocation)) {
      if (view.tag >= 50 && view.tag < 100) {
        
      }
      else if (view.tag < 14 || view.tag == 100){
        homePosition = view.center;
        dragObject = (UIImageView *)view;
        if (dragObject.highlighted == YES) {
          [self resetLetter];
          return;
        }
        if (allFilledIn) {
          return;
        }
        dragging = YES;
        [UIView animateWithDuration:0.1 animations:^{
          dragObject.center = CGPointMake(homePosition.x, homePosition.y+4);
          [self hideBottomBar:YES];
        }];
      }
    }
  }
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
  UITouch *touch = [[event allTouches] anyObject];
  CGPoint touchLocation = [touch locationInView:self.view];
  
  if(dragging) {
    dragObject.center = touchLocation;
    NSMutableArray *aSlots = [NSMutableArray array];
    for (int i = 14; i < self.maxCounter; i++) {
      UIImageView *j = (UIImageView *)[self.view viewWithTag:i];
      [aSlots addObject:j];
    }
    moving = YES;
    [self.view bringSubviewToFront:dragObject];
  }
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
  dragging = NO;
  moving = NO;
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
  if (dragging) {
    if (moving) {
      BOOL inFrame = NO;
      BOOL taken = NO;
      NSMutableArray *aSlots = [NSMutableArray array];
      for (int i = 14; i < self.maxCounter; i++) {
        UIImageView *j = (UIImageView *)[self.view viewWithTag:i];
        [aSlots addObject:j];
      }
      
      NSMutableArray *selection = [NSMutableArray array];
      for (int i = 0; i < 14; i++) {
        UIImageView *letter = (UIImageView *)[self.view viewWithTag:i];
        [selection addObject:letter];
      }
      
      for (NSNumber *slotsTaken in slotTakenTags) {
        UIView *i = [self.view viewWithTag:[slotsTaken integerValue]];
        if (CGRectIntersectsRect(dragObject.frame, i.frame)) {
          [self moveLettersWithSlot:i.tag];
          taken = YES;
        }
      }
      
      if (!taken) {
        for (UIView *answer in aSlots) {
          if (CGRectIntersectsRect(answer.frame, dragObject.frame)) {
            [self hideBottomBar:YES];
            [self createAnswerOnSlotWithView:answer];
            inFrame = YES;
          }
        }
      }
      if (!inFrame) {
        [self resetLetter];
      }
    }
    else {
      [self createSlotWithCurrentSlot];
      [self hideBottomBar:YES];
    }
    dragging = NO;
  }
  moving = NO;
}

- (void)moveLettersWithSlot:(int)tag {
  
}

- (void)createAnswerOnSlotWithView:(UIView *)view {
  int slotOpen = [self checkForFirstSlotAvailable];
  if (slotOpen == self.correctAmtOfLetters) {
    slotOpen = self.correctAmtOfLetters;
    return;
  }
  dragObject.frame = view.frame;
  dragObject.highlighted = YES;
  int slot = [self checkWhichSlotIsInRectWithTag:view.tag];
  NSNumber *open = [NSNumber numberWithBool:YES];
  NSString *letter;
  for (UILabel *l in dragObject.subviews) {
    letter = l.text;
  }
  BOOL isAva = [[slotsTakenArray objectAtIndex:slot] boolValue];
  if (isAva) {
    int tag = [[slotTakenTags objectAtIndex:slot] integerValue];
    UIView *prev = [self.view viewWithTag:tag];
    if (tag == 100) tag = 0;
    prev.center = originalLetterLocations[tag];
    NSMutableArray *bottom = [NSMutableArray array];
    for (int i = 50; i < 64; i++) {
      UIImageView *image = (UIImageView*)[self.view viewWithTag:i];
      [bottom addObject:image];
    }
    UIImageView *b = [bottom objectAtIndex:tag];
    b.hidden = NO;
  }
  
  [submittedAnswers replaceObjectAtIndex:slot withObject:letter];
  [slotsTakenArray replaceObjectAtIndex:slot withObject:open];
  [slotTakenTags replaceObjectAtIndex:slot withObject:[NSNumber numberWithInt:dragObject.tag]];
  
  [self checkIfAllSlotsAreTaken];
}

- (int)checkWhichSlotIsInRectWithTag:(int)tag {
  int slot;
  NSMutableArray *temp = [[NSMutableArray alloc] init];
  for (int i = 14; i < self.maxCounter; i++) {
    UIView *view = [self.view viewWithTag:i];
    [temp addObject:view];
  }
  
  for (int i = 0; i < temp.count ;i++) {
    UIImageView *img = [temp objectAtIndex:i];
    if (img.tag == tag) {
      slot = i;
      break;
    }
  }
  return slot;
}

- (void)createSlotWithCurrentSlot {
  int slotOpen = [self checkForFirstSlotAvailable];
  if (slotOpen == self.correctAmtOfLetters) {
    slotOpen = self.correctAmtOfLetters;
    return;
  }
  int tag;
  if (dragObject.tag == 100) tag = 0;
  else tag = dragObject.tag;
  
  NSMutableArray *aSlots = [NSMutableArray array];
  
  for (int i = 14; i < self.maxCounter; i++) {
    UIImageView *j = (UIImageView *)[self.view viewWithTag:i];
    [aSlots addObject:j];
  }
  UIView * view = [aSlots objectAtIndex:slotOpen];
  dragObject.frame = view.frame;
  dragObject.highlighted = YES;
  NSNumber *open = [NSNumber numberWithBool:YES];
  NSString *letter;
  for (UILabel *l in dragObject.subviews) {
    letter = l.text;
  }
  [submittedAnswers replaceObjectAtIndex:slotOpen withObject:letter];
  [slotsTakenArray replaceObjectAtIndex:slotOpen withObject:open];
  [slotTakenTags replaceObjectAtIndex:slotOpen withObject:[NSNumber numberWithInt:dragObject.tag]];
  
  [self checkIfAllSlotsAreTaken];
}

- (void)resetLetter {
  allFilledIn = NO;
  int tag;
  if (dragObject.tag == 100) tag = 0;
  else tag = dragObject.tag;
  [UIView animateWithDuration:0.15 animations:^{
    dragObject.center = originalLetterLocations[tag];
  }completion:^(BOOL finished){
    if (finished) {
      NSMutableArray *bottom = [NSMutableArray array];
      for (int i = 50; i < 64; i++) {
        UIImageView *image = (UIImageView*)[self.view viewWithTag:i];
        [bottom addObject:image];
      }
      UIImageView *b = [bottom objectAtIndex:tag];
      b.hidden = NO;
    }
  }];
  dragObject.highlighted = NO;
  [self replaceSlotsTakenWithTag:dragObject.tag];
}

- (void)checkIfAllSlotsAreTaken {
  BOOL completed = YES;
  for (int i = 0 ; i < slotsTakenArray.count; i++) {
    if (![[slotsTakenArray objectAtIndex:i]boolValue]) {
      completed = NO;
      break;
    }
  }
  if (completed) {
    allFilledIn = YES;
    [self checkCorrect];
  }
}

- (int)checkForFirstSlotAvailable{
  int openSlot;
  for (int i = 0 ; i <= slotsTakenArray.count ;i++) {
    if (i == 7) {
      openSlot = i;
      break;
    }
    BOOL open = [[slotsTakenArray objectAtIndex:i] boolValue];
    if (open == NO) {
      openSlot = i;
      break;
    }
  }
  return openSlot;
}

- (void)replaceSlotsTakenWithTag:(int)tag {
  for (int i = 0; i < submittedAnswers.count; i++) {
    if (tag == [[slotTakenTags objectAtIndex:i]integerValue]) {
      NSNumber *no = [NSNumber numberWithBool:NO];
      [slotTakenTags replaceObjectAtIndex:i withObject:[NSNumber numberWithInt:-1]];
      [slotsTakenArray replaceObjectAtIndex:i withObject:no];
      break;
    }
  }
}

- (void)checkCorrect {
  NSString *answer = @"";
  NSString *correctAnswer = @"";
  for (int i = 0; i < [submittedAnswers count]; i++) {
    NSString *letter = [submittedAnswers objectAtIndex:i];
    answer = [NSString stringWithFormat:@"%@%@",answer, letter];
    
    NSString *correctLetter = [self.answerArray objectAtIndex:i];
    correctAnswer = [NSString stringWithFormat:@"%@%@",correctAnswer,correctLetter];
  }
  if ([answer isEqualToString: correctAnswer]) {
    [self showCorrect];
  }
  else {
    [self showError];
  }
}

- (void)showCorrect {
  for (int i = 0; i < slotTakenTags.count; i++) {
    int tag = [[slotTakenTags objectAtIndex:i]integerValue];
    UIImageView *letter = (UIImageView *)[self.view viewWithTag:tag];
    for (UILabel *l in letter.subviews) {
      l.textColor = [UIColor greenColor];
    }
  }
  [self.game transitionWithConclusion:YES skipping:NO andNextQuestionType:kFillIn];
}

- (void)hideBottomBar:(BOOL)should {
  int tag;
  NSMutableArray *bottom = [NSMutableArray array];
  for (int i = 50; i < 64; i++) {
    UIImageView *image = (UIImageView*)[self.view viewWithTag:i];
    [bottom addObject:image];
  }
  if (dragObject.tag == 100) tag = 0;
  else tag = dragObject.tag;
  UIImageView *b = [bottom objectAtIndex:tag];
  if (dragObject.hidden) {
    should = YES;
  }
  b.hidden = should;
}

- (void)showError {
  for (int i = 0; i < slotTakenTags.count; i++) {
    int tag = [[slotTakenTags objectAtIndex:i]integerValue];
    UIImageView *letter = (UIImageView *)[self.view viewWithTag:tag];
    for (UILabel *l in letter.subviews) {
      [UIView animateWithDuration:0.1 delay:0.0 options:(UIViewAnimationOptionAutoreverse| UIViewAnimationOptionRepeat) animations:^{
        [UIView setAnimationRepeatCount:5];
        l.textColor = [UIColor redColor];
        l.alpha = 0.0f;
      }completion:^(BOOL finished) {
        l.textColor = [UIColor blackColor];
        l.alpha = 1.0f;
      }];
    }
    [self.game transitionWithConclusion:NO skipping:NO andNextQuestionType:kFillIn];
  }
}

#pragma Memory Management

- (void)dealloc {
  self.questionDict = nil;
  self.answerArray = nil;
  self.game = nil;
  self.answerSlots = nil;
  self.slotsTaken = nil;
  self.letterStorage = nil;
  [self.questionDict release];
  [self.answerArray release];
  [self.answerSlots release];
  [self.slotsTaken release];
  [self.letterStorage release];
  
  [self.game release];
  [super dealloc];
}


@end
