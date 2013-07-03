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
  NSMutableArray *bottomBarArray;
  NSMutableArray *answerViews;
  NSMutableArray *selectedAnswerTags;
  NSMutableArray *selectedLetters;
  NSMutableArray *cheatArray;
  NSMutableArray *selectionSlots;
  NSMutableArray *usedCheatArray;
  NSMutableArray *cheatCountArray;
  NSString *correctAnswer;
  NSString *lastQuestion;
  UIView *dragObject;
  CGRect originalLetterLocations[14];
  CGRect homePosition;
  CGRect originalContainerViewFrame;
  
  BOOL dragging;
  BOOL moving;
  BOOL filledSlotMoving;
  BOOL isInMorethanOneRect;
  BOOL isIconQuestion;
  BOOL needToDisableButton;
  int enabledTag;
  int previousTag;
  int correctLetterCount;
  int animationCounter;
  int maxUnfilledSlot;
  int numberOfLines;
  int firstLineCount;
  int secondLineCount;
  int cheatCount;
}

@end

@implementation FillInTypeViewController

#pragma mark - Tutorial Methods

- (id)initWithTutorialIconQuestion:(GameViewController *)game questionData:(NSDictionary *)question iconQuestion:(BOOL)isItIconQuestion {
  if ((self = [super init])) {
    self.game = game;
    isIconQuestion = isItIconQuestion;
    lastQuestion = [question objectForKey:@"question"];
    correctLetterCount = [[question objectForKey:@"letterCount"] integerValue];
    numberOfLines = [[question objectForKey:@"numberOfLines"] integerValue];
    firstLineCount = [[question objectForKey:@"firstLineCount"] integerValue];
    secondLineCount = [[question objectForKey:@"secondLineCount"] integerValue];
    correctAnswer = [question objectForKey:@"correctAnswer"];
    selectionSlots = [question objectForKey:@"selectionSlots"];
  }
  return self;
}

- (id)initWithTutorial:(GameViewController *)game question:(NSDictionary *)question {
  if ((self= [super init])) {
    self.game = game;
    self.questionLabel.text = [question objectForKey:@"question"];
    correctLetterCount = [[question objectForKey:@"letterCount"] integerValue];
    numberOfLines = [[question objectForKey:@"numberOfLines"] integerValue];
    firstLineCount = [[question objectForKey:@"firstLineCount"] integerValue];
    secondLineCount = [[question objectForKey:@"secondLineCount"] integerValue];
    correctAnswer = [question objectForKey:@"correctAnswer"];
    selectionSlots = [question objectForKey:@"selectionSlots"];
  }
  return self;
}

- (void)resetTutorialLetters {
  for (int i = 0; i < selectedAnswerTags.count; i++) {
    int tag = [[selectedAnswerTags objectAtIndex:i]integerValue];
    UIView *view = [self.view viewWithTag:tag];
    [UIView animateWithDuration:0.3f animations:^{
      view.frame = originalLetterLocations[tag-1];
    }completion:^(BOOL finished) {
      [self showBottomBarByTag:tag];
    }];
  }
  for (int i = 0 ; i < correctLetterCount; i++) {
    [selectedAnswerTags replaceObjectAtIndex:i withObject:[NSNumber numberWithInt:-1]];
    [selectedLetters replaceObjectAtIndex:i withObject:[NSNumber numberWithInt:-1]];
  }
  dragging = NO;
  dragObject = nil;
  filledSlotMoving = NO;
  isInMorethanOneRect = NO;
}

- (void)showBottomBarByTag:(int)tag {
  UIImageView *b = [bottomBarArray objectAtIndex:tag-1];
  b.hidden = NO;
}

- (void)disableUserInteractionWithTag:(int)tag {
  needToDisableButton = YES;
  enabledTag = tag;
}

#pragma mark - Non-Tutorial Methods

