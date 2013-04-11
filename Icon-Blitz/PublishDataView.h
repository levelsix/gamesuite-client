//
//  FacebookConfig.h
//  Icon-Blitz
//
//  Created by Danny on 3/13/13.
//
//

#import <Foundation/Foundation.h>
#import <FacebookSDK/FacebookSDK.h>

@interface PublishDataView : UIView <UITextViewDelegate, NSURLConnectionDelegate>

@property (nonatomic, assign) IBOutlet UILabel *postNameLabel;
@property (nonatomic, assign) IBOutlet UILabel *postCaptionLabel;
@property (nonatomic, assign) IBOutlet UILabel *postDescriptionLabel;
@property (nonatomic, retain) IBOutlet UIImageView *postImageView;
@property (nonatomic, retain) IBOutlet UITextView *postMessageTextView;
@property (nonatomic, retain) NSMutableDictionary *postParams;
@property (strong, nonatomic) NSMutableData *imageData;
@property (strong, nonatomic) NSURLConnection *imageConnection;

- (id)init;

- (IBAction)cancelButtonAction:(id)sender;
- (IBAction)shareButtonAction:(id)sender;

@end