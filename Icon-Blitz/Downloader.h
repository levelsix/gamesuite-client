//
//  Downloader.h
//  Icon-Blitz
//
//  Created by Danny on 3/19/13.
//
//

#import <Foundation/Foundation.h>

@interface Downloader : NSObject {
  dispatch_queue_t _syncQueue;
  dispatch_queue_t _asyncQueue;
  NSString *_cacheDir;
}

+ (Downloader *)sharedDownloader;

- (void) syncDownloadFile:(NSString *)fileName;
- (void) asyncDownloadFile:(NSString *)imageName completion:(void (^)(void))completed;

@end
