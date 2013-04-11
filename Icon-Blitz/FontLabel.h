//
//  FontLabel.h
//  Icon-Blitz
//
//  Created by Danny on 3/20/13.
//
//

#import <UIKit/UIKit.h>

@interface GlobalMethods : NSObject
+ (void) adjustFontSizeForSize:(int)size withUIView:(UIView *)somethingWithText;
+ (void) adjustFontSizeForUILabel:(UILabel *)label;
@end

@interface FontLabel : UILabel

@end

@interface FontLabel2 : UILabel

@end
