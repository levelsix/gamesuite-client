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
#import "SocketCommunication.h"

#define MAX_GOLD_COINS 15
#define ADD_NEW_COIN_TIME 1200

@interface HomeViewController () {
  NSTimer *newCoinTimer;
  NSInteger addNewCoinTime;
  BOOL fromSignUp;
  int amountOfRubies;
  int amountOfGoldCoins;
  int yourTurnAmt;
  int theirTurnAmt;
  int completedAmt;
  int rubyBefore;
    
  BOOL myTurnHasNoGames;
  BOOL theirTurnHasNoGames;
  BOOL completedHasNoGames;
  
  BasicUserProto *basicProto;

}

@end

@implementation HomeViewController {
  ADBannerView *_bannerView;
  NSTimer *_timer;
  CFTimeInterval _ticks;
}

- (id)initWithLoginResponse:(LoginResponseProto *)proto {
  if ((self = [super init])) {
    self.loginProto = proto;
    self.completedGames = [proto.completedGamesList copy];
    self.myTurns = proto.myTurnList;
    self.questions = proto.newQuestionsList;
    self.userInfo = [[UserInfo alloc] initWithCompleteUserProto:proto.recipient];
    self.userInfo.listOfFacebookFriends = proto.facebookFriendsWithAccountsList;
    self.userInfo.questions = proto.newQuestionsList;
    [self saveTokenWithProto:proto.recipient];
    [self addArraysTogether];
    fromSignUp = YES;
  }
  return self;
}

- (void)saveTokenWithProto:(CompleteUserProto *)proto {
  NSMutableDictionary *completeUserDict = [NSMutableDictionary dictionary];
  [completeUserDict setObject:proto.userId forKey:@"userId"];
  [completeUserDict setObject:proto.nameStrangersSee forKey:@"nameStrangersSee"];
  [completeUserDict setObject:proto.nameFriendsSee forKey:@"nameFriendsSee"];
  [completeUserDict setObject:proto.email forKey:@"email"];
  [completeUserDict setObject:proto.password forKey:@"password"];
  [completeUserDict setObject:proto.facebookId forKey:@"facebookId"];
  [completeUserDict setObject:[NSNumber numberWithLongLong:proto.lastLogin] forKey:@"lastLogin"];
  [completeUserDict setObject:[NSNumber numberWithLongLong:proto.signupDate] forKey:@"signupDate"];

  NSMutableDictionary *tokenDict = [NSMutableDictionary dictionary];
  
  [tokenDict setObject:proto.badp.basicAuthorizedDeviceId forKey:@"basicAuthorizedDeviceId"];
  [tokenDict setObject:proto.badp.userId forKey:@"tokenUserId"];
  [tokenDict setObject:proto.badp.loginToken forKey:@"loginToken"];
  [tokenDict setObject:[NSNumber numberWithLongLong:proto.badp.expirationDate] forKey:@"expirationDate"];
  [tokenDict setObject:proto.badp.udid forKey:@"udid"];
  [tokenDict setObject:proto.badp.deviceId forKey:@"deviceId"];
  
  
  [[NSUserDefaults standardUserDefaults] setObject:[completeUserDict copy] forKey:COMPLETE_USER_INFO];
  [[NSUserDefaults standardUserDefaults] setObject:[tokenDict copy] forKey:LOGIN_TOKEN];
  [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)loginWithToken {
  [self.view addSubview:self.updatingView];
  [self.updatingSpinner startAnimating];
  self.updatingView.center = CGPointMake(self.view.frame.size.width/2, self.view.frame.size.height/2);
  self.view.userInteractionEnabled = NO;
  
  NSDictionary *completeUser = [[NSUserDefaults standardUserDefaults] objectForKey:COMPLETE_USER_INFO];
  NSDictionary *token = [[NSUserDefaults standardUserDefaults] objectForKey:LOGIN_TOKEN];
  
  if (completeUser && token) {    
    NSString *userId = [completeUser objectForKey:@"userId"];
    NSString *nameStrangersSee = [completeUser objectForKey:@"nameStrangersSee"];
    NSString *nameFriendsSee = [completeUser objectForKey:@"nameFriendsSee"];
    NSString *email = [completeUser objectForKey:@"email"];
    NSString *facebookId = [completeUser objectForKey:@"facebookId"];
    NSString *password = [completeUser objectForKey:@"password"];
    
    NSString *basicAuthorizedDeviceId = [token objectForKey:@"basicAuthorizedDeviceId"];
    NSString *tokenUserId = [token objectForKey:@"tokenUserId"];
    NSString *loginToken = [token objectForKey:@"loginToken"];
    long long int expirationDate = [[token objectForKey:@"expirationDate"] longLongValue];
    
    NSString *udid = [token objectForKey:@"udid"];
    NSString *deviceId = [token objectForKey:@"deviceId"];
    
    
    BasicAuthorizedDeviceProto *deviceProto = [[[[[[[[BasicAuthorizedDeviceProto builder] setBasicAuthorizedDeviceId:basicAuthorizedDeviceId] setUserId:tokenUserId] setLoginToken:loginToken] setExpirationDate:expirationDate] setUdid:udid] setDeviceId:deviceId] build];
    
    basicProto = [[[[[[[[[BasicUserProto builder] setUserId:userId] setNameStrangersSee:nameStrangersSee] setNameFriendsSee:nameFriendsSee] setEmail:email] setPassword:password] setFacebookId:facebookId] setBadp:deviceProto] build];
    
    SocketCommunication *sc = [SocketCommunication sharedSocketCommunication];
    sc.delegate = self;
    
    BOOL didFacebookLogin = [[NSUserDefaults standardUserDefaults] boolForKey:DID_FACEBOOK_SIGNUP];
    if (didFacebookLogin) {
      if (!FBSession.activeSession.isOpen) {
        FacebookObject *fb = [[FacebookObject alloc] init];
        AppDelegate *ad = [[UIApplication sharedApplication] delegate];
        ad.delegate = self;
        [fb facebookLogin];
      }
      else {
        [self finishedFBLogin];
      }
    }
    else {
      [sc sendLoginRequestEventViaToken:basicProto facebookFriends:NULL];
    }
  }
}

- (void)finishedFBLogin {
  NSMutableArray *friendIds = [NSMutableArray array];
  FBRequest *friendsRequest = [FBRequest requestForMyFriends];
  [friendsRequest startWithCompletionHandler: ^(FBRequestConnection *connection,
                                                NSDictionary* result,
                                                NSError *error) {
    if (!error) {
      NSArray* friends = [result objectForKey:@"data"];
      for (NSDictionary<FBGraphUser>* friend in friends) {
        [friendIds addObject:friend.id];
      }
      SocketCommunication *sc = [SocketCommunication sharedSocketCommunication];
      sc.delegate = self;
      [sc sendLoginRequestEventViaToken:basicProto facebookFriends:friendIds];
    }
    else {
      NSLog(@"%@",error);
    }
  }];
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
  amountOfRubies = 15;
  if (amountOfGoldCoins != MAX_GOLD_COINS) {
    newCoinTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(coinCountDown) userInfo:nil repeats:YES];  
  }
  [self coinManagement:YES];
  
  if ([ADBannerView instancesRespondToSelector:@selector(initWithAdType:)]) {
    _bannerView = [[ADBannerView alloc] initWithAdType:ADAdTypeBanner];
  }
  else {
    _bannerView = [[ADBannerView alloc] init];
  }
  _bannerView.delegate = self;
  [self.view addSubview:_bannerView];
  [self layoutAnimated:NO];
}

- (void)layoutAnimated:(BOOL)animated
{
  CGRect contentFrame = self.view.bounds;
  if (contentFrame.size.width < contentFrame.size.height) {
    _bannerView.currentContentSizeIdentifier = ADBannerContentSizeIdentifierPortrait;
  } else {
    _bannerView.currentContentSizeIdentifier = ADBannerContentSizeIdentifierLandscape;
  }
  
  CGRect bannerFrame = _bannerView.frame;
  if (_bannerView.bannerLoaded) {
    contentFrame.size.height -= _bannerView.frame.size.height;
    bannerFrame.origin.y = contentFrame.size.height;
  } else {
    bannerFrame.origin.y = contentFrame.size.height;
  }
  
  [UIView animateWithDuration:animated ? 0.25 : 0.0 animations:^{
    [self.view layoutIfNeeded];
    _bannerView.frame = bannerFrame;
  }];
}

- (void)addArraysTogether {
  myTurnHasNoGames = NO;
  theirTurnHasNoGames = NO;
  completedHasNoGames = NO;
  self.wholeArray = [[NSMutableArray alloc] init];
  NSArray *newArray = [self.wholeArray arrayByAddingObjectsFromArray:self.myTurns];
  NSArray *secondArray = [newArray arrayByAddingObjectsFromArray:self.notMyTurns];
  NSArray *thirdArray = [secondArray arrayByAddingObjectsFromArray:self.completedGames];
  self.wholeArray = [[NSMutableArray alloc] initWithArray:thirdArray];
  yourTurnAmt = newArray.count;
  theirTurnAmt = secondArray.count;
  completedAmt = thirdArray.count;
  
  if (yourTurnAmt == 0) {
    yourTurnAmt = 1;
    myTurnHasNoGames = YES;
  }
  if (theirTurnAmt == 0) {
    theirTurnAmt = 1;
    theirTurnHasNoGames = YES;
  }
  if (completedAmt == 0) {
    completedAmt = 1;
    completedHasNoGames = YES;
  }
  [self.tableView reloadData];
}

- (void)updateUI {
  self.rubyLabel.text = [NSString stringWithFormat:@"%d",self.userInfo.rubies];
}

- (void)updateRuby:(int)value  {
  rubyBefore = amountOfRubies;
  amountOfRubies += value;
  self.rubyLabel.text = [NSString stringWithFormat:@"%d",amountOfRubies];
  [NSTimer scheduledTimerWithTimeInterval:0.01 target:self selector:@selector(countUpRuby:) userInfo:nil repeats:YES];
}

- (void)countUpRuby:(NSTimer *)timer {
  rubyBefore += 1;
  self.rubyLabel.text = [NSString stringWithFormat:@"%d",rubyBefore];
  if (rubyBefore >= amountOfRubies) {
    [timer invalidate];
  }
}

- (void)updateGoldCoin:(int)value {
  amountOfGoldCoins = 15;
  [self coinManagement:YES];
  [self invalidateTimer];
  addNewCoinTime = ADD_NEW_COIN_TIME;
  NSInteger minute = addNewCoinTime/60;
  NSInteger leftOver = addNewCoinTime % 60;
  NSString *timeFormat = [NSString stringWithFormat:@"%0.2d:%0.2d",minute, leftOver];
  self.coinTimeLabel.text = timeFormat;
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

- (IBAction)startNewGame:(id)sender {
  amountOfGoldCoins--;
  [self coinManagement:NO];
  if(![newCoinTimer isValid]) {
    newCoinTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(coinCountDown) userInfo:nil repeats:YES];    
  }

  ChallengeTypeViewController *vc = [[ChallengeTypeViewController alloc] initWithUserInfo:self.userInfo];
  vc.delegate = self;
  [self.navigationController pushViewController:vc rotated:YES];
}

- (IBAction)goToGame:(id)sender {
  UIButton *b = (UIButton *)sender;

  if (b.tag > theirTurnAmt && b.tag <= completedAmt) {
    //view completed games


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
  self.shopMenu.center = CGPointMake(self.view.frame.size.width/2, self.view.frame.size.height/2);
  [self.shopMenu getDataWithGame:self];
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

- (void)passDataBackToRootView:(UserInfo *)userInfo {
  self.userInfo = userInfo;
}

#pragma mark Protocol Buffers methods

- (void)refreshDataWithProto:(LoginResponseProto *)proto {
  self.userInfo = [[UserInfo alloc] initWithCompleteUserProto:proto.recipient];
  self.userInfo.listOfFacebookFriends = proto.facebookFriendsWithAccountsList;
  self.userInfo.questions = proto.newQuestionsList;
  self.myTurns = proto.myTurnList;
  self.notMyTurns = proto.notMyTurnList;
  self.completedGames = proto.completedGamesList;
  [self addArraysTogether];
}

- (void)receivedProtoResponse:(PBGeneratedMessage *)message {
  LoginResponseProto *proto = (LoginResponseProto *)message;
  [self.updatingSpinner stopAnimating];
  [self.updatingView removeFromSuperview];
  self.view.userInteractionEnabled = YES;
  if (proto.status == LoginResponseProto_LoginResponseStatusSuccessLoginToken || proto.status == LoginResponseProto_LoginResponseStatusSuccessFacebookId || proto.status == LoginResponseProto_LoginResponseStatusSuccessEmailPassword || proto.status == LoginResponseProto_LoginResponseStatusSuccessNoCredentials) {
    [self saveTokenWithProto:proto.recipient];
    [self refreshDataWithProto:proto];
  }
  else {
    //implemente fail sceneario
    NSLog(@"log in failed");
  }
}

- (void)getNewQuestions {

}

- (void)startNewRoundWithTag:(int)tag {
  OngoingGameProto *onGoingGame = (OngoingGameProto *)[self.wholeArray objectAtIndex:tag];
  
  if (onGoingGame.myNewRound) {
    
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
      return yourTurnAmt;
      break;
      
    case kTheirTurn:
      return theirTurnAmt;
      break;
      
    case kCompletedGames:
      return completedAmt;
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
        if (myTurnHasNoGames) {
          cell.playerPic.hidden = YES;
          cell.arrow.hidden = YES;
          cell.timeLabel.hidden = YES;
          cell.turnLabel.hidden = YES;
          cell.nameLabel.hidden = YES;
          cell.longerLabel.hidden = NO;
          cell.longerLabel.numberOfLines = 0;
          cell.longerLabel.text = [NSString stringWithFormat:@"You have no games right now \nStart a new game >>"];
        }
        else {
          tag = [tableView numberOfRowsInSection:kYourTurn];
          cell.gameButton.tag = tag -1;
        }
        break;
        
      case kTheirTurn:
        if (theirTurnHasNoGames) {
          cell.playerPic.hidden = YES;
          cell.arrow.hidden = YES;
          cell.timeLabel.hidden = YES;
          cell.turnLabel.hidden = YES;
          cell.nameLabel.hidden = YES;
          cell.noGameLabel.hidden = NO;
          cell.noGameLabel.text = [NSString stringWithFormat:@"No one finished their turn yet"];
          cell.gameButton.userInteractionEnabled = NO;
        }
        else {
          previousRowAmt = [tableView numberOfRowsInSection:kYourTurn];
          tag = [tableView numberOfRowsInSection:kTheirTurn];
          cell.gameButton.tag = previousRowAmt + tag -1;
        }
        break;
        
      case kCompletedGames:
        if (completedHasNoGames) {
          cell.playerPic.hidden = YES;
          cell.arrow.hidden = YES;
          cell.timeLabel.hidden = YES;
          cell.turnLabel.hidden = YES;
          cell.nameLabel.hidden = YES;
          cell.noGameLabel.hidden = NO;
          cell.noGameLabel.text = [NSString stringWithFormat:@"You have no games finished recently"];
          cell.gameButton.userInteractionEnabled = NO;
        }
        else {
          previousRowAmt = [tableView numberOfRowsInSection:kYourTurn];
          previousRowAmt = previousRowAmt + [tableView numberOfRowsInSection:kTheirTurn];
          tag = [tableView numberOfRowsInSection:kCompletedGames];
          cell.gameButton.tag = previousRowAmt + tag -1;
        }
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

#pragma mark - iAd delegates

- (NSUInteger)supportedInterfaceOrientations
{
  return UIInterfaceOrientationMaskAll;
}

- (void)viewDidLayoutSubviews
{
  [self layoutAnimated:[UIView areAnimationsEnabled]];
}

- (void)bannerViewDidLoadAd:(ADBannerView *)banner
{
  [self layoutAnimated:YES];
}

- (void)bannerView:(ADBannerView *)banner didFailToReceiveAdWithError:(NSError *)error
{
  [self layoutAnimated:YES];
}

- (BOOL)bannerViewActionShouldBegin:(ADBannerView *)banner willLeaveApplication:(BOOL)willLeave
{
  return YES;
}

- (void)bannerViewActionDidFinish:(ADBannerView *)banner
{
  
}

@end
