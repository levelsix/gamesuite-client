//
//  HomeCell.m
//  Icon-Blitz
//
//  Created by Danny on 4/8/13.
//
//

#import "HomeCell.h"

@implementation StartGameCell

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

@end


@implementation TurnCells

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
  self.nameLabel = nil;
  self.turnLabel = nil;
  self.timeLabel = nil;
  self.playerPic = nil;
  
  [self.nameLabel release];
  [self.turnLabel release];
  [self.timeLabel release];
  [self.playerPic  release];
  
  [super dealloc];
}

@end