//
//  FacebookConfig.m
//  Icon-Blitz
//
//  Created by Danny on 3/13/13.
//
//

#import "PublishDataView.h"

@implementation PublishDataView

NSString *const kPlaceholderPostMessage = @"Say something about this...";

@synthesize postMessageTextView, postImageView, postCaptionLabel, postNameLabel, postDescriptionLabel;
@synthesize postParams;

- (void)dealloc {
  if (self.imageConnection) {
    [self.imageConnection cancel];
  }  
}

- (void)connection:(NSURLConnection*)connection
    didReceiveData:(NSData*)data{
  [self.imageData appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection{
  // Load the image
  self.postImageView.image = [UIImage imageWithData:
                              [NSData dataWithData:self.imageData]];
  self.imageConnection = nil;
  self.imageData = nil;
}

- (void)connection:(NSURLConnection *)connection
  didFailWithError:(NSError *)error{
  self.imageConnection = nil;
  self.imageData = nil;
}

- (void)publishStory
{
  [FBRequestConnection
   startWithGraphPath:@"me/feed"
   parameters:self.postParams
   HTTPMethod:@"POST"
   completionHandler:^(FBRequestConnection *connection,
                       id result,
                       NSError *error) {
     NSString *alertText;
     if (error) {
       alertText = [NSString stringWithFormat:
                    @"error: domain = %@, code = %d",
                    error.domain, error.code];
     } else {
       alertText = [NSString stringWithFormat:
                    @"Posted action, id: %@",
                    [result objectForKey:@"id"]];
     }
     // Show the result in an alert
     [[[UIAlertView alloc] initWithTitle:@"Result"
                                 message:alertText
                                delegate:self
                       cancelButtonTitle:@"OK!"
                       otherButtonTitles:nil]
      show];
   }];
  [self removeFromSuperview];
}

- (void)publishWithoutUI {
  [FBRequestConnection startWithGraphPath:@"me/feed" parameters:self.postParams HTTPMethod:@"POST" completionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
    if (!error) {
      NSLog(@"posted");
    }
    else {
      NSLog(@"%@",error);
    }
  }];
}

- (id)initWithPostParams:(NSMutableDictionary *)postParam {
  if ((self = [super init])) {
    self.postParams = postParam;
    [self resetPostMessage];
    self.postNameLabel.text = [self.postParams objectForKey:@"name"];
    self.postCaptionLabel.text = [self.postParams objectForKey:@"caption"];
    [self.postCaptionLabel sizeToFit];
    self.postDescriptionLabel.text = [self.postParams objectForKey:@"description"];
    [self.postDescriptionLabel sizeToFit];
    
    self.imageData = [[NSMutableData alloc] init];
    NSURLRequest *imageRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:[self.postParams objectForKey:@"picture"]]];
    self.imageConnection = [[NSURLConnection alloc] initWithRequest:imageRequest delegate:self];
  }
  return self;
}

- (IBAction)shareButtonAction:(id)sender {
  // Hide keyboard if showing when button clicked
  if ([self.postMessageTextView isFirstResponder]) {
    [self.postMessageTextView resignFirstResponder];
  }
  // Add user message parameter if user filled it in
  if (![self.postMessageTextView.text
        isEqualToString:kPlaceholderPostMessage] &&
      ![self.postMessageTextView.text isEqualToString:@""]) {
    [self.postParams setObject:self.postMessageTextView.text
                        forKey:@"message"];
  }
  
  // Ask for publish_actions permissions in context
  if ([FBSession.activeSession.permissions
       indexOfObject:@"publish_actions"] == NSNotFound) {
    // No permissions found in session, ask for it
    [FBSession.activeSession
     requestNewPublishPermissions:
     [NSArray arrayWithObject:@"publish_actions"]
     defaultAudience:FBSessionDefaultAudienceFriends
     completionHandler:^(FBSession *session, NSError *error) {
       if (!error) {
         // If permissions granted, publish the story
         [self publishStory];
       }
     }];
  } else {
    // If permissions present, publish the story
    [self publishStory];
  }
}

- (void) alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
  NSLog(@"dismissed");
}

- (IBAction)cancelButtonAction:(id)sender {
  [self removeFromSuperview];
}

- (void)resetPostMessage {
  self.postMessageTextView.text = kPlaceholderPostMessage;
  self.postMessageTextView.textColor = [UIColor lightGrayColor];
}

- (void)textViewDidBeginEditing:(UITextView *)textView {
  //clear the message text when the user starts editing
  if ([textView.text isEqualToString:kPlaceholderPostMessage]) {
    textView.text = @"";
    textView.textColor = [UIColor blackColor];
  }
}

- (void)textViewDidEndEditing:(UITextView *)textView {
  //reset to placeholder text if the user is done
  //editing and no message has been entered
  if ([textView.text isEqualToString:@""]) {
    [self resetPostMessage];
  }
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
  UITouch *touch = [[event allTouches] anyObject];
  if ([self.postMessageTextView isFirstResponder] && (self.postMessageTextView != touch.view)) {
    [self.postMessageTextView resignFirstResponder];
  }
}


@end