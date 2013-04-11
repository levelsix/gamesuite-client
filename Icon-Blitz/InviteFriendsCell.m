//
//  InviteFriendsCell.m
//  Icon-Blitz
//
//  Created by Danny on 4/4/13.
//
//

#import "InviteFriendsCell.h"

@implementation InviteFriendsCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)dealloc {
  self.profilePic = nil;
  self.nameLabel = nil;
  self.lastPlayedLabel = nil;
  
  [self.profilePic release];
  [self.nameLabel release];
  [self.lastPlayedLabel release];
  [self.inviteNowLabel release];
  [super dealloc];
}

@end
