//
//  ShopMenu.h
//  Icon-Blitz
//
//  Created by Danny on 4/25/13.
//
//

#import <UIKit/UIKit.h>

@class GoldCoinCell;
@class RubyCell;
@class BlankCell;
@class HomeViewController;

@interface ShopMenu : UIView <UITableViewDataSource, UITableViewDelegate> {
  int productCount;
  int slotCount;
  int animationCounter;
  BOOL loaded;
}

@property (nonatomic, strong) IBOutlet GoldCoinCell *goldCoinCell;
@property (nonatomic, strong) IBOutlet RubyCell *rubyCell;
@property (nonatomic, strong) IBOutlet BlankCell *blankCell;
@property (nonatomic, strong) IBOutlet UITableView *shopTableView;
@property (nonatomic, strong) HomeViewController *game;
@property (nonatomic, strong) UIActivityIndicatorView *spinner;

- (void)doAnimation;
- (void)getDataWithGame:(HomeViewController *)game;
- (IBAction)buyProduct:(UIButton *)sender;
@end
