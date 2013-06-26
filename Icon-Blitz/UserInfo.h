//
//  GameState.h
//  Icon-Blitz
//
//  Created by Danny on 4/16/13.
//
//

#import <Foundation/Foundation.h>
#import "ProtoHeaders.h"
#import "StaticProperties.h"

typedef enum {
  kFacebookLogin = 0,
  kEmailLogin,
  kAnonLogin,
  kNoneLogin,
}LoginType;

@interface UserInfo : NSObject

@property (nonatomic, strong) NSString *userId;
@property (nonatomic, strong) NSString *username;
@property (nonatomic, strong) NSString *facebookName;
@property (nonatomic, strong) NSString *udid;
@property (nonatomic, strong) NSString *facebookId;
@property (nonatomic, strong) NSString *password;
@property (nonatomic, strong) NSString *email;
@property (nonatomic, copy) NSArray *questions;
@property (nonatomic, copy) NSArray *listOfFacebookFriends;
@property (nonatomic, assign) LoginType loginType;
@property (nonatomic, assign) int rubies;
@property (nonatomic, assign) int goldCoins;
@property (nonatomic, strong) BasicAuthorizedDeviceProto *loginToken;
@property (nonatomic, assign) int64_t lastLogin;
@property (nonatomic, assign) int32_t signupDate;
@property (nonatomic, assign) int64_t lastTokenRefillTime;

- (id)initWithCompleteUserProto:(CompleteUserProto *)proto;

- (NSString *)getUDID;
- (NSString *)getMacAddress;

@end
