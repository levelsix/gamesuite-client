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
  BOOL filledSlotMoving;
  BOOL isInMorethanOneRect;
  CGRect homePosition;
  NSMutableArray *bottomBarArray;
  NSMutableArray *answerViews;
  UIView *dragObject;
  NSMutableArray *selectedAnswerTags;
  NSMutableArray *selectedLetters;
  CGRect originalLetterLocations[14];
  NSArray *selectionSlots;
  NSString *correctAnswer;
  int previousTag;
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
  correctLetterCount = 12;
  numberOfLines = 2;
  firstLineCount = 6;
  secondLineCount = 6;
  for (int i = 0 ; i < correctLetterCount; i++) {
    [selectedAnswerTags addObject:[NSNumber numberWithInt:-1]];
    [selectedLetters addObject:[NSNumber numberWithInt:-1]];
  }
  selectionSlots = [[NSArray alloc] initWithObjects:@"L",@"E",@"V",@"E",@"L",@"6",@" ",@"R",@"O",@"C",@"K",@"S",@"!",@" ",nil];
  [self createAnswerSlots];
  [self createSelectionSlots];
  animationCounter = 1;
  correctAnswer = @"LEVEL6ROCKS!";
  [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(animateSelectionSlots:) userInfo:nil repeats:YES];
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
    firstLine.center = CGPointMake(self.view.frame.size.width/2, 180);
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

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event   {
  UITouch *touch = [[event allTouches] anyObject];
  CGPoint touchLocation = [touch locationInView:self.view];
  
  for (UIView *view in self.view.subviews) {
    if (CGRectContainsPoint(view.frame, touchLocation)) {
      if (view.tag > 0 && view.tag <= kAnswerSlotBottomEndingTag) { //touching the selection slots
        dragObject = view;
        dragging = YES;
        [self.view bringSubviewToFront:dragObject];
        int tag = 0; //this tag is for locating the intersected tag in our selectedAnswerTag
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
  NSLog(@"%d",filledSlotMoving);
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


//- (void)checkIfDragViewIsIntersectingMultipleRect {
//  //loop through all of our view
//  NSMutableArray *areas = [NSMutableArray array];
//  NSMutableArray *intersectedTag = [NSMutableArray array];
//  int tag = 0;
//  UIView *firstLine = [self.view viewWithTag:kFirstLine];
//  UIView *secondLine = [self.view viewWithTag:kSecondLine];
//  if (numberOfLines == 2) {
//    if (CGRectIntersectsRect(dragObject.frame, firstLine.frame) || CGRectIntersectsRect(dragObject.frame, secondLine.frame)) {
//      for (UIView *view in answerViews) {
//        CGRect firstRect = [firstLine convertRect:view.frame toView:self.view];
//        if (CGRectIntersectsRect(dragObject.frame, firstRect)) {
//          CGRect rect = CGRectIntersection(dragObject.frame, firstRect);
//          float area = rect.size.width * rect.size.height;
//          [areas addObject:[NSNumber numberWithFloat:area]];
//          [intersectedTag addObject:[NSNumber numberWithInt:tag]];
//          tag++;
//        }
//        CGRect secondRect = [secondLine convertRect:view.frame toView:self.view];
//        if (CGRectIntersectsRect(dragObject.frame, secondRect)) {
//          CGRect rect = CGRectIntersection(dragObject.frame, secondRect);
//          float area = rect.size.width * rect.size.height;
//          [areas addObject:[NSNumber numberWithFloat:area]];
//          [intersectedTag addObject:[NSNumber numberWithInt:tag]];
//          tag++;
//        }
//      }
//    }
//  }
//  float previousArea = 0;
//  int arrayCounter = 0;
//  int actualTagInAnswerArray;
//  for (int i = 0; i < tag; i+=2) {
//    float area = [[areas objectAtIndex:i] floatValue];
//    if (previousArea <= area) {
//      previousArea = area;
//      arrayCounter = i;
//    }
//  }
//  NSLog(@"%f", previousArea);
//  actualTagInAnswerArray = [[intersectedTag objectAtIndex:arrayCounter/2] integerValue];
//  UIView *view = (UIView *)[answerViews objectAtIndex:actualTagInAnswerArray];
//  CGRect newFrame;
//  if (numberOfLines == 2) {
//    if (actualTagInAnswerArray < firstLineCount) {
//      newFrame = [firstLine convertRect:view.frame toView:self.view];
//    }
//    else {
//      newFrame = [secondLine convertRect:view.frame fromView:self.view];
//    }
//  }
//  else {
//    newFrame = [firstLine convertRect:view.frame fromView:self.view];
//  }
//  dragObject.frame = newFrame;
//  NSLog(@"%f",newFrame.size.width*newFrame.size.height);
//}


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
      NSLog(@"meep");
      [self resetLetter];
      for (int i = 0 ; i <selectedAnswerTags.count;i++) {
        int answer = [[selectedAnswerTags objectAtIndex:0] integerValue];
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
  //if everything is full, we check if the answer is correct
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
  //NSLog(@"%@",answer);
  if ([answer isEqualToString:correctAnswer]) {
    [self showCorrect];
  }
  else {
    [self showError];
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
  [self.game transitionWithConclusion:YES skipping:NO andNextQuestionType:kFillIn];
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
  [self.game transitionWithConclusion:NO skipping:NO andNextQuestionType:kFillIn];
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
