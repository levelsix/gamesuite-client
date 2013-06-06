//
//  TutorialViewController.h
//  Icon-Blitz
//
//  Created by Danny on 5/30/13.
//
//

#import <UIKit/UIKit.h>
#import "TutorialMultipleChoiceViewController.h"

typedef enum {
  kBeginningMultipleChoiceStage = 1,
  kFillInStage,
  kCheatStage,
  kFreezeStage
}TutorialStages;

@interface TutorialViewController : UIViewController <CallMainTutorialViewDelegate>

@property (nonatomic, strong) IBOutlet UILabel *dialogueLabel;
@property (nonatomic, strong) IBOutlet UIButton *chatButton;
@property (nonatomic, strong) IBOutlet UIView *chatView;

@property (nonatomic, strong) TutorialMultipleChoiceViewController *gameView;
@property (nonatomic, strong) IBOutlet UIImageView *glowOverlay;
@property (nonatomic, strong) IBOutlet UIView *overlayView;
@property (nonatomic, assign) TutorialStages currentStage;

- (IBAction)chatClicked:(id)sender;

@end
