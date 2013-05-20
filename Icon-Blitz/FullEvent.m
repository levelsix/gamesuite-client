//
//  FullEvent.m
//  Icon-Blitz
//
//  Created by Danny on 4/12/13.
//
//

#import "FullEvent.h"

@implementation FullEvent

+ (id)createWithEvent:(PBGeneratedMessage *)e tag:(int)t {
  return [[self alloc] initWithEvent:e tag:t];
}

- (id)initWithEvent:(PBGeneratedMessage *)e tag:(int)t {
  if ((self = [super init])) {
    self.event = e;
    self.tag = t;
  }
  return self;
}


@end
