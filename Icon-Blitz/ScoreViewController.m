//
//  ScoreViewController.m
//  Icon-Blitz
//
//  Created by Danny on 4/19/13.
//
//

#import "ScoreViewController.h"
#import "UserInfo.h"
#import <QuartzCore/QuartzCore.h>
#import "UINavigationController+PushPopRotated.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "GameViewController.h"

#define RoundOne 1
#define RoundTwo 2
#define RoundThree 3

@interface ScoreViewController () {
  int uScoreOneBefore;
  int uScoreTwoBefore;
  int uScoreThreeBefore;
  int oScoreOneBefore;
  int oScoreTwoBefore;
  int oScoreThreeBefore;
  int uTotalScoreBefore;
  int oTotalScoreBefore;
  
  //user's score
  int uScoreOne;
  int uScoreTwo;
  int uScoreThree;
  int oScoreOne;
  int oScoreTwo;
  int oScoreThree;
  int uTotalScore;
  int oTotalScore;
  
  //this is just for animation, it starts at 0
  int currentRound;
  int animationCounter;

  BOOL userScoreLoaded;
  BOOL opponentScoreLoaded;
  BOOL spinning;
  BOOL myTurn;
}

@end

@implementation ScoreViewController

#pragma mark - Main Game


- (id)initWithRoundOneUserInfo:(UserInfo *)userInfo completedRoundResponse:(CompletedRoundResponseProto *)proto {
  if ((self = [super init])) {
  
  }
  return self;
}

- (id)initWithOngoingGameProto:(OngoingGameProto *)gameStats userInfo:(UserInfo *)userInfo myTurn:(BOOL)isMyTurn {
  if ((self = [super init])) {
    //non-completed games
    uScoreOne = 0; uScoreTwo = 0; uScoreThree = 0;
    oScoreOne = 0; oScoreTwo = 0; oScoreThree = 0;
    self.userInfo = userInfo;
    self.gameStats = gameStats;
    myTurn = isMyTurn;
    [self setupGameStats];
  }
  return self;
}

- (id)initWithGameResultsProto:(GameResultsProto *)completedGames userInfo:(UserInfo *)userInfo {
  if ((self = [super init])) {
    //completed games
    self.userInfo = userInfo;
    self.completedGameStats = completedGames;
    myTurn = NO;
    [self setUpCompletedGameStats];
  }
  return self;
}

- (void)setUpCompletedGameStats {
  //USER IS FIRST PLAYER
  if (self.completedGameStats.firstPlayer.bup.userId == self.userInfo.userId) {
    BasicRoundResultsProto *userScore = [self.completedGameStats.firstPlayer.previousRoundsStatsList objectAtIndex:0];
    BasicRoundResultsProto *opponentScore = [self.completedGameStats.secondPlayer.previousRoundsStatsList objectAtIndex:0];
    
    uScoreOne = userScore.score;
    oScoreOne = opponentScore.score;
    
    userScore = [self.completedGameStats.firstPlayer.previousRoundsStatsList objectAtIndex:1];
    opponentScore = [self.completedGameStats.secondPlayer.previousRoundsStatsList objectAtIndex:1];
    
    uScoreTwo = userScore.score;
    oScoreTwo = opponentScore.score;
    
    userScore = [self.completedGameStats.firstPlayer.previousRoundsStatsList objectAtIndex:2];
    opponentScore = [self.completedGameStats.secondPlayer.previousRoundsStatsList objectAtIndex:2];
    
    uScoreThree = userScore.score;
    oScoreThree = opponentScore.score;
    
    if (self.completedGameStats.firstPlayer.bup.nameFriendsSee) {
      self.userName.text = [NSString stringWithFormat:@"%@",self.completedGameStats.firstPlayer.bup.nameFriendsSee];
    }
    else {
      self.userName.text = [NSString stringWithFormat:@"%@",self.completedGameStats.firstPlayer.bup.nameStrangersSee];
    }
    
    if (self.completedGameStats.secondPlayer.bup.nameFriendsSee) {
      self.opponentName.text = [NSString stringWithFormat:@"%@",self.completedGameStats.secondPlayer.bup.nameFriendsSee];
    }
    else {
      self.opponentName.text = [NSString stringWithFormat:@"%@",self.completedGameStats.secondPlayer.bup.nameStrangersSee];
    }
  }
  //user is second player
  else if (self.completedGameStats.secondPlayer.bup.userId == self.userInfo.userId) {
    BasicRoundResultsProto *userScore = [self.completedGameStats.secondPlayer.previousRoundsStatsList objectAtIndex:0];
    BasicRoundResultsProto *opponentScore = [self.completedGameStats.firstPlayer.previousRoundsStatsList objectAtIndex:0];
    
    uScoreOne = userScore.score;
    oScoreOne = opponentScore.score;
    
    userScore = [self.completedGameStats.secondPlayer.previousRoundsStatsList objectAtIndex:1];
    opponentScore = [self.completedGameStats.firstPlayer.previousRoundsStatsList objectAtIndex:1];
    
    uScoreTwo = userScore.score;
    oScoreTwo = opponentScore.score;
    
    userScore = [self.completedGameStats.secondPlayer.previousRoundsStatsList objectAtIndex:2];
    opponentScore = [self.completedGameStats.firstPlayer.previousRoundsStatsList objectAtIndex:2];
    
    uScoreThree = userScore.score;
    oScoreThree = opponentScore.score;
    
    if (self.completedGameStats.secondPlayer.bup.nameFriendsSee) {
      self.userName.text = [NSString stringWithFormat:@"%@",self.completedGameStats.secondPlayer.bup.nameFriendsSee];
    }
    else {
      self.userName.text = [NSString stringWithFormat:@"%@",self.completedGameStats.secondPlayer.bup.nameStrangersSee];
    }
    
    if (self.completedGameStats.firstPlayer.bup.nameFriendsSee) {
      self.opponentName.text = [NSString stringWithFormat:@"%@",self.completedGameStats.firstPlayer.bup.nameFriendsSee];
    }
    else {
      self.opponentName.text = [NSString stringWithFormat:@"%@",self.completedGameStats.firstPlayer.bup.nameStrangersSee];
    }
  }
  uTotalScore = uScoreOne + uScoreTwo + uScoreThree;
  oTotalScore = oScoreOne + oScoreTwo + oScoreThree;
}

- (void)setupGameStats {
  //if user is the first player meaning the one that started the game
  if (self.gameStats.gameSoFar.firstPlayer.bup.userId == self.userInfo.userId) {
    //the count total in previousroundsStatslist indicates how many rounds have passed
    [self setUpFirstPlayerStatsByRound:self.gameStats.gameSoFar.firstPlayer.previousRoundsStatsList.count];
  }
  // if user is the second player, meaning the opponent started the game
  else if (self.gameStats.gameSoFar.secondPlayer.bup.userId == self.userInfo.userId){
    [self setUpSecondPlayerStatsByRound:self.gameStats.gameSoFar.secondPlayer.previousRoundsStatsList.count];
  }
  if (myTurn) {
    self.doneLabel.text = [NSString stringWithFormat:@"PLAY"];
    self.backButton.hidden = NO;
    self.backLabel.hidden = NO;
  }
  uTotalScore = uScoreOne + uScoreTwo + uScoreThree;
  oTotalScore = oScoreOne + oScoreTwo + oScoreThree;
}

- (void)setUpFirstPlayerStatsByRound:(int)roundTotal {
  //if user is first player and if its the users turn
  //its the user's turn to play, they see the opponenents score and the user's score should be 0
  if (roundTotal + 1 == RoundOne) {
    BasicRoundResultsProto *userRoundOne = [self.gameStats.gameSoFar.firstPlayer.previousRoundsStatsList objectAtIndex:0];
    uScoreOne = userRoundOne.score;
  }
  
  else if (roundTotal + 1 == RoundTwo) {
    BasicRoundResultsProto *userRound = [self.gameStats.gameSoFar.firstPlayer.previousRoundsStatsList objectAtIndex:0];
    BasicRoundResultsProto *opponentRound = [self.gameStats.gameSoFar.secondPlayer.previousRoundsStatsList objectAtIndex:0];
    
    uScoreOne = userRound.score;
    oScoreOne = opponentRound.score;
  }
  
  else if (roundTotal+ 1 == RoundThree) {
    BasicRoundResultsProto *userRound = [self.gameStats.gameSoFar.firstPlayer.previousRoundsStatsList objectAtIndex:0];
    BasicRoundResultsProto *opponentRound = [self.gameStats.gameSoFar.secondPlayer.previousRoundsStatsList objectAtIndex:0];
    
    uScoreOne = userRound.score;
    oScoreOne = opponentRound.score;
    
    userRound = [self.gameStats.gameSoFar.firstPlayer.previousRoundsStatsList objectAtIndex:1];
    opponentRound = [self.gameStats.gameSoFar.secondPlayer.previousRoundsStatsList objectAtIndex:1];
    
    uScoreTwo = userRound.score;
    oScoreTwo = opponentRound.score;
  }
  
  if (self.gameStats.gameSoFar.firstPlayer.bup.nameFriendsSee) {
    self.userName.text = [NSString stringWithFormat:@"%@",self.gameStats.gameSoFar.firstPlayer.bup.nameFriendsSee];
  }
  else {
    self.userName.text = [NSString stringWithFormat:@"%@",self.gameStats.gameSoFar.firstPlayer.bup.nameStrangersSee];
  }
  
  if (self.gameStats.gameSoFar.secondPlayer.bup.nameFriendsSee) {
    self.opponentName.text = [NSString stringWithFormat:@"%@",self.gameStats.gameSoFar.secondPlayer.bup.nameFriendsSee];
  }
  else {
    self.opponentName.text = [NSString stringWithFormat:@"%@",self.gameStats.gameSoFar.secondPlayer.bup.nameStrangersSee];
  }
}

- (void)setUpSecondPlayerStatsByRound:(int)roundTotal {
  //if user is second player and its the user's turn
  if (roundTotal + 1 == RoundOne) {
    BasicRoundResultsProto *opponent = [self.gameStats.gameSoFar.firstPlayer.previousRoundsStatsList objectAtIndex:0];
    oScoreOne = opponent.score;
  }
  else if (roundTotal + 1 == RoundTwo) {
    BasicRoundResultsProto *opponent = [self.gameStats.gameSoFar.firstPlayer.previousRoundsStatsList objectAtIndex:0];
    BasicRoundResultsProto *user = [self.gameStats.gameSoFar.secondPlayer.previousRoundsStatsList objectAtIndex:0];
    
    oScoreOne = opponent.score;
    uScoreOne = user.score;
    
    opponent = [self.gameStats.gameSoFar.firstPlayer.previousRoundsStatsList objectAtIndex:1];
    oScoreTwo = opponent.score;
  }
  else if (roundTotal + 1 == RoundThree) {
    BasicRoundResultsProto *opponent = [self.gameStats.gameSoFar.firstPlayer.previousRoundsStatsList objectAtIndex:0];
    BasicRoundResultsProto *user = [self.gameStats.gameSoFar.secondPlayer.previousRoundsStatsList objectAtIndex:0];
    
    oScoreOne = opponent.score;
    uScoreOne = user.score;
    
    opponent = [self.gameStats.gameSoFar.firstPlayer.previousRoundsStatsList objectAtIndex:1];
    user = [self.gameStats.gameSoFar.secondPlayer.previousRoundsStatsList objectAtIndex:1];
    
    oScoreTwo = opponent.score;
    uScoreTwo = user.score;
    
    opponent = [self.gameStats.gameSoFar.firstPlayer.previousRoundsStatsList objectAtIndex:2];
    oScoreThree = opponent.score;
  }
  
  if (self.gameStats.gameSoFar.secondPlayer.bup.nameFriendsSee) {
    self.userName.text = [NSString stringWithFormat:@"%@",self.gameStats.gameSoFar.secondPlayer.bup.nameFriendsSee];
  }
  else {
    self.userName.text =  [NSString stringWithFormat:@"%@",self.gameStats.gameSoFar.secondPlayer.bup.nameStrangersSee];
  }
  
  if (self.gameStats.gameSoFar.firstPlayer.bup.nameFriendsSee) {
    self.opponentName.text = [NSString stringWithFormat:@"%@",self.gameStats.gameSoFar.firstPlayer.bup.nameFriendsSee];
  }
  else {
    self.opponentName.text = [NSString stringWithFormat:@"%@",self.gameStats.gameSoFar.firstPlayer.bup.nameStrangersSee];
  }
}

