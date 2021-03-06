// Generated by the protocol buffer compiler.  DO NOT EDIT!

#import "ProtocolBuffers.h"

#import "User.pb.h"

@class BasicAuthorizedDeviceProto;
@class BasicAuthorizedDeviceProto_Builder;
@class BasicUserProto;
@class BasicUserProto_Builder;
@class CompleteUserProto;
@class CompleteUserProto_Builder;
@class CreateAccountResponseProto;
@class CreateAccountResponseProto_Builder;
@class CreateAccountViaEmailRequestProto;
@class CreateAccountViaEmailRequestProto_Builder;
@class CreateAccountViaFacebookRequestProto;
@class CreateAccountViaFacebookRequestProto_Builder;
@class CreateAccountViaNoCredentialsRequestProto;
@class CreateAccountViaNoCredentialsRequestProto_Builder;
@class UserCurrencyProto;
@class UserCurrencyProto_Builder;
typedef enum {
  CreateAccountResponseProto_CreateAccountStatusSuccessAccountCreated = 1,
  CreateAccountResponseProto_CreateAccountStatusFailDuplicateFacebookId = 2,
  CreateAccountResponseProto_CreateAccountStatusFailDuplicateUdid = 3,
  CreateAccountResponseProto_CreateAccountStatusFailMissingFacebookId = 4,
  CreateAccountResponseProto_CreateAccountStatusFailInvalidName = 5,
  CreateAccountResponseProto_CreateAccountStatusFailInvalidUdid = 6,
  CreateAccountResponseProto_CreateAccountStatusFailInvalidPassword = 7,
  CreateAccountResponseProto_CreateAccountStatusFailOther = 8,
  CreateAccountResponseProto_CreateAccountStatusFailDuplicateEmail = 9,
  CreateAccountResponseProto_CreateAccountStatusFailInvalidEmail = 10,
  CreateAccountResponseProto_CreateAccountStatusFailDuplicateName = 11,
} CreateAccountResponseProto_CreateAccountStatus;

BOOL CreateAccountResponseProto_CreateAccountStatusIsValidValue(CreateAccountResponseProto_CreateAccountStatus value);


@interface CreateAccountEventRoot : NSObject {
}
+ (PBExtensionRegistry*) extensionRegistry;
+ (void) registerAllExtensions:(PBMutableExtensionRegistry*) registry;
@end

@interface CreateAccountViaFacebookRequestProto : PBGeneratedMessage {
@private
  BOOL hasFacebookId_:1;
  BOOL hasNameFriendsSee_:1;
  BOOL hasEmail_:1;
  BOOL hasUdid_:1;
  BOOL hasDeviceId_:1;
  NSString* facebookId;
  NSString* nameFriendsSee;
  NSString* email;
  NSString* udid;
  NSString* deviceId;
}
- (BOOL) hasFacebookId;
- (BOOL) hasNameFriendsSee;
- (BOOL) hasEmail;
- (BOOL) hasUdid;
- (BOOL) hasDeviceId;
@property (readonly, retain) NSString* facebookId;
@property (readonly, retain) NSString* nameFriendsSee;
@property (readonly, retain) NSString* email;
@property (readonly, retain) NSString* udid;
@property (readonly, retain) NSString* deviceId;

+ (CreateAccountViaFacebookRequestProto*) defaultInstance;
- (CreateAccountViaFacebookRequestProto*) defaultInstance;

- (BOOL) isInitialized;
- (void) writeToCodedOutputStream:(PBCodedOutputStream*) output;
- (CreateAccountViaFacebookRequestProto_Builder*) builder;
+ (CreateAccountViaFacebookRequestProto_Builder*) builder;
+ (CreateAccountViaFacebookRequestProto_Builder*) builderWithPrototype:(CreateAccountViaFacebookRequestProto*) prototype;

