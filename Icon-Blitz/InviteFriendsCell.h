//
//  InviteFriendsCell.h
//  Icon-Blitz
//
//  Created by Danny on 4/4/13.
//
//

#import <UIKit/UIKit.h>

@interface InviteFriendsCell : UITableViewCell

@property (nonatomic, retain) IBOutlet UIImageView *profilePic;
@property (nonatomic, retain) IBOutlet UILabel *nameLabel;
@property (nonatomic, retain) IBOutlet UILabel *lastPlayedLabel;
@property (nonatomic, retain) IBOutlet UILabel *inviteNowLabel;
@property (nonatomic, retain) IBOutlet UIButton *challengeButton;
@end
