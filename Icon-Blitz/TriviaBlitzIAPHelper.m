//
//  TriviaBlitzIAPHelper.m
//  Icon-Blitz
//
//  Created by Danny on 5/14/13.
//
//

#import "TriviaBlitzIAPHelper.h"

@implementation TriviaBlitzIAPHelper

+ (TriviaBlitzIAPHelper *)sharedInstance {
  static dispatch_once_t once;
  static TriviaBlitzIAPHelper * sharedInstance;
  dispatch_once(&once, ^{
    NSSet * productIdentifiers = [NSSet setWithObjects:
                                  @"Trivia_Gold_Product_1",
                                  @"Trivia_Gold_Product_2",
                                  @"Trivia_Gold_Product_3",
                                  @"Trivia_Gold_Product_4",
                                  @"Trivia_Silver_Product_1",
                                  nil];
    sharedInstance = [[self alloc] initWithProductIdentifiers:productIdentifiers];
  });
  return sharedInstance;
}

@end
