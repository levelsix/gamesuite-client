//
//  Downloader.m
//  Icon-Blitz
//
//  Created by Danny on 3/19/13.
//
//

#import "Downloader.h"

#define URL_BASE @"https://s3.amazonaws.com/lvl6pictures/Resources/";

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
    _cacheDir = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0] copy];
    NSLog(@"%@",_cacheDir);
  }
  return self;
}

- (NSString *)downloadFile:(NSString *)imageName {
  NSString *urlBase = URL_BASE;
  NSURL *url = [[NSURL alloc] initWithString:[urlBase stringByAppendingString:imageName]];
  NSString *filePath = [[NSString alloc] initWithFormat:@"%@/%@",_cacheDir, [[url pathComponents] lastObject]];
  BOOL success = YES;
  
  if (![[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
    NSData *data = [[NSData alloc] initWithContentsOfURL:url];
    if (data) {
      success = [data writeToFile:filePath atomically:YES];
    }
  }
  
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
  [[NSRunLoop mainRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:0.01f]];
  dispatch_sync(_syncQueue, ^{
    [self downloadFile:fileName];
  });
}


- (void) dealloc {
  dispatch_release(_syncQueue);
  dispatch_release(_asyncQueue);
}


@end
