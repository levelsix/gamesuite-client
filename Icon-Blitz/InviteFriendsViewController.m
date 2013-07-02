//
//  InviteFriendsViewController.m
//  Icon-Blitz
//
//  Created by Danny on 4/4/13.
//
//

#import "InviteFriendsViewController.h"
#import "FontLabel.h"
#import "InviteFriendsCell.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import <FacebookSDK/FacebookSDK.h>
#import <QuartzCore/QuartzCore.h>
#import "GameViewController.h"
#import "UINavigationController+PushPopRotated.h"
#import "UserInfo.h"
#import "SocketCommunication.h"
#import "ChallengeTypeViewController.h"

#define MaxSections 2
#define NumberOfRows 2

@implementation InviteFriendsViewController

- (id)initWithUserInfo:(UserInfo *)userInfo andFriendArray:(NSArray *)friendArray inviteArray:(NSArray *)inviteArray {
  if ((self = [super init])) {
    self.friendsData = friendArray;
    self.inviteArray = inviteArray;
    self.userInfo = userInfo;
    self.totalArray = [[NSMutableArray alloc] init];
        
    //add all the arrays together for better organizing;
    for (int i = 0 ;i <friendArray.count;i++) {
      NSDictionary<FBGraphUser> *friend = [friendArray objectAtIndex:i];
      [self.totalArray addObject:friend];
    }
    for (int i = 0; i <inviteArray.count;i++) {
      NSDictionary<FBGraphUser> *friend = [inviteArray objectAtIndex:i];
      [self.totalArray addObject:friend];
    }
  }
  return self;
}

- (void)viewDidLoad
{
  [super viewDidLoad];
  self.inviteTableView.tableFooterView = [[UIView alloc] init];
  [SDWebImageManager.sharedManager.imageDownloader setValue:@"FriendsArray" forHTTPHeaderField:@"Friends"];
  SDWebImageManager.sharedManager.imageDownloader.queueMode = SDWebImageDownloaderLIFOQueueMode;
}

- (IBAction)back:(id)sender {
  [self.navigationController popViewControllerRotated:YES];
  if ([self.delegate respondsToSelector:@selector(passUserData:)]) {
    [self.delegate passUserData:self.userInfo];
  }
}

- (IBAction)challengeFriend:(UIButton *)sender {
  SocketCommunication *sc = [SocketCommunication sharedSocketCommunication];
  sc.delegate = self;
    
  BasicUserProto *proto = [sc buildSender];
  
  NSTimeInterval time = [self getUsersTimeInSeconds];
  self.startTime = (int64_t)time;
  NSDictionary<FBGraphUser> *chosen = [self.totalArray objectAtIndex:sender.tag];
  for (BasicUserProto *userInfo in self.userInfo.listOfFacebookFriends) {
    if ([userInfo.facebookId isEqualToString:chosen.id]) {
      self.spinnerView.hidden = NO;
      [self.spinner startAnimating];
      self.view.userInteractionEnabled = NO;
      [sc sendStartRoundRequest:proto isRandomPlayer:NO opponent:userInfo.userId gameId:nil roundNumber:1 isPlayerOne:YES startTime:self.startTime*1000 questions:self.userInfo.questions];
      break;
      return;
    }
  }
}

- (NSTimeInterval)getUsersTimeInSeconds {
  NSDate *date = [[NSDate alloc] init];
  NSTimeInterval time = [date timeIntervalSince1970];
  return time;
}

#pragma mark Protocol Buffer Methods

- (void)receivedProtoResponse:(PBGeneratedMessage *)message {
  self.view.userInteractionEnabled = YES;
  self.spinnerView.hidden = YES;
  [self.spinner stopAnimating];
  StartRoundResponseProto *proto = (StartRoundResponseProto *)message;
  if (proto.status == StartRoundResponseProto_StartRoundStatusSuccess) {
    GameViewController *vc = [[GameViewController alloc] initWithUserInfo:self.userInfo gameId:proto.gameId recipient:proto.recipient opponent:nil startTime:self.startTime roundNumber:1];
    [self.navigationController pushViewController:vc rotated:YES];
  }
  else {
    [self failedProtoResponse:proto];
  }
}

- (void)failedProtoResponse:(StartRoundResponseProto *)proto {
  UIAlertView *alert;
  switch ((int)proto.status) {
    case StartRoundResponseProto_StartRoundStatusFailWrongRoundNumber:
      break;
      
    case StartRoundResponseProto_StartRoundStatusFailWrongOpponents:
      break;
      
    case StartRoundResponseProto_StartRoundStatusFailGameEnded:
      break;
      
    case StartRoundResponseProto_StartRoundStatusFailNotEnoughTokens:
      alert = [[UIAlertView alloc] initWithTitle:@"Not enough tokens" message:@"You don't have enough tokens, you can buy some at the home screen" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
      break;
      
    case StartRoundResponseProto_StartRoundStatusFailNotUserTurn:
      break;
      
    case StartRoundResponseProto_StartRoundStatusFailOther:
      break;
      
    case StartRoundResponseProto_StartRoundStatusFailClientTooApartFromServerTime:
      break;
      
    default:
      break;
  }
  [alert show];
}

#pragma mark TableView Delegates Methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  switch (section) {
    case 0:
      return self.friendsData.count;
      break;
      
      case 1:
      return self.inviteArray.count;
      break;
      
    default:
      break;
  }
  return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
  UIView *headerView = [[UIView alloc] init];
  
  
  UILabel *titleLabel = [[UILabel alloc] init];
  if (section == 0) {
    titleLabel.text = [NSString stringWithFormat:@"   ACTIVE PLAYERS"];
  }
  if (section == 1) {
    titleLabel.text = [NSString stringWithFormat:@"   INVITE PLAYERS"];
  }
  titleLabel.textColor = [UIColor whiteColor];
  UIImage *headerImage = [UIImage imageNamed:@"categorybar.png"];
  UIImageView *imageView = [[UIImageView alloc]initWithImage:headerImage];
  imageView.frame = CGRectMake(imageView.frame.origin.x, imageView.frame.origin.y, 320,19);
  
  titleLabel.backgroundColor = [UIColor clearColor];
  titleLabel.frame = CGRectMake(imageView.frame.origin.x, imageView.frame.origin.y+3, 320,19);
  titleLabel.font = [UIFont fontWithName:@"AvenirNextLTPro-Demi" size:titleLabel.font.pointSize-3];
  [headerView addSubview:imageView];
  [headerView addSubview:titleLabel];
  return headerView;
  
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  static NSString *cellIdentifier = @"InviteFriends";
  
  InviteFriendsCell *cell = (InviteFriendsCell*)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
  if (cell == nil)
  {
    [[NSBundle mainBundle] loadNibNamed:@"InviteFriendsCell" owner:self options:nil];
    cell = self.inviteCell;
  }
  
  if (indexPath.section == 0) {
    cell.inviteNowLabel.text = @"Last played";
    cell.inviteNowLabel.textColor = [UIColor lightGrayColor];
  }
  else if (indexPath.section == 1) {
    cell.inviteNowLabel.text = @"Invite now";
    cell.inviteNowLabel.textColor = [UIColor lightGrayColor];
    cell.lastPlayedLabel.hidden = YES;
  }
  
  UIImage *maskImage = [UIImage imageNamed:@"fbblackcircle.png"];
  NSDictionary<FBGraphUser> *friend;
  if (indexPath.section == 0) {
    friend = [self.friendsData objectAtIndex:indexPath.row];
  }
  else {
    friend = [self.inviteArray objectAtIndex:indexPath.row];
    cell.challengeLabel.text = [NSString stringWithFormat:@"Invite Now"];
  }
  cell.nameLabel.text = [NSString stringWithFormat:@"%@",friend.name];
  NSString *url = [NSString stringWithFormat:@"http://graph.facebook.com/%d/picture?type=normal",[friend.id intValue]];
  [cell.profilePic setImageWithURL:[NSURL URLWithString:url]
                 placeholderImage:cell.profilePic.image options:indexPath.row == 0 ? SDWebImageRefreshCached : 0];
  
  [cell.profilePic setImageWithURL:[NSURL URLWithString:url]placeholderImage:cell.profilePic.image options:indexPath.row == 0 ? SDWebImageRefreshCached : 0 completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
    CALayer *mask = [CALayer layer];
    mask.contents = (id)[maskImage CGImage];
    mask.frame = CGRectMake(0, 0, maskImage.size.width, maskImage.size.height);
    cell.profilePic.layer.mask = mask;
    cell.layer.masksToBounds = YES;
    cell.profilePic.contentMode = UIViewContentModeScaleAspectFill;
  }];
  
  if (indexPath.section == 0) {
    cell.tag = indexPath.row;
    cell.challengeButton.tag = indexPath.row;
  }
  else if (indexPath.section == 1) {
    int row = [tableView numberOfRowsInSection:0];
    cell.tag = row + indexPath.row;
    cell.challengeButton.tag = row + indexPath.row;
  }
  return cell;
}

@end