+ (CreateAccountViaFacebookRequestProto*) parseFromData:(NSData*) data;
+ (CreateAccountViaFacebookRequestProto*) parseFromData:(NSData*) data extensionRegistry:(PBExtensionRegistry*) extensionRegistry;
+ (CreateAccountViaFacebookRequestProto*) parseFromInputStream:(NSInputStream*) input;
+ (CreateAccountViaFacebookRequestProto*) parseFromInputStream:(NSInputStream*) input extensionRegistry:(PBExtensionRegistry*) extensionRegistry;
+ (CreateAccountViaFacebookRequestProto*) parseFromCodedInputStream:(PBCodedInputStream*) input;
+ (CreateAccountViaFacebookRequestProto*) parseFromCodedInputStream:(PBCodedInputStream*) input extensionRegistry:(PBExtensionRegistry*) extensionRegistry;
@end

@interface CreateAccountViaFacebookRequestProto_Builder : PBGeneratedMessage_Builder {
@private
  CreateAccountViaFacebookRequestProto* result;
}

- (CreateAccountViaFacebookRequestProto*) defaultInstance;

- (CreateAccountViaFacebookRequestProto_Builder*) clear;
- (CreateAccountViaFacebookRequestProto_Builder*) clone;

- (CreateAccountViaFacebookRequestProto*) build;
- (CreateAccountViaFacebookRequestProto*) buildPartial;

- (CreateAccountViaFacebookRequestProto_Builder*) mergeFrom:(CreateAccountViaFacebookRequestProto*) other;
- (CreateAccountViaFacebookRequestProto_Builder*) mergeFromCodedInputStream:(PBCodedInputStream*) input;
- (CreateAccountViaFacebookRequestProto_Builder*) mergeFromCodedInputStream:(PBCodedInputStream*) input extensionRegistry:(PBExtensionRegistry*) extensionRegistry;

- (BOOL) hasFacebookId;
- (NSString*) facebookId;
- (CreateAccountViaFacebookRequestProto_Builder*) setFacebookId:(NSString*) value;
- (CreateAccountViaFacebookRequestProto_Builder*) clearFacebookId;

- (BOOL) hasNameFriendsSee;
- (NSString*) nameFriendsSee;
- (CreateAccountViaFacebookRequestProto_Builder*) setNameFriendsSee:(NSString*) value;
- (CreateAccountViaFacebookRequestProto_Builder*) clearNameFriendsSee;

- (BOOL) hasEmail;
- (NSString*) email;
- (CreateAccountViaFacebookRequestProto_Builder*) setEmail:(NSString*) value;
- (CreateAccountViaFacebookRequestProto_Builder*) clearEmail;

- (BOOL) hasUdid;
- (NSString*) udid;
- (CreateAccountViaFacebookRequestProto_Builder*) setUdid:(NSString*) value;
- (CreateAccountViaFacebookRequestProto_Builder*) clearUdid;

- (BOOL) hasDeviceId;
- (NSString*) deviceId;
- (CreateAccountViaFacebookRequestProto_Builder*) setDeviceId:(NSString*) value;
- (CreateAccountViaFacebookRequestProto_Builder*) clearDeviceId;
@end

@interface CreateAccountViaEmailRequestProto : PBGeneratedMessage {
@private
  BOOL hasNameStrangersSee_:1;
  BOOL hasEmail_:1;
  BOOL hasPassword_:1;
  BOOL hasUdid_:1;
  BOOL hasDeviceId_:1;
  NSString* nameStrangersSee;
  NSString* email;
  NSString* password;
  NSString* udid;
  NSString* deviceId;
}
- (BOOL) hasNameStrangersSee;
- (BOOL) hasEmail;
- (BOOL) hasPassword;
- (BOOL) hasUdid;
- (BOOL) hasDeviceId;
@property (readonly, retain) NSString* nameStrangersSee;
@property (readonly, retain) NSString* email;
@property (readonly, retain) NSString* password;
@property (readonly, retain) NSString* udid;
@property (readonly, retain) NSString* deviceId;

+ (CreateAccountViaEmailRequestProto*) defaultInstance;
- (CreateAccountViaEmailRequestProto*) defaultInstance;

- (BOOL) isInitialized;
- (void) writeToCodedOutputStream:(PBCodedOutputStream*) output;
- (CreateAccountViaEmailRequestProto_Builder*) builder;
+ (CreateAccountViaEmailRequestProto_Builder*) builder;
+ (CreateAccountViaEmailRequestProto_Builder*) builderWithPrototype:(CreateAccountViaEmailRequestProto*) prototype;

+ (CreateAccountViaEmailRequestProto*) parseFromData:(NSData*) data;
+ (CreateAccountViaEmailRequestProto*) parseFromData:(NSData*) data extensionRegistry:(PBExtensionRegistry*) extensionRegistry;
+ (CreateAccountViaEmailRequestProto*) parseFromInputStream:(NSInputStream*) input;
+ (CreateAccountViaEmailRequestProto*) parseFromInputStream:(NSInputStream*) input extensionRegistry:(PBExtensionRegistry*) extensionRegistry;
+ (CreateAccountViaEmailRequestProto*) parseFromCodedInputStream:(PBCodedInputStream*) input;
+ (CreateAccountViaEmailRequestProto*) parseFromCodedInputStream:(PBCodedInputStream*) input extensionRegistry:(PBExtensionRegistry*) extensionRegistry;
@end

@interface CreateAccountViaEmailRequestProto_Builder : PBGeneratedMessage_Builder {
@private
  CreateAccountViaEmailRequestProto* result;
}

- (CreateAccountViaEmailRequestProto*) defaultInstance;

- (CreateAccountViaEmailRequestProto_Builder*) clear;
- (CreateAccountViaEmailRequestProto_Builder*) clone;

- (CreateAccountViaEmailRequestProto*) build;
- (CreateAccountViaEmailRequestProto*) buildPartial;

- (CreateAccountViaEmailRequestProto_Builder*) mergeFrom:(CreateAccountViaEmailRequestProto*) other;
- (CreateAccountViaEmailRequestProto_Builder*) mergeFromCodedInputStream:(PBCodedInputStream*) input;
- (CreateAccountViaEmailRequestProto_Builder*) mergeFromCodedInputStream:(PBCodedInputStream*) input extensionRegistry:(PBExtensionRegistry*) extensionRegistry;

- (BOOL) hasNameStrangersSee;
- (NSString*) nameStrangersSee;
- (CreateAccountViaEmailRequestProto_Builder*) setNameStrangersSee:(NSString*) value;
- (CreateAccountViaEmailRequestProto_Builder*) clearNameStrangersSee;

- (BOOL) hasEmail;
- (NSString*) email;
- (CreateAccountViaEmailRequestProto_Builder*) setEmail:(NSString*) value;
- (CreateAccountViaEmailRequestProto_Builder*) clearEmail;

- (BOOL) hasPassword;
- (NSString*) password;
- (CreateAccountViaEmailRequestProto_Builder*) setPassword:(NSString*) value;
- (CreateAccountViaEmailRequestProto_Builder*) clearPassword;

- (BOOL) hasUdid;
- (NSString*) udid;
- (CreateAccountViaEmailRequestProto_Builder*) setUdid:(NSString*) value;
- (CreateAccountViaEmailRequestProto_Builder*) clearUdid;

- (BOOL) hasDeviceId;
- (NSString*) deviceId;
- (CreateAccountViaEmailRequestProto_Builder*) setDeviceId:(NSString*) value;
- (CreateAccountViaEmailRequestProto_Builder*) clearDeviceId;
@end

@interface CreateAccountViaNoCredentialsRequestProto : PBGeneratedMessage {
@private
  BOOL hasUdid_:1;
  BOOL hasDeviceId_:1;
  BOOL hasNameStrangersSee_:1;
  NSString* udid;
  NSString* deviceId;
  NSString* nameStrangersSee;
}
- (BOOL) hasUdid;
- (BOOL) hasDeviceId;
- (BOOL) hasNameStrangersSee;
@property (readonly, retain) NSString* udid;
@property (readonly, retain) NSString* deviceId;
@property (readonly, retain) NSString* nameStrangersSee;

+ (CreateAccountViaNoCredentialsRequestProto*) defaultInstance;
- (CreateAccountViaNoCredentialsRequestProto*) defaultInstance;

- (BOOL) isInitialized;
- (void) writeToCodedOutputStream:(PBCodedOutputStream*) output;
- (CreateAccountViaNoCredentialsRequestProto_Builder*) builder;
+ (CreateAccountViaNoCredentialsRequestProto_Builder*) builder;
+ (CreateAccountViaNoCredentialsRequestProto_Builder*) builderWithPrototype:(CreateAccountViaNoCredentialsRequestProto*) prototype;

+ (CreateAccountViaNoCredentialsRequestProto*) parseFromData:(NSData*) data;
+ (CreateAccountViaNoCredentialsRequestProto*) parseFromData:(NSData*) data extensionRegistry:(PBExtensionRegistry*) extensionRegistry;
+ (CreateAccountViaNoCredentialsRequestProto*) parseFromInputStream:(NSInputStream*) input;
+ (CreateAccountViaNoCredentialsRequestProto*) parseFromInputStream:(NSInputStream*) input extensionRegistry:(PBExtensionRegistry*) extensionRegistry;
+ (CreateAccountViaNoCredentialsRequestProto*) parseFromCodedInputStream:(PBCodedInputStream*) input;
+ (CreateAccountViaNoCredentialsRequestProto*) parseFromCodedInputStream:(PBCodedInputStream*) input extensionRegistry:(PBExtensionRegistry*) extensionRegistry;
@end

@interface CreateAccountViaNoCredentialsRequestProto_Builder : PBGeneratedMessage_Builder {
@private
  CreateAccountViaNoCredentialsRequestProto* result;
}

- (CreateAccountViaNoCredentialsRequestProto*) defaultInstance;

- (CreateAccountViaNoCredentialsRequestProto_Builder*) clear;
- (CreateAccountViaNoCredentialsRequestProto_Builder*) clone;

- (CreateAccountViaNoCredentialsRequestProto*) build;
- (CreateAccountViaNoCredentialsRequestProto*) buildPartial;

- (CreateAccountViaNoCredentialsRequestProto_Builder*) mergeFrom:(CreateAccountViaNoCredentialsRequestProto*) other;
- (CreateAccountViaNoCredentialsRequestProto_Builder*) mergeFromCodedInputStream:(PBCodedInputStream*) input;
- (CreateAccountViaNoCredentialsRequestProto_Builder*) mergeFromCodedInputStream:(PBCodedInputStream*) input extensionRegistry:(PBExtensionRegistry*) extensionRegistry;

- (BOOL) hasUdid;
- (NSString*) udid;
- (CreateAccountViaNoCredentialsRequestProto_Builder*) setUdid:(NSString*) value;
- (CreateAccountViaNoCredentialsRequestProto_Builder*) clearUdid;

- (BOOL) hasDeviceId;
- (NSString*) deviceId;
- (CreateAccountViaNoCredentialsRequestProto_Builder*) setDeviceId:(NSString*) value;
- (CreateAccountViaNoCredentialsRequestProto_Builder*) clearDeviceId;

- (BOOL) hasNameStrangersSee;
- (NSString*) nameStrangersSee;
- (CreateAccountViaNoCredentialsRequestProto_Builder*) setNameStrangersSee:(NSString*) value;
- (CreateAccountViaNoCredentialsRequestProto_Builder*) clearNameStrangersSee;
@end

