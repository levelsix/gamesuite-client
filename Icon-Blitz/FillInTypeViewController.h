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

- (id)initWithGame:(GameViewController *)game;
- (void)removeOptions;
- (void)resetTutorialLetters;
- (id)initWithTutorial:(GameViewController *)game question:(NSDictionary *)question;

@end
