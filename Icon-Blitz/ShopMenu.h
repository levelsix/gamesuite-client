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

@interface ShopMenu : UIView <UITableViewDataSource, UITableViewDelegate> {
  int goldCoinSaleSlot;
  int rubySaleSlot;
  int slotCount;
  int animationCounter;
  BOOL loaded;
}

@property (nonatomic, strong) IBOutlet GoldCoinCell *goldCoinCell;
@property (nonatomic, strong) IBOutlet RubyCell *rubyCell;
@property (nonatomic, strong) IBOutlet BlankCell *blankCell;
@property (nonatomic, strong) IBOutlet UITableView *shopTableView;

- (void)doAnimation;
@end
