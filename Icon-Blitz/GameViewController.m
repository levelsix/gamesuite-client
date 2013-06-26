//
//  GameViewController.m
//  Icon-Blitz
//
//  Created by Danny on 3/18/13.
//
//

#import "GameViewController.h"
#import "MultipleChoiceViewController.h"
#import "FacebookObject.h"
#import "ScoreViewController.h"
#import "UINavigationController+PushPopRotated.h"
#import "UserInfo.h"
#import "FillInTypeViewController.h"
#import "SocketCommunication.h" 
#import "TutorialMultipleChoiceViewController.h"

#define Tutorial_Timer 60
#define Regular_Game_Timer 120

@interface GameViewController () {
  int freezeCounter;
  int pointsBefore;
  int pointsAfter;
  int timeAfter;
  long long int endTime;
  NSTimer *freezeTimer;
  CGRect gameRect;
  CGRect originalTriviaLabelFrame;
  ProtoType protoType;
  UsedCheatType usedCheatType;
}
@end

@implementation GameViewController

#pragma mark Tutorial Stuff

- (id)initWithTutorial {
  // if this is from tutorial;
  if ((self = [super init])) {
    NSMutableDictionary *tutorialQuestion = [NSMutableDictionary dictionary];
    [tutorialQuestion setObject:[NSString stringWithFormat:@"Where was the 2008 Olympics held?"] forKey:@"question"];
    [tutorialQuestion setObject:[NSString stringWithFormat:@"London"] forKey:@"answerA"];
    [tutorialQuestion setObject:[NSString stringWithFormat:@"Japan"] forKey:@"answerB"];
    [tutorialQuestion setObject:[NSString stringWithFormat:@"Beijing"] forKey:@"answerC"];
    [tutorialQuestion setObject:[NSString stringWithFormat:@"Nanjing"] forKey:@"answerD"];
    [tutorialQuestion setObject:[NSNumber numberWithInt:3] forKey:@"correctChoice"];
    
    self.currentController = [[MultipleChoiceViewController alloc] initWithTutorial:self question:[tutorialQuestion copy]];
    self.currentController.view.center = CGPointMake(self.currentController.view.center.x, self.currentController.view.center.y+56);
    [self.view addSubview:self.currentController.view];
    self.isTutorial = YES;
    gameRect = CGRectMake(self.currentController.view.frame.origin.x, self.currentController.view.frame.origin.y, 320, 353);
    self.triviaType.text = [NSString stringWithFormat:@"Multiple Choice Fact"];
    [self startTimer];
  }
  return self;
}

- (void)answerCallback:(BOOL)correct {
  if ([self.delegate respondsToSelector:@selector(answerSelection:)]) {
    [self.delegate answerSelection:correct];
  }
}

- (void)showNextLetterCallBack {
  if ([self.delegate respondsToSelector:@selector(nextLetterCallback)]) {
    [self.delegate nextLetterCallback];
  }
}

- (void)fillInFinished:(BOOL)correct {
  if ([self.delegate respondsToSelector:@selector(fillInAnswerCallBack:)]) {
    [self.delegate fillInAnswerCallBack:correct];
  }
}

- (void)tutorialCheatUsed {
  if ([self.delegate respondsToSelector:@selector(tutorialCheatClicked)]) {
    [self.delegate tutorialCheatClicked];
  }
}

- (void)tutorialFreezeUsed {
  if ([self.delegate respondsToSelector:@selector(tutorialFreezeClicked)]) {
    [self.delegate tutorialFreezeClicked];
  }
}

- (void)tutorialCorrectionAnimationWithCorrect:(BOOL)isCorrect fromQuestionType:(QuestionType)type {
  if (isCorrect){
    UIImage *right = [UIImage imageNamed:@"correct.png"];
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, right.size.width, right.size.height)];
    imageView.center = CGPointMake(self.view.frame.size.width/2, self.view.frame.size.height/2);
    imageView.image = right;
    [self.view addSubview:imageView];
    [UIView animateWithDuration:0.4 animations:^{
      imageView.transform = CGAffineTransformMakeScale(2, 2);
      imageView.transform = CGAffineTransformMakeRotation(-5.85);
    }completion:^(BOOL finished) {
      [imageView removeFromSuperview];
    }];
  }
  else {
    UIImage *wrong = [UIImage imageNamed:@"wrong.png"];
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, wrong.size.width, wrong.size.height)];
    imageView.center = CGPointMake(self.view.frame.size.width/2, self.view.frame.size.height/2);
    imageView.image = wrong;
    [self.view addSubview:imageView];
    [UIView animateWithDuration:0.4 animations:^{
      imageView.transform = CGAffineTransformMakeScale(2, 2);
      imageView.transform = CGAffineTransformMakeRotation(-5.85);
    }completion:^(BOOL finished) {
      [imageView removeFromSuperview];
    }];
  }
  if (type == kMultipleChoice) [self answerCallback:isCorrect];
  if (type == kFillIn) [self fillInFinished:isCorrect];
}

