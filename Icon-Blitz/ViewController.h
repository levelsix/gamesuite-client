//
//  ViewController.h
//  Icon-Blitz
//
//  Created by Danny on 3/12/13.
//
//

#import <UIKit/UIKit.h>
#import <FacebookSDK/FacebookSDK.h>

@class PublishDataView;

@interface ViewController : UIViewController

@property (nonatomic, retain) IBOutlet UIButton *authButton;
@property (nonatomic, retain) IBOutlet UIButton *queryButton;
@property (nonatomic, retain) IBOutlet UIButton *multiQueryButton;
@property (nonatomic, retain) IBOutlet PublishDataView *publishView;
@property (nonatomic, retain) NSArray *facebookFriendsArray;

- (IBAction)facebookLogin:(id)sender;
- (IBAction)publish:(id)sender;
- (IBAction)multiQueryButtonACtion:(id)sender;
- (IBAction)queryButtonAction:(id)sender;

@end