- (id)initWithGame:(GameViewController *)game {
  if (self = [super init]) {
    self.game = game;
    correctLetterCount = 12;
    numberOfLines = 2;
    firstLineCount = 6;
    secondLineCount = 6;
    correctAnswer = @"LEVEL6ROCKS!";
    
    selectionSlots = [[NSMutableArray alloc] initWithObjects:@"L",@"E",@"V",@"E",@"L",@"6",@" ",@"R",@"O",@"C",@"K",@"S",@"!",@" ",nil];
  }
  return self;
}

- (void)viewDidLoad
{
  [super viewDidLoad];
  if (isIconQuestion && self.game.isTutorial) {
    self.questionLabel.hidden = YES;
    self.iconView.center = CGPointMake(self.questionContainerView.center.x, self.questionContainerView.center.y + 21);
    [self createMaskImage:@"icontest.jpg"];
    [self.view addSubview:self.iconView];
  }
  else {
    originalContainerViewFrame = self.questionContainerView.frame;
  }
  //[self.game animateTriviaTypeLabel];
  self.view.userInteractionEnabled = NO;
  bottomBarArray = [NSMutableArray array];
  answerViews = [NSMutableArray array];
  selectedAnswerTags = [NSMutableArray array];
  selectedLetters = [NSMutableArray array];
  cheatArray = [NSMutableArray array];
  usedCheatArray = [NSMutableArray array];
  for (int i = 0 ; i < correctLetterCount; i++) {
    [selectedAnswerTags addObject:[NSNumber numberWithInt:-1]];
    [selectedLetters addObject:[NSNumber numberWithInt:-1]];
  }
  [self createAnswerSlots];
  [self createSelectionSlots];
  [self generatePreCheatList];
  [self fillInCheatArray];
  animationCounter = 1;

  if (self.game.isTutorial) {
    self.questionLabel.text = lastQuestion;
  }
  
  [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(animateSelectionSlots:) userInfo:nil repeats:YES];
}

- (void)animateContainerView {
  self.questionLabel.hidden = NO;
  self.questionContainerView.frame = CGRectMake(self.questionContainerView.center.x, self.questionContainerView.frame.origin.y, 0, self.questionContainerView.frame.size.height);
  [UIView animateWithDuration:1.0f animations:^{
    self.questionContainerView.frame = originalContainerViewFrame;
  }completion:NULL];
}

- (void)createMaskImage:(NSString *)imageName {
  UIImage *image = [UIImage imageNamed:imageName];
  self.iconImage.image = image;
}
 
- (void)generatePreCheatList {
  cheatCountArray = [NSMutableArray array];
  int ar[correctLetterCount],i,d,tmp;
  for(i = 0; i < correctLetterCount; i++) ar[i] = i;
  for(i = 0; i < correctLetterCount; i++) {
    d = i + (arc4random()%(correctLetterCount-i));
    tmp = ar[i];
    ar[i] = ar[d];
    ar[d] = tmp;
  }
  for (int i = 0; i <correctLetterCount; i++) {
    [cheatCountArray addObject:[NSNumber numberWithInt:ar[i]]];
  }
}

- (void)fillInCheatArray {
  for (int i = 0; i < correctLetterCount; i++) {
    char letter = [correctAnswer characterAtIndex:i];
    NSString *letterString = [NSString stringWithFormat:@"%c",letter];
    [cheatArray addObject:letterString];
  }
}

- (void)createAnswerSlots {
  int tag = kUnfilledStartingTag;
  if (numberOfLines == 2) {
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
    firstLine.center = CGPointMake(self.view.frame.size.width/2, 170);
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
    secondLine.center = CGPointMake(self.view.frame.size.width/2, 215);
    [self.view addSubview:secondLine];
    
  }
  else {
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
    firstLine.tag = kFirstLine;
    firstLine.frame = CGRectMake(0, 0, lastSlotPosX, lastSlotPosY);
    if (isIconQuestion) firstLine.center = CGPointMake(self.view.frame.size.width/2, 225);
    else firstLine.center = CGPointMake(self.view.frame.size.width/2, 200);
    [self.view addSubview:firstLine];
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
    
    UIView *slotView = [[UIView alloc] initWithFrame:CGRectMake(23 + (i * WidthDifference), 255, topView.frame.size.width, topView.frame.size.height + bottomView.frame.size.height)];
    
    bottomView.frame = CGRectMake(0, topView.frame.size.height - 7, 37, 11);
    [slotView addSubview:bottomView];
    [slotView addSubview:topView];
        
    slotView.tag = counter;
    bottomView.tag = bottomStartingTag;

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
    bottomStartingTag++;
    counter++;
    slotView.transform = CGAffineTransformMakeScale(0.01, 0.01);
    slotView.alpha = 0.0f;
  }
  
  for (int i = 0; i < MaxOneLineSlots; i++) {
    UIImage *bottom = [UIImage imageNamed:@"buttonbottom.png"];
    UIImageView *bottomView = [[UIImageView alloc] initWithImage:bottom];
    
    UIImage *top = [UIImage imageNamed:@"buttontop.png"];
    UIImageView *topView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, top.size.width, top.size.height)];
    topView.image = top;
    
    UIView *slotView = [[UIView alloc] initWithFrame:CGRectMake(23 + (i * WidthDifference), 305, topView.frame.size.width, topView.frame.size.height + bottomView.frame.size.height)];
    
    bottomView.frame = CGRectMake(0, topView.frame.size.height - 7, 37, 11);
    [slotView addSubview:bottomView];
    [slotView addSubview:topView];
    
    slotView.tag = counter;
    bottomView.tag = bottomStartingTag;
    
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
    bottomStartingTag++;
    counter++;
    
    [self.view addSubview:slotView];
    slotView.transform = CGAffineTransformMakeScale(0.01, 0.01);
    slotView.alpha = 0.0f;
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
    topView.alpha = 1.0f;
  }completion:nil];
  animationCounter++;
  if (animationCounter > 14) {
    self.view.userInteractionEnabled = YES;
    if (!self.game.isTutorial) self.game.removeCheatButon.userInteractionEnabled = YES;
    [timer invalidate];
  }
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event   {
  UITouch *touch = [[event allTouches] anyObject];
  CGPoint touchLocation = [touch locationInView:self.view];
  
  for (UIView *view in self.view.subviews) {
    if (CGRectContainsPoint(view.frame, touchLocation)) {
      if (view.tag > 0 && view.tag <= kAnswerSlotBottomEndingTag) { //touching the selection slots
        if (needToDisableButton && view.tag != enabledTag) {
          return;
        }
        dragObject = view;
        [self.view bringSubviewToFront:dragObject];
        int tag = 0; //this tag is for locating the intersected tag in our selectedAnswerTag
        for (NSNumber *usedCheat in usedCheatArray) {
          if ([usedCheat integerValue] == dragObject.tag) {
            return;
          }
        }
        dragging = YES;
        for (NSNumber *ourAnswers in selectedAnswerTags) {
          //check through our answer if we are clicking on the answers
          if ([ourAnswers integerValue] == dragObject.tag) {
            //if we do clicking on the answer we set the fillSlotMoving to 
            filledSlotMoving = YES;
            previousTag = tag;
            homePosition = dragObject.frame;
            return;
          }
          tag++;
        }
        [UIView animateWithDuration:0.1f animations:^{
          dragObject.center = CGPointMake(dragObject.center.x, dragObject.center.y+4);
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
    if (needToDisableButton) {
      return;
    }
    moving = YES;
    dragObject.center = touchLocation;
  }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
  //we clicked on an answer that we chose and we are not dragging it
  if (filledSlotMoving && !moving) {
    //we remove that letter from our answers and move it back to selection
    dragging = NO;
    [self resetLetter];
    [selectedAnswerTags replaceObjectAtIndex:previousTag withObject:[NSNumber numberWithInt:-1]];
    [selectedLetters replaceObjectAtIndex:previousTag withObject:[NSNumber numberWithInt:-1]];
  }
  else if (filledSlotMoving && moving) {
    //we are dragging our answer from before
    dragging = NO;
    [self draggingSelectedAnswer];
  }
  
  if (dragging && moving) { //if user is dragging the selection slots
    [self draggingPlacementAndAnimations];
  }
  else if (dragging && !moving){ // user is just clicking it
    [self inputTouchedSlot];
  }

  dragging = NO;
  moving = NO;
  filledSlotMoving = NO;
  //check if our answer is correct
  BOOL full = YES;
  for (NSNumber *num in selectedAnswerTags) {
    if ([num integerValue] == -1) {
      full = NO;
    }
  }
  if (full) {
    [self checkIfAnswerIsCorrect];
  }
}


- (void)checkIfDragViewIsIntersectingMultipleRect {
  //loop through all of our view
  NSMutableArray *areas = [NSMutableArray array];
  NSMutableArray *intersectedTag = [NSMutableArray array];
  int tag = 0;
  UIView *firstLine = [self.view viewWithTag:kFirstLine];
  UIView *secondLine = [self.view viewWithTag:kSecondLine];
  if (numberOfLines == 2) {
    if (CGRectIntersectsRect(dragObject.frame, firstLine.frame) || CGRectIntersectsRect(dragObject.frame, secondLine.frame)) {
      for (UIView *view in answerViews) {
        CGRect firstRect = [firstLine convertRect:view.frame toView:self.view];
        if (CGRectIntersectsRect(dragObject.frame, firstRect)) {
          CGRect rect = CGRectIntersection(dragObject.frame, firstRect);
          float area = rect.size.width * rect.size.height;
          [areas addObject:[NSNumber numberWithFloat:area]];
          [intersectedTag addObject:[NSNumber numberWithInt:tag]];
          tag++;
        }
        CGRect secondRect = [secondLine convertRect:view.frame toView:self.view];
        if (CGRectIntersectsRect(dragObject.frame, secondRect)) {
          CGRect rect = CGRectIntersection(dragObject.frame, secondRect);
          float area = rect.size.width * rect.size.height;
          [areas addObject:[NSNumber numberWithFloat:area]];
          [intersectedTag addObject:[NSNumber numberWithInt:tag]];
          tag++;
        }
      }
    }
  }
  float previousArea = 0;
  int arrayCounter = 0;
  int actualTagInAnswerArray;
  for (int i = 0; i < tag; i+=2) {
    float area = [[areas objectAtIndex:i] floatValue];
    if (previousArea <= area) {
      previousArea = area;
      arrayCounter = i;
    }
  }
  actualTagInAnswerArray = [[intersectedTag objectAtIndex:arrayCounter/2] integerValue];
  UIView *view = (UIView *)[answerViews objectAtIndex:actualTagInAnswerArray];
  CGRect newFrame;
  if (numberOfLines == 2) {
    if (actualTagInAnswerArray < firstLineCount) {
      newFrame = [firstLine convertRect:view.frame toView:self.view];
    }
    else {
      newFrame = [secondLine convertRect:view.frame fromView:self.view];
    }
  }
  else {
    newFrame = [firstLine convertRect:view.frame fromView:self.view];
  }
  dragObject.frame = newFrame;
  NSLog(@"%f",newFrame.size.width*newFrame.size.height);
}


- (void)draggingSelectedAnswer {
  if (numberOfLines == 2) { // if user is dragging our answer from before and the answer is a 2 lined answer
    UIView *firstLine = [self.view viewWithTag:kFirstLine];
    UIView *secondLine = [self.view viewWithTag:kSecondLine];
    if (CGRectIntersectsRect(dragObject.frame, firstLine.frame) || CGRectIntersectsRect(dragObject.frame, secondLine.frame)) { //if dragobject is in the rect of line one or line two
      int tag = 0;
      for (UIView *view in answerViews) {
        CGRect firstRect = [firstLine convertRect:view.frame toView:self.view];
        CGRect secondRect = [secondLine convertRect:view.frame toView:self.view];
        if (CGRectIntersectsRect(dragObject.frame, firstRect)) { // if it intersets with the first line
          if ([[selectedAnswerTags objectAtIndex:tag] integerValue] == -1) {//if the slot that we drag to is not taken
            [selectedAnswerTags replaceObjectAtIndex:tag withObject:[NSNumber numberWithInt:dragObject.tag]];
            [selectedAnswerTags replaceObjectAtIndex:previousTag withObject:[NSNumber numberWithInt:-1]];
            [selectedLetters replaceObjectAtIndex:previousTag withObject:[NSNumber numberWithInt:-1]];
            [self addLetterToAnswer:tag];            
            dragObject.frame = firstRect;
          }
          else if ([[selectedAnswerTags objectAtIndex:tag]integerValue] != -1) {
            //do an animation swapping letters
            UIView *droppedOnView = [self.view viewWithTag:[[selectedAnswerTags objectAtIndex:tag]integerValue]];
            for (UIImageView *view in droppedOnView.subviews) {
              for (UILabel *l in view.subviews) {
                [selectedLetters replaceObjectAtIndex:previousTag withObject:l.text];
              }
            }
            droppedOnView.frame = homePosition;
            dragObject.frame = firstRect;
            [selectedAnswerTags replaceObjectAtIndex:previousTag withObject:[NSNumber numberWithInt:droppedOnView.tag]];
            [selectedAnswerTags replaceObjectAtIndex:tag withObject:[NSNumber numberWithInt:dragObject.tag]];
            [self addLetterToAnswer:tag];
          }
          else {
            [UIView animateWithDuration:0.1f animations:^{
              dragObject.frame = homePosition;
            }];
          }
          return;
        }
        else if (CGRectIntersectsRect(dragObject.frame, secondRect)) {
          if ([[selectedAnswerTags objectAtIndex:tag+firstLineCount] integerValue] == -1) {//if the slot that we drag to is not taken
            [selectedAnswerTags replaceObjectAtIndex:tag+firstLineCount withObject:[NSNumber numberWithInt:dragObject.tag]];
            [selectedAnswerTags replaceObjectAtIndex:previousTag withObject:[NSNumber numberWithInt:-1]];
            [selectedLetters replaceObjectAtIndex:previousTag withObject:[NSNumber numberWithInt:-1]];
            [self addLetterToAnswer:tag+firstLineCount];
            dragObject.frame = secondRect;
          }
          else if ([[selectedAnswerTags objectAtIndex:tag+firstLineCount] integerValue] != -1) {
            //do an animation swapping letters
            UIView *droppedOnView = [self.view viewWithTag:[[selectedAnswerTags objectAtIndex:tag+firstLineCount] integerValue]];
            for (UIImageView *view in droppedOnView.subviews) {
              for (UILabel *l in view.subviews) {
                [selectedLetters replaceObjectAtIndex:previousTag withObject:l.text];
              }
            }
            droppedOnView.frame = homePosition;
            dragObject.frame = secondRect;
            [selectedAnswerTags replaceObjectAtIndex:previousTag withObject:[NSNumber numberWithInt:droppedOnView.tag]];
            [selectedAnswerTags replaceObjectAtIndex:tag+firstLineCount withObject:[NSNumber numberWithInt:dragObject.tag]];
            [self addLetterToAnswer:tag+firstLineCount];

          }
          else {
            [UIView animateWithDuration:0.1f animations:^{
              dragObject.frame = homePosition;
            }];
          }
          return;
        }
        tag++;
      }
    }
    else {
      [self resetLetter];
      for (int i = 0 ; i <selectedAnswerTags.count;i++) {
        int answer = [[selectedAnswerTags objectAtIndex:i] integerValue];
        if (answer == dragObject.tag) {
          [selectedAnswerTags replaceObjectAtIndex:i withObject:[NSNumber numberWithInt:-1]];
          [selectedLetters replaceObjectAtIndex:i withObject:[NSNumber numberWithInt:-1]];
          break;
        }
      }
    }
  }
  else if (numberOfLines == 1) {
    UIView *firstLine = [self.view viewWithTag:kFirstLine];
    if (CGRectIntersectsRect(dragObject.frame, firstLine.frame)) { //if dragobject is in the rect of line one or line two
      int tag = 0;
      for (UIView *view in answerViews) {
        CGRect firstRect = [firstLine convertRect:view.frame toView:self.view];
        if (CGRectIntersectsRect(dragObject.frame, firstRect)) {
          if ([[selectedAnswerTags objectAtIndex:tag] integerValue] == -1) {//if the slot that we drag to is not taken
            [selectedAnswerTags replaceObjectAtIndex:tag withObject:[NSNumber numberWithInt:dragObject.tag]];
            [selectedAnswerTags replaceObjectAtIndex:previousTag withObject:[NSNumber numberWithInt:-1]];
            [selectedLetters replaceObjectAtIndex:previousTag withObject:[NSNumber numberWithInt:-1]];
            [self addLetterToAnswer:tag];
            dragObject.frame = firstRect;
          }
          else if ([[selectedAnswerTags objectAtIndex:tag]integerValue] != -1) {
            //do an animation swapping letters
            UIView *droppedOnView = [self.view viewWithTag:[[selectedAnswerTags objectAtIndex:tag]integerValue]];
            for (UIImageView *view in droppedOnView.subviews) {
              for (UILabel *l in view.subviews) {
                [selectedLetters replaceObjectAtIndex:previousTag withObject:l.text];
              }
            }
            droppedOnView.frame = homePosition;
            dragObject.frame = firstRect;
            [selectedAnswerTags replaceObjectAtIndex:previousTag withObject:[NSNumber numberWithInt:droppedOnView.tag]];
            [selectedAnswerTags replaceObjectAtIndex:tag withObject:[NSNumber numberWithInt:dragObject.tag]];
            [self addLetterToAnswer:tag];
          }
          else {
            [UIView animateWithDuration:0.1f animations:^{
              dragObject.frame = homePosition;
            }];
          }
          return;
        }
        tag++;
      }
    }
    else {
      [self resetLetter];
      for (int i = 0 ; i <selectedAnswerTags.count;i++) {
        int answer = [[selectedAnswerTags objectAtIndex:i] integerValue];
        if (answer == dragObject.tag) {
          [selectedAnswerTags replaceObjectAtIndex:i withObject:[NSNumber numberWithInt:-1]];
          [selectedLetters replaceObjectAtIndex:i withObject:[NSNumber numberWithInt:-1]];
          break;
        }
      }
    }
  }
}

- (void)movePreviousAnswerBackToSelection:(int)tag {
  UIView *previousView = [self.view viewWithTag:tag];
  [UIView animateWithDuration:0.1f animations:^{
    previousView.frame = originalLetterLocations[tag-1];
    UIImageView *b = [bottomBarArray objectAtIndex:tag-1];
    b.hidden = NO;
  }completion:^(BOOL finished) {
    UIImageView *b = [bottomBarArray objectAtIndex:tag-1];
    b.hidden = NO;
  }];
}

- (void)draggingPlacementAndAnimations {
  if (numberOfLines == 2 && moving) { //if user is dragging the selection slots and its a 2 lined answer
    UIView *firstLine = [self.view viewWithTag:kFirstLine];
    UIView *secondLine = [self.view viewWithTag:kSecondLine];
    if (CGRectIntersectsRect(dragObject.frame, firstLine.frame) || CGRectIntersectsRect(dragObject.frame, secondLine.frame)) { //if dragobject is in the rect of line one or line two
      int tag = 0; // this tag is for locating the intersected tag in our selectedAnswerTag
      for (UIView *view in answerViews) {
        CGRect firstRect = [firstLine convertRect:view.frame toView:self.view];
        CGRect secondRect = [secondLine convertRect:view.frame toView:self.view];
        if (CGRectIntersectsRect(dragObject.frame, firstRect)) { // if it intersets with the first line
          dragObject.frame = firstRect;
          if ([[selectedAnswerTags objectAtIndex:tag]integerValue] != -1) { // if our answer slot is already taken
            [self movePreviousAnswerBackToSelection:[[selectedAnswerTags objectAtIndex:tag]integerValue]];
          }
          [selectedAnswerTags replaceObjectAtIndex:tag withObject:[NSNumber numberWithInt:dragObject.tag]];
          [self addLetterToAnswer:tag];
          return;
        }
        else if (CGRectIntersectsRect(dragObject.frame, secondRect)) { // if it intersets with the second line
          tag = firstLineCount + tag;
          dragObject.frame = secondRect;
          if ([[selectedAnswerTags objectAtIndex:tag]integerValue] != -1) { // if our answer slot is already taken
            [self movePreviousAnswerBackToSelection:[[selectedAnswerTags objectAtIndex:tag]integerValue]];
          }
          [selectedAnswerTags replaceObjectAtIndex:tag withObject:[NSNumber numberWithInt:dragObject.tag]];
          [self addLetterToAnswer:tag];
          return;
        }
        tag++;
      }
    }
    else {
      [self resetLetter];
    }
  }
  else if (numberOfLines == 1 && moving) { // if user is dragging the selection slots and its a 1 lined answer
    UIView *firstLine = [self.view viewWithTag:kFirstLine];
    int tag = 0; // this tag is for locating the intersected tag in our selectedAnswerTag
    if (CGRectIntersectsRect(dragObject.frame, firstLine.frame)) {
      for (UIView *view in answerViews) {
        CGRect firstRect = [firstLine convertRect:view.frame toView:self.view];
        if (CGRectIntersectsRect(dragObject.frame, firstRect)) {
          dragObject.frame = firstRect;
          if ([[selectedAnswerTags objectAtIndex:tag]integerValue] != -1) { // if our answer slot is already taken
            [self movePreviousAnswerBackToSelection:[[selectedAnswerTags objectAtIndex:tag]integerValue]];
          }
          [selectedAnswerTags replaceObjectAtIndex:tag withObject:[NSNumber numberWithInt:dragObject.tag]];
          [self addLetterToAnswer:tag];
          return;
        }
        tag++;
      }
    }
    else {
      [self resetLetter];
    }
  }
}

- (void)addLetterToAnswer:(int)tag {
  //add the letter to our selectedLetters
  for (UIImageView *image in dragObject.subviews) {
    for (UILabel *l in image.subviews) {
      [selectedLetters replaceObjectAtIndex:tag withObject:l.text];
    }
  }
}

- (void)inputTouchedSlot {
  //this is just pressing, not dragging
  int open = [self checkForOpenslot];
  if (open == selectedAnswerTags.count) { // this means if all the slots are full, it does nothing
    return;
  }
  UIImageView *answerSlot = [answerViews objectAtIndex:open];
  if (numberOfLines == 1) {
    //if answer is 1 lined and converts the view to self.view's point and replace the answer slot
    UIView *firstLine = [self.view viewWithTag:kFirstLine];
    CGRect newFrame = [firstLine convertRect:answerSlot.frame toView:self.view];
    [UIView animateWithDuration:0.2f animations:^{
      dragObject.frame = newFrame;
    }];
  }
  else {
    //if answer is 2 lined and converts the view to self.view's point and replace the answer slot
    if (open < firstLineCount) {
      UIView *firstLine = [self.view viewWithTag:kFirstLine];
      CGRect newFrame = [firstLine convertRect:answerSlot.frame toView:self.view];
      [UIView animateWithDuration:0.2f animations:^{
        dragObject.frame = newFrame;
      }];
    }
    else {
      UIView *secondLine = [self.view viewWithTag:kSecondLine];
      CGRect newFrame = [secondLine convertRect:answerSlot.frame toView:self.view];
      [UIView animateWithDuration:0.2f animations:^{
        dragObject.frame = newFrame;
      }];
    }
  }
  //add the dragobject's tag to our answer
  [selectedAnswerTags replaceObjectAtIndex:open withObject:[NSNumber numberWithInt:dragObject.tag]];
  
  //add the letter inside the dragobject to our answer in letters
  for (UIImageView *image in dragObject.subviews) {
    for (UILabel *l in image.subviews) {
      [selectedLetters replaceObjectAtIndex:open withObject:l.text];
    }
  }
  
  if (self.game.isTutorial) {
    [self.game showNextLetterCallBack];
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
    if (self.game.isTutorial) {
      dragObject = nil;
    }
  }
  else {
    [self showError];
    if (self.game.isTutorial) {
      dragObject = nil;
    }
  }
}

- (void)showCorrect {
  for (int i = 0; i < selectedAnswerTags.count;i++) {
    int tag = [[selectedAnswerTags objectAtIndex:i] integerValue];
    UIView *view = [self.view viewWithTag:tag];
    for (UIImageView *v in view.subviews) {
      for (UILabel *l in v.subviews) {
        l.textColor = [UIColor greenColor];
      }
    }
  }
  if (self.game.isTutorial)
    [self.game tutorialCorrectionAnimationWithCorrect:YES fromQuestionType:kFillIn];
  else
    [self.game transitionWithConclusion:YES skipping:NO andNextQuestionType:kFillIn point:10];
}

- (void)showError {
  for (int i = 0; i < selectedAnswerTags.count;i++) {
    int tag = [[selectedAnswerTags objectAtIndex:i] integerValue];
    UIView *view = [self.view viewWithTag:tag];
    for (UIImageView *v in view.subviews) {
      for (UILabel *l in v.subviews) {
        [UIView animateWithDuration:0.1 delay:0.0 options:(UIViewAnimationOptionAutoreverse| UIViewAnimationOptionRepeat) animations:^{
          [UIView setAnimationRepeatCount:5];
          l.textColor = [UIColor redColor];
          l.alpha = 0.0f;
        }completion:^(BOOL finished) {
          l.textColor = [UIColor blackColor];
          l.alpha = 1.0f;
        }];
      }
    }
  }
  if (self.game.isTutorial) [self.game tutorialCorrectionAnimationWithCorrect:NO fromQuestionType:kFillIn];
  else [self.game transitionWithConclusion:NO skipping:NO andNextQuestionType:kFillIn point:0];
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

- (void)removeOptions {
  if (cheatCount >= correctLetterCount) {
    return;
  }
  int cheatIndex = [[cheatCountArray objectAtIndex:cheatCount] integerValue];
  
  NSString *letterToTakeOut = [cheatArray objectAtIndex:cheatIndex];
  for (int i = 0; i < selectionSlots.count; i++) {
    NSString *fromSelection = [NSString stringWithFormat:@"%@",[selectionSlots objectAtIndex:i]];
    if ([fromSelection isEqualToString:letterToTakeOut]) {
      UIView *selectionLetter = [self.view viewWithTag:i+1];
      [selectionSlots replaceObjectAtIndex:i withObject:[NSNumber numberWithInt:-1]];
      [self addCheatViewtoAnswerView:selectionLetter tagInArray:cheatIndex letterToTakeOut:letterToTakeOut];
      break;
    }
  }
  cheatCount++;
  if (cheatCount == correctLetterCount) {
    [self performSelector:@selector(checkIfAnswerIsCorrect) withObject:nil afterDelay:0.3f];
  }
}


- (void)addCheatViewtoAnswerView:(UIView *)cheatView tagInArray:(int)tag letterToTakeOut:(NSString *)letter{
  UIView *view = (UIView *)[answerViews objectAtIndex:tag];
  [usedCheatArray addObject:[NSNumber numberWithInt:cheatView.tag]];
  dragObject = cheatView;
  if (numberOfLines == 2) {
    UIView *firstLine = [self.view viewWithTag:kFirstLine];
    UIView *secondLine = [self.view viewWithTag:kSecondLine];
    CGRect newFrame;
    if (tag < firstLineCount) newFrame = [firstLine convertRect:view.frame toView:self.view];
    else newFrame = [secondLine convertRect:view.frame toView:self.view];
    [UIView animateWithDuration:0.3f animations:^{
      cheatView.frame = newFrame;
    }];
    [self hideBottomBar];
  }
  else {
    UIView *firstLine = [self.view viewWithTag:kFirstLine];
    CGRect newFrame = [firstLine convertRect:view.frame toView:self.view];
    [UIView animateWithDuration:0.3f animations:^{
      cheatView.frame = newFrame;
    }];
    [self hideBottomBar];
  }
  [selectedAnswerTags replaceObjectAtIndex:tag withObject:[NSNumber numberWithInt:view.tag]];
  [selectedLetters replaceObjectAtIndex:tag withObject:letter];
}

@end
