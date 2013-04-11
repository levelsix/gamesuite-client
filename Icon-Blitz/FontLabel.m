//
//  FontLabel.m
//  Icon-Blitz
//
//  Created by Danny on 3/20/13.
//
//

#import "FontLabel.h"

#define FONT_LABEL_OFFSET 3.f

static NSString *fontName = @"AJensonPro-BoldCapt";

static int fontSize = 12;

@implementation GlobalMethods

+ (void)adjustFontSizeForSize:(int)size withUIView:(UIView *)somethingWithText {
  if ([somethingWithText respondsToSelector:@selector(setFont:)]) {
    UIFont *f = [UIFont fontWithName:[self font] size:size];
    [somethingWithText performSelector:@selector(setFont:) withObject:f];
    
    // Move frame down to account for this font
    CGRect tmp = somethingWithText.frame;
    tmp.origin.y += FONT_LABEL_OFFSET * size / [self fontSize];
    somethingWithText.frame = tmp;    
  }
}

+ (void) adjustFontSizeForUILabel:(UILabel *)label {
  
  [self adjustFontSizeForSize:label.font.pointSize withUIView:label];
}

+ (NSString *) font {
  return fontName;
}

+ (int) fontSize {
  return fontSize;
}

@end

@implementation FontLabel

- (void)awakeFromNib {
  [super awakeFromNib];
  [GlobalMethods adjustFontSizeForUILabel:self];
  self.font = [UIFont fontWithName:@"Avenir Next Lt Pro" size:self.font.pointSize];
}

@end

@implementation FontLabel2

- (void)awakeFromNib {
  [super awakeFromNib];
  [GlobalMethods adjustFontSizeForUILabel:self];
  self.font = [UIFont fontWithName:@"AvenirNextLTPro-Demi" size:self.font.pointSize];
}

@end