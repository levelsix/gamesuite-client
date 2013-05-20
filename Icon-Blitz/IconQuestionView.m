//
//  IconQuestionView.m
//  Icon-Blitz
//
//  Created by Danny on 4/30/13.
//
//

#import "IconQuestionView.h"

@implementation IconQuestionView

- (id)initWithImageName:(NSString *)imageName {
  if ((self = [super init])) {
    UIImage *icon = [UIImage imageNamed:imageName];
    self.iconImage.image = icon;
  }
  return self;
}



@end
