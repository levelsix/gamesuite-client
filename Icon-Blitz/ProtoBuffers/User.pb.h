// Generated by the protocol buffer compiler.  DO NOT EDIT!

#import "ProtocolBuffers.h"

@class BasicAuthorizedDeviceProto;
@class BasicAuthorizedDeviceProto_Builder;
@class BasicUserProto;
@class BasicUserProto_Builder;
@class CompleteUserProto;
@class CompleteUserProto_Builder;
@class UserCurrencyProto;
@class UserCurrencyProto_Builder;

@interface UserRoot : NSObject {
}
+ (PBExtensionRegistry*) extensionRegistry;
+ (void) registerAllExtensions:(PBMutableExtensionRegistry*) registry;
@end

@interface BasicUserProto : PBGeneratedMessage {
@private
  BOOL hasUserId_:1;
  BOOL hasNameStrangersSee_:1;
  BOOL hasNameFriendsSee_:1;
  BOOL hasEmail_:1;
  BOOL hasPassword_:1;
  BOOL hasFacebookId_:1;
  BOOL hasBadp_:1;
  NSString* userId;
  NSString* nameStrangersSee;
  NSString* nameFriendsSee;
  NSString* email;
  NSString* password;
  NSString* facebookId;
  BasicAuthorizedDeviceProto* badp;
}
- (BOOL) hasUserId;
- (BOOL) hasNameStrangersSee;
- (BOOL) hasNameFriendsSee;
- (BOOL) hasEmail;
- (BOOL) hasPassword;
- (BOOL) hasFacebookId;
- (BOOL) hasBadp;
@property (readonly, retain) NSString* userId;
@property (readonly, retain) NSString* nameStrangersSee;
@property (readonly, retain) NSString* nameFriendsSee;
@property (readonly, retain) NSString* email;
@property (readonly, retain) NSString* password;
@property (readonly, retain) NSString* facebookId;
@property (readonly, retain) BasicAuthorizedDeviceProto* badp;

+ (BasicUserProto*) defaultInstance;
- (BasicUserProto*) defaultInstance;

- (BOOL) isInitialized;
- (void) writeToCodedOutputStream:(PBCodedOutputStream*) output;
- (BasicUserProto_Builder*) builder;
+ (BasicUserProto_Builder*) builder;
+ (BasicUserProto_Builder*) builderWithPrototype:(BasicUserProto*) prototype;

+ (BasicUserProto*) parseFromData:(NSData*) data;
+ (BasicUserProto*) parseFromData:(NSData*) data extensionRegistry:(PBExtensionRegistry*) extensionRegistry;
+ (BasicUserProto*) parseFromInputStream:(NSInputStream*) input;
+ (BasicUserProto*) parseFromInputStream:(NSInputStream*) input extensionRegistry:(PBExtensionRegistry*) extensionRegistry;
+ (BasicUserProto*) parseFromCodedInputStream:(PBCodedInputStream*) input;
+ (BasicUserProto*) parseFromCodedInputStream:(PBCodedInputStream*) input extensionRegistry:(PBExtensionRegistry*) extensionRegistry;
@end

@interface BasicUserProto_Builder : PBGeneratedMessage_Builder {
@private
  BasicUserProto* result;
}

- (BasicUserProto*) defaultInstance;

- (BasicUserProto_Builder*) clear;
- (BasicUserProto_Builder*) clone;

- (BasicUserProto*) build;
- (BasicUserProto*) buildPartial;

- (BasicUserProto_Builder*) mergeFrom:(BasicUserProto*) other;
- (BasicUserProto_Builder*) mergeFromCodedInputStream:(PBCodedInputStream*) input;
- (BasicUserProto_Builder*) mergeFromCodedInputStream:(PBCodedInputStream*) input extensionRegistry:(PBExtensionRegistry*) extensionRegistry;

- (BOOL) hasUserId;
- (NSString*) userId;
- (BasicUserProto_Builder*) setUserId:(NSString*) value;
- (BasicUserProto_Builder*) clearUserId;

- (BOOL) hasNameStrangersSee;
- (NSString*) nameStrangersSee;
- (BasicUserProto_Builder*) setNameStrangersSee:(NSString*) value;
- (BasicUserProto_Builder*) clearNameStrangersSee;

- (BOOL) hasNameFriendsSee;
- (NSString*) nameFriendsSee;
- (BasicUserProto_Builder*) setNameFriendsSee:(NSString*) value;
- (BasicUserProto_Builder*) clearNameFriendsSee;

- (BOOL) hasEmail;
- (NSString*) email;
- (BasicUserProto_Builder*) setEmail:(NSString*) value;
- (BasicUserProto_Builder*) clearEmail;

- (BOOL) hasPassword;
- (NSString*) password;
- (BasicUserProto_Builder*) setPassword:(NSString*) value;
- (BasicUserProto_Builder*) clearPassword;

- (BOOL) hasFacebookId;
- (NSString*) facebookId;
- (BasicUserProto_Builder*) setFacebookId:(NSString*) value;
- (BasicUserProto_Builder*) clearFacebookId;

- (BOOL) hasBadp;
- (BasicAuthorizedDeviceProto*) badp;
- (BasicUserProto_Builder*) setBadp:(BasicAuthorizedDeviceProto*) value;
- (BasicUserProto_Builder*) setBadpBuilder:(BasicAuthorizedDeviceProto_Builder*) builderForValue;
- (BasicUserProto_Builder*) mergeBadp:(BasicAuthorizedDeviceProto*) value;
- (BasicUserProto_Builder*) clearBadp;
@end

@interface BasicAuthorizedDeviceProto : PBGeneratedMessage {
@private
  BOOL hasExpirationDate_:1;
  BOOL hasBasicAuthorizedDeviceId_:1;
  BOOL hasUserId_:1;
  BOOL hasLoginToken_:1;
  BOOL hasUdid_:1;
  BOOL hasDeviceId_:1;
  int64_t expirationDate;
  NSString* basicAuthorizedDeviceId;
  NSString* userId;
  NSString* loginToken;
  NSString* udid;
  NSString* deviceId;
}
- (BOOL) hasBasicAuthorizedDeviceId;
- (BOOL) hasUserId;
- (BOOL) hasLoginToken;
- (BOOL) hasExpirationDate;
- (BOOL) hasUdid;
- (BOOL) hasDeviceId;
@property (readonly, retain) NSString* basicAuthorizedDeviceId;
@property (readonly, retain) NSString* userId;
@property (readonly, retain) NSString* loginToken;
@property (readonly) int64_t expirationDate;
@property (readonly, retain) NSString* udid;
@property (readonly, retain) NSString* deviceId;

+ (BasicAuthorizedDeviceProto*) defaultInstance;
- (BasicAuthorizedDeviceProto*) defaultInstance;

- (BOOL) isInitialized;
- (void) writeToCodedOutputStream:(PBCodedOutputStream*) output;
- (BasicAuthorizedDeviceProto_Builder*) builder;
+ (BasicAuthorizedDeviceProto_Builder*) builder;
+ (BasicAuthorizedDeviceProto_Builder*) builderWithPrototype:(BasicAuthorizedDeviceProto*) prototype;

+ (BasicAuthorizedDeviceProto*) parseFromData:(NSData*) data;
+ (BasicAuthorizedDeviceProto*) parseFromData:(NSData*) data extensionRegistry:(PBExtensionRegistry*) extensionRegistry;
+ (BasicAuthorizedDeviceProto*) parseFromInputStream:(NSInputStream*) input;
+ (BasicAuthorizedDeviceProto*) parseFromInputStream:(NSInputStream*) input extensionRegistry:(PBExtensionRegistry*) extensionRegistry;
+ (BasicAuthorizedDeviceProto*) parseFromCodedInputStream:(PBCodedInputStream*) input;
+ (BasicAuthorizedDeviceProto*) parseFromCodedInputStream:(PBCodedInputStream*) input extensionRegistry:(PBExtensionRegistry*) extensionRegistry;
@end

@interface BasicAuthorizedDeviceProto_Builder : PBGeneratedMessage_Builder {
@private
  BasicAuthorizedDeviceProto* result;
}

- (BasicAuthorizedDeviceProto*) defaultInstance;

- (BasicAuthorizedDeviceProto_Builder*) clear;
- (BasicAuthorizedDeviceProto_Builder*) clone;

- (BasicAuthorizedDeviceProto*) build;
- (BasicAuthorizedDeviceProto*) buildPartial;

- (BasicAuthorizedDeviceProto_Builder*) mergeFrom:(BasicAuthorizedDeviceProto*) other;
- (BasicAuthorizedDeviceProto_Builder*) mergeFromCodedInputStream:(PBCodedInputStream*) input;
- (BasicAuthorizedDeviceProto_Builder*) mergeFromCodedInputStream:(PBCodedInputStream*) input extensionRegistry:(PBExtensionRegistry*) extensionRegistry;

- (BOOL) hasBasicAuthorizedDeviceId;
- (NSString*) basicAuthorizedDeviceId;
- (BasicAuthorizedDeviceProto_Builder*) setBasicAuthorizedDeviceId:(NSString*) value;
- (BasicAuthorizedDeviceProto_Builder*) clearBasicAuthorizedDeviceId;

- (BOOL) hasUserId;
- (NSString*) userId;
- (BasicAuthorizedDeviceProto_Builder*) setUserId:(NSString*) value;
- (BasicAuthorizedDeviceProto_Builder*) clearUserId;

- (BOOL) hasLoginToken;
- (NSString*) loginToken;
- (BasicAuthorizedDeviceProto_Builder*) setLoginToken:(NSString*) value;
- (BasicAuthorizedDeviceProto_Builder*) clearLoginToken;

- (BOOL) hasExpirationDate;
- (int64_t) expirationDate;
- (BasicAuthorizedDeviceProto_Builder*) setExpirationDate:(int64_t) value;
- (BasicAuthorizedDeviceProto_Builder*) clearExpirationDate;

- (BOOL) hasUdid;
- (NSString*) udid;
- (BasicAuthorizedDeviceProto_Builder*) setUdid:(NSString*) value;
- (BasicAuthorizedDeviceProto_Builder*) clearUdid;

- (BOOL) hasDeviceId;
- (NSString*) deviceId;
- (BasicAuthorizedDeviceProto_Builder*) setDeviceId:(NSString*) value;
- (BasicAuthorizedDeviceProto_Builder*) clearDeviceId;
@end

@interface UserCurrencyProto : PBGeneratedMessage {
@private
  BOOL hasLastTokenRefillTime_:1;
  BOOL hasNumTokens_:1;
  BOOL hasNumRubies_:1;
  int64_t lastTokenRefillTime;
  int32_t numTokens;
  int32_t numRubies;
}
- (BOOL) hasNumTokens;
- (BOOL) hasLastTokenRefillTime;
- (BOOL) hasNumRubies;
@property (readonly) int32_t numTokens;
@property (readonly) int64_t lastTokenRefillTime;
@property (readonly) int32_t numRubies;

+ (UserCurrencyProto*) defaultInstance;
- (UserCurrencyProto*) defaultInstance;

- (BOOL) isInitialized;
- (void) writeToCodedOutputStream:(PBCodedOutputStream*) output;
- (UserCurrencyProto_Builder*) builder;
+ (UserCurrencyProto_Builder*) builder;
+ (UserCurrencyProto_Builder*) builderWithPrototype:(UserCurrencyProto*) prototype;

+ (UserCurrencyProto*) parseFromData:(NSData*) data;
+ (UserCurrencyProto*) parseFromData:(NSData*) data extensionRegistry:(PBExtensionRegistry*) extensionRegistry;
+ (UserCurrencyProto*) parseFromInputStream:(NSInputStream*) input;
+ (UserCurrencyProto*) parseFromInputStream:(NSInputStream*) input extensionRegistry:(PBExtensionRegistry*) extensionRegistry;
+ (UserCurrencyProto*) parseFromCodedInputStream:(PBCodedInputStream*) input;
+ (UserCurrencyProto*) parseFromCodedInputStream:(PBCodedInputStream*) input extensionRegistry:(PBExtensionRegistry*) extensionRegistry;
@end

@interface UserCurrencyProto_Builder : PBGeneratedMessage_Builder {
@private
  UserCurrencyProto* result;
}

- (UserCurrencyProto*) defaultInstance;

- (UserCurrencyProto_Builder*) clear;
- (UserCurrencyProto_Builder*) clone;

- (UserCurrencyProto*) build;
- (UserCurrencyProto*) buildPartial;

- (UserCurrencyProto_Builder*) mergeFrom:(UserCurrencyProto*) other;
- (UserCurrencyProto_Builder*) mergeFromCodedInputStream:(PBCodedInputStream*) input;
- (UserCurrencyProto_Builder*) mergeFromCodedInputStream:(PBCodedInputStream*) input extensionRegistry:(PBExtensionRegistry*) extensionRegistry;

- (BOOL) hasNumTokens;
- (int32_t) numTokens;
- (UserCurrencyProto_Builder*) setNumTokens:(int32_t) value;
- (UserCurrencyProto_Builder*) clearNumTokens;

- (BOOL) hasLastTokenRefillTime;
- (int64_t) lastTokenRefillTime;
- (UserCurrencyProto_Builder*) setLastTokenRefillTime:(int64_t) value;
- (UserCurrencyProto_Builder*) clearLastTokenRefillTime;

- (BOOL) hasNumRubies;
- (int32_t) numRubies;
- (UserCurrencyProto_Builder*) setNumRubies:(int32_t) value;
- (UserCurrencyProto_Builder*) clearNumRubies;
@end

@interface CompleteUserProto : PBGeneratedMessage {
@private
  BOOL hasLastLogin_:1;
  BOOL hasSignupDate_:1;
  BOOL hasUserId_:1;
  BOOL hasNameStrangersSee_:1;
  BOOL hasNameFriendsSee_:1;
  BOOL hasEmail_:1;
  BOOL hasPassword_:1;
  BOOL hasFacebookId_:1;
  BOOL hasBadp_:1;
  BOOL hasCurrency_:1;
  int64_t lastLogin;
  int64_t signupDate;
  NSString* userId;
  NSString* nameStrangersSee;
  NSString* nameFriendsSee;
  NSString* email;
  NSString* password;
  NSString* facebookId;
  BasicAuthorizedDeviceProto* badp;
  UserCurrencyProto* currency;
}
- (BOOL) hasUserId;
- (BOOL) hasNameStrangersSee;
- (BOOL) hasNameFriendsSee;
- (BOOL) hasEmail;
- (BOOL) hasPassword;
- (BOOL) hasFacebookId;
- (BOOL) hasBadp;
- (BOOL) hasLastLogin;
- (BOOL) hasSignupDate;
- (BOOL) hasCurrency;
@property (readonly, retain) NSString* userId;
@property (readonly, retain) NSString* nameStrangersSee;
@property (readonly, retain) NSString* nameFriendsSee;
@property (readonly, retain) NSString* email;
@property (readonly, retain) NSString* password;
@property (readonly, retain) NSString* facebookId;
@property (readonly, retain) BasicAuthorizedDeviceProto* badp;
@property (readonly) int64_t lastLogin;
@property (readonly) int64_t signupDate;
@property (readonly, retain) UserCurrencyProto* currency;

+ (CompleteUserProto*) defaultInstance;
- (CompleteUserProto*) defaultInstance;

- (BOOL) isInitialized;
- (void) writeToCodedOutputStream:(PBCodedOutputStream*) output;
- (CompleteUserProto_Builder*) builder;
+ (CompleteUserProto_Builder*) builder;
+ (CompleteUserProto_Builder*) builderWithPrototype:(CompleteUserProto*) prototype;

+ (CompleteUserProto*) parseFromData:(NSData*) data;
+ (CompleteUserProto*) parseFromData:(NSData*) data extensionRegistry:(PBExtensionRegistry*) extensionRegistry;
+ (CompleteUserProto*) parseFromInputStream:(NSInputStream*) input;
+ (CompleteUserProto*) parseFromInputStream:(NSInputStream*) input extensionRegistry:(PBExtensionRegistry*) extensionRegistry;
+ (CompleteUserProto*) parseFromCodedInputStream:(PBCodedInputStream*) input;
+ (CompleteUserProto*) parseFromCodedInputStream:(PBCodedInputStream*) input extensionRegistry:(PBExtensionRegistry*) extensionRegistry;
@end

@interface CompleteUserProto_Builder : PBGeneratedMessage_Builder {
@private
  CompleteUserProto* result;
}

- (CompleteUserProto*) defaultInstance;

- (CompleteUserProto_Builder*) clear;
- (CompleteUserProto_Builder*) clone;

- (CompleteUserProto*) build;
- (CompleteUserProto*) buildPartial;

- (CompleteUserProto_Builder*) mergeFrom:(CompleteUserProto*) other;
- (CompleteUserProto_Builder*) mergeFromCodedInputStream:(PBCodedInputStream*) input;
- (CompleteUserProto_Builder*) mergeFromCodedInputStream:(PBCodedInputStream*) input extensionRegistry:(PBExtensionRegistry*) extensionRegistry;

- (BOOL) hasUserId;
- (NSString*) userId;
- (CompleteUserProto_Builder*) setUserId:(NSString*) value;
- (CompleteUserProto_Builder*) clearUserId;

- (BOOL) hasNameStrangersSee;
- (NSString*) nameStrangersSee;
- (CompleteUserProto_Builder*) setNameStrangersSee:(NSString*) value;
- (CompleteUserProto_Builder*) clearNameStrangersSee;

- (BOOL) hasNameFriendsSee;
- (NSString*) nameFriendsSee;
- (CompleteUserProto_Builder*) setNameFriendsSee:(NSString*) value;
- (CompleteUserProto_Builder*) clearNameFriendsSee;

- (BOOL) hasEmail;
- (NSString*) email;
- (CompleteUserProto_Builder*) setEmail:(NSString*) value;
- (CompleteUserProto_Builder*) clearEmail;

- (BOOL) hasPassword;
- (NSString*) password;
- (CompleteUserProto_Builder*) setPassword:(NSString*) value;
- (CompleteUserProto_Builder*) clearPassword;

- (BOOL) hasFacebookId;
- (NSString*) facebookId;
- (CompleteUserProto_Builder*) setFacebookId:(NSString*) value;
- (CompleteUserProto_Builder*) clearFacebookId;

- (BOOL) hasBadp;
- (BasicAuthorizedDeviceProto*) badp;
- (CompleteUserProto_Builder*) setBadp:(BasicAuthorizedDeviceProto*) value;
- (CompleteUserProto_Builder*) setBadpBuilder:(BasicAuthorizedDeviceProto_Builder*) builderForValue;
- (CompleteUserProto_Builder*) mergeBadp:(BasicAuthorizedDeviceProto*) value;
- (CompleteUserProto_Builder*) clearBadp;

- (BOOL) hasLastLogin;
- (int64_t) lastLogin;
- (CompleteUserProto_Builder*) setLastLogin:(int64_t) value;
- (CompleteUserProto_Builder*) clearLastLogin;

- (BOOL) hasSignupDate;
- (int64_t) signupDate;
- (CompleteUserProto_Builder*) setSignupDate:(int64_t) value;
- (CompleteUserProto_Builder*) clearSignupDate;

- (BOOL) hasCurrency;
- (UserCurrencyProto*) currency;
- (CompleteUserProto_Builder*) setCurrency:(UserCurrencyProto*) value;
- (CompleteUserProto_Builder*) setCurrencyBuilder:(UserCurrencyProto_Builder*) builderForValue;
- (CompleteUserProto_Builder*) mergeCurrency:(UserCurrencyProto*) value;
- (CompleteUserProto_Builder*) clearCurrency;
@end

