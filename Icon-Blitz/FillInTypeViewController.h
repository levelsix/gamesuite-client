//
//  FillInTypeViewController.h
//  Icon-Blitz
//
//  Created by Danny on 5/10/13.
//
//

#import <UIKit/UIKit.h>

@class GameViewController;

@interface FillInTypeViewController : UIViewController {
  int correctLetterCount;
  int animationCounter;
  int maxUnfilledSlot;
  int numberOfLines;
  int firstLineCount;
  int secondLineCount;
}

@property (nonatomic, strong) GameViewController *game;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil game:(GameViewController *)game;

@end
