//
//  TutorialViewController.m
//  Icon-Blitz
//
//  Created by Danny on 5/30/13.
//
//

#import "TutorialViewController.h"
#import "TutorialMultipleChoiceViewController.h"
#import <QuartzCore/QuartzCore.h>

#define MaxFillInLetters 12

@interface TutorialViewController () {
  int dialogueCount;
  int rightAnswer;
  int timerCounter;
  int currentLetter;
  int cheatCount;
  
  NSTimer *fillInTimer;;
  UIImageView *arrow;
  NSMutableArray *correctLetterArray;
  NSArray *multipleChoiceDialgueArray;
  BOOL answerIsCorrect;
  BOOL userDidStartFillIn;
  BOOL requiredDialogue;
  BOOL keepTryingFillInAnswer;
}

@end

@implementation TutorialViewController

- (void)viewDidLoad
{
  [super viewDidLoad];
  
  dialogueCount = 0;
  rightAnswer = 3;
  currentLetter = 0;
  self.currentStage = kBeginningMultipleChoiceStage;
  requiredDialogue = YES;
  self.gameView = [[TutorialMultipleChoiceViewController alloc]init];
  self.gameView.delegate = self;
  [self.gameView disableButtons];
  [self.view addSubview:self.gameView.view];
  [self.view bringSubviewToFront:self.overlayView];
  [self.gameView disableButtons];
  
  correctLetterArray = [[NSMutableArray alloc] init];
  for (int i = 1 ; i <= 12; i++) {
    NSNumber *num = [NSNumber numberWithInt:i];
    [correctLetterArray addObject:num];
  }
  
  NSString *path = [[NSBundle mainBundle] pathForResource:@"Tutorial" ofType:@"plist"];
  NSDictionary *dict = [[NSDictionary alloc] initWithContentsOfFile:path];
  multipleChoiceDialgueArray = [dict objectForKey:@"Multiple Choice"];
  [self setUpDialogue];
}

- (void)setUpDialogue {
  NSArray *item = [multipleChoiceDialgueArray objectAtIndex:dialogueCount];
  if (keepTryingFillInAnswer) {
    item = [multipleChoiceDialgueArray objectAtIndex:4];
    dialogueCount = 4;
  }
  int fontSize;
  NSString *text;
  
  if (answerIsCorrect) {
    fontSize = [[item objectAtIndex:3] integerValue];
    text = [item objectAtIndex:2];
  }
  else {
    fontSize = [[item objectAtIndex:1] integerValue];
    text = [item objectAtIndex:0];
  }
  
  self.dialogueLabel.font = [UIFont fontWithName:@"Avenir Next Lt Pro" size:fontSize];
  self.dialogueLabel.text = [NSString stringWithFormat:@"%@",text];
}

- (IBAction)chatClicked:(id)sender {
  [self continueChat];
}

- (void)continueChat {
  [self doAction];
  dialogueCount++;
  if (requiredDialogue) [self animateDialogue];
  NSLog(@"dialogue count = %d",dialogueCount);
}

- (void)animateDialogue {
  self.chatButton.userInteractionEnabled = NO;
  [UIView animateWithDuration:0.2f animations:^{
    self.dialogueLabel.alpha = 0.0f;
  }completion:^(BOOL finished) {
    [self setUpDialogue];
    [UIView animateWithDuration:0.2f animations:^{
      self.dialogueLabel.alpha = 1.0f;
    }completion:^(BOOL finished) {
      self.chatButton.userInteractionEnabled = YES;
    }];
  }];
}

- (void)doAction {
  switch (dialogueCount) {
    case 1:
      self.glowOverlay.center = CGPointMake(self.glowOverlay.center.x,self.glowOverlay.center.y);
      [self moveChatViewOffScreen];
      [self performSelector:@selector(showQuestionView) withObject:nil afterDelay:0.4f];
      break;
      
    case 2:
      [self.chatButton setImage:[UIImage imageNamed:@"okay.png"] forState:UIControlStateNormal];
      break;
    
    case 3:
      [self moveChatViewOffScreen];
      [self.gameView disableButtons];
      [self showQuestionView];
      [self.chatButton setImage:[UIImage imageNamed:@"next.png"] forState:UIControlStateNormal];
      [self.gameView pushToFillInView];
      self.currentStage = kFillInStage;
      fillInTimer = [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(countDown) userInfo:nil repeats:YES];
      break;
      
    case 4:
      //reset user's answers
      if (answerIsCorrect) {
        [self.gameView pushToLyricsView];
        self.chatButton.userInteractionEnabled = NO;
        [self.chatButton setImage:[UIImage imageNamed:@"okay.png"] forState:UIControlStateNormal];
        [self performSelector:@selector(guideUserToUseCheat) withObject:nil afterDelay:0.5f];
      }
      else {
        keepTryingFillInAnswer = YES;
        [self resetLetters];
      }
      break;
      
    case 5:
      [self showFreezeStage];
      break;
      
    default:
      break;
  }
}

- (void)moveChatViewOffScreen {
  CGPoint bumpFrame;
  CGPoint newFrame;
  //move the chat view downward
  if (self.chatView.center.y > self.view.frame.size.height/2) {
    bumpFrame = CGPointMake(self.chatView.center.x, self.chatView.center.y - 10);
    newFrame = CGPointMake(self.chatView.center.x, self.chatView.center.y * 2);
  }
  //move the chatview upward
  else {
    bumpFrame = CGPointMake(self.chatView.center.x, self.chatView.center.y + 10);
    newFrame = CGPointMake(self.chatView.center.x, -self.chatView.center.y);
  }
  [UIView animateWithDuration:0.1f animations:^{
    self.chatView.center = bumpFrame;
  }completion:^(BOOL finished) {
    [UIView animateWithDuration:0.3f animations:^{
      self.chatView.center = newFrame;      
    }];
  }];
}

- (void)showQuestionView {
  self.glowOverlay.hidden = YES;
  self.overlayView.userInteractionEnabled = NO;
}

- (void)multipleChoiceCallBack:(BOOL)correct {
  answerIsCorrect = correct;
  [arrow removeFromSuperview];
  if (correct) {
    [self showMultipleChoiceCorrectAnimation];
  }
  else {
    [self showMultipleChoiceFalseAnimation];
  }
}

//multipleChoice
- (void)pointToRightAnswer {
  CGPoint pos = [self.gameView getCorrectMultipleChoiceCenter:rightAnswer];
  UIImage *image = [UIImage imageNamed:@"3darrow.png"];
  arrow = [[UIImageView alloc] initWithFrame:CGRectMake(pos.x, pos.y-30, image.size.width, image.size.height)];
  arrow.image = image;
  [self.overlayView addSubview:arrow];
  
  CGPoint newPoint = CGPointMake(arrow.center.x, arrow.center.y + 30);
  
  [UIView animateWithDuration:0.5 delay:0.0 options:UIViewAnimationOptionAutoreverse | UIViewAnimationOptionRepeat | UIViewAnimationOptionCurveEaseInOut animations:^{
    arrow.center = newPoint;
  }completion:NULL];
  self.overlayView.userInteractionEnabled = NO;
}

- (void)showMultipleChoiceFalseAnimation {
  self.chatButton.hidden = YES;
  self.overlayView.userInteractionEnabled = YES;
  self.chatView.center = CGPointMake(self.view.frame.size.width/2, -(self.view.frame.size.height/2));
  [UIView animateWithDuration:0.3f delay:0.4f options:UIViewAnimationCurveEaseInOut animations:^{
    self.chatView.center = CGPointMake(self.view.frame.size.width/2, self.view.frame.size.height/2 - 120);
  }completion:^(BOOL finished) {
    [UIView animateWithDuration:0.25f animations:^{
      self.chatView.center = CGPointMake(self.view.frame.size.width/2, self.view.frame.size.height/2 - 160);
    }completion:^(BOOL finished) {
      [UIView animateWithDuration:0.25f animations:^{
        self.chatView.center = CGPointMake(self.view.frame.size.width/2, self.view.frame.size.height/2 - 140);
      }completion:^(BOOL finished) {
        [arrow removeFromSuperview];
        [self pointToRightAnswer];
        self.overlayView.userInteractionEnabled = NO;
      }];
    }];
  }];
}

- (void)showMultipleChoiceCorrectAnimation {
  int point = 0;
  if (self.currentStage == kCheatStage) {
    answerIsCorrect = NO;
    self.chatButton.userInteractionEnabled = YES;
    point = 20;
  }
  [self setUpDialogue];
  self.chatButton.hidden = NO;
  //move the view from downwards
  self.chatView.center = CGPointMake(self.view.frame.size.width/2, self.view.frame.size.height * 1.5);
  [UIView animateWithDuration:0.3f delay:0.4f options:UIViewAnimationCurveEaseInOut animations:^{
    self.chatView.center = CGPointMake(self.view.frame.size.width/2, self.view.frame.size.height/2 + 100 - point);
  }completion:^(BOOL finished)
   {
     self.glowOverlay.hidden = NO;
    [UIView animateWithDuration:0.25f animations:^{
      self.chatView.center = CGPointMake(self.view.frame.size.width/2, self.view.frame.size.height/2 + 140 - point);
    }completion:^(BOOL finished) {
      [UIView animateWithDuration:0.25f animations:^{
        self.chatView.center = CGPointMake(self.view.frame.size.width/2, self.view.frame.size.height/2 + 120 - point);
      }];
    }];
  }];

  [UIView animateWithDuration:0.7f delay:0.8f options:UIViewAnimationCurveEaseInOut animations:^{
    self.glowOverlay.center = CGPointMake(self.gameView.gameView.pointsLabel.center.x, self.gameView.gameView.pointsLabel.center.y - 30);
  }completion:^(BOOL finished) {
    [self.gameView.gameView animatePointsLabel];
    answerIsCorrect = NO;
  }];
  self.overlayView.userInteractionEnabled = YES;
}

#pragma mark FILL-IN-METHODS

- (void)resetLetters {
  self.overlayView.hidden = YES;
  [self moveChatViewOffScreen];
  [self.gameView.gameView resetLettersOnTutorial];
  currentLetter = 0;
  userDidStartFillIn = NO;
  [self.gameView disableButtons];
  [self performSelector:@selector(showCorrectLetters) withObject:nil afterDelay:0.5f];
}

- (void)countDown {
  timerCounter++;
  if (timerCounter >= 12) {
    [fillInTimer invalidate];
    [self showCorrectLetters];
  }
}

- (void)showCorrectLetters {
  if ([fillInTimer isValid]) {
    [fillInTimer invalidate];
    userDidStartFillIn = YES;
  }
  if (userDidStartFillIn) return;
  if (currentLetter == MaxFillInLetters) return;
  int letter = [[correctLetterArray objectAtIndex:currentLetter] integerValue];
  CGPoint letterPoint = [self.gameView getFillInLettersCenter:letter];
  currentLetter++;
  [self pointToRightLetter:letterPoint];
}

- (void)fillInFinishedCallBack:(BOOL)correct {
  [arrow removeFromSuperview];
  self.overlayView.userInteractionEnabled = YES;
  requiredDialogue = NO;
  answerIsCorrect = correct;
  if (!keepTryingFillInAnswer) self.overlayView.center = CGPointMake(self.overlayView.center.x, self.overlayView.center.y + 20);
  if (correct) {
    [self showFillInCorrectAnimation];
  }
  else {
    [self showFillInFalseAnimation];
  }
}

- (void)showFillInCorrectAnimation {
  [self setUpDialogue];
  self.chatButton.hidden = NO;
  self.overlayView.hidden = NO;
  self.glowOverlay.hidden = YES;
  //move the view from downwards
  if (!keepTryingFillInAnswer) self.glowOverlay.center = CGPointMake(self.glowOverlay.center.x,self.glowOverlay.center.y - 100);
  self.chatView.center = CGPointMake(self.view.frame.size.width/2, self.view.frame.size.height * 1.5);
  [UIView animateWithDuration:0.3f delay:0.4f options:UIViewAnimationCurveEaseInOut animations:^{
    self.chatView.center = CGPointMake(self.view.frame.size.width/2, self.view.frame.size.height/2 + 80);
  }completion:^(BOOL finished)
   {
     self.glowOverlay.hidden = NO;
     [UIView animateWithDuration:0.25f animations:^{
       self.chatView.center = CGPointMake(self.view.frame.size.width/2, self.view.frame.size.height/2 + 120);
     }completion:^(BOOL finished) {
       [UIView animateWithDuration:0.25f animations:^{
         keepTryingFillInAnswer = NO;
         self.chatView.center = CGPointMake(self.view.frame.size.width/2, self.view.frame.size.height/2 + 100);
       }completion:NULL];
     }];
   }];
  self.currentStage = kCheatStage;
}

