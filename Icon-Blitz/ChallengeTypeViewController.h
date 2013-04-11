//
//  ChallengeTypeViewController.h
//  Icon-Blitz
//
//  Created by Danny on 4/8/13.
//
//

#import <UIKit/UIKit.h>

@interface ChallengeTypeViewController : UIViewController {

}

@property (nonatomic, retain) NSMutableArray *facebookData;
@property (nonatomic, assign) BOOL loaded;

- (IBAction)facebookClicked:(UIButton *)sender;
- (IBAction)twitterClicked:(UIButton *)sender;
- (IBAction)userNameClicked:(UIButton *)sender;
- (IBAction)randomClicked:(UIButton *)sender;
- (IBAction)back:(UIButton *)sender;

@end