- (void)animatePointsLabel {
  pointsAfter += 10;
  [self updatePointsLabel];
  [self fadeInLabelWithAmount:10 add:YES andNumberType:kPointType];
}

- (void)pushToTutorialFillInIconView {
  NSArray *selectionArray = [[NSArray alloc] initWithObjects:@"A",@"B",@"T",@"X",@"Y",@"Z",@"N",@"M",@"A",@"N",@"Q",@"L",@"R",@"D", nil];
  NSMutableDictionary *question = [NSMutableDictionary dictionary];
  [question setObject:[NSNumber numberWithInt:6] forKey:@"letterCount"];
  [question setObject:[NSNumber numberWithInt:1] forKey:@"numberOfLines"];
  [question setObject:[NSNumber numberWithInt:6] forKey:@"firstLineCount"];
  [question setObject:[NSNumber numberWithInt:0] forKey:@"secondLineCount"];
  [question setObject:@"BATMAN" forKey:@"correctAnswer"];
  [question setObject:selectionArray forKey:@"selectionSlots"];
  
  UIViewController *newController = [[FillInTypeViewController alloc] initWithTutorialIconQuestion:self questionData:[question copy] iconQuestion:YES];
  
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
    self.triviaType.hidden = YES;
  }completion:^(BOOL finished) {
    [weakSelf.currentController.view removeFromSuperview];
    [weakSelf.currentController removeFromParentViewController];
    [newController didMoveToParentViewController:weakSelf];
    
    weakSelf.currentController = newController;
    self.view.userInteractionEnabled = YES;
  }];
}

- (void)pushtoLastQuestion {
  NSMutableDictionary *question= [NSMutableDictionary dictionary];
  [question setObject:[NSString stringWithFormat:@"What company did Steve Jobs create?"] forKey:@"question"];
  [question setObject:[NSNumber numberWithInt:5] forKey:@"letterCount"];
  [question setObject:[NSNumber numberWithInt:1] forKey:@"numberOfLines"];
  [question setObject:[NSNumber numberWithInt:5] forKey:@"firstLineCount"];
  [question setObject:[NSNumber numberWithInt:0] forKey:@"secondLineCount"];
  [question setObject:@"APPLE" forKey:@"correctAnswer"];
  NSArray *selection = [[NSArray alloc] initWithObjects:@"L",@"V",@"L",@"6",@"A",@"Z",@"P",@"P",@"X",@"Y",@"S",@"E",@"W",@"Q", nil];
  [question setObject:selection forKey:@"selectionSlots"];
  UIViewController *newController = [[FillInTypeViewController alloc] initWithTutorialIconQuestion:self questionData:[question copy] iconQuestion:NO];
  
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
    self.triviaType.hidden = YES;
  }completion:^(BOOL finished) {
    [weakSelf.currentController.view removeFromSuperview];
    [weakSelf.currentController removeFromParentViewController];
    [newController didMoveToParentViewController:weakSelf];
    
    weakSelf.currentController = newController;
    self.view.userInteractionEnabled = YES;
  }];
}

- (void)pushToLyricsView {
  NSMutableDictionary *question = [NSMutableDictionary dictionary];
  [question setObject:[NSString stringWithFormat:@"I got 99 problems but a @#$%% ain't one"] forKey:@"question"];
  [question setObject:[NSString stringWithFormat:@"Beyonce"] forKey:@"answerA"];
  [question setObject:[NSString stringWithFormat:@"Jay Z"] forKey:@"answerB"];
  [question setObject:[NSString stringWithFormat:@"Bruno Mars"] forKey:@"answerC"];
  [question setObject:[NSString stringWithFormat:@"DJ SoundFX"] forKey:@"answerD"];
  [question setObject:[NSNumber numberWithInt:2] forKey:@"correctChoice"];

  UIViewController *newController = [[MultipleChoiceViewController alloc] initWithTutorial:self question:[question copy]];
  
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
    self.triviaType.hidden = YES;
  }completion:^(BOOL finished) {
    [weakSelf.currentController.view removeFromSuperview];
    [weakSelf.currentController removeFromParentViewController];
    [newController didMoveToParentViewController:weakSelf];
    
    weakSelf.currentController = newController;
    self.view.userInteractionEnabled = YES;
  }];
}

- (void)resetLettersOnTutorial {
  FillInTypeViewController *vc = (FillInTypeViewController *)self.currentController;
  [vc resetTutorialLetters];
}

- (void)disableLetterInteraction:(int)tag {
  FillInTypeViewController *vc = (FillInTypeViewController *)self.currentController;
  [vc disableUserInteractionWithTag:tag];
}

- (void)enableTimer {
  if (![self.gameTimer isValid]) {
    self.gameTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(countDown) userInfo:nil repeats:YES];
  }
}

#pragma mark Non-Tutorial Stuff

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil userData:(UserInfo *)userData {
  if ((self = [super init])) {
    self.userData = userData;
    self.currentController = [[FillInTypeViewController alloc] initWithGame:self];
    self.currentController.view.center = CGPointMake(self.currentController.view.center.x, self.currentController.view.center.y+56);
    [self.view addSubview:self.currentController.view];    
    gameRect = CGRectMake(self.currentController.view.frame.origin.x, self.currentController.view.frame.origin.y, 320, 353);
    protoType = kProtoTypeNone;
    usedCheatType = kCheatNone;
  }
  return self;
}

- (id)initWithUserInfo:(UserInfo *)userInfo gameId:(NSString *)gameId recipient:(BasicUserProto *)recipent opponent:(BasicUserProto *)opponent startTime:(long long)startTime roundNumber:(int)roundNumber {
  if (self = [super init]) {
    self.userData = userInfo;
    self.gameId = gameId;
    self.recipient = recipent;
    self.opponent = opponent;
    self.startTime = startTime;
    self.roundNumber = roundNumber;
    self.questionsAnswered = [[NSMutableArray alloc] init];
  }
  return self;
}

- (void)viewDidLoad
{
  [super viewDidLoad];
  self.currentQuestion = 0;
  self.points = 0;
  pointsBefore = 0;
  pointsAfter = 0;
  self.freezeCost.font = [UIFont fontWithName:@"Avenir Next Lt Pro" size:13];
  self.optionCost.font = [UIFont fontWithName:@"Avenir Next Lt Pro" size:13];
  self.triviaType.font = [UIFont fontWithName:@"Avenir Next Lt Pro" size:14];
  //originalTriviaLabelFrame =  self.triviaContainer.frame;
  //self.triviaContainer.frame = CGRectMake(self.triviaContainer.center.x, self.triviaContainer.frame.origin.y, 0, self.triviaContainer.frame.size.height);
}

#pragma mark - Helper Methods

- (NSTimeInterval)getUsersTimeInSeconds {
  NSTimeZone* local = [NSTimeZone localTimeZone];
  NSInteger secondsOffset = [local secondsFromGMTForDate:[NSDate date]];
  NSDate *date = [[NSDate alloc] init];
  NSTimeInterval time = [date timeIntervalSince1970];
  return time +secondsOffset;
}

- (void)startTimer {
  if (self.isTutorial) self.timeLeft = Tutorial_Timer;
  else self.timeLeft = Regular_Game_Timer;
  self.timeLeftLabel.text = [NSString stringWithFormat:@"%d",self.timeLeft];
  self.gameTimer = [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(countDown) userInfo:nil repeats:YES];
}

