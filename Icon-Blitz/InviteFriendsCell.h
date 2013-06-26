//
//  InviteFriendsCell.h
//  Icon-Blitz
//
//  Created by Danny on 4/4/13.
//
//

#import <UIKit/UIKit.h>

@interface InviteFriendsCell : UITableViewCell

@property (nonatomic, strong) IBOutlet UIImageView *profilePic;
@property (nonatomic, strong) IBOutlet UILabel *nameLabel;
@property (nonatomic, strong) IBOutlet UILabel *lastPlayedLabel;
@property (nonatomic, strong) IBOutlet UILabel *inviteNowLabel;
@property (nonatomic, strong) IBOutlet UIButton *challengeButton;
@property (nonatomic, strong) IBOutlet UILabel *challengeLabel;
@end
