//
//  FriendsViewController.m
//  Icon-Blitz
//
//  Created by Danny on 3/14/13.
//
//

#import "FriendsViewController.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import  <FacebookSDK/FacebookSDK.h>

@interface FriendsViewController ()

@end

@implementation FriendsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil andData:(NSArray *)data {
  self = [super initWithNibName:nil bundle:nil];
  if (self) {
    self.friendsData = data ;
  }
  [SDWebImageManager.sharedManager.imageDownloader setValue:@"FriendsArray" forHTTPHeaderField:@"Friends"];
  SDWebImageManager.sharedManager.imageDownloader.queueMode = SDWebImageDownloaderLIFOQueueMode;
  return self;
}

- (void)flushCache {
  [SDWebImageManager.sharedManager.imageCache clearMemory];
  [SDWebImageManager.sharedManager.imageCache clearDisk];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
  return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
  return self.friendsData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  static NSString *CellIdentifier = @"Cell";
  
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
  if (cell == nil)
  {
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
  }
  
  NSDictionary<FBGraphUser> *friend = [self.friendsData objectAtIndex:indexPath.row];
  cell.textLabel.text = [NSString stringWithFormat:@"%@",friend.name];
  cell.imageView.contentMode = UIViewContentModeScaleAspectFill;
  NSString *url = [NSString stringWithFormat:@"http://graph.facebook.com/%d/picture?type=normal",[friend.id intValue]];
  [cell.imageView setImageWithURL:[NSURL URLWithString:url]
                 placeholderImage:[UIImage imageNamed:@"placeholder.png"] options:indexPath.row == 0 ? SDWebImageRefreshCached : 0];
  cell.clipsToBounds = YES;
  
  return cell;
}

@end
