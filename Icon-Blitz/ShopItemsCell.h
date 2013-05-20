//
//  ShopItemsCell.h
//  Icon-Blitz
//
//  Created by Danny on 4/8/13.
//
//

#import <UIKit/UIKit.h>

@interface GoldCoinCell : UITableViewCell

@property (nonatomic, strong) IBOutlet UILabel *itemTitle;
@property (nonatomic, strong) IBOutlet UILabel *itemAmount;
@property (nonatomic, strong) IBOutlet UILabel *itemCost;
@property (nonatomic, strong) IBOutlet UIButton *buyButton;
@end

@interface RubyCell : UITableViewCell

@property (nonatomic, strong) IBOutlet UILabel *itemTitle;
@property (nonatomic, strong) IBOutlet UILabel *itemAmount;
@property (nonatomic, strong) IBOutlet UILabel *itemCost;
@property (nonatomic, strong) IBOutlet UIButton *buyButton;
@end

@interface BlankCell : UITableViewCell

@end