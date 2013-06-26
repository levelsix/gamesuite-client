//
//  main.m
//  Icon-Blitz
//
//  Created by Danny on 3/12/13.
//
//

#import <UIKit/UIKit.h>

#import "AppDelegate.h"

int main(int argc, char *argv[]) {
  @autoreleasepool {
    int retVal = -1;
    @try {
      retVal = UIApplicationMain(argc, argv, nil, nil);
    }
    @catch (NSException* exception) {
      NSLog(@"Uncaught exception: %@", exception.description);
      NSLog(@"Stack trace: %@", [exception callStackSymbols]);
    }
    return retVal;
  }
}
