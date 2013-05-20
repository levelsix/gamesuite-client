//
//  HomeViewController.m
//  Icon-Blitz
//
//  Created by Danny on 3/20/13.
//
//

#import "HomeViewController.h"
#import "HomeCell.h"
#import "ChallengeTypeViewController.h"
#import "GameViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "FacebookObject.h"
#import "ShopMenu.h"
#import "UINavigationController+PushPopRotated.h"
#import "ScoreViewController.h"
#import "UserInfo.h"

#define MAX_GOLD_COINS 15
#define ADD_NEW_COIN_TIME 1200

@interface HomeViewController () {
  NSTimer *newCoinTimer;
  NSInteger addNewCoinTime;
  int amountOfRubies;
  int amountOfGoldCoins;
  int yourTurnAmt;
  int theirTurnAmt;
  int completedAmt;
}

@end

@implementation HomeViewController

- (id) initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil event:(LoginResponseProto *)proto {
  self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
  if (self) {
    self.loginProto = proto;
    self.completedGames = proto.completedGamesList;
    self.myTurns = proto.myTurnList;
    self.questions = proto.newQuestionsList;
    self.userInfo = [[UserInfo alloc] initWithCompleteUserProto:proto.recipient];
    self.userInfo.facebookFriends = proto.facebookFriendsWithAccountsList;
    self.userInfo.questions = proto.newQuestionsList;
  }
  return self;
}

- (void)viewDidLoad
{
  [super viewDidLoad];
  [self loadGoldCoins];
  addNewCoinTime = ADD_NEW_COIN_TIME;
  NSInteger minute = addNewCoinTime/60;
  NSInteger leftOver = addNewCoinTime % 60;
  NSString *timeFormat = [NSString stringWithFormat:@"%0.2d:%0.2d",minute, leftOver];
  self.coinTimeLabel.text = timeFormat;
  amountOfGoldCoins = MAX_GOLD_COINS;
  if (amountOfGoldCoins != MAX_GOLD_COINS) {
    newCoinTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(coinCountDown) userInfo:nil repeats:YES];  
  }
  
  [self coinManagement:YES];
  [self addArraysTogether];
}

- (void)addArraysTogether {
  self.wholeArray = [[NSMutableArray alloc] init];
  NSArray *newArray = [self.wholeArray arrayByAddingObjectsFromArray:self.myTurns];
  NSArray *secondArray = [newArray arrayByAddingObjectsFromArray:self.notMyTurns];
  NSArray *thirdArray = [secondArray arrayByAddingObjectsFromArray:self.completedGames];
  self.wholeArray = [[NSMutableArray alloc] initWithArray:thirdArray];
  yourTurnAmt = 2;
  theirTurnAmt = 5;
  completedAmt = 8;
//  yourTurnAmt = self.myTurns.count;
//  theirTurnAmt = self.notMyTurns.count + self.myTurns.count;
//  completedAmt00 = self.myTurns.count + self.notMyTurns.count + self.completedGames.count;
}

- (void)updateUI {
  self.rubyLabel.text = [NSString stringWithFormat:@"%d",self.userInfo.rubies];
}

- (void)coinCountDown {
  addNewCoinTime--;
  NSInteger minute = addNewCoinTime/60;
  NSInteger leftOver = addNewCoinTime % 60;
  NSString *timeFormat = [NSString stringWithFormat:@"%0.2d:%0.2d",minute, leftOver];
  self.coinTimeLabel.text = timeFormat;
  
  if (addNewCoinTime <= 0) {
    amountOfGoldCoins++;
    [self coinManagement:YES];
    if (amountOfGoldCoins >= MAX_GOLD_COINS) {
      amountOfGoldCoins = MAX_GOLD_COINS;
      addNewCoinTime = ADD_NEW_COIN_TIME;
      NSInteger minute = addNewCoinTime/60;
      NSInteger leftOver = addNewCoinTime % 60;
      NSString *timeFormat = [NSString stringWithFormat:@"%0.2d:%0.2d",minute, leftOver];
      self.coinTimeLabel.text = timeFormat;
      [self invalidateTimer];
    }
    addNewCoinTime = ADD_NEW_COIN_TIME;
  }
}

- (void)invalidateTimer {
  if (newCoinTimer) {
    [newCoinTimer invalidate];
    newCoinTimer = nil;
  }
}

- (void)loadGoldCoins {
  int j = 0;
  for (int i = 100; i < 115; i++) {
    j++;
    UIImage *image = [UIImage imageNamed:@"coinoverlay.png"];
    UIImageView *coin = [[UIImageView alloc] initWithImage:image];
    coin.frame = CGRectMake(0, 0, image.size.width, image.size.height);
    coin.tag = i;
    coin.center = CGPointMake(173 - (6 * j),75);
    [self.view addSubview:coin];
  }
}

- (void)coinManagement:(BOOL)add {
  if (add) {
    int tag = 115 - amountOfGoldCoins;
    for (int i = tag;i < 115; i++) {
      UIImage *overlay = [UIImage imageNamed:@"goldcoin.png"];
      UIImageView *coin = (UIImageView *)[self.view viewWithTag:i];
      coin.image = overlay;
    }
  }
  else {
    int tag = 115 - amountOfGoldCoins;
    for (int i = 100; i < tag; i++) {
      UIImage *overlay = [UIImage imageNamed:@"coinoverlay.png"];
      UIImageView *coin = (UIImageView *)[self.view viewWithTag:i];
      coin.image = overlay;
    }
  }
}

- (void)viewDidAppear:(BOOL)animated {
  //[self updateUI];
}

- (IBAction)startNewGame:(id)sender {
  amountOfGoldCoins--;
  [self coinManagement:NO];
  if(![newCoinTimer isValid]) {
    newCoinTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(coinCountDown) userInfo:nil repeats:YES];    
  }
  
  //ChallengeTypeViewController *vc = [[ChallengeTypeViewController alloc] initWithNibName: @"ChallengeTypeViewController" bundle:nil userInfo:self.userInfo];
  ChallengeTypeViewController *vc = [[ChallengeTypeViewController alloc] initWithNibName:@"ChallengeTypeViewController" bundle:nil];
  [self.navigationController pushViewController:vc rotated:YES];
}

- (IBAction)goToGame:(id)sender {
  UIButton *b = (UIButton *)sender;

  if (b.tag > theirTurnAmt && b.tag <= completedAmt) {
    //view completed games
//    GameResultsProto *finishedData = [self.wholeArray objectAtIndex:b.tag];
//    ScoreViewController *vc = [[ScoreViewController alloc] initWithNibName:@"ScoreViewController" bundle:nil gameResultProto:finishedData];
//    [self.navigationController pushViewController:vc rotated:YES];
//    [vc release];
  }
  else if (b.tag <= yourTurnAmt) {
    //go into my turn
    if (amountOfGoldCoins <= 0) {
      UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Not enough gold coins" message:@"You dont have enough gold coins, you can buy more at the shop" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
      [alert show];
      return;
    }
    amountOfGoldCoins--;
    [self coinManagement:NO];
    if (![newCoinTimer isValid]) {
      newCoinTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(coinCountDown) userInfo:nil repeats:YES];
    }
  }
  else {
    // view your current round scores
    
    
  }
}

- (IBAction)goToShop:(id)sender {
  [[NSBundle mainBundle] loadNibNamed:@"ShopMenu" owner:self options:nil];
  self.view.userInteractionEnabled = NO;
  self.shopMenu.center = CGPointMake(160, 240);
  [self.shopMenu doAnimation];
  self.shopMenu.alpha = 0.0f;
  [self.view addSubview:self.shopMenu];
  [UIView animateWithDuration:0.3f animations:^{
    self.shopMenu.alpha = 1.0f;
  }];
  [self bounceView:self.shopMenu withCompletionBlock:nil];
}

- (IBAction)closeView:(id)sender {
  [UIView animateWithDuration:0.2 animations:^{
    self.shopMenu.transform = CGAffineTransformMakeScale(0.01, 0.01);
  }completion:^(BOOL finished) {
    [self.shopMenu removeFromSuperview];
  }];
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

#pragma mark UITableView Delegate Methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  switch (section) {
    case kNewGame:
      return 1;
      break;
      
    case kYourTurn:
      return 3;
      //return self.myTurns.count;
      break;
      
    case kTheirTurn:
      return 3;
      //return self.notMyTurns.count;
      break;
      
    case kCompletedGames:
      return 3;
      //return self.completedGames.count;
      break;
      
    default:
      return 0;
      break;
  }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
  if (section == kNewGame) {
    return 0;
  }
  else {
    return 37;
  }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
  UIView *headerView = [[UIView alloc] init];
  
  UILabel *titleLabel = [[UILabel alloc] init];
  UIImage *headerImage;
  if (section == kNewGame){
    return nil;
  }
  else if (section == kYourTurn) {
    titleLabel.text = [NSString stringWithFormat:@"YOUR TURN"];
    headerImage = [UIImage imageNamed:@"yourturnbg.png"];
  }
  else if (section == kTheirTurn) {
    titleLabel.text = [NSString stringWithFormat:@"THEIR TURN"];
    headerImage = [UIImage imageNamed:@"theirturnbg.png"];
  }
  
  else if (section == kCompletedGames) {
    titleLabel.text = [NSString stringWithFormat:@"COMPLETED GAMES"];
    headerImage = [UIImage imageNamed:@"completegamesbg.png"];
  }

  UIImageView *imageView = [[UIImageView alloc] initWithImage:headerImage];
  imageView.frame = CGRectMake(10, 0,headerImage.size.width, headerImage.size.height);
  imageView.contentMode = UIViewContentModeScaleAspectFill;
  [headerView addSubview:imageView];
  
  titleLabel.textColor = [UIColor whiteColor];
  titleLabel.backgroundColor = [UIColor clearColor];
  titleLabel.frame = CGRectMake(10, 5, imageView.frame.size.width, imageView.frame.size.height);
  titleLabel.font = [UIFont fontWithName:@"AvenirNextLTPro-Bold" size:22];
  [headerView addSubview:titleLabel];
  titleLabel.textAlignment = UITextAlignmentCenter;
  return headerView;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  static NSString *CellIdentifier1 = @"NewGame";
  static NSString *CellIdentifier2 = @"TurnCells";
  static NSString *CellIdentifier3 = @"LastCell";
  NSInteger lastCellIndex = [tableView numberOfRowsInSection:indexPath.section] -1;
  if (indexPath.section == kNewGame) {
    StartGameCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier1];
    
    if (cell == nil) {
      [[NSBundle mainBundle] loadNibNamed:@"HomeCell" owner:self options:nil];
      cell = self.startCell;
    }
    return cell;
  }
  else if (indexPath.row == lastCellIndex) {
    LastCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier3];
    if (cell == nil) {
      [[NSBundle mainBundle] loadNibNamed:@"HomeCell" owner:self options:nil];
      cell = self.lastCell;
    }

    switch (indexPath.section) {
        int tag;
        int previousRowAmt;
      case kYourTurn:
        tag = [tableView numberOfRowsInSection:kYourTurn];
        cell.gameButton.tag = tag -1;
        break;
        
        case kTheirTurn:
        previousRowAmt = [tableView numberOfRowsInSection:kYourTurn];
        tag = [tableView numberOfRowsInSection:kTheirTurn];
        cell.gameButton.tag = previousRowAmt + tag -1;
        break;
        
        case kCompletedGames:
        previousRowAmt = [tableView numberOfRowsInSection:kYourTurn];
        previousRowAmt = previousRowAmt + [tableView numberOfRowsInSection:kTheirTurn];
        tag = [tableView numberOfRowsInSection:kCompletedGames];
        cell.gameButton.tag = previousRowAmt + tag -1;
        break;
        
      default:
        break;
    }
    
    return cell;
  }
  else {
    TurnCells *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier2];
    if (cell == nil) {
      [[NSBundle mainBundle] loadNibNamed:@"HomeCell" owner:self options:nil];
      cell = self.turnCell;
    }
    
    switch (indexPath.section) {
        int tag;
        int previousRowAmt;
      case kYourTurn:
        cell.gameButton.tag = indexPath.row;
        break;
        
      case kTheirTurn:
        previousRowAmt = [tableView numberOfRowsInSection:kYourTurn];
        cell.gameButton.tag = previousRowAmt + indexPath.row;
        break;
        
      case kCompletedGames:
        previousRowAmt = [tableView numberOfRowsInSection:kYourTurn];
        tag = [tableView numberOfRowsInSection:kYourTurn];
        cell.gameButton.tag = previousRowAmt + tag + indexPath.row;
        break;
        
      default:
        break;
    }
    
    return cell;
  }
  return nil;
}

@end