- (void)viewDidLoad
{
  [super viewDidLoad];
  animationCounter = 9;
  uScoreOne = 50;
  uScoreTwo = 50;
  uScoreThree = 50;
  oScoreOne = 60;
  oScoreTwo = 60;
  oScoreThree = 60;
  uTotalScore = 150;
  oTotalScore = 180;
  //test data
  self.userImage.image = [UIImage imageNamed:@"testimage1.jpg"];
  self.opponentImage.image = [UIImage imageNamed:@"testimage2.jpg"];
  [self updatePlayerPics];
  
  [self startSpin];
}

- (void)updatePlayerPics {
  UIImage *maskImage = [UIImage imageNamed:@"fbblackcircle.png"];
  CALayer *mask = [CALayer layer];
  mask.contents = (id)[maskImage CGImage];
  mask.frame = CGRectMake(0, 0, maskImage.size.width, maskImage.size.height);
  self.userImage.layer.mask = mask;
  self.userImage.contentMode = UIViewContentModeScaleAspectFill;
  
  CALayer *opponentMask = [CALayer layer];
  opponentMask.contents = (id)[maskImage CGImage];
  opponentMask.frame = CGRectMake(0, 0, maskImage.size.width, maskImage.size.height);
  self.opponentImage.layer.mask = opponentMask;
  self.opponentImage.contentMode = UIViewContentModeScaleAspectFill;
  
}

- (void)viewDidAppear:(BOOL)animated {
  [self performSelector:@selector(animateNameSection) withObject:nil afterDelay:0.3f];
}


- (void)receievedRetrieveScoreResponse:(Class)proto {
  [self.spinner stopAnimating];
  self.spinner.hidden = YES;
}

- (IBAction)done:(id)sender {
  if (myTurn) {
    GameViewController *vc = [[GameViewController alloc] initWithNibName:nil bundle:nil userData:self.userInfo];
    [self.navigationController pushViewController:vc animated:YES];
  }
  else {
    [self.navigationController popToRootViewControllerAnimated:YES];
  }
}

- (IBAction)back:(id)sender {
  [self.navigationController popToRootViewControllerAnimated:YES];
}

#pragma mark - Animations

- (void)spinWithOptions:(UIViewAnimationOptions)options {
  [UIView animateWithDuration:5.0f delay:0.0f options:options animations:^{
    self.spinningBackground.transform = CGAffineTransformRotate(self.spinningBackground.transform, M_PI / 2);
  }completion:^(BOOL finished) {
    if (finished) {
      if (spinning) {
        // if flag still set, keep spinning with constant speed
        [self spinWithOptions: UIViewAnimationOptionCurveLinear];
      } else if (options != UIViewAnimationOptionCurveEaseOut) {
        // one last spin, with deceleration
        [self spinWithOptions: UIViewAnimationOptionCurveEaseOut];
      }
    }
  }];
}

- (void) startSpin {
  if (!spinning) {
    spinning = YES;
    [self spinWithOptions: UIViewAnimationOptionCurveEaseIn];
  }
}

- (void) stopSpin {
  // set the flag to stop spinning after one last 90 degree increment
  spinning = NO;
}

- (void)pulsingAnimationWithView:(UIView *)view {
  CABasicAnimation *theAnimation;
  
  theAnimation=[CABasicAnimation animationWithKeyPath:@"transform.scale"];
  theAnimation.duration= 0.7;
  theAnimation.repeatCount = HUGE_VALF;
  theAnimation.autoreverses =YES;
  theAnimation.fromValue=[NSNumber numberWithFloat:1.0];
  theAnimation.toValue=[NSNumber numberWithFloat:1.5];
  [view.layer addAnimation:theAnimation forKey:@"animatePulse"];
}

- (void) bounceView: (UIView *) view
withCompletionBlock:(void(^)(BOOL))completionBlock
{
  view.layer.transform = CATransform3DMakeScale(0.3, 0.3, 1.0);
  
  CAKeyframeAnimation *bounceAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
  bounceAnimation.values = [NSArray arrayWithObjects:
                            [NSNumber numberWithFloat:0.3],
                            [NSNumber numberWithFloat:1.1],
                            [NSNumber numberWithFloat:0.95],
                            [NSNumber numberWithFloat:1.0], nil];
  
  bounceAnimation.keyTimes = [NSArray arrayWithObjects:
                              [NSNumber numberWithFloat:0],
                              [NSNumber numberWithFloat:0.4],
                              [NSNumber numberWithFloat:0.7],
                              [NSNumber numberWithFloat:0.9],
                              [NSNumber numberWithFloat:1.0], nil];
  
  bounceAnimation.timingFunctions = [NSArray arrayWithObjects:
                                     [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut],
                                     [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut],
                                     [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut], nil];
  
  bounceAnimation.duration = 0.5;
  [view.layer addAnimation:bounceAnimation forKey:@"bounce"];
  
  view.layer.transform = CATransform3DIdentity;
  if (completionBlock) {
    [UIView animateWithDuration:0 delay:0.5 options:UIViewAnimationOptionTransitionNone animations:nil completion:completionBlock];
  }
}


#pragma mark - ANIMATIONS IN ORDER

- (void)animateNameSection {
  //tag 100 and 101 is the fbblackcircle
  UIView *userBlackCircleView = [self.view viewWithTag:100];
  UIView *opponentBlackCircleView = [self.view viewWithTag:101];
  CGPoint userBlackCircleOriginalPoint = userBlackCircleView.center;
  CGPoint opponentBlackCircleOriginalPoint = opponentBlackCircleView.center;
  userBlackCircleView.center = CGPointMake(-userBlackCircleView.center.x, userBlackCircleView.center.y);
  opponentBlackCircleView.center = CGPointMake(opponentBlackCircleView.center.x * 2, opponentBlackCircleView.center.y);
  
  userBlackCircleView.hidden = NO;
  opponentBlackCircleView.hidden = NO;
  
  [UIView animateWithDuration:0.3f delay:0.3f options:UIViewAnimationTransitionNone animations:^{
    userBlackCircleView.center = userBlackCircleOriginalPoint;
    opponentBlackCircleView.center = opponentBlackCircleOriginalPoint;
  }completion:nil];
  
  
  for (int i = 1; i <= 3; i++) {
    UIView *view = [self.view viewWithTag:i];
    view.hidden = NO;
    CGPoint originalPoint = view.center;
    view.center = CGPointMake(-view.center.x, view.center.y);
    [UIView animateWithDuration:0.3f delay:0.3f options:UIViewAnimationTransitionNone animations:^{
      view.center = originalPoint;
    }completion:nil];
  }

  for (int i = 4; i <= 6; i++) {
    UIView *view = [self.view viewWithTag:i];
    view.hidden = NO;
    CGPoint originalPoint = view.center;
    view.center = CGPointMake(view.center.x * 2, view.center.y);
    [UIView animateWithDuration:0.3f delay:0.3f options:UIViewAnimationTransitionNone animations:^{
      view.center = originalPoint;
    }completion:nil];
  }
  
  UIView *view = [self.view viewWithTag:7];
  view.transform = CGAffineTransformMakeScale(3, 3);
  [UIView animateWithDuration:0.4f delay:0.6f options:UIViewAnimationOptionTransitionNone animations:^{
    view.alpha = 1.0f;
    view.transform = CGAffineTransformIdentity;
  }completion:^(BOOL finished) {
    [self animatePointBG];
  }];
}

- (void)animatePointBG {
  [NSTimer scheduledTimerWithTimeInterval:0.2f target:self selector:@selector(animatePointDescriptions:) userInfo:nil repeats:YES];
}

- (void)animatePointDescriptions:(NSTimer *)timer {
  UIView *label = [self.view viewWithTag:animationCounter];
  animationCounter++;
  
  [UIView animateWithDuration:0.2f animations:^{
    label.alpha = 1.0f;
  }];
  [self bounceView:label withCompletionBlock:nil];
  
  if (animationCounter == 14) {
    [timer invalidate];
    [self animateFirstRow];
  }
}

- (void)animateFirstRow {
  UIView *u = [self.view viewWithTag:animationCounter];
  animationCounter++;
  UIView *o = [self.view viewWithTag:animationCounter];
  animationCounter++;

  [UIView animateWithDuration:0.3f animations:^{
    u.alpha = 1.0f;
    o.alpha = 1.0f;
  }completion:^(BOOL finished) {
    [self startTimerWithTag:14];
    [self startTimerWithTag:15];
  }];
}

