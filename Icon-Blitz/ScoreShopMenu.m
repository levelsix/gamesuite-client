//
//  ScoreShopMenu.m
//  Icon-Blitz
//
//  Created by Danny on 7/3/13.
//
//

#import "ScoreShopMenu.h"
#import "ScoreShopItemsCell.h"

#import <StoreKit/StoreKit.h>
#import <QuartzCore/QuartzCore.h>
#import "TriviaBlitzIAPHelper.h"
#import "StaticProperties.h"
#import "ScoreViewController.h"

#define Trivia_Silver_Product_1 0
#define Trivia_Gold_Product_1 1
#define Trivia_Gold_Product_2 2
#define Trivia_Gold_Product_3 3
#define Trivia_Gold_Product_4 4

@interface ScoreShopMenu () {
  NSMutableArray *_products;
}

@end

@implementation ScoreShopMenu

- (void)getDataWithScore:(ScoreViewController *)scoreView {
  self.scoreView = scoreView;
  UIActivityIndicatorView *spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
  [self addSubview:spinner];
  spinner.center = CGPointMake(self.frame.size.width/2, self.frame.size.height/2);
  [spinner startAnimating];
  [[TriviaBlitzIAPHelper sharedInstance] requestProductsWithCompletionHandler:^(BOOL success, NSArray *products) {
    if (success) {
      [spinner stopAnimating];
      _products = [products mutableCopy];
      id object = [_products lastObject];
      [_products removeObjectAtIndex:_products.count-1];
      [_products insertObject:object atIndex:0];
      [self doAnimation];
    }
  }];
}

- (void)doAnimation {
  self.userInteractionEnabled = NO;
  productCount = _products.count;
  slotCount = 1;
  animationCounter = 1;
  [self.shopTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
  [self.shopTableView reloadData];
  [NSTimer scheduledTimerWithTimeInterval:0.2f target:self selector:@selector(animateCells:) userInfo:nil repeats:YES];
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(productPurchased:) name:IAPHelperProductPurchasedNotification object:nil];
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(productCanceled:) name:IAPHelperProductCanceledNotification object:nil];
}

- (void)dealloc {
  [[NSNotificationCenter defaultCenter] removeObserver:self];
  
}

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

- (IBAction)closeView:(id)sender {
  [self removeFromSuperview];
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

- (void)productPurchased:(NSNotification *)notification  {
  NSString * productIdentifier = notification.object;
  int tag = 0;
  for (SKProduct *product in _products) {
    if ([product.productIdentifier isEqualToString:productIdentifier]) {
      [self.spinner stopAnimating];
      [self.spinner removeFromSuperview];
      [self afterPurchaseComplete:tag];
      self.userInteractionEnabled = YES;
      self.superview.userInteractionEnabled = YES;
      break;
    }
    tag++;
  }
}

- (void)afterPurchaseComplete:(int)tag {
  switch (tag) {
    case Trivia_Silver_Product_1:
      [self.scoreView updateGoldCoins:15];
      break;
      
    case Trivia_Gold_Product_1:
      [self.scoreView updateRubies:10];
      break;
      
    case Trivia_Gold_Product_2:
      [self.scoreView updateRubies:25];
      break;

    case Trivia_Gold_Product_3:
      [self.scoreView updateRubies:100];
      break;
      
    case Trivia_Gold_Product_4:
      [self.scoreView updateRubies:500];
      break;
      
    default:
      break;
  }
}

- (void)productCanceled:(NSNotification *)notification {
  [self.spinner stopAnimating];
  [self.spinner removeFromSuperview];
  self.userInteractionEnabled = YES;
  self.superview.userInteractionEnabled = YES;
}

- (IBAction)buyProduct:(UIButton *)sender {
  self.userInteractionEnabled = NO;
  self.superview.userInteractionEnabled = NO;
  SKProduct *product = _products[sender.tag-1];
  self.spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
  self.spinner.center = CGPointMake(self.frame.size.width/2, self.frame.size.height/2);
  [self addSubview:self.spinner];
  [self.spinner startAnimating];
  [[TriviaBlitzIAPHelper sharedInstance] buyProduct:product];
}

#pragma mark TableView Delegates Methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  return productCount * 2 ;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  if (indexPath.row % 2 != 0) {
    return 5;
  }
  return 74;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  static NSString *goldCoinCellId = @"ShopGoldCoin";
  static NSString *rubyCellId = @"ShopRuby";
  static NSString *blankCell = @"ShopCell";
  if (indexPath.row == 0) {
    ShopGoldCoinCell *cell = [tableView dequeueReusableCellWithIdentifier:goldCoinCellId];
    if (cell == nil) {
      [[NSBundle mainBundle] loadNibNamed:@"ScoreShopItemsCell" owner:self options:nil];
      cell = self.goldCoinCell;
    }
    UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 80, 320, 80)];
    [cell.contentView addSubview:imgView];
    if (!loaded) {
      cell.alpha = 0.0f;
      cell.hidden = YES;
      cell.tag = slotCount;
      SKProduct *product = (SKProduct *)_products[slotCount-1];
      cell.itemTitle.text = product.localizedTitle;
      cell.itemCost.text = [NSString stringWithFormat:@"$%@",product.price];
      cell.itemAmount.text = product.localizedDescription;
      cell.buyButton.tag = slotCount;
      slotCount++;
    }
    return cell;
  }
  else if(indexPath.row % 2 == 1) {
    ShopBlankCell*cell = [tableView dequeueReusableCellWithIdentifier:blankCell];
    if (cell == nil) {
      cell = self.blankCell;
    }
    return cell;
  }
  
  else {
    ShopRubyCell *cell = [tableView dequeueReusableCellWithIdentifier:rubyCellId];
    if (cell == nil) {
      [[NSBundle mainBundle] loadNibNamed:@"ScoreShopItemsCell" owner:self options:nil];
      cell = self.rubyCell;
    }
    UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 80, 320, 80)];
    [cell.contentView addSubview:imgView];
    if (!loaded) {
      cell.alpha = 0.0f;
      cell.hidden = YES;
      cell.tag = slotCount;
      SKProduct *product = (SKProduct *)_products[slotCount-1];
      cell.itemTitle.text = product.localizedTitle;
      cell.itemCost.text = [NSString stringWithFormat:@"$%@",product.price];
      cell.itemAmount.text = product.localizedDescription;
      cell.buyButton.tag = slotCount;
      slotCount++;
    }
    return cell;
  }
  return nil;
}


@end
