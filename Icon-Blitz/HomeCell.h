//
//  HomeCell.h
//  Icon-Blitz
//
//  Created by Danny on 4/8/13.
//
//

#import <UIKit/UIKit.h>

@interface StartGameCell : UITableViewCell

@end

@interface TurnCells : UITableViewCell

@property (nonatomic, retain) IBOutlet UILabel *nameLabel;
@property (nonatomic, retain) IBOutlet UILabel *turnLabel;
@property (nonatomic, retain) IBOutlet UILabel *timeLabel;
@property (nonatomic, retain) IBOutlet UIImageView *playerPic;
@property (nonatomic, retain) IBOutlet UIImageView *backgroundImage;

@end