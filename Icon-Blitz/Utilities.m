//
//  Utilities.m
//  Icon-Blitz
//
//  Created by Danny on 4/29/13.
//
//

#import "Utilities.h"

@implementation CancellableTableView

- (BOOL) touchesShouldCancelInContentView:(UIView *)view {
  return YES;
}

@end
