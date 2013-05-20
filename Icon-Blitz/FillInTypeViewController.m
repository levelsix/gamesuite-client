//
//  FillInTypeViewController.m
//  Icon-Blitz
//
//  Created by Danny on 5/10/13.
//
//

#import "FillInTypeViewController.h"
#import "GameViewController.h"
#import <QuartzCore/QuartzCore.h>

#define kAnswerSlotViewStartingTag 1
#define kAnswerSlotViewEndingTag 14
#define kAnswerSlotBottomStartingTag 15
#define kAnswerSlotBottomEndingTag 29
#define WidthDifference 40
#define MaxOneLineSlots 7
#define kUnfilledStartingTag 50 
#define kFirstLine 100
#define kSecondLine 101

@interface FillInTypeViewController () {
  BOOL dragging;
  BOOL moving;
  CGPoint homePosition;
  NSMutableArray *bottomBarArray;
  NSMutableArray *answerViews;
  UIView *dragObject;
  NSMutableArray *selectedAnswerTags;
  NSMutableArray *selectedLetters;
  CGRect originalLetterLocations[14];
  NSArray *selectionSlots;
  NSString *correctAnswer;
}

@end

@implementation FillInTypeViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil game:(GameViewController *)game {
  self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
  if (self) {
    self.game = game;
  }
  return self;
}

- (void)viewDidLoad
{
  [super viewDidLoad];
  self.view.userInteractionEnabled = NO;
  bottomBarArray = [NSMutableArray array];
  answerViews = [NSMutableArray array];
  selectedAnswerTags = [NSMutableArray array];
  selectedLetters = [NSMutableArray array];
  correctLetterCount = 9;
  numberOfLines = 2;
  firstLineCount = 5;
  secondLineCount = 4;
  for (int i = 0 ; i < correctLetterCount; i++) {
    [selectedAnswerTags addObject:[NSNumber numberWithInt:-1]];
    [selectedLetters addObject:[NSNumber numberWithInt:i]];
  }
  selectionSlots = [[NSArray alloc] initWithObjects:@"L",@"E",@"V",@"E",@"L",@"6",@" ",@"R",@"O",@"C",@"K",@"S",@"!",@" ",nil];
  [self createAnswerSlots];
  [self createSelectionSlots];
  animationCounter = 1;
  correctAnswer = @"LevelRock";
  [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(animateSelectionSlots:) userInfo:nil repeats:YES];
}

- (void)createAnswerSlots {
  int tag = kUnfilledStartingTag;
  if (numberOfLines != 1) {
    UIView *firstLine = [[UIView alloc] init];
    float lastSlotPosY;
    float lastSlotPosX;
    for (int i = 0; i < firstLineCount; i++) {
      NSString *letterPath = [NSString stringWithFormat:@"unfilledblack.png"];
      UIImage *letters = [UIImage imageNamed:letterPath];
      UIImageView *view = [[UIImageView alloc] initWithFrame:CGRectMake(i * WidthDifference, 0, 37, 38)];
      view.image = letters;
      view.tag = tag;
      tag++;
      if (i == firstLineCount-1) {
        lastSlotPosX = view.center.x + view.frame.size.width/2;
        lastSlotPosY = view.frame.size.height;
      }
      [firstLine addSubview:view];
    }
    
    firstLine.frame = CGRectMake(0, 0, lastSlotPosX, lastSlotPosY);
    firstLine.center = CGPointMake(self.view.frame.size.width/2, 150);
    [self.view addSubview:firstLine];
    
    UIView *secondLine = [[UIView alloc] init];

    for (int i = 0; i < secondLineCount; i++) {
      NSString *letterPath = [NSString stringWithFormat:@"unfilledblack.png"];
      UIImage *letters = [UIImage imageNamed:letterPath];
      UIImageView *view = [[UIImageView alloc] initWithFrame:CGRectMake(i * WidthDifference, 0, 37, 38)];
      view.image = letters;
      view.tag = tag;
      tag++;
      if (i == secondLineCount-1) {
        lastSlotPosX = view.center.x + view.frame.size.width/2;
        lastSlotPosY = view.frame.size.height;
      }
      [secondLine addSubview:view];

    }
    firstLine.tag = kFirstLine;
    secondLine.tag = kSecondLine;
    secondLine.frame = CGRectMake(0, 0, lastSlotPosX, lastSlotPosY);
    secondLine.center = CGPointMake(self.view.frame.size.width/2, 200);
    [self.view addSubview:secondLine];
    
  }
  else {
    UIView *answerView = [[UIView alloc] init];
    float lastSlotPosY;
    float lastSlotPosX;
    for (int i = 0; i < correctLetterCount; i++) {
      
      NSString *letterPath = [NSString stringWithFormat:@"unfilledblack.png"];
      UIImage *letters = [UIImage imageNamed:letterPath];
      UIImageView *view = [[UIImageView alloc] initWithFrame:CGRectMake(i * WidthDifference, 0, 37, 38)];
      view.image = letters;
      view.tag = tag;
      if (i == correctLetterCount-1) {
        lastSlotPosX = view.center.x + view.frame.size.width/2;
        lastSlotPosY = view.frame.size.height;
      }
      tag++;
      [answerView addSubview:view];
    }
    answerView.frame = CGRectMake(0, 0, lastSlotPosX, lastSlotPosY);
    answerView.center = CGPointMake(self.view.frame.size.width/2, 180);
    [self.view addSubview:answerView];
  }
  maxUnfilledSlot = tag;
  for (int i = kUnfilledStartingTag; i < maxUnfilledSlot; i++) {
    UIImageView *j = (UIImageView *)[self.view viewWithTag:i];
    [answerViews addObject:j];
  }
}

- (void)createSelectionSlots {
  int counter = kAnswerSlotViewStartingTag;
  int arrayCounter = 0;
  int bottomStartingTag = kAnswerSlotBottomStartingTag;
  for (int i = 0; i < MaxOneLineSlots; i++) {
    UIImage *bottom = [UIImage imageNamed:@"buttonbottom.png"];
    UIImageView *bottomView = [[UIImageView alloc] initWithImage:bottom];
    
    UIImage *top = [UIImage imageNamed:@"buttontop.png"];
    UIImageView *topView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, top.size.width, top.size.height)];
    topView.image = top;
    
    UIView *slotView = [[UIView alloc] initWithFrame:CGRectMake(23 + (i * WidthDifference), 245, topView.frame.size.width, topView.frame.size.height + bottomView.frame.size.height)];
    
    bottomView.frame = CGRectMake(0, topView.frame.size.height - 7, 37, 11);
    [slotView addSubview:bottomView];
    [slotView addSubview:topView];
        
    slotView.tag = counter;
    bottomView.tag = bottomStartingTag;
    bottomStartingTag++;
    counter++;
    NSString *letter = [selectionSlots objectAtIndex:arrayCounter];
    UILabel *letterLabel = [[UILabel alloc] initWithFrame:CGRectMake(9.5, 5, 37, 37)];
    letterLabel.font = [UIFont fontWithName:@"Avenir Next Lt Pro" size:23];
    letterLabel.text = letter;
    letterLabel.backgroundColor = [UIColor clearColor];
    [letterLabel setFrame:CGRectMake(0,5,letterLabel.frame.size.width,letterLabel.frame.size.height)];
    letterLabel.textAlignment = UITextAlignmentCenter;
    [topView addSubview:letterLabel];
    originalLetterLocations[i] = slotView.frame;

    [self.view addSubview:slotView];
    arrayCounter++;
    
    slotView.transform = CGAffineTransformMakeScale(0.01, 0.01);
  }
  
  for (int i = 0; i < MaxOneLineSlots; i++) {
    UIImage *bottom = [UIImage imageNamed:@"buttonbottom.png"];
    UIImageView *bottomView = [[UIImageView alloc] initWithImage:bottom];
    
    UIImage *top = [UIImage imageNamed:@"buttontop.png"];
    UIImageView *topView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, top.size.width, top.size.height)];
    topView.image = top;
    
    UIView *slotView = [[UIView alloc] initWithFrame:CGRectMake(23 + (i * WidthDifference), 295, topView.frame.size.width, topView.frame.size.height + bottomView.frame.size.height)];
    
    bottomView.frame = CGRectMake(0, topView.frame.size.height - 7, 37, 11);
    [slotView addSubview:bottomView];
    [slotView addSubview:topView];
    
    slotView.tag = counter;
    bottomView.tag = bottomStartingTag;
    bottomStartingTag++;
    counter++;
    
    NSString *letter = [selectionSlots objectAtIndex:arrayCounter];
    UILabel *letterLabel = [[UILabel alloc] initWithFrame:CGRectMake(9.5, 5, 37, 37)];
    letterLabel.font = [UIFont fontWithName:@"Avenir Next Lt Pro" size:23];
    letterLabel.text = letter;
    letterLabel.backgroundColor = [UIColor clearColor];
    [letterLabel setFrame:CGRectMake(0,5,letterLabel.frame.size.width,letterLabel.frame.size.height)];
    letterLabel.textAlignment = UITextAlignmentCenter;
    [topView addSubview:letterLabel];
    originalLetterLocations[arrayCounter] = slotView.frame;
    
    arrayCounter++;
    
    [self.view addSubview:slotView];
    slotView.transform = CGAffineTransformMakeScale(0.01, 0.01);
  }
  for (int i = kAnswerSlotBottomStartingTag; i < kAnswerSlotBottomEndingTag;i++) {
    UIImageView *image = (UIImageView*)[self.view viewWithTag:i];
    [bottomBarArray addObject:image];
  }
}

- (void)animateSelectionSlots:(NSTimer *)timer {
  UIImageView *topView = (UIImageView *)[self.view viewWithTag:animationCounter];
  [UIView animateWithDuration:0.1 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
    topView.transform = CGAffineTransformIdentity;
  }completion:nil];
  animationCounter++;
  if (animationCounter > 14) {
    self.view.userInteractionEnabled = YES;
    [timer invalidate];
  }
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
  UITouch *touch = [[event allTouches] anyObject];
  CGPoint touchLocation = [touch locationInView:self.view];
  for (UIView *view in self.view.subviews) {
    if (CGRectContainsPoint(view.frame, touchLocation)) {
      if (view.tag > 0 && view.tag <= kAnswerSlotViewEndingTag) {
        dragObject = view;
        int tag = 0;
        for (NSNumber *used in selectedAnswerTags) {
          tag++;
          if ([used integerValue] == dragObject.tag) {
            [self resetLetter];
            [selectedAnswerTags replaceObjectAtIndex:tag-1 withObject:[NSNumber numberWithInt:-1]];
            [selectedLetters replaceObjectAtIndex:tag-1 withObject:[NSNumber numberWithInt:-1]];
            return;
          }
        }
        dragging = YES;
        [UIView animateWithDuration:0.1 animations:^{
          dragObject.center = CGPointMake(dragObject.center.x, dragObject.center.y+4);
        }completion:^(BOOL finished) {
          [self hideBottomBar];
        }];
      }
    }
  }
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
  UITouch *touch = [[event allTouches] anyObject];
  CGPoint touchLocation = [touch locationInView:self.view];
  if (dragging) {
    moving = YES;
    dragObject.center = touchLocation;
    [self.view bringSubviewToFront:dragObject];
  }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
  if (dragging) {
    [self replaceAnswerWithDragging];
  }
  dragging = NO;
  moving = NO;
}

- (void)replaceAnswerWithDragging {
  //dragging to answer slots
  if (numberOfLines != 1 && moving) {
    int tag = 0;
    UIView *firstLine = [self.view viewWithTag:kFirstLine];
    UIView *secondLine = [self.view viewWithTag:kSecondLine];
    if (CGRectIntersectsRect(dragObject.frame, firstLine.frame) || CGRectIntersectsRect(dragObject.frame, secondLine.frame)) {
      for (UIView *view in answerViews) {
        CGRect firstRect = [firstLine convertRect:view.frame toView:self.view];
        CGRect secondRect = [secondLine convertRect:view.frame toView:self.view];
        tag++;
        
        if (CGRectIntersectsRect(dragObject.frame,firstRect)) {
          dragObject.frame = firstRect;
          [selectedAnswerTags replaceObjectAtIndex:tag-1 withObject:[NSNumber numberWithInt:dragObject.tag]];
          for (UILabel *l in dragObject.subviews) {
            [selectedLetters replaceObjectAtIndex:tag-1 withObject:l.text];
          }
          break;
        }
        else if (CGRectIntersectsRect(dragObject.frame, secondRect)) {
          tag = firstLineCount + tag;
          dragObject.frame = secondRect;
          [selectedAnswerTags replaceObjectAtIndex:tag-1 withObject:[NSNumber numberWithInt:dragObject.tag]];
          for (UIImageView *image in dragObject.subviews) {
            for (UILabel *l in image.subviews) {
              [selectedLetters replaceObjectAtIndex:tag-1 withObject:l.text];
            }
          }
          break;
        }
      }
    }
    else if (numberOfLines == 1 && moving){
      int tag = 0;
      UIView *firstLine = [self.view viewWithTag:kFirstLine];
      if (CGRectIntersectsRect(dragObject.frame, firstLine.frame)) {
        for (UIView *view in answerViews) {
          CGRect firstRect = [firstLine convertRect:view.frame toView:self.view];
          tag++;
          if (CGRectIntersectsRect(dragObject.frame,firstRect)) {
            dragObject.frame = firstRect;
            [selectedAnswerTags replaceObjectAtIndex:tag-1 withObject:[NSNumber numberWithInt:dragObject.tag]];
            for (UIImageView *image in dragObject.subviews) {
              for (UILabel *l in image.subviews) {
                [selectedLetters replaceObjectAtIndex:tag-1 withObject:l.text];
              }
            }
          }
        }
      }
    }
    else {
      [self resetLetter];
    }
  }
  else if (!moving) {
    [self replaceAnswerWithSelection];
  }
}

- (void)replaceAnswerWithSelection {
  //this is just pressing, not dragging

  int open = [self checkForOpenslot];
  if (open == selectedAnswerTags.count) {
    return;
  }
  UIImageView *answerSlot = [answerViews objectAtIndex:open];
  if (numberOfLines == 1) {
    UIView *firstLine = [self.view viewWithTag:kFirstLine];
    CGRect newFrame = [firstLine convertRect:answerSlot.frame toView:self.view];
    dragObject.frame = newFrame;
  }
  else {
    if (open < firstLineCount) {
      UIView *firstLine = [self.view viewWithTag:kFirstLine];
      CGRect newFrame = [firstLine convertRect:answerSlot.frame toView:self.view];
      dragObject.frame = newFrame;
    }
    else {
      UIView *secondLine = [self.view viewWithTag:kSecondLine];
      CGRect newFrame = [secondLine convertRect:answerSlot.frame toView:self.view];
      dragObject.frame = newFrame;
    }
  }
  [selectedAnswerTags replaceObjectAtIndex:open withObject:[NSNumber numberWithInt:dragObject.tag]];
  for (UIImageView *image in dragObject.subviews) {
    for (UILabel *l in image.subviews) {
      [selectedLetters replaceObjectAtIndex:open withObject:l.text];
    }
  }
  if (open == selectedAnswerTags.count-1) {
    [self checkIfAnswerIsCorrect];
  }
}

- (void)checkIfAnswerIsCorrect {
  NSString *answer = @"";
  for (int i = 0; i < selectedLetters.count; i++) {
    NSString *letter =[selectedLetters objectAtIndex:i];
    answer = [NSString stringWithFormat:@"%@%@",answer,letter];
  }
  if ([answer isEqualToString:correctAnswer]) {
    [self showCorrect];
  }
  else {
    [self showError];
  }
}

- (void)showCorrect {
  for (int i = 0; i < selectedAnswerTags.count;i++) {
    
  }
}

- (void)showError {
  
}

- (int)checkForOpenslot {
  int openSlot;
  for (int i = 0; i <= selectedAnswerTags.count; i++) {
    if (i == selectedAnswerTags.count) {
      [self resetLetter];
      openSlot = i;
      break;
    }
    int open = [[selectedAnswerTags objectAtIndex:i] intValue];
    if  (open == -1) {
      openSlot = i;
      break;
    }
  }
  return openSlot;
}

- (void)resetLetter {
  [UIView animateWithDuration:0.15 animations:^{
    dragObject.frame = originalLetterLocations[dragObject.tag-1];
  }completion:^(BOOL finished) {
    if (finished) {
      UIImageView *b = [bottomBarArray objectAtIndex:dragObject.tag-1];
      b.hidden = NO;
    }
  }];
}

- (void)hideBottomBar {
  UIImageView *b = [bottomBarArray objectAtIndex:dragObject.tag-1];
  b.hidden = YES;
}

@end
