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

@interface ScoreViewController () {
  int animationCounter;
  int uScoreOneBefore;
  int uScoreTwoBefore;
  int uScoreThreeBefore;
  int oScoreOneBefore;
  int oScoreTwoBefore;
  int oScoreThreeBefore;
  int uTotalScoreBefore;
  int oTotalScoreBefore;
  BOOL userScoreLoaded;
  BOOL opponentScoreLoaded;
  int currentRound;
  BOOL spinning;
}

@end

@implementation ScoreViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil gameResultProto:(GameResultsProto *)proto basicUserProto:(BasicUserProto *)userProto completed:(BOOL)completed currentRound:(int)round;
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
      self.proto = proto;
      self.userProto = userProto;
      currentRound = round;
      if (completed) {
        [self updateCompleteNameAndStats];
      }
      else {
        [self updateScores];
      }
    }
    return self;
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
  for (int i = 14 ; i < 22; i++) {
    UILabel *label = (UILabel *)[self.view viewWithTag:i];
    label.text = [NSString stringWithFormat:@"0"];
  }
  //test data
  self.userImage.image = [UIImage imageNamed:@"testimage1.jpg"];
  self.opponentImage.image = [UIImage imageNamed:@"testimage2.jpg"];
  [self startSpin];
}

- (void)viewDidAppear:(BOOL)animated {
  [self performSelector:@selector(animateNameSection) withObject:nil afterDelay:0.3f];
}

- (void)updateScores {
  
}

- (void)updateCompleteNameAndStats {
  if ([self.proto.firstPlayer.bup.nameFriendsSee isEqualToString:self.userProto.nameFriendsSee] || [self.proto.firstPlayer.bup.nameStrangersSee isEqualToString:self.userProto.nameStrangersSee]) {
    //if user is first player
    BasicRoundResultsProto *round = [self.proto.firstPlayer.previousRoundsStatsList objectAtIndex:0];
    uScoreOne = round.score;
    
    round = [self.proto.firstPlayer.previousRoundsStatsList objectAtIndex:1];
    uScoreTwo = round.score;
    
    round = [self.proto.firstPlayer.previousRoundsStatsList objectAtIndex:2];
    uScoreThree = round.score;
    
    round = [self.proto.secondPlayer.previousRoundsStatsList objectAtIndex:0];
    oScoreOne = round.score;
    
    round = [self.proto.secondPlayer.previousRoundsStatsList objectAtIndex:1];
    oScoreTwo = round.score;
    
    round = [self.proto.secondPlayer.previousRoundsStatsList objectAtIndex:2];
    oScoreThree = round.score;
    
    uTotalScore = uScoreOne + uScoreTwo + uScoreThree;
    oTotalScore = oScoreOne + oScoreTwo + oScoreThree;
    
    if (self.proto.firstPlayer.bup.nameFriendsSee) self.userName.text = self.proto.firstPlayer.bup.nameFriendsSee;
    else self.userName.text = self.proto.firstPlayer.bup.nameFriendsSee;
    
    if (self.proto.secondPlayer.bup.nameFriendsSee) self.opponentName.text = self.proto.secondPlayer.bup.nameFriendsSee;
    else self.opponentName.text = self.proto.secondPlayer.bup.nameStrangersSee;
    
  }
  else {
    //if user is second player
    BasicRoundResultsProto *round = [self.proto.secondPlayer.previousRoundsStatsList objectAtIndex:0];
    uScoreOne = round.score;
    
    round = [self.proto.secondPlayer.previousRoundsStatsList objectAtIndex:1];
    uScoreTwo = round.score;
    
    round = [self.proto.secondPlayer.previousRoundsStatsList objectAtIndex:2];
    uScoreThree = round.score;
    
    round = [self.proto.firstPlayer.previousRoundsStatsList objectAtIndex:0];
    oScoreOne = round.score;
    
    round = [self.proto.firstPlayer.previousRoundsStatsList objectAtIndex:1];
    oScoreTwo = round.score;
    
    round = [self.proto.firstPlayer.previousRoundsStatsList objectAtIndex:2];
    oScoreThree = round.score;
    
    uTotalScore = uScoreOne + uScoreTwo + uScoreThree;
    oTotalScore = oScoreOne + oScoreTwo + oScoreThree;
    
    if (self.proto.secondPlayer.bup.nameFriendsSee) self.userName.text = self.proto.secondPlayer.bup.nameFriendsSee;
    else self.userName.text = self.proto.secondPlayer.bup.nameStrangersSee;
    
    if (self.proto.firstPlayer.bup.nameFriendsSee) self.opponentName.text = self.proto.firstPlayer.bup.nameFriendsSee;
    else self.opponentName.text = self.proto.firstPlayer.bup.nameStrangersSee;
  }
}

