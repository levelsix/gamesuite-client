//
//  Downloader.m
//  Icon-Blitz
//
//  Created by Danny on 3/19/13.
//
//

#import "Downloader.h"

#define URL_BASE @"https://s3.amazonaws.com/lvl6utopia/Resources/";

@implementation Downloader

+ (Downloader *)sharedDownloader {
  static dispatch_once_t _downloader;
  static Downloader *sharedDownloader = nil;
  
  dispatch_once(&_downloader, ^{
    sharedDownloader = [[super allocWithZone:nil] init];
  });
  
  return sharedDownloader;
}

+ (id)allocWithZone:(NSZone *)zone {
  return [self sharedDownloader];
}

- (id)init {
  if ((self = [super init])) {
    _syncQueue = dispatch_queue_create("Sync Download", NULL);
    _asyncQueue = dispatch_queue_create("Async Downloader", NULL);
    _cacheDir = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0]copy];
    
  }
  return self;
}

- (NSString *)downloadFile:(NSString *)imageName {
  NSString *urlBase = URL_BASE;
  NSURL *url = [[NSURL alloc] initWithString:[urlBase stringByAppendingString:imageName]];
  NSString *filePath = [[NSString alloc] initWithFormat:@"%@/%@",_cacheDir, [[url pathComponents] lastObject]];
  BOOL success = YES;
  
  NSData *data = [[NSData alloc] initWithContentsOfURL:url];
  if (data) {
    success = [data writeToFile:filePath atomically:YES];
  }
  
  return success ? filePath : nil;
}

- (void) asyncDownloadFile:(NSString *)imageName completion:(void (^)(void))completed {
  // Get an image from the URL below
  dispatch_async(_asyncQueue, ^{
    [self downloadFile:imageName];
    dispatch_async(dispatch_get_main_queue(), ^(void) {
      if (completed) {
        completed();
      }
    });
  });
}

- (void)syncDownloadFile:(NSString *)fileName {
  [self beginLoading:fileName];
  [[NSRunLoop mainRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:0.01f]];
  dispatch_sync(_syncQueue, ^{
    [self downloadFile:fileName];
  });
  [self stopLoading];
}


- (void) beginLoading:(NSString *)fileName {
//  NSString *f = fileName;
//  
//  NSArray *removeStrings = [NSArray arrayWithObjects:@".", @"Walk", @"Generic", @"Attack", nil];
//  
//  for (NSString *str in removeStrings) {
//    NSRange range = [fileName rangeOfString:str];
//    if (range.length > 0) {
//      range.length = fileName.length-range.location;
//      f = [fileName stringByReplacingCharactersInRange:range withString:@""];
//    }
//  }
//  
//  f = [f stringByReplacingOccurrencesOfString:@"@2x" withString:@""];
//  
//  NSRegularExpression *regexp = [NSRegularExpression regularExpressionWithPattern:@"([a-z])([A-Z])" options:0 error:NULL];
//  f = [regexp stringByReplacingMatchesInString:f options:0 range:NSMakeRange(0, f.length) withTemplate:@"$1 $2"];
//  
//  f = [f capitalizedString];
//  loadingView.label.text = fileName ? [NSString stringWithFormat:@"Loading\n%@", f] : @"Loading Files";
//  [Globals displayUIView:loadingView];
//  
//  // Put it under char selection view
//  UIView *cv = [loadingView.superview viewWithTag:CHAR_SELECTION_VIEW_TAG];
//  if (cv) {
//    [cv.superview bringSubviewToFront:cv];
//  }
}

- (void)stopLoading {
  
}

- (void) dealloc {
  dispatch_release(_syncQueue);
  dispatch_release(_asyncQueue);
}


@end
