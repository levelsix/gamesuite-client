//
//  TextFieldIndentation.m
//  Icon-Blitz
//
//  Created by Danny on 5/6/13.
//
//

#import "TextFieldIndentation.h"

@implementation TextFieldIndentation

- (CGRect) textRectForBounds:(CGRect)bounds {
  return CGRectMake(bounds.origin.x + self.horizontalPadding, bounds.origin.y + self.verticalPadding, bounds.size.width - self.horizontalPadding*2, bounds.size.height - self.verticalPadding*2);
}

- (CGRect)editingRectForBounds:(CGRect)bounds {
  return [self textRectForBounds:bounds];
}

@end
