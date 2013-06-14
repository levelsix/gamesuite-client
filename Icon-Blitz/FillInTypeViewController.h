//
//  FillInTypeViewController.h
//  Icon-Blitz
//
//  Created by Danny on 5/10/13.
//
//

#import <UIKit/UIKit.h>

@class GameViewController;

@interface FillInTypeViewController : UIViewController

@property (nonatomic, strong) GameViewController *game;
@property (nonatomic, strong) IBOutlet UILabel *questionLabel;
@property (nonatomic, strong) IBOutlet UIView *iconView;
@property (nonatomic, strong) IBOutlet UIImageView *iconImageView;
@property (nonatomic, strong) IBOutlet UIImageView *iconImage;
@property (nonatomic, strong) IBOutlet UIView *questionContainerView;

- (id)initWithGame:(GameViewController *)game;
- (void)removeOptions;
- (void)resetTutorialLetters;
- (id)initWithTutorial:(GameViewController *)game question:(NSDictionary *)question;
- (id)initWithTutorialIconQuestion:(GameViewController *)game questionData:(NSDictionary *)question iconQuestion:(BOOL)isItIconQuestion;
- (void)disableUserInteractionWithTag:(int)tag;

@end