- (void)receievedRetrieveScoreResponse:(Class)proto {
  [self.spinner stopAnimating];
  self.spinner.hidden = YES;
}

- (IBAction)done:(id)sender {
  [self.navigationController popToRootViewControllerAnimated:YES];
}

- (IBAction)back:(id)sender {
  [self.navigationController popToRootViewControllerAnimated:YES];
}

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

#pragma mark - Animations
//they are in order

- (void)animateNameSection {
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
  //UIView *view = [self.view viewWithTag:8];
  //view.transform = CGAffineTransformMakeScale(3, 3);
  //[UIView animateWithDuration:0.3f animations:^{
    //view.alpha = 1.0f;
    //view.transform = CGAffineTransformIdentity;
  //}completion:^(BOOL finished) {
    //[NSTimer scheduledTimerWithTimeInterval:0.2f target:self selector:@selector(animatePointDescriptions:) userInfo:nil repeats:YES];
  //}];
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
  [self pulsingAnimationWithView:self.opponentImage];
  UILabel *label = (UILabel *)[self.view viewWithTag:22];
  UIView *button = (UIView *)[self.view viewWithTag:23];
  UIView *doneLabel = (UIView *)[self.view viewWithTag:24];
  [UIView animateWithDuration:0.3 animations:^{
    label.alpha = 1.0f;
  }completion:^(BOOL finished) {
    [UIView animateWithDuration:0.2f animations:^{
      button.alpha = 1.0f;
      doneLabel.alpha =1.0f;
    }];
    [self bounceView:button withCompletionBlock:nil];
    [self bounceView:doneLabel withCompletionBlock:nil];
  }];
}

- (void)startTimerWithTag:(int)tag {
  switch (tag) {
    case 14:
//      if (currentRound != 1) {
//        break;
//      }
      [NSTimer scheduledTimerWithTimeInterval:0.01 target:self selector:@selector(changeUScoreOne:) userInfo:nil repeats:YES];
      break;
      
    case 15:
//      if (currentRound != 1) {
//        break;
//      }
      [NSTimer scheduledTimerWithTimeInterval:0.01 target:self selector:@selector(changeOScoreOne:) userInfo:nil repeats:YES];
      break;
      
    case 16:
//      if (currentRound != 2) {
//        break;
//      }
      [NSTimer scheduledTimerWithTimeInterval:0.01 target:self selector:@selector(changeUScoreTwo:) userInfo:nil repeats:YES];
      break;
      
    case 17:
//      if (currentRound != 2) {
//        break;
//      }
      [NSTimer scheduledTimerWithTimeInterval:0.01 target:self selector:@selector(changeOScoreTwo:) userInfo:nil repeats:YES];
      break;
      
    case 18:
//      if (currentRound != 3) {
//        break;
//      }
      [NSTimer scheduledTimerWithTimeInterval:0.01 target:self selector:@selector(changeUScoreThree:) userInfo:nil repeats:YES];
      break;
      
    case 19:
//      if (currentRound != 3) {
//        break;
//      }
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
  label.text= [NSString stringWithFormat:@"%d",uScoreOneBefore];
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
  label.text= [NSString stringWithFormat:@"%d",oScoreOneBefore];
  if (oScoreOneBefore >= oScoreOne) {
    opponentScoreLoaded = YES;
    if (userScoreLoaded && opponentScoreLoaded) {
      [self animateSecondRow];
    }
    [timer invalidate];
  }
}

- (void)changeUScoreTwo:(NSTimer *)timer {
  uScoreTwoBefore += 1;
  UILabel *label = (UILabel *)[self.view viewWithTag:16];
  label.text= [NSString stringWithFormat:@"%d",uScoreTwoBefore];
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
  label.text= [NSString stringWithFormat:@"%d",oScoreTwoBefore];
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
  label.text= [NSString stringWithFormat:@"%d",uScoreThreeBefore];
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
  label.text= [NSString stringWithFormat:@"%d",oScoreThreeBefore];
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
  label.text= [NSString stringWithFormat:@"%d",uTotalScoreBefore];
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
  label.text= [NSString stringWithFormat:@"%d",oTotalScoreBefore];
  if (oTotalScoreBefore >= oTotalScore) {
    opponentScoreLoaded = YES;
    if (userScoreLoaded && opponentScoreLoaded) {
      [self animateTurnAndDone];
    }
    [timer invalidate];
  }
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

@end
