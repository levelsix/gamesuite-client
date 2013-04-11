//
//  FillInViewController.h
//  Icon-Blitz
//
//  Created by Danny on 4/3/13.
//
//

#import <UIKit/UIKit.h>
#import "FontLabel.h"
#import "FontLabel.h"

@class GameViewController;

@interface FillInViewController : UIViewController

@property (nonatomic, assign) int correctAmtOfLetters;
@property (nonatomic, assign) int maxCounter;
@property (nonatomic, retain) IBOutlet UILabel *questionLabel;
@property (nonatomic, retain) NSDictionary *questionDict;
@property (nonatomic, retain) NSArray *answerArray;
@property (nonatomic, retain) GameViewController *game;
@property (nonatomic, retain) NSMutableArray *answerSlots;
@property (nonatomic, retain) NSMutableArray *slotsTaken;
@property (nonatomic, retain) NSMutableArray *letterStorage;

+ (id)gameWithController:(GameViewController *)game;
- (id)initWithGame:(GameViewController *)game;
- (void)createAnswerSlot;
- (void)placeNewData;
- (void)removeOptions;

@end
