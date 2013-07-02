//
//  FillInViewController.m
//  Icon-Blitz
//
//  Created by Danny on 6/26/13.
//
//

#import "FillInViewController.h"
#import "GameViewController.h"
#import "AnswerView.h"

#define MAX_ONE_LINE_SLOTS 7
#define WIDTH_DIFFERENCE 40
#define LETTER_OPTION_VIEW_TAG 1
#define LETTER_OPTION_BOTTOM_TAG 15
#define ANSWER_SLOTS_TAG 50
#define FIRST_ANSWER_LINE_TAG 100
#define SECOND_ANSWER_LINE_TAG 101

@interface FillInViewController () {
  NSMutableArray *letterOptionsArray;
  NSMutableArray *answerSlotViews;
  NSMutableArray *originalAnswerFrameArray;
  NSMutableArray *submittedAnswers;
  NSMutableArray *submittedAnswersTag;
  NSMutableArray *usedCheatArray;
  NSMutableArray *cheatCountArray;
  NSMutableArray *cheatArray;
  CGRect originalLetterViewLocations[14];
  CGRect originalAnswerViewLocations[14];
  CGRect homePosition;
  NSString *correctAnswer;
  NSString *lastQuestion;
  
  int animationCounter;
  int numberOfLines;
  int firstLineLetterCount;
  int secondLineLetterCount;
  int maxAnswerSlotTag;
  int correctAnswerLetterCount;
  int cheatCount;
  
  BOOL isIconQuestion;
  BOOL touched;
  BOOL dragging;
  BOOL slotTaken[14];
  
  SelectionView *selectedObject;
  
}

@end

@implementation FillInViewController

- (id)initWithGame:(GameViewController *)game {
  if ((self = [super init]) ) {
    self.game = game;
    animationCounter = 1;
    [self inputTestData];
    self.view.userInteractionEnabled = NO;
    [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(animateSelectionSlots:) userInfo:nil repeats:YES];
  }
  return self;
}

- (void)inputTestData {
  firstLineLetterCount = 5;
  secondLineLetterCount = 4;
  numberOfLines = 2;
  correctAnswerLetterCount = 9;
  letterOptionsArray = [[NSMutableArray alloc] initWithObjects:@"L",@"E",@"V",@"E",@"L",@"6",@" ",@"R",@"O",@"C",@"K",@"S",@"!",@" ",nil];
  correctAnswer = @"LEVELROCK";
  
  answerSlotViews = [[NSMutableArray alloc] init];
  originalAnswerFrameArray = [[NSMutableArray alloc] init];
  submittedAnswers = [[NSMutableArray alloc] init];
  submittedAnswersTag = [[NSMutableArray alloc] init];
  
  for (int i = 0 ; i < correctAnswerLetterCount; i++) {
    [submittedAnswers addObject:@"A"];
    [submittedAnswersTag addObject:[NSNumber numberWithInt:-1]];
  }
  
  for (int i = 0; i < 14; i++) {
    slotTaken[i] = NO;
  }
  [self createLetterOptions];
  [self createAnswerSlotViews];
  [self generatePreCheatList];
  [self fillInCheatArray];
}

- (void)viewDidLoad
{
  [super viewDidLoad];
}

- (void)generatePreCheatList {
  cheatCountArray = [NSMutableArray array];
  int ar[correctAnswerLetterCount],i,d,tmp;
  for(i = 0; i < correctAnswerLetterCount; i++) ar[i] = i;
  for(i = 0; i < correctAnswerLetterCount; i++) {
    d = i + (arc4random()%(correctAnswerLetterCount-i));
    tmp = ar[i];
    ar[i] = ar[d];
    ar[d] = tmp;
  }
  for (int i = 0; i <correctAnswerLetterCount; i++) {
    [cheatCountArray addObject:[NSNumber numberWithInt:ar[i]]];
  }
}

- (void)fillInCheatArray {
  for (int i = 0 ; i < correctAnswerLetterCount; i++) {
    char letter = [correctAnswer characterAtIndex:i];
    NSString *letterString = [NSString stringWithFormat:@"%c",letter];
    [cheatArray addObject:letterString];
  }
}

