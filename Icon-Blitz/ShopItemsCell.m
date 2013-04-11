//
//  ShopItemsCell.m
//  Icon-Blitz
//
//  Created by Danny on 4/8/13.
//
//

#import "ShopItemsCell.h"

@implementation ShopItemsCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)dealloc {
  self.itemTitle = nil;
  self.itemAmount = nil;
  self.itemImage = nil;
  self.itemCost = nil;
  self.backGroundImage = nil;
  
  [self.itemTitle release];
  [self.itemAmount release];
  [self.itemImage release];
  [self.itemCost  release];
  [self.backGroundImage release];
  
  [super dealloc];
}

@end