- (void)animateSecondRow {
  userScoreLoaded = NO;
  opponentScoreLoaded = NO;
  UIView *u = [self.view viewWithTag:animationCounter];
  animationCounter++;
  UIView *o = [self.view viewWithTag:animationCounter];
  animationCounter++;
  [UIView animateWithDuration:0.3f animations:^{
    u.alpha = 1.0f;
    o.alpha = 1.0f;
  }completion:^(BOOL finished) {
    [self startTimerWithTag:16];
    [self startTimerWithTag:17];
  }];
}

- (void)animateThirdRow {
  userScoreLoaded = NO;
  opponentScoreLoaded = NO;
  UIView *u = [self.view viewWithTag:animationCounter];
  animationCounter++;
  UIView *o = [self.view viewWithTag:animationCounter];
  animationCounter++;
  [UIView animateWithDuration:0.3f animations:^{
    u.alpha = 1.0f;
    o.alpha = 1.0f;
  }completion:^(BOOL finished) {
    [self startTimerWithTag:18];
    [self startTimerWithTag:19];
  }];
}

- (void)animateFourthRow {
  userScoreLoaded = NO;
  opponentScoreLoaded = NO;
  UIView *u = [self.view viewWithTag:animationCounter];
  animationCounter++;
  UIView *o = [self.view viewWithTag:animationCounter];
  animationCounter++;
  [UIView animateWithDuration:0.3f animations:^{
    u.alpha = 1.0f;
    o.alpha = 1.0f;
  }completion:^(BOOL finished) {
    [self startTimerWithTag:20];
    [self startTimerWithTag:21];
  }];
}

- (void)animateTurnAndDone {
  UILabel *label = (UILabel *)[self.view viewWithTag:22];
  UIView *button = (UIView *)[self.view viewWithTag:23];
  UIView *doneLabel = (UIView *)[self.view viewWithTag:24];
  [UIView animateWithDuration:0.3 animations:^{
    label.alpha = 1.0f;
  }completion:^(BOOL finished) {
    [UIView animateWithDuration:0.2f animations:^{
      button.alpha = 1.0f;
      doneLabel.alpha =1.0f;
    }completion:^(BOOL finished) {
      [self pulsingAnimationWithView:self.opponentTotalScore];
      [self pulsingAnimationWithView:self.whosTurn];
    }];
    [self bounceView:button withCompletionBlock:nil];
    [self bounceView:doneLabel withCompletionBlock:nil];
  }];
}

- (void)startTimerWithTag:(int)tag {
  switch (tag) {
    case 14:
      [NSTimer scheduledTimerWithTimeInterval:0.01 target:self selector:@selector(changeUScoreOne:) userInfo:nil repeats:YES];
      break;
      
    case 15:
      [NSTimer scheduledTimerWithTimeInterval:0.01 target:self selector:@selector(changeOScoreOne:) userInfo:nil repeats:YES];
      break;
      
    case 16:
      [NSTimer scheduledTimerWithTimeInterval:0.01 target:self selector:@selector(changeUScoreTwo:) userInfo:nil repeats:YES];
      break;
      
    case 17:
      [NSTimer scheduledTimerWithTimeInterval:0.01 target:self selector:@selector(changeOScoreTwo:) userInfo:nil repeats:YES];
      break;
      
    case 18:
      [NSTimer scheduledTimerWithTimeInterval:0.01 target:self selector:@selector(changeUScoreThree:) userInfo:nil repeats:YES];
      break;
      
    case 19:
      [NSTimer scheduledTimerWithTimeInterval:0.01 target:self selector:@selector(changeOScoreThree:) userInfo:nil repeats:YES];
      break;
      
    case 20:
      [NSTimer scheduledTimerWithTimeInterval:0.01 target:self selector:@selector(changeTScoreOne:) userInfo:nil repeats:YES];
      break;
      
    case 21:
      [NSTimer scheduledTimerWithTimeInterval:0.01 target:self selector:@selector(changeTScoreTwo:) userInfo:nil repeats:YES];
      break;
    
    default:
      break;
  }
}

- (void)changeUScoreOne:(NSTimer *)timer {
  uScoreOneBefore += 1;
  UILabel *label = (UILabel *)[self.view viewWithTag:14];
  if (uScoreOne == 0) label = [NSString stringWithFormat:@"-"];
  else label.text= [NSString stringWithFormat:@"%d",uScoreOneBefore];
  if (uScoreOneBefore >= uScoreOne) {
    userScoreLoaded = YES;
    if (opponentScoreLoaded && userScoreLoaded) {
      [self animateSecondRow];
    }
    [timer invalidate];
  }
}

- (void)changeOScoreOne:(NSTimer *)timer {
  oScoreOneBefore += 1;
  UILabel *label = (UILabel *)[self.view viewWithTag:15];
  if (oScoreOne == 0) label = [NSString stringWithFormat:@"-"];
  else label.text= [NSString stringWithFormat:@"%d",oScoreOneBefore];
  if (oScoreOneBefore >= oScoreOne) {
    opponentScoreLoaded = YES;
    if (userScoreLoaded && opponentScoreLoaded) {
      [self animateSecondRow];
    }
    [timer invalidate];
  }
}

- (void)changeUScoreTwo:(NSTimer *)timer {
  uScoreTwoBefore++;
  UILabel *label = (UILabel *)[self.view viewWithTag:16];
  if (uScoreTwo == 0) label.text = [NSString stringWithFormat:@"-"];
  else label.text= [NSString stringWithFormat:@"%d",uScoreTwoBefore];
  if (uScoreTwoBefore >= uScoreTwo) {
    userScoreLoaded = YES;
    if (opponentScoreLoaded && userScoreLoaded) {
      [self animateThirdRow];
    }
    [timer invalidate];
  }
}

- (void)changeOScoreTwo:(NSTimer *)timer {
  oScoreTwoBefore += 1;
  UILabel *label = (UILabel *)[self.view viewWithTag:17];
  if (oScoreTwo == 0) label.text = [NSString stringWithFormat:@"-"];
  else label.text= [NSString stringWithFormat:@"%d",oScoreTwoBefore];
  if (oScoreTwoBefore >= oScoreTwo) {
    opponentScoreLoaded = YES;
    if (userScoreLoaded && opponentScoreLoaded) {
      [self animateThirdRow];
    }
    [timer invalidate];
  }
}

- (void)changeUScoreThree:(NSTimer *)timer {
  uScoreThreeBefore += 1;
  UILabel *label = (UILabel *)[self.view viewWithTag:18];
  if (uScoreThree == 0) label.text = [NSString stringWithFormat:@"-"];
  else label.text= [NSString stringWithFormat:@"%d",uScoreThreeBefore];
  if (uScoreThreeBefore >= uScoreThree) {
    userScoreLoaded = YES;
    if (opponentScoreLoaded && userScoreLoaded) {
      [self animateFourthRow];
    }
    [timer invalidate];
  }
}

- (void)changeOScoreThree:(NSTimer *)timer {
  oScoreThreeBefore += 1;
  UILabel *label = (UILabel *)[self.view viewWithTag:19];
  if (oScoreThree == 0) label.text = [NSString stringWithFormat:@"-"];
  else label.text= [NSString stringWithFormat:@"%d",oScoreThreeBefore];
  if (oScoreThreeBefore >= oScoreThree) {
    opponentScoreLoaded = YES;
    if (userScoreLoaded && opponentScoreLoaded) {
      [self animateFourthRow];
    }
    [timer invalidate];
  }
}

- (void)changeTScoreOne:(NSTimer *)timer {
  uTotalScoreBefore += 1;
  UILabel *label = (UILabel *)[self.view viewWithTag:20];
  if (uTotalScore == 0) label.text = [NSString stringWithFormat:@"-"];
  else label.text= [NSString stringWithFormat:@"%d",uTotalScoreBefore];
  if (uTotalScoreBefore >= uTotalScore) {
    userScoreLoaded = YES;
    if (opponentScoreLoaded && userScoreLoaded) {
      [self animateTurnAndDone];
    }
    [timer invalidate];
  }
}

- (void)changeTScoreTwo:(NSTimer *)timer {
  oTotalScoreBefore += 1;
  UILabel *label = (UILabel *)[self.view viewWithTag:21];
  if (oTotalScore == 0) label.text = [NSString stringWithFormat:@"-"];
  else label.text = [NSString stringWithFormat:@"%d",oTotalScoreBefore];
  if (oTotalScoreBefore >= oTotalScore) {
    opponentScoreLoaded = YES;
    if (userScoreLoaded && opponentScoreLoaded) {
      [self animateTurnAndDone];
    }
    [timer invalidate];
  }
}

@end