@interface CreateAccountResponseProto : PBGeneratedMessage {
@private
  BOOL hasRecipient_:1;
  BOOL hasStatus_:1;
  BasicUserProto* recipient;
  CreateAccountResponseProto_CreateAccountStatus status;
  NSMutableArray* mutableOtherNamesList;
}
- (BOOL) hasRecipient;
- (BOOL) hasStatus;
@property (readonly, retain) BasicUserProto* recipient;
@property (readonly) CreateAccountResponseProto_CreateAccountStatus status;
- (NSArray*) otherNamesList;
- (NSString*) otherNamesAtIndex:(int32_t) index;

+ (CreateAccountResponseProto*) defaultInstance;
- (CreateAccountResponseProto*) defaultInstance;

- (BOOL) isInitialized;
- (void) writeToCodedOutputStream:(PBCodedOutputStream*) output;
- (CreateAccountResponseProto_Builder*) builder;
+ (CreateAccountResponseProto_Builder*) builder;
+ (CreateAccountResponseProto_Builder*) builderWithPrototype:(CreateAccountResponseProto*) prototype;

+ (CreateAccountResponseProto*) parseFromData:(NSData*) data;
+ (CreateAccountResponseProto*) parseFromData:(NSData*) data extensionRegistry:(PBExtensionRegistry*) extensionRegistry;
+ (CreateAccountResponseProto*) parseFromInputStream:(NSInputStream*) input;
+ (CreateAccountResponseProto*) parseFromInputStream:(NSInputStream*) input extensionRegistry:(PBExtensionRegistry*) extensionRegistry;
+ (CreateAccountResponseProto*) parseFromCodedInputStream:(PBCodedInputStream*) input;
+ (CreateAccountResponseProto*) parseFromCodedInputStream:(PBCodedInputStream*) input extensionRegistry:(PBExtensionRegistry*) extensionRegistry;
@end

@interface CreateAccountResponseProto_Builder : PBGeneratedMessage_Builder {
@private
  CreateAccountResponseProto* result;
}

- (CreateAccountResponseProto*) defaultInstance;

- (CreateAccountResponseProto_Builder*) clear;
- (CreateAccountResponseProto_Builder*) clone;

- (CreateAccountResponseProto*) build;
- (CreateAccountResponseProto*) buildPartial;

- (CreateAccountResponseProto_Builder*) mergeFrom:(CreateAccountResponseProto*) other;
- (CreateAccountResponseProto_Builder*) mergeFromCodedInputStream:(PBCodedInputStream*) input;
- (CreateAccountResponseProto_Builder*) mergeFromCodedInputStream:(PBCodedInputStream*) input extensionRegistry:(PBExtensionRegistry*) extensionRegistry;

- (BOOL) hasRecipient;
- (BasicUserProto*) recipient;
- (CreateAccountResponseProto_Builder*) setRecipient:(BasicUserProto*) value;
- (CreateAccountResponseProto_Builder*) setRecipientBuilder:(BasicUserProto_Builder*) builderForValue;
- (CreateAccountResponseProto_Builder*) mergeRecipient:(BasicUserProto*) value;
- (CreateAccountResponseProto_Builder*) clearRecipient;

- (BOOL) hasStatus;
- (CreateAccountResponseProto_CreateAccountStatus) status;
- (CreateAccountResponseProto_Builder*) setStatus:(CreateAccountResponseProto_CreateAccountStatus) value;
- (CreateAccountResponseProto_Builder*) clearStatus;

- (NSArray*) otherNamesList;
- (NSString*) otherNamesAtIndex:(int32_t) index;
- (CreateAccountResponseProto_Builder*) replaceOtherNamesAtIndex:(int32_t) index with:(NSString*) value;
- (CreateAccountResponseProto_Builder*) addOtherNames:(NSString*) value;
- (CreateAccountResponseProto_Builder*) addAllOtherNames:(NSArray*) values;
- (CreateAccountResponseProto_Builder*) clearOtherNamesList;
@end