- (void)animateTriviaTypeLabel {
  self.triviaType.hidden = NO;
  self.triviaContainer.frame = CGRectMake(self.triviaContainer.center.x, self.triviaContainer.frame.origin.y, 0, self.triviaContainer.frame.size.height);
  [UIView animateWithDuration:1.0f animations:^{
    self.triviaContainer.frame = originalTriviaLabelFrame;
  }completion:NULL];
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
  if (self.timeLeft == 1 && self.isTutorial) {
    self.timeLeft = 1;
    self.timeLeftLabel.text = [NSString stringWithFormat:@"1"];
    [self.gameTimer invalidate];
    return;
  }
  self.timeLeft -= 1;
  [self updateTimeLabelWithSkip:NO];
  if (self.timeLeft <= 0) {
    self.timeLeftLabel.text = [NSString stringWithFormat:@"%d",self.timeLeft];
    self.view.userInteractionEnabled = NO;
    [self.gameTimer invalidate];
    [self completRound];
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

#pragma mark - Iboutlet Methods

- (IBAction)skipSelected:(id)sender {
  timeAfter = self.timeLeft - 10;
  if (timeAfter <= 0) timeAfter = 0;
  [self updateTimeLabelWithSkip:YES];
  
  [self fadeInLabelWithAmount:10 add:NO andNumberType:kTimeType];
  [self transitionWithConclusion:NO skipping:NO andNextQuestionType:kFillIn];
}

- (IBAction)cheatOneClicked:(id)sender {  
  if (self.userData.rubies < CheatCost) {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Not enough rubies" message:@"You don't have enough rubies, you can buy them after this game!" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [alert show];
    return;
  }
  
  SocketCommunication *sc = [SocketCommunication sharedSocketCommunication];
  sc.delegate = self;
  
  BasicUserProto *proto = [sc buildSender];
  [sc sendSpendRubies:proto amountSpent:CheatCost];
  
  protoType = kSpendRubyProto;
  usedCheatType = kRemoveCheat;
}

- (IBAction)cheatTwoClicked:(id)sender {
  //if its tutorual, we dont need rubies
  if (self.isTutorial) {
    self.freezeButton.userInteractionEnabled = NO;
    self.freezeButton.alpha = 0.5f;
    freezeCounter = 10;
    self.freezeCountDownLabel.text = [NSString stringWithFormat:@"%d",freezeCounter];
    if ([self.gameTimer isValid]) {
      [self.gameTimer invalidate];
    }
    freezeTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(freezeCountDown) userInfo:nil repeats:YES];
    self.freezeCountDownLabel.hidden = NO;
    [self tutorialFreezeUsed];
    return;
  }
  
  //need to check if user has enough rubies
  if (self.userData.rubies < FreezeCost && !self.isTutorial) {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Not enough rubies" message:@"You don't have enough rubies, you can buy them after this game!" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [alert show];
    return;
  }
  protoType = kSpendRubyProto;
  usedCheatType = kFreezeCheat;
  
  if (!self.isTutorial) {
    SocketCommunication *sc = [SocketCommunication sharedSocketCommunication];
    sc.delegate = self;
    BasicUserProto *sender = [sc buildSender];
    [sc sendSpendRubies:sender amountSpent:FreezeCost];
  }
}

- (void)freezeCountDown {
  freezeCounter--;
  self.freezeCountDownLabel.text = [NSString stringWithFormat:@"%d",freezeCounter];
  if (freezeCounter <= 0) {
    freezeCounter = 10;
    self.freezeCountDownLabel.hidden = YES;
    [freezeTimer invalidate];
    self.freezeButton.userInteractionEnabled = YES;
    self.freezeButton.alpha = 1.0f;
    if (!self.isTutorial && !self.timeLeft <= 1) self.gameTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(countDown) userInfo:nil repeats:YES];
  }
}

- (void)pushNewViewControllersWithType:(QuestionType)type {
  UIViewController *newController;
  if (type == kFillIn)  {
    newController = [[FillInTypeViewController alloc] initWithGame:self];
  }
  else if (type == kMultipleChoice) {
    newController = [[MultipleChoiceViewController alloc] initWithGame:self];
  }
  
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
    self.triviaType.hidden = YES;
  }completion:^(BOOL finished) {
    [weakSelf.currentController.view removeFromSuperview];
    [weakSelf.currentController removeFromParentViewController];
    [newController didMoveToParentViewController:weakSelf];
    
    weakSelf.currentController = newController;
    self.view.userInteractionEnabled = YES;
  }];
}

- (void)transitionWithConclusion:(BOOL)conclusion skipping:(BOOL)didSkip andNextQuestionType:(QuestionType)type {
  self.removeCheatButon.userInteractionEnabled = NO;
  self.view.userInteractionEnabled = NO;
  
  QuestionProto *qProto = (QuestionProto *)[self.userData.questions objectAtIndex:self.currentQuestion];
  
  QuestionAnsweredProto_AnswerType answerType;
  if (didSkip) answerType = QuestionAnsweredProto_AnswerTypeSkipped;
  else if (conclusion) answerType = QuestionAnsweredProto_AnswerTypeCorrect;
  else answerType = QuestionAnsweredProto_AnswerTypeIncorrect;
  
  QuestionAnsweredProto *proto = [[[[[QuestionAnsweredProto builder] setQuestionId:qProto.id] setAnswerType:answerType] setQuestionNumber:self.currentQuestion] build];
  
  [self.questionsAnswered addObject:proto];
  
  if(!didSkip) {
    if (conclusion) {
      pointsAfter += 10;
      UIImage *right = [UIImage imageNamed:@"correct.png"];
      UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, right.size.width, right.size.height)];
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

#pragma mark - Protocol Buffer Stuff

- (void)cheatOneSucess {
  self.currentType = [self getQuestiontype];
  if (self.currentType = kFillIn) {
    FillInTypeViewController *vc = (FillInTypeViewController *)self.currentController;
    [vc removeOptions];
  }
  else {
    MultipleChoiceViewController *vc = (MultipleChoiceViewController *)self.currentController;
    [vc removeOptions];
  }
  if (self.isTutorial) {
    [self tutorialCheatUsed];
  }
}

- (void)cheatTwoSucess {
  self.freezeButton.userInteractionEnabled = NO;
  self.freezeButton.alpha = 0.5f;
  freezeCounter = 10;
  self.freezeCountDownLabel.text = [NSString stringWithFormat:@"%d",freezeCounter];
  if ([self.gameTimer isValid]) {
    [self.gameTimer invalidate];
  }
  freezeTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(freezeCountDown) userInfo:nil repeats:YES];
  self.freezeCountDownLabel.hidden = NO;
  [self tutorialFreezeUsed];
}

- (void)cheatFailed:(SpendRubiesResponseProto *)proto {
  UIAlertView *alert;
  if (proto.status == SpendRubiesResponseProto_SpendRubiesStatusFailNotEnoughRubies) {
    alert = [[UIAlertView alloc] initWithTitle:@"Not enough rubies" message:@"You dont have enough rubies, you can buy more after this game" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
  }
  else if (proto.status == SpendRubiesResponseProto_SpendRubiesStatusFailOther) {
    alert = [[UIAlertView alloc] initWithTitle:@"Error accessing error" message:@"There is an error accessing the server right now, please try again later" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
  }
  [alert show];
}

- (void)completeRoundFail:(CompletedRoundResponseProto *)proto {
  if (proto.status == CompletedRoundResponseProto_CompletedRoundStatusFailGameDoesNotExist) {
    
  }
  else if (proto.status == CompletedRoundResponseProto_CompletedRoundStatusFailGameAlreadyCompleted) {
    
  }
  else if (proto.status == CompletedRoundResponseProto_CompletedRoundStatusFailOther) {
    
  }
}

- (void)receivedProtoResponse:(PBGeneratedMessage *)message {
  if (protoType == kSpendRubyProto) {
    SpendRubiesResponseProto *proto = (SpendRubiesResponseProto *)message;
    if (proto.status == SpendRubiesResponseProto_SpendRubiesStatusSuccess) {
      self.userData.rubies = proto.currentFunds.numRubies;
      self.userData.goldCoins = proto.currentFunds.numTokens;
      if (usedCheatType == kRemoveCheat) [self cheatOneSucess];
      else if (usedCheatType == kFreezeCheat) [self cheatTwoSucess];
    }
    else {
      [self cheatFailed:proto];
    }
  }
  else if (protoType == kCompleteRoundProto) {
    [self.spinner stopAnimating];
    self.spinnerView.hidden = YES;
    CompletedRoundResponseProto *proto = (CompletedRoundResponseProto *)message;
    if (proto.status == CompletedRoundResponseProto_CompletedRoundStatusSuccess) {
      ScoreViewController *vc = [[ScoreViewController alloc] initWithRoundOneUserInfo:self.userData completedRoundResponse:proto];
      [self.navigationController pushViewController:vc animated:YES];
    }
    else {
      [self completeRoundFail:proto];
    }
  }
}

- (void)completRound {
  self.view.userInteractionEnabled = NO;
  protoType = kCompleteRoundProto;
  SocketCommunication *sc = [SocketCommunication sharedSocketCommunication];
  sc.delegate = self;
  BasicUserProto *user = [sc buildSender];
  
  endTime = (long long)[self getUsersTimeInSeconds];
  
  self.spinnerView.hidden = NO;
  [self.spinner startAnimating];
  
  CompleteRoundResultsProto *proto = [[[[[[[CompleteRoundResultsProto builder] setId:NULL] setRoundNumber:self.roundNumber] setStartTime:self.startTime] setEndTime:endTime] addAllAnswers:self.questionsAnswered] build];
  [sc sendCompleteRoundRequest:user opponent:self.opponent gameId:self.gameId results:proto];
}

@end
