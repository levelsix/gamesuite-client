//
//  ShopMenu.m
//  Icon-Blitz
//
//  Created by Danny on 4/25/13.
//
//

#import "ShopMenu.h"
#import "ShopItemsCell.h"

#import <StoreKit/StoreKit.h>
#import "TriviaBlitzIAPHelper.h"
#import <QuartzCore/QuartzCore.h>

@implementation ShopMenu

- (void)doAnimation {
  self.userInteractionEnabled = NO;
  goldCoinSaleSlot = 1;
  rubySaleSlot = 5;
  slotCount = 1;
  animationCounter = 1;
  [self.shopTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
  [self.shopTableView reloadData];
  [NSTimer scheduledTimerWithTimeInterval:0.2f target:self selector:@selector(animateCells:) userInfo:nil repeats:YES];
}

//- (void)slidingInAnimation:(NSTimer *)timer {
//  UITableViewCell *cell = (UITableViewCell *)[self.shopTableView viewWithTag:animationCounter];
//  animationCounter++;
//  CGPoint originalCenter = cell.center;
//  
//  if (animationCounter % 2 != 0) {
//    cell.hidden = NO;
//    cell.center = CGPointMake(-originalCenter.x, originalCenter.y);
//    [UIView animateWithDuration:0.3 animations:^{
//      cell.center = originalCenter;
//    }];
//  }
//  else {
//    cell.hidden = NO;
//    cell.center = CGPointMake(originalCenter.x*2, originalCenter.y);
//    [UIView animateWithDuration:0.3 animations:^{
//      cell.center = originalCenter;
//    }];
//  }
//  if (animationCounter == 6) {
//    self.superview.userInteractionEnabled = YES;
//    self.userInteractionEnabled = YES;
//    loaded = YES;
//    [timer invalidate];
//  }
//}

- (void)animateCells:(NSTimer *)timer {
  UITableViewCell *cell = (UITableViewCell *)[self.shopTableView viewWithTag:animationCounter];
  animationCounter++;
  
  [UIView animateWithDuration:0.2f animations:^{
    cell.hidden = NO;
    cell.alpha = 1.0f;
  }];
  [self bounceView:cell withCompletionBlock:nil];
  
  if (animationCounter == 6) {
    self.superview.userInteractionEnabled = YES;
    self.userInteractionEnabled = YES;
    loaded = YES;
    [timer invalidate];
  }
}

#pragma mark TableView Delegates Methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  return (goldCoinSaleSlot + rubySaleSlot) * 2 ;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  if (indexPath.row % 2 != 0) {
    return 5;
  }
  return 74;
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
  
  bounceAnimation.duration = 0.7f;
  [view.layer addAnimation:bounceAnimation forKey:@"bounce"];
  
  view.layer.transform = CATransform3DIdentity;
  if (completionBlock) {
    [UIView animateWithDuration:0 delay:0.0 options:UIViewAnimationOptionTransitionNone animations:nil completion:completionBlock];
  }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  static NSString *goldCoinCellId = @"GoldCoin";
  static NSString *rubyCellId = @"Ruby";
  static NSString *blankCell = @"Cell";
  if (indexPath.row == 0) {
    GoldCoinCell *cell = [tableView dequeueReusableCellWithIdentifier:goldCoinCellId];
    if (cell == nil) {
      [[NSBundle mainBundle] loadNibNamed:@"ShopItemsCell" owner:self options:nil];
      cell = self.goldCoinCell;
    }
    UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 80, 320, 80)];
    [cell.contentView addSubview:imgView];
    if (!loaded) {
      cell.alpha = 0.0f;
      cell.hidden = YES;
      cell.tag = slotCount;
      slotCount++;
    }
    return cell;
  }
  else if(indexPath.row % 2 == 1) {
      BlankCell*cell = [tableView dequeueReusableCellWithIdentifier:blankCell];
    if (cell == nil) {
      cell = self.blankCell;
    }
    return cell;
  }
  
  else {
    RubyCell *cell = [tableView dequeueReusableCellWithIdentifier:rubyCellId];
    if (cell == nil) {
      [[NSBundle mainBundle] loadNibNamed:@"ShopItemsCell" owner:self options:nil];
      cell = self.rubyCell;
    }
    UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 80, 320, 80)];
    [cell.contentView addSubview:imgView];
    if (!loaded) {
      cell.alpha = 0.0f;
      cell.hidden = YES;
      cell.tag = slotCount;
      slotCount++;
    }
    return cell;
  }
  return nil;
}


@end