- (void)createLetterOptions {
  int optionViewtag = LETTER_OPTION_VIEW_TAG;
  int optionViewBottomTag = LETTER_OPTION_BOTTOM_TAG;
  int arrayIndex = 0;
  for (int i = 0; i < MAX_ONE_LINE_SLOTS; i++) {
    UIImage *bottom = [UIImage imageNamed:@"buttonbottom.png"];
    UIImageView *bottomView = [[UIImageView alloc] initWithImage:bottom];
    
    UIImage *top = [UIImage imageNamed:@"buttontop.png"];
    UIImageView *topView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, top.size.width, top.size.height)];
    topView.image = top;
    
    SelectionView *slotView = [[SelectionView alloc] initWithFrame:CGRectMake(23 + (i * WIDTH_DIFFERENCE), 255, topView.frame.size.width, topView.frame.size.height + bottomView.frame.size.height)];
    
    bottomView.frame = CGRectMake(0, topView.frame.size.height - 7, 37, 11);
    [slotView addSubview:bottomView];
    [slotView addSubview:topView];
    slotView.bottomBar = bottomView;
    
    slotView.tag = optionViewtag;
    bottomView.tag = optionViewBottomTag;
    
    NSString *letter = [letterOptionsArray objectAtIndex:arrayIndex];
    UILabel *letterLabel = [[UILabel alloc] initWithFrame:CGRectMake(9.5, 5, 37, 37)];
    letterLabel.font = [UIFont fontWithName:@"Avenir Next Lt Pro" size:23];
    letterLabel.text = letter;
    letterLabel.backgroundColor = [UIColor clearColor];
    [letterLabel setFrame:CGRectMake(0,5,letterLabel.frame.size.width,letterLabel.frame.size.height)];
    letterLabel.textAlignment = UITextAlignmentCenter;
    [topView addSubview:letterLabel];
    originalLetterViewLocations[arrayIndex] = slotView.frame;
    
    [self.view addSubview:slotView];
    arrayIndex++;
    optionViewBottomTag++;
    optionViewtag++;
    slotView.transform = CGAffineTransformMakeScale(0.01, 0.01);
    slotView.alpha = 0.0f;
  }
  
  for (int i = 0 ; i < MAX_ONE_LINE_SLOTS; i++) {
    UIImage *bottom = [UIImage imageNamed:@"buttonbottom.png"];
    UIImageView *bottomView = [[UIImageView alloc] initWithImage:bottom];
    
    UIImage *top = [UIImage imageNamed:@"buttontop.png"];
    UIImageView *topView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, top.size.width, top.size.height)];
    topView.image = top;
    
    SelectionView *slotView = [[SelectionView alloc] initWithFrame:CGRectMake(23 + (i * WIDTH_DIFFERENCE), 305, topView.frame.size.width, topView.frame.size.height + bottomView.frame.size.height)];
    
    bottomView.frame = CGRectMake(0, topView.frame.size.height - 7, 37, 11);
    [slotView addSubview:bottomView];
    [slotView addSubview:topView];
    slotView.bottomBar = bottomView;
    
    slotView.tag = optionViewtag;
    bottomView.tag = optionViewBottomTag;
    
    NSString *letter = [letterOptionsArray objectAtIndex:arrayIndex];
    UILabel *letterLabel = [[UILabel alloc] initWithFrame:CGRectMake(9.5, 5, 37, 37)];
    letterLabel.font = [UIFont fontWithName:@"Avenir Next Lt Pro" size:23];
    letterLabel.text = letter;
    letterLabel.backgroundColor = [UIColor clearColor];
    [letterLabel setFrame:CGRectMake(0,5,letterLabel.frame.size.width,letterLabel.frame.size.height)];
    letterLabel.textAlignment = UITextAlignmentCenter;
    [topView addSubview:letterLabel];
    originalLetterViewLocations[arrayIndex] = slotView.frame;
    
    [self.view addSubview:slotView];
    arrayIndex++;
    optionViewBottomTag++;
    optionViewtag++;
    slotView.transform = CGAffineTransformMakeScale(0.01, 0.01);
    slotView.alpha = 0.0f;
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
    [timer invalidate];
  }
}

- (void)createAnswerSlotViews {
  int setTag = 0;
  int tag = ANSWER_SLOTS_TAG;
  NSMutableArray *firstLineViewTags = [[NSMutableArray alloc] init];
  NSMutableArray *secondLineViewTags = [[NSMutableArray alloc] init];
  if (numberOfLines == 2) {
    UIView *firstLine = [[UIView alloc] init];
    float lastSlotPosY;
    float lastSlotPosX;
    for (int i = 0; i < firstLineLetterCount; i++) {
      NSString *letterPath = [NSString stringWithFormat:@"unfilledblack.png"];
      UIImage *letters = [UIImage imageNamed:letterPath];
      AnswerView *view = [[AnswerView alloc] initWithFrame:CGRectMake(i * WIDTH_DIFFERENCE, 0, 37, 38)];
      view.image = letters;
      view.tag = tag;
      view.inArrayTag = setTag;
      [firstLineViewTags addObject:[NSNumber numberWithInt:tag]];
      tag++;
      setTag++;
      if (i == firstLineLetterCount-1) {
        lastSlotPosX = view.center.x + view.frame.size.width/2;
        lastSlotPosY = view.frame.size.height;
      }
      [firstLine addSubview:view];
    }
    
    firstLine.frame = CGRectMake(0, 0, lastSlotPosX, lastSlotPosY);
    firstLine.center = CGPointMake(self.view.frame.size.width/2, 170);
    [self.view addSubview:firstLine];
    
    UIView *secondLine = [[UIView alloc] init];
    
    for (int i = 0; i < secondLineLetterCount; i++) {
      NSString *letterPath = [NSString stringWithFormat:@"unfilledblack.png"];
      UIImage *letters = [UIImage imageNamed:letterPath];
      AnswerView *view = [[AnswerView alloc] initWithFrame:CGRectMake(i * WIDTH_DIFFERENCE, 0, 37, 38)];
      view.image = letters;
      view.tag = tag;
      view.inArrayTag = setTag;
      [secondLineViewTags addObject:[NSNumber numberWithInt:tag]];
      tag++;
      setTag++;
      if (i == secondLineLetterCount-1) {
        lastSlotPosX = view.center.x + view.frame.size.width/2;
        lastSlotPosY = view.frame.size.height;
      }
      [secondLine addSubview:view];
    }
    firstLine.tag = FIRST_ANSWER_LINE_TAG;
    secondLine.tag = SECOND_ANSWER_LINE_TAG;
    secondLine.frame = CGRectMake(0, 0, lastSlotPosX, lastSlotPosY);
    secondLine.center = CGPointMake(self.view.frame.size.width/2, 215);
    [self.view addSubview:secondLine];    
  }
  else {
    UIView *firstLine = [[UIView alloc] init];
    float lastSlotPosY;
    float lastSlotPosX;
    for (int i = 0; i < firstLineLetterCount; i++) {
      NSString *letterPath = [NSString stringWithFormat:@"unfilledblack.png"];
      UIImage *letters = [UIImage imageNamed:letterPath];
      AnswerView *view = [[AnswerView alloc] initWithFrame:CGRectMake(i * WIDTH_DIFFERENCE, 0, 37, 38)];
      view.image = letters;
      view.tag = tag;
      view.inArrayTag = setTag;
      [firstLineViewTags addObject:[NSNumber numberWithInt:tag]];
      tag++;
      if (i == firstLineLetterCount-1) {
        lastSlotPosX = view.center.x + view.frame.size.width/2;
        lastSlotPosY = view.frame.size.height;
      }
      CGRect firstRect = [firstLine convertRect:view.frame toView:self.view];
      originalAnswerViewLocations[setTag] = firstRect;
      setTag++;

      [firstLine addSubview:view];
    }
    firstLine.tag = FIRST_ANSWER_LINE_TAG;
    firstLine.frame = CGRectMake(0, 0, lastSlotPosX, lastSlotPosY);
    if (isIconQuestion) firstLine.center = CGPointMake(self.view.frame.size.width/2, 225);
    else firstLine.center = CGPointMake(self.view.frame.size.width/2, 200);
    [self.view addSubview:firstLine];
  }
  [self convertRectsWithFirstArray:firstLineViewTags secondArray:secondLineViewTags];
  maxAnswerSlotTag = tag;
  for (int i = ANSWER_SLOTS_TAG; i < maxAnswerSlotTag; i++) {
    AnswerView *j = (AnswerView *)[self.view viewWithTag:i];
    [answerSlotViews addObject:j];
  }
}

- (void)convertRectsWithFirstArray:(NSArray *)first secondArray:(NSArray *)second {
  int tag = 0;
  UIView *firstLine = [self.view viewWithTag:FIRST_ANSWER_LINE_TAG];
  UIView *secondLine = [self.view viewWithTag:SECOND_ANSWER_LINE_TAG];
  for (int i = 0; i < first.count;i++){
    int viewTag = [[first objectAtIndex:i] integerValue];
    AnswerView *view = (AnswerView *)[firstLine viewWithTag:viewTag];
    CGRect rect  = [firstLine convertRect:view.frame toView:self.view];
    originalAnswerViewLocations[tag] = rect;
    tag++;
  }
  for (int i = 0; i <second.count; i++) {
    int viewTag = [[second objectAtIndex:i] integerValue];
    AnswerView *view = (AnswerView *)[secondLine viewWithTag:viewTag];
    CGRect rect = [secondLine convertRect:view.frame toView:self.view];
    originalAnswerViewLocations[tag] = rect;
    tag++;
  }
  
  for (int i = 0; i < correctAnswerLetterCount; i++) {
    [originalAnswerFrameArray addObject:[NSValue valueWithCGRect:originalAnswerViewLocations[i]]];
  }
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
  UITouch *touch = [[event allTouches] anyObject];
  CGPoint touchLocation = [touch locationInView:self.view];
  for (SelectionView *subview in self.view.subviews) {
    if (CGRectContainsPoint(subview.frame, touchLocation)) {
      //user is touching our options, which tags are from 1-14
      if (subview.tag > 0 && subview.tag <= 14) {
        selectedObject = subview;
        [self.view bringSubviewToFront:selectedObject];
        touched = YES;
        homePosition = selectedObject.frame;
        if (!selectedObject.used) {
          [self hideBottomBar];
        }
      }
    }
  }
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
  UITouch *touch = [[event allTouches] anyObject];
  CGPoint touchLocation = [touch locationInView:self.view];
  if (touched) {
    if (!selectedObject.used)  {
      dragging = YES;
      selectedObject.center = touchLocation;selectedObject.center = touchLocation;
    }
  }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
  if (touched && !dragging) {
    if (selectedObject.used) {
      [self resetLetter];
    }
    else {
      [self inputNonDraggingLetter];
    }
  }
  else if (touched && dragging) {
    [self inputDraggingLetter];
  }
  touched = NO;
  dragging = NO;
  
  NSLog(@"%@",submittedAnswers);
  
  for (int i = 0; i < answerSlotViews.count; i++) {
    AnswerView *answer = (AnswerView *)[answerSlotViews objectAtIndex:i];
    if (!answer.taken) {
      return;
      break;
    }
    if (i == answerSlotViews.count - 1) {
      self.view.userInteractionEnabled = NO;
      [self checkIfAnswerIsCorrect];
    }
  }
}

- (void)checkIfAnswerIsCorrect{
  NSString *answer = @"";
  for (int i = 0; i < submittedAnswers.count; i++) {
    NSString *letter =[submittedAnswers objectAtIndex:i];
    answer = [NSString stringWithFormat:@"%@%@",answer,letter];
  }
  if ([answer isEqualToString:correctAnswer]) {
    [self showCorrectAnimation];
  }
  else {
    [self showFalseAnimation];
  }
}

- (void)showCorrectAnimation {
  for (NSNumber *tag in submittedAnswersTag) {
    SelectionView *selection = (SelectionView *)[self.view viewWithTag:[tag integerValue]];
    for (UIImageView *l in selection.subviews) {
      for (UILabel *letter in l.subviews) {
        [UIView animateWithDuration:0.1 delay:0.0 options:(UIViewAnimationOptionAutoreverse| UIViewAnimationOptionRepeat) animations:^{
          [UIView setAnimationRepeatCount:5];
          letter.textColor = [UIColor greenColor];
          letter.alpha = 0.0f;
        }completion:^(BOOL finished) {
          letter.textColor = [UIColor blackColor];
          letter.alpha = 1.0f;
        }];
      }
    }
  }
  [self.game transitionWithConclusion:YES skipping:NO andNextQuestionType:kFillIn];
}

- (void)showFalseAnimation {
  for (NSNumber *tag in submittedAnswersTag) {
    SelectionView *selection = (SelectionView *)[self.view viewWithTag:[tag integerValue]];
    for (UIImageView *l in selection.subviews) {
      for (UILabel *letter in l.subviews) {
        [UIView animateWithDuration:0.1 delay:0.0 options:(UIViewAnimationOptionAutoreverse| UIViewAnimationOptionRepeat) animations:^{
          [UIView setAnimationRepeatCount:5];
          letter.textColor = [UIColor redColor];
          letter.alpha = 0.0f;
        }completion:^(BOOL finished) {
          letter.textColor = [UIColor blackColor];
          letter.alpha = 1.0f;
        }];
      }
    }
  }
  [self.game transitionWithConclusion:NO skipping:NO andNextQuestionType:kFillIn];
}

- (void)hideBottomBar {
  [UIView animateWithDuration:0.1f animations:^{
    selectedObject.center = CGPointMake(selectedObject.center.x, selectedObject.center.y+4);
    selectedObject.bottomBar.hidden = YES;
  }];
}

- (void)inputDraggingLetter {
  NSMutableArray *areas = [[NSMutableArray alloc] init];
  for (NSValue *frameValue in originalAnswerFrameArray) {
    CGRect newFrame = [frameValue CGRectValue];
    CGRect rect = CGRectIntersection(selectedObject.frame, newFrame);
    float area = rect.size.width * rect.size.height;
    [areas addObject:[NSNumber numberWithFloat:area]];
  }
  float xmax = -MAXFLOAT;
  float xmin = MAXFLOAT;
  for (NSNumber *num in areas) {
    float x = num.floatValue;
    if (x < xmin) xmin = x;
    if (x > xmax) xmax = x;
  }
  
  if (xmin <= 0 && xmax <= 0) {
    [self resetLetter];
    return;
  }
  
  for (int i = 0; i < areas.count; i++) {
    NSNumber *num = [areas objectAtIndex:i];
    if ([num floatValue] == xmax) {
      AnswerView *view = (AnswerView *)[answerSlotViews objectAtIndex:i];
      if (view.taken) {
        int tag = [[submittedAnswersTag objectAtIndex:view.inArrayTag] integerValue];
        SelectionView *selection = (SelectionView *)[self.view viewWithTag:tag];
        [self resetLetterWithView:selection];
      }
      CGRect newFrame = [[originalAnswerFrameArray objectAtIndex:i] CGRectValue];
      selectedObject.frame = newFrame;
      view.taken = YES;
      selectedObject.used = YES;
      selectedObject.takenTag = view.inArrayTag;
      for (UIImageView *image in selectedObject.subviews) {
        for (UILabel *l in image.subviews) {
          NSString *letter = l.text;
          [submittedAnswers replaceObjectAtIndex:view.inArrayTag withObject:letter];
          [submittedAnswersTag replaceObjectAtIndex:view.inArrayTag withObject:[NSNumber numberWithInt:selectedObject.tag]];
        }
      }
      selectedObject = nil;
      break;
    }
  }
}

- (void)resetLetterWithView:(SelectionView *)view {
  [UIView animateWithDuration:0.15f animations:^{
    view.frame = originalLetterViewLocations[view.tag-1];
  }completion:^(BOOL finished) {
    view.used = NO;
    view.bottomBar.hidden = NO;
    selectedObject = nil;
  }];
}

- (void)resetLetter {
  [UIView animateWithDuration:0.15f animations:^{
    selectedObject.frame = originalLetterViewLocations[selectedObject.tag-1];
  }completion:^(BOOL finished) {
    if (selectedObject.used) {
      AnswerView *answer = [answerSlotViews objectAtIndex:selectedObject.takenTag];
      answer.taken = NO;
      [submittedAnswers replaceObjectAtIndex:selectedObject.takenTag withObject:@"A"];
      [submittedAnswersTag replaceObjectAtIndex:selectedObject.takenTag withObject:[NSNumber numberWithInt:-1]];
      selectedObject.takenTag = -1;
    }
    selectedObject.bottomBar.hidden = NO;
    selectedObject.used = NO;
    selectedObject = nil;
  }];
}

- (void)inputNonDraggingLetter {
  AnswerView *view = [self firstAvaiableAnswerSlot];
  if (numberOfLines == 1) {
    [self moveToOneLineWithAnswerFrame:view];
  }
  else {
    [self moveToTwoLineWithAnswerFrame:view];
  }
}

- (void)moveToOneLineWithAnswerFrame:(AnswerView *)answerView {
  CGRect newFrame = originalAnswerViewLocations[answerView.inArrayTag];
  [UIView animateWithDuration:0.2f animations:^{
    selectedObject.frame = newFrame;
  }];
  selectedObject.used = YES;
  answerView.taken = YES;
  selectedObject.takenTag = answerView.inArrayTag;
  selectedObject = nil;
}

- (void)moveToTwoLineWithAnswerFrame:(AnswerView *)answerView {
  CGRect newFrame = originalAnswerViewLocations[answerView.inArrayTag];
  [UIView animateWithDuration:0.2f animations:^{
    selectedObject.frame = newFrame;
  }];
  selectedObject.used = YES;
  answerView.taken = YES;
  selectedObject.takenTag = answerView.inArrayTag;
  for (UIImageView *image in selectedObject.subviews) {
    for (UILabel *l in image.subviews) {
      NSString *letter = l.text;
      [submittedAnswers replaceObjectAtIndex:answerView.inArrayTag withObject:letter];
      [submittedAnswersTag replaceObjectAtIndex:answerView.inArrayTag withObject:[NSNumber numberWithInt:selectedObject.tag]];
    }
  }
  selectedObject = nil;
}

- (AnswerView *)firstAvaiableAnswerSlot {
  for (AnswerView *answerSlot in answerSlotViews) {
    if (!answerSlot.taken) {
      return answerSlot;
      break;
    }
  }
  return nil;
}

- (void)removeOptions {
  if (cheatCount >= correctAnswerLetterCount) {
    return;
  }
  
  int cheatIndex = [[cheatCountArray objectAtIndex:cheatCount] integerValue];
  NSString *letterToTakeOut = [cheatArray objectAtIndex:cheatIndex];
  
  for (int i = 0 ; i < letterOptionsArray.count; i++) {
    NSString *fromSelection = [NSString stringWithFormat:@"%@",[letterOptionsArray objectAtIndex:i]];
    if ([fromSelection isEqualToString:letterToTakeOut]) {
      SelectionView *selectedLetter = (SelectionView *)[self.view viewWithTag:i+1];
      [letterOptionsArray replaceObjectAtIndex:i withObject:[NSNumber numberWithInt:-1]];
      [self addCheatViewtoAnswerView:selectedLetter tagInArray:cheatIndex letterToTakeOut:letterToTakeOut];
      break;
    }
  }
  cheatCount++;
  if (cheatCount == correctAnswerLetterCount) {
    [self performSelector:@selector(checkIfAnswerIsCorrect) withObject:nil afterDelay:0.3f];
  }
}

- (void)addCheatViewtoAnswerView:(SelectionView *)cheatView tagInArray:(int)tag letterToTakeOut:(NSString *)letter {
  AnswerView *view = (AnswerView *)[answerSlotViews objectAtIndex:tag];
  [usedCheatArray addObject:[NSNumber numberWithInt:cheatView.tag]];
  selectedObject = cheatView;;
  
  if (numberOfLines == 2) {
    UIView *firstLine = [self.view viewWithTag:FIRST_ANSWER_LINE_TAG];
    UIView *secondLine = [self.view viewWithTag:SECOND_ANSWER_LINE_TAG];
    CGRect newFrame;
    if (tag < firstLineLetterCount) newFrame = [firstLine convertRect:view.frame toView:self.view];
    else newFrame = [secondLine convertRect:view.frame toView:self.view];
    [UIView animateWithDuration:0.3f animations:^{
      cheatView.frame = newFrame;
    }];
    selectedObject.bottomBar.hidden = YES;
  }
  else {
    UIView *firstLine = [self.view viewWithTag:FIRST_ANSWER_LINE_TAG];
    CGRect newFrame = [firstLine convertRect:view.frame toView:self.view];
    [UIView animateWithDuration:0.3f animations:^{
      cheatView.frame = newFrame;
    }];
    selectedObject.bottomBar.hidden = YES;
  }
  [submittedAnswers replaceObjectAtIndex:view.inArrayTag withObject:letter];
  [submittedAnswersTag replaceObjectAtIndex:view.inArrayTag withObject:[NSNumber numberWithInt:cheatView.tag]];
}

@end
