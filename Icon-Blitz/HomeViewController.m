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

@interface HomeViewController ()

@end

@implementation HomeViewController

- (void)viewDidLoad
{
  [super viewDidLoad];
}

- (void)dealloc {
  [self.tableView release];
  [super dealloc];
}

#pragma mark UITableView Delegate Methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  return 3;
}


- (void)refrestData {
  dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
    
    dispatch_async(dispatch_get_main_queue(), ^{
      [self.tableView reloadData];
    });
  });
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  switch (section) {
    case kNewGame:
      return 1;
      break;
      
    case kYourTurn:
      return 2;
      break;
      
    case kTheirTurn:
      return 2;
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
    return 57;
  }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
  UIView *headerView = [[UIView alloc] init];
  
  UILabel *titleLabel = [[UILabel alloc] init];
  
  if (section == kNewGame){
    [headerView release];
    [titleLabel release];
    return nil;
  }
  else if (section == kYourTurn) {
    titleLabel.text = [NSString stringWithFormat:@"YOUR TURN"];
  }
  else if (section == kTheirTurn) {
    titleLabel.text = [NSString stringWithFormat:@"THEIR TURN"];
  }

  UIImage *headerImage = [UIImage imageNamed:@"toppiece.png"];
  UIImageView *imageView = [[UIImageView alloc] initWithImage:headerImage];
  imageView.frame = CGRectMake(10, 0,headerImage.size.width + 15, headerImage.size.height);
  imageView.contentMode = UIViewContentModeScaleAspectFill;
  [headerView addSubview:imageView];
  
  titleLabel.textColor = [UIColor lightGrayColor];
  titleLabel.backgroundColor = [UIColor clearColor];
  titleLabel.frame = CGRectMake(10, 5, imageView.frame.size.width, imageView.frame.size.height);
  titleLabel.font = [UIFont fontWithName:@"AvenirNextLTPro-Bold" size:22];
  [headerView addSubview:titleLabel];
  titleLabel.textAlignment = UITextAlignmentCenter;
  return [headerView autorelease];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  static NSString *cellIdentifier = @"";
  if (indexPath.section == kNewGame) {
    cellIdentifier = @"NewGame";
  }
  else if (indexPath.section == kYourTurn || indexPath.section == kTheirTurn) {
    cellIdentifier = @"TurnCells";
  }
  
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
  
  if (cell == nil) {
    [[NSBundle mainBundle] loadNibNamed:@"HomeCell" owner:self options:nil];
    if (indexPath.section == kNewGame) cell = self.startCell;
    else if (indexPath.section == kYourTurn || indexPath.section == kTheirTurn) cell = self.turnCell;
  }
  NSInteger lastCellIndex = [tableView numberOfRowsInSection:indexPath.section]  -1;
  
  if (indexPath.row == lastCellIndex) {
    UIImage *bg = [UIImage imageNamed:@"bottompiece.png"];
    if ([cell isKindOfClass:[TurnCells class]]) {
      self.turnCell.backgroundImage.image = bg;
      cell = self.turnCell;
    }
  }
  return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  if (indexPath.section == kNewGame) {
    ChallengeTypeViewController *vc = [[ChallengeTypeViewController alloc] initWithNibName:@"ChallengeTypeViewController" bundle:nil];
    [self.navigationController pushViewController:vc animated:YES];
    [vc release];
  }
}

@end
