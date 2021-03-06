//
//  FillInViewController.h
//  Icon-Blitz
//
//  Created by Danny on 6/26/13.
//
//

#import <UIKit/UIKit.h>

@class GameViewController;

@interface FillInViewController : UIViewController

@property (nonatomic, strong) GameViewController *game;
@property (nonatomic, strong) IBOutlet UILabel *questionLabel;
@property (nonatomic, strong) IBOutlet UIView *iconView;
@property (nonatomic, strong) IBOutlet UIImageView *iconImageView;
@property (nonatomic, strong) IBOutlet UIImageView *iconImage;
@property (nonatomic, strong) IBOutlet UIView *questionContainerView;
@property (nonatomic, strong) IBOutlet UILabel *triviaType;
@property (nonatomic, strong) IBOutlet UIView *triviaContainer;

- (id)initWithGame:(GameViewController *)game;
- (void)removeOptions;
@end
