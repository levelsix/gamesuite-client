//
//  ScoreShopItemsCell.h
//  Icon-Blitz
//
//  Created by Danny on 7/3/13.
//
//

#import <UIKit/UIKit.h>
@interface ShopGoldCoinCell : UITableViewCell

@property (nonatomic, strong) IBOutlet UILabel *itemTitle;
@property (nonatomic, strong) IBOutlet UILabel *itemAmount;
@property (nonatomic, strong) IBOutlet UILabel *itemCost;
@property (nonatomic, strong) IBOutlet UIButton *buyButton;
@end

@interface ShopRubyCell : UITableViewCell

@property (nonatomic, strong) IBOutlet UILabel *itemTitle;
@property (nonatomic, strong) IBOutlet UILabel *itemAmount;
@property (nonatomic, strong) IBOutlet UILabel *itemCost;
@property (nonatomic, strong) IBOutlet UIButton *buyButton;
@end

@interface ShopBlankCell : UITableViewCell

@end