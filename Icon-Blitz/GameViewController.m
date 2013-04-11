//
//  GameViewController.m
//  Icon-Blitz
//
//  Created by Danny on 3/18/13.
//
//

#import "GameViewController.h"
#import "MultipleChoiceViewController.h"
#import "FillInViewController.h"

#define kTagDisplayResultTag 1000

#define kPrevScreen 0
#define kCurrentScreen 1
#define kNextScren 2

@interface GameViewController () {
  int freezeCounter;
  NSTimer *freezeTimer;
  CGRect gameRect;
  BOOL freezeTimerStarted;
}
- (void)youLose;
@end

@implementation GameViewController

- (void)viewDidLoad
{
  [super viewDidLoad];
  self.timeLeft = 120;
  self.points = 0;
  self.timeLeftLabel.text = [NSString stringWithFormat:@"%d",self.timeLeft];
  self.pointsLabel.text = [NSString stringWithFormat:@"%d",self.points];
  
  //self.currentController = [FillInViewController gameWithController:self];
  self.currentController = [MultipleChoiceViewController initWithGameInfo:self];
  self.currentController.view.center = CGPointMake(self.currentController.view.center.x, self.currentController.view.center.y+56);
  [self.view addSubview:self.currentController.view];
    
  gameRect = CGRectMake(self.currentController.view.frame.origin.x, self.currentController.view.frame.origin.y, 320, 353);
  
  gameTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(countDown) userInfo:nil repeats:YES];
  
}

- (void)countDown {
  self.timeLeft -= 1;
  [self updateTimeLabel];
  if (self.timeLeft <= 0) {
    [self youLose];
    [gameTimer invalidate];
  }
}

- (void)updateTimeLabel {
  self.timeLeftLabel.text = [NSString stringWithFormat:@"%d",self.timeLeft];
}

- (void)updatePointsLabel {
  self.pointsLabel.text = [NSString stringWithFormat:@"%d",self.points];
}

- (void)youLose {
  [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)fadeInLabelWithAmount:(int)amount add:(BOOL)add andNumberType:(NumberType)type{
  UILabel *label = [[[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 50)] autorelease];
  NSString *prefixType;
  
  if (add) {
    prefixType = [NSString stringWithFormat:@"+"];
    label.textColor = [UIColor greenColor];
  }
  else {
    prefixType = [NSString stringWithFormat:@"-"];
    label.textColor = [UIColor redColor];
  }

  NSString *stringAmount = [NSString stringWithFormat:@"%@ %d",prefixType,amount];
  CGPoint newPoint;
  
  if (type == kPointType) {
    label.center = CGPointMake(self.pointsLabel.center.x + 47, self.pointsLabel.center.y + 35);
    newPoint = CGPointMake(label.center.x, label.center.y - 16);
  }
  else if (type == kTimeType) {
    label.center = CGPointMake(self.timeLeftLabel.center.x + 37, self.timeLeftLabel.center.y + 35);
    newPoint = CGPointMake(label.center.x, label.center.y - 16);
  }
  else if (type == kRubyType) {
    
  }
  label.font = [UIFont fontWithName:@"Avenir Next Lt Pro" size:25];
  label.text = stringAmount;
  label.backgroundColor = [UIColor clearColor];
  [self.view addSubview:label];
  
  [UIView animateWithDuration:0.6 animations:^{
    label.center = newPoint;
  }completion:^(BOOL finished) {
    [label removeFromSuperview];
  }];
}

- (IBAction)skipSelected:(id)sender {
  self.timeLeft -= 10;
  [self updateTimeLabel];
  //NSDictionary *currentQ = [self.gameData objectAtIndex:self.currentQuestion+1];
  //QuestionType type = [[currentQ objectForKey:@"Type"] integerValue];
  [self fadeInLabelWithAmount:10 add:NO andNumberType:kTimeType];
  [self transitionWithConclusion:NO skipping:NO andNextQuestionType:kFillIn];
}

- (IBAction)cheatOneClicked:(id)sender {
//  self.currentType = kFillIn;
//  if (self.currentType == kFillIn) {
//    [self.fillInView removeOptions];
//  }
//  else if (self.currentType == kMultipleChoice) {
//    [self.multipleChoiceView removeOptions];
//  }
}

- (IBAction)cheatTwoClicked:(id)sender {
  self.freezeButton.userInteractionEnabled = NO;
  freezeCounter = 0;
  if ([gameTimer isValid]) {
    [gameTimer invalidate];
  }
  freezeTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(freezeCountDown) userInfo:nil repeats:YES];
}

- (void)freezeCountDown {
  freezeCounter++;
  if (freezeCounter >= 10) {
    [freezeTimer invalidate];
    self.freezeButton.userInteractionEnabled = YES;
    gameTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(countDown) userInfo:nil repeats:YES];
  }
}

- (void)pushNewViewControllersWithType:(QuestionType)type {
  UIViewController *newController;
  if (type == kFillIn) newController = [FillInViewController gameWithController:self];
  else if (type == kMultipleChoice) newController = [MultipleChoiceViewController initWithGameInfo:self];
  
  [newController.view layoutIfNeeded];
  
  CGRect newFrame = CGRectMake(self.view.bounds.size.width, gameRect.origin.y, gameRect.size.width, gameRect.size.height);
  CGPoint offFrame = CGPointMake(-self.view.bounds.size.width, 0);
  newController.view.frame = newFrame;
  
  [self.currentController willMoveToParentViewController:nil];
  [self addChildViewController:newController];
  
  [self.view addSubview:newController.view];
  
  [self.currentController willMoveToParentViewController:nil];
  
  __weak __block GameViewController  *weakSelf = self;
  [UIView animateWithDuration:0.4 animations:^{
    self.currentController.view.center = offFrame;
    newController.view.frame = gameRect;
  }completion:^(BOOL finished) {
    [weakSelf.currentController.view removeFromSuperview];
    [weakSelf.currentController removeFromParentViewController];
    [newController didMoveToParentViewController:weakSelf];
    
    weakSelf.currentController = newController;
    self.view.userInteractionEnabled = YES;
  }];
}

- (void)transitionWithConclusion:(BOOL)conclusion skipping:(BOOL)didSkip andNextQuestionType:(QuestionType)type {
  self.view.userInteractionEnabled = NO;
  if(!didSkip) {
    if (conclusion) {
      self.points += 10;
      [self updatePointsLabel];

      UIImage *right = [UIImage imageNamed:@"correct.png"];
      UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, right.size.width, right.size.height)];
      imageView.tag  = kTagDisplayResultTag;
      imageView.center = CGPointMake(self.view.frame.size.width/2, self.view.frame.size.height/2);
      imageView.image = right;
      [self.view addSubview:imageView];
      [UIView animateWithDuration:0.4 animations:^{
        imageView.transform = CGAffineTransformMakeScale(2, 2);
        imageView.transform = CGAffineTransformMakeRotation(-5.55);
      }completion:^(BOOL finished) {
        [self fadeInLabelWithAmount:10 add:YES andNumberType:kPointType];
        [self pushNewViewControllersWithType:kMultipleChoice];
        [imageView removeFromSuperview];
      }];
      
    }
    else {
      UIImage *wrong = [UIImage imageNamed:@"wrong.png"];
      UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, wrong.size.width, wrong.size.height)];
      imageView.tag  = kTagDisplayResultTag;
      imageView.center = CGPointMake(self.view.frame.size.width/2, self.view.frame.size.height/2);
      imageView.image = wrong;
      [self.view addSubview:imageView];

      [UIView animateWithDuration:0.4 animations:^{
        imageView.transform = CGAffineTransformMakeScale(2, 2);
        imageView.transform = CGAffineTransformMakeRotation(-5.55);
      }completion:^(BOOL finished) {
  
        [self pushNewViewControllersWithType:kFillIn];
        [imageView removeFromSuperview];
      }];
    }
  }
  else {
    [self pushNewViewControllersWithType:kFillIn];
  }
}

- (void)dealloc {
  self.gameData = nil;
  self.questionView = nil;
  self.freezeButton = nil;
  
  [self.gameData release];
  [self.questionView release];
  [self.freezeButton release];
  [super dealloc];
}

@end
