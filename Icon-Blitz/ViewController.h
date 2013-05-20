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

@property (nonatomic, strong) IBOutlet UIButton *authButton;
@property (nonatomic, strong) IBOutlet UIButton *queryButton;
@property (nonatomic, strong) IBOutlet UIButton *multiQueryButton;
@property (nonatomic, strong) IBOutlet PublishDataView *publishView;
@property (nonatomic, strong) NSArray *facebookFriendsArray;

- (IBAction)facebookLogin:(id)sender;
- (IBAction)publish:(id)sender;
- (IBAction)multiQueryButtonACtion:(id)sender;
- (IBAction)queryButtonAction:(id)sender;

@end
