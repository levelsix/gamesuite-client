//
//  FullEvent.h
//  Icon-Blitz
//
//  Created by Danny on 4/12/13.
//
//

#import <Foundation/Foundation.h>

@interface FullEvent : NSObject

@property (nonatomic, strong) PBGeneratedMessage *event;
@property (nonatomic, assign) int tag;

+ (id)createWithEvent:(PBGeneratedMessage *)e tag:(int)t;
- (id)initWithEvent:(PBGeneratedMessage *)e tag:(int)t;

@end
