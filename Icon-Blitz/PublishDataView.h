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

@property (nonatomic, weak) IBOutlet UILabel *postNameLabel;
@property (nonatomic, weak) IBOutlet UILabel *postCaptionLabel;
@property (nonatomic, weak) IBOutlet UILabel *postDescriptionLabel;
@property (nonatomic, strong) IBOutlet UIImageView *postImageView;
@property (nonatomic, strong) IBOutlet UITextView *postMessageTextView;
@property (nonatomic, strong) NSMutableDictionary *postParams;
@property (strong, nonatomic) NSMutableData *imageData;
@property (strong, nonatomic) NSURLConnection *imageConnection;

- (id)initWithPostParams:(NSMutableDictionary *)postParam;
- (void)publishWithoutUI;
- (IBAction)cancelButtonAction:(id)sender;
- (IBAction)shareButtonAction:(id)sender;

@end