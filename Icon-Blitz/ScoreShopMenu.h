//
//  ScoreShopMenu.h
//  Icon-Blitz
//
//  Created by Danny on 7/3/13.
//
//

#import <UIKit/UIKit.h>

@class ShopGoldCoinCell;
@class ShopRubyCell;
@class ShopBlankCell;
@class ScoreViewController;

@interface ScoreShopMenu : UIView <UITableViewDataSource, UITableViewDelegate>  {
  int productCount;
  int slotCount;
  int animationCounter;
  BOOL loaded;
}

@property (nonatomic, strong) IBOutlet ShopGoldCoinCell *goldCoinCell;
@property (nonatomic, strong) IBOutlet ShopRubyCell *rubyCell;
@property (nonatomic, strong) IBOutlet ShopBlankCell *blankCell;
@property (nonatomic, strong) IBOutlet UITableView *shopTableView;
@property (nonatomic, strong) ScoreViewController *scoreView;
@property (nonatomic, strong) UIActivityIndicatorView *spinner;

- (void)doAnimation;
- (IBAction)buyProduct:(UIButton *)sender;
- (IBAction)closeView:(id)sender;
- (void)getDataWithScore:(ScoreViewController *)scoreView;
@end
