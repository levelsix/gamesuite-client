//
//  IconQuestionView.h
//  Icon-Blitz
//
//  Created by Danny on 4/30/13.
//
//

#import <UIKit/UIKit.h>

@interface IconQuestionView : UIView

@property (nonatomic, strong) IBOutlet UIImageView *iconBackground;
@property (nonatomic, strong) IBOutlet UIImageView *iconImage;

- (id)initWithImageName:(NSString *)imageName;

@end
