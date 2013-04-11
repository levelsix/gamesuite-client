//
//  ShopItemsCell.h
//  Icon-Blitz
//
//  Created by Danny on 4/8/13.
//
//

#import <UIKit/UIKit.h>

@interface ShopItemsCell : UITableViewCell

@property (nonatomic, retain) IBOutlet UILabel *itemTitle;
@property (nonatomic, retain) IBOutlet UILabel *itemAmount;
@property (nonatomic, retain) IBOutlet UIImageView *itemImage;
@property (nonatomic, retain) IBOutlet UILabel *itemCost;
@property (nonatomic, retain) IBOutlet UIImageView *backGroundImage;

@end
