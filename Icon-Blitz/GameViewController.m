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
#import "FacebookObject.h"
#import "ScoreViewController.h"
#import "UINavigationController+PushPopRotated.h"
#import "UserInfo.h"
#import "ProtoHeaders.h"
#import "FillInTypeViewController.h"

#define kTagDisplayResultTag 1000

@interface GameViewController () {
  int freezeCounter;
  int pointsBefore;
  int pointsAfter;
  int timeAfter;
  NSTimer *freezeTimer;
  CGRect gameRect;
  BOOL freezeTimerStarted;
}
- (void)youLose;
@end

@implementation GameViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil userData:(UserInfo *)userData {
  if ((self = [super init])) {
    self.userData = userData;
    //[self updateRubyLabel];
  }
  return self;
}

- (void)viewDidLoad
{
  [super viewDidLoad];
  self.currentQuestion = 0;
  self.timeLeft = 120;
  self.points = 0;
  pointsBefore = 0;
  pointsAfter = 0;
  
  self.timeLeftLabel.text = [NSString stringWithFormat:@"%d",self.timeLeft];
  self.pointsLabel.text = [NSString stringWithFormat:@"%d",self.points];
  
  self.questionsId = [[NSMutableArray alloc] init];
  
//  if ([self getQuestiontype] == kMultipleChoice) {
//    self.currentController = [FillInViewController gameWithController:self];
//  }
//  else {
//    self.currentController = [MultipleChoiceViewController initWithGameInfo:self];
//  }
  
  self.currentController = [[FillInTypeViewController alloc] initWithNibName:@"FillInTypeViewController" bundle:nil game:self];
  //self.currentController = [FillInViewController gameWithController:self];
  self.currentController.view.center = CGPointMake(self.currentController.view.center.x, self.currentController.view.center.y+56);
  [self.view addSubview:self.currentController.view];

  gameRect = CGRectMake(self.currentController.view.frame.origin.x, self.currentController.view.frame.origin.y, 320, 353);
  //gameTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(countDown) userInfo:nil repeats:YES];
  
}

- (QuestionType)getQuestiontype {
  QuestionType type;
  if ([[self.userData.questions objectAtIndex:self.currentQuestion] isKindOfClass:[MultipleChoiceAnswerProto class]]) {
    type = kMultipleChoice;
  }
  else {
    type = kFillIn;
  }
  self.currentType = type;
  return type;
}

- (void)countDown {
  self.timeLeft -= 1;
  [self updateTimeLabelWithSkip:NO];
  if (self.timeLeft <= 0) {
    self.timeLeftLabel.text = [NSString stringWithFormat:@"%d",self.timeLeft];
    self.view.userInteractionEnabled = NO;
    [gameTimer invalidate];
    [self youLose];
  }
}

- (void)updateRubyLabel {
  self.rubyLabel.text = [NSString stringWithFormat:@"%d",self.userData.rubies];
}

- (void)updateTimeLabelWithSkip:(BOOL)skip {
  if (skip) {
    [self performSelector:@selector(changeTime) withObject:nil afterDelay:0.05];
  }
  else {
    self.timeLeftLabel.text = [NSString stringWithFormat:@"%d",self.timeLeft];    
  }
}

- (void)updatePointsLabel {
  [self performSelector:@selector(changePoints) withObject:nil afterDelay:.05];
}

- (void)changeTime {
  static float delay = .01;
  self.timeLeft -= 1;
  self.timeLeftLabel.text = [NSString stringWithFormat:@"%d",self.timeLeft];
  if (self.timeLeft > timeAfter) {
    [self performSelector:@selector(changeTime) withObject:nil afterDelay:.05];
  }else if (self.timeLeft < timeAfter -5 && self.timeLeft < timeAfter - 10) {
    [self performSelector:@selector(changeTime) withObject:nil afterDelay:.05 + delay];
    delay += 0.01;
  }
}

-(void)changePoints {
  static float delay = .01;
  pointsBefore += 1;
  self.pointsLabel.text = [NSString stringWithFormat:@"%d",pointsBefore];
  if (pointsBefore < pointsAfter) {
    [self performSelector:@selector(changePoints) withObject:nil afterDelay:.05];
  }else if (pointsBefore > pointsAfter -5 && pointsBefore < pointsAfter) {
    [self performSelector:@selector(changePoints) withObject:nil afterDelay:.05 + delay];
    delay += 0.01;
  }
}

- (void)youLose {
  self.view.userInteractionEnabled = YES;
  ScoreViewController *vc = [[ScoreViewController alloc] initWithNibName:@"ScoreViewController" bundle:nil];
  [self.navigationController pushViewController:vc rotated:YES];
}

- (void)publish {
  NSMutableDictionary *params = [NSMutableDictionary dictionary];
  [params setObject:@"Trivia Blitz" forKey:@"name"];
  [params setObject:[NSString stringWithFormat:@"Danny has scored %d in Trivia Blitz",self.points] forKey:@"caption"];
  [params setObject:[NSString stringWithFormat:@"Danny has scored %d in Trivia Blitz",self.points] forKey:@"description"];
  [params setObject:@"http://i.imgur.com/9KY7dLJ.jpg" forKey:@"picture"];
  
  FacebookObject *facebookObject = [[FacebookObject alloc] init];
  [facebookObject publishWithoutUIAndParams:params];
}

- (void)fadeInLabelWithAmount:(int)amount add:(BOOL)add andNumberType:(NumberType)type{
  UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 50)];
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
  timeAfter = self.timeLeft - 10;
  if (timeAfter <= 0) timeAfter = 0;
  [self updateTimeLabelWithSkip:YES];
  
  [self fadeInLabelWithAmount:10 add:NO andNumberType:kTimeType];
  [self transitionWithConclusion:NO skipping:NO andNextQuestionType:kFillIn];
}

- (IBAction)cheatOneClicked:(id)sender {
//  self.currentType = kMultipleChoice;
//  if (self.currentType = kFillIn) {
//    FillInViewController *vc = (FillInViewController *)self.currentController;
//    [vc removeOptions];
//  }
//  else {
//    MultipleChoiceViewController *vc = (MultipleChoiceViewController *)self.currentController;
//    [vc removeOptions];
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
  if (type == kFillIn) newController = [[FillInTypeViewController alloc]initWithNibName:nil bundle:nil game:self];
  else if (type == kMultipleChoice) newController = [MultipleChoiceViewController initWithGameInfo:self];
  
  [newController.view layoutIfNeeded];
  
  CGRect newFrame = CGRectMake(self.view.bounds.size.width, gameRect.origin.y, gameRect.size.width, gameRect.size.height);
  CGPoint offFrame = CGPointMake(-self.view.bounds.size.width, self.currentController.view.center.y);
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
      pointsAfter += 10;
      UIImage *right = [UIImage imageNamed:@"correct.png"];
      UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, right.size.width, right.size.height)];
      imageView.tag  = kTagDisplayResultTag;
      imageView.center = CGPointMake(self.view.frame.size.width/2, self.view.frame.size.height/2);
      imageView.image = right;
      [self.view addSubview:imageView];
      [UIView animateWithDuration:0.4 animations:^{
        imageView.transform = CGAffineTransformMakeScale(2, 2);
        imageView.transform = CGAffineTransformMakeRotation(-5.85);
        [self updatePointsLabel];
        [self fadeInLabelWithAmount:10 add:YES andNumberType:kPointType];
      }completion:^(BOOL finished) {
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
        imageView.transform = CGAffineTransformMakeRotation(-5.85);
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

@end
