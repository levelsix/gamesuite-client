//
//  ShopMenuViewController.h
//  Icon-Blitz
//
//  Created by Danny on 4/8/13.
//
//

#import <UIKit/UIKit.h>

@class ShopItemsCell;

@interface ShopMenuViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, retain) ShopItemsCell *shopCell;
@property (nonatomic, retain) UITableViewCell *shopTableView;

- (IBAction)closeView:(id)sender;

@end