- (void)showFillInFalseAnimation {
  if (keepTryingFillInAnswer) self.chatButton.hidden = YES;
  self.chatView.center = CGPointMake(self.view.frame.size.width/2, self.view.frame.size.height * 1.5);
  [UIView animateWithDuration:0.3f delay:0.4f options:UIViewAnimationCurveEaseInOut animations:^{
    self.chatView.center = CGPointMake(self.view.frame.size.width/2, self.view.frame.size.height/2 + 80);
  }completion:^(BOOL finished)
   {
     if (!keepTryingFillInAnswer) self.glowOverlay.center = CGPointMake(self.glowOverlay.center.x, self.glowOverlay.center.y - 100);
     self.overlayView.hidden = NO;
     self.glowOverlay.hidden = NO;
     [UIView animateWithDuration:0.25f animations:^{
       self.chatView.center = CGPointMake(self.view.frame.size.width/2, self.view.frame.size.height/2 + 120);
     }completion:^(BOOL finished) {
       [UIView animateWithDuration:0.25f animations:^{
         self.chatView.center = CGPointMake(self.view.frame.size.width/2, self.view.frame.size.height/2 + 100);
       }completion:^(BOOL finished) {
         if (keepTryingFillInAnswer) {
           [self performSelector:@selector(resetLetters) withObject:nil afterDelay:1.0f];
         }
       }];
     }];
   }];
}

- (void)showNextLetterCallBack {
  [self showCorrectLetters];
}

//fillIn
- (void)pointToRightLetter:(CGPoint)point {
  CGPoint newPoint = CGPointMake(point.x - 18.5, point.y);
  [self animateArrowAtPoint:newPoint];
  self.overlayView.userInteractionEnabled = NO;
}

#pragma mark - Multiple Choice - Removing Options

- (void)guideUserToUseCheat {
  [self moveChatViewOffScreen];
  self.glowOverlay.hidden = YES;
  
  [arrow removeFromSuperview];
  CGPoint point = CGPointMake(self.view.frame.size.width/2 - 10, self.gameView.gameView.removeCheatButon.center.y - self.gameView.gameView.removeCheatButon.frame.size.height/2-30);
  [self animateArrowAtPoint:point];
  [self performSelector:@selector(enableRemoveCheatButtonOnly) withObject:nil afterDelay:0.9f];
}

- (void)enableRemoveCheatButtonOnly {
  self.gameView.gameView.currentController.view.userInteractionEnabled = NO;
  self.gameView.gameView.removeCheatButon.userInteractionEnabled = YES;
  self.overlayView.userInteractionEnabled = NO;
}


- (void)cheatClicked {
  cheatCount++;
  if (cheatCount >= 3) {
    self.gameView.gameView.removeCheatButon.userInteractionEnabled = NO;
    self.gameView.gameView.currentController.view.userInteractionEnabled = YES;
    [arrow removeFromSuperview];
    return;
  }
}

#pragma mark - FreezeStage

#warning - animate arrow to freeze button

- (void)animateArrowAtPoint:(CGPoint)point {
  [arrow removeFromSuperview];
  UIImage *image = [UIImage imageNamed:@"3darrow.png"];
  arrow = [[UIImageView alloc] initWithFrame:CGRectMake(point.x, point.y, image.size.width, image.size.height)];
  arrow.image = image;
  arrow.alpha = 0.0f;
  [self.view addSubview:arrow];
  
  CGPoint newPoint = CGPointMake(arrow.center.x, arrow.center.y - 30);
  [UIView animateWithDuration:0.5 delay:0.2f options:UIViewAnimationTransitionNone animations:^{
    arrow.alpha = 1.0f;
  }completion:NULL];
  
  [UIView animateWithDuration:0.5 delay:0.4f options:UIViewAnimationOptionAutoreverse | UIViewAnimationOptionRepeat | UIViewAnimationOptionCurveEaseInOut animations:^{
    arrow.center = newPoint;
  }completion:NULL];
}

- (void)showFreezeStage {
  [self moveChatViewOffScreen];
  self.glowOverlay.hidden = YES;
  self.overlayView.userInteractionEnabled = NO;
  [self.gameView pushToFillInView];
  
}

@end
