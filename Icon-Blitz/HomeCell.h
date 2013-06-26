//
//  HomeCell.h
//  Icon-Blitz
//
//  Created by Danny on 4/8/13.
//
//

#import <UIKit/UIKit.h>

@interface StartGameCell : UITableViewCell

@property (nonatomic, strong) IBOutlet UIButton *startButton;

@end

@interface TurnCells : UITableViewCell

@property (nonatomic, strong) IBOutlet UILabel *nameLabel;
@property (nonatomic, strong) IBOutlet UILabel *turnLabel;
@property (nonatomic, strong) IBOutlet UILabel *timeLabel;
@property (nonatomic, strong) IBOutlet UIImageView *playerPic;
@property (nonatomic, strong) IBOutlet UIButton *gameButton;

@end

@interface LastCell : UITableViewCell

@property (nonatomic, strong) IBOutlet UILabel *nameLabel;
@property (nonatomic, strong) IBOutlet UILabel *turnLabel;
@property (nonatomic, strong) IBOutlet UILabel *timeLabel;
@property (nonatomic, strong) IBOutlet UILabel *noGameLabel;
@property (nonatomic, strong) IBOutlet UILabel *longerLabel;
@property (nonatomic, strong) IBOutlet UIImageView *arrow;
@property (nonatomic, strong) IBOutlet UIImageView *playerPic;
@property (nonatomic, strong) IBOutlet UIButton *gameButton;

@end
