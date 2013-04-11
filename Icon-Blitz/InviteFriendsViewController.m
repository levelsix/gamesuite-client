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

#define MaxSections 2
#define NumberOfRows 2

@interface InviteFriendsViewController ()

@end

@implementation InviteFriendsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil andFriendArray:(NSArray *)friendArray
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
      self.friendsData = friendArray;
      [SDWebImageManager.sharedManager.imageDownloader setValue:@"FriendsArray" forHTTPHeaderField:@"Friends"];
      SDWebImageManager.sharedManager.imageDownloader.queueMode = SDWebImageDownloaderLIFOQueueMode;
    }
    return self;
}

- (void)viewDidLoad
{
  [super viewDidLoad];
  self.inviteTableView.tableFooterView = [[[UIView alloc] init] autorelease];
}

- (void)dealloc {
  self.inviteTableView = nil;
  self.inviteCell = nil;
  self.friendsData = nil;

  [self.inviteTableView release];
  [self.inviteTableView release];
  [self.friendsData release];
  [super dealloc];
}

- (IBAction)back:(id)sender {

  [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)challengeFriend:(UIButton *)sender {
  [self pushViewController];
}

#pragma mark TableView Delegates Methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  return self.friendsData.count/2;
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
  return [headerView autorelease];
  
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
  NSDictionary<FBGraphUser> *friend = [self.friendsData objectAtIndex:indexPath.row];
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

- (void)pushViewController {
  GameViewController *vc = [[GameViewController alloc] initWithNibName:@"GameViewController" bundle:nil];
  [self.navigationController pushViewController:vc animated:YES];
  [vc release];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  //UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
  [self pushViewController];
}

@end
