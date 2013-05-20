// Generated by the protocol buffer compiler.  DO NOT EDIT!

#import "ProtocolBuffers.h"

@class Example;
@class ExampleList;
@class ExampleList_Builder;
@class Example_Builder;
@class Example_PhoneNumber;
@class Example_PhoneNumber_Builder;
typedef enum {
  Example_PhoneTypeMobile = 0,
  Example_PhoneTypeHome = 1,
  Example_PhoneTypeWork = 2,
} Example_PhoneType;

BOOL Example_PhoneTypeIsValidValue(Example_PhoneType value);


@interface ExampleRoot : NSObject {
}
+ (PBExtensionRegistry*) extensionRegistry;
+ (void) registerAllExtensions:(PBMutableExtensionRegistry*) registry;
@end

@interface Example : PBGeneratedMessage {
@private
  BOOL hasId_:1;
  BOOL hasName_:1;
  BOOL hasEmail_:1;
  int32_t id;
  NSString* name;
  NSString* email;
  NSMutableArray* mutablePhoneList;
}
- (BOOL) hasName;
- (BOOL) hasId;
- (BOOL) hasEmail;
@property (readonly, retain) NSString* name;
@property (readonly) int32_t id;
@property (readonly, retain) NSString* email;
- (NSArray*) phoneList;
- (Example_PhoneNumber*) phoneAtIndex:(int32_t) index;

+ (Example*) defaultInstance;
- (Example*) defaultInstance;

- (BOOL) isInitialized;
- (void) writeToCodedOutputStream:(PBCodedOutputStream*) output;
- (Example_Builder*) builder;
+ (Example_Builder*) builder;
+ (Example_Builder*) builderWithPrototype:(Example*) prototype;

+ (Example*) parseFromData:(NSData*) data;
+ (Example*) parseFromData:(NSData*) data extensionRegistry:(PBExtensionRegistry*) extensionRegistry;
+ (Example*) parseFromInputStream:(NSInputStream*) input;
+ (Example*) parseFromInputStream:(NSInputStream*) input extensionRegistry:(PBExtensionRegistry*) extensionRegistry;
+ (Example*) parseFromCodedInputStream:(PBCodedInputStream*) input;
+ (Example*) parseFromCodedInputStream:(PBCodedInputStream*) input extensionRegistry:(PBExtensionRegistry*) extensionRegistry;
@end

@interface Example_PhoneNumber : PBGeneratedMessage {
@private
  BOOL hasNumber_:1;
  BOOL hasType_:1;
  NSString* number;
  Example_PhoneType type;
}
- (BOOL) hasNumber;
- (BOOL) hasType;
@property (readonly, retain) NSString* number;
@property (readonly) Example_PhoneType type;

+ (Example_PhoneNumber*) defaultInstance;
- (Example_PhoneNumber*) defaultInstance;

- (BOOL) isInitialized;
- (void) writeToCodedOutputStream:(PBCodedOutputStream*) output;
- (Example_PhoneNumber_Builder*) builder;
+ (Example_PhoneNumber_Builder*) builder;
+ (Example_PhoneNumber_Builder*) builderWithPrototype:(Example_PhoneNumber*) prototype;

+ (Example_PhoneNumber*) parseFromData:(NSData*) data;
+ (Example_PhoneNumber*) parseFromData:(NSData*) data extensionRegistry:(PBExtensionRegistry*) extensionRegistry;
+ (Example_PhoneNumber*) parseFromInputStream:(NSInputStream*) input;
+ (Example_PhoneNumber*) parseFromInputStream:(NSInputStream*) input extensionRegistry:(PBExtensionRegistry*) extensionRegistry;
+ (Example_PhoneNumber*) parseFromCodedInputStream:(PBCodedInputStream*) input;
+ (Example_PhoneNumber*) parseFromCodedInputStream:(PBCodedInputStream*) input extensionRegistry:(PBExtensionRegistry*) extensionRegistry;
@end

@interface Example_PhoneNumber_Builder : PBGeneratedMessage_Builder {
@private
  Example_PhoneNumber* result;
}

- (Example_PhoneNumber*) defaultInstance;

- (Example_PhoneNumber_Builder*) clear;
- (Example_PhoneNumber_Builder*) clone;

- (Example_PhoneNumber*) build;
- (Example_PhoneNumber*) buildPartial;

- (Example_PhoneNumber_Builder*) mergeFrom:(Example_PhoneNumber*) other;
- (Example_PhoneNumber_Builder*) mergeFromCodedInputStream:(PBCodedInputStream*) input;
- (Example_PhoneNumber_Builder*) mergeFromCodedInputStream:(PBCodedInputStream*) input extensionRegistry:(PBExtensionRegistry*) extensionRegistry;

- (BOOL) hasNumber;
- (NSString*) number;
- (Example_PhoneNumber_Builder*) setNumber:(NSString*) value;
- (Example_PhoneNumber_Builder*) clearNumber;

- (BOOL) hasType;
- (Example_PhoneType) type;
- (Example_PhoneNumber_Builder*) setType:(Example_PhoneType) value;
- (Example_PhoneNumber_Builder*) clearType;
@end

@interface Example_Builder : PBGeneratedMessage_Builder {
@private
  Example* result;
}

- (Example*) defaultInstance;

- (Example_Builder*) clear;
- (Example_Builder*) clone;

- (Example*) build;
- (Example*) buildPartial;

- (Example_Builder*) mergeFrom:(Example*) other;
- (Example_Builder*) mergeFromCodedInputStream:(PBCodedInputStream*) input;
- (Example_Builder*) mergeFromCodedInputStream:(PBCodedInputStream*) input extensionRegistry:(PBExtensionRegistry*) extensionRegistry;

- (BOOL) hasName;
- (NSString*) name;
- (Example_Builder*) setName:(NSString*) value;
- (Example_Builder*) clearName;

- (BOOL) hasId;
- (int32_t) id;
- (Example_Builder*) setId:(int32_t) value;
- (Example_Builder*) clearId;

- (BOOL) hasEmail;
- (NSString*) email;
- (Example_Builder*) setEmail:(NSString*) value;
- (Example_Builder*) clearEmail;

- (NSArray*) phoneList;
- (Example_PhoneNumber*) phoneAtIndex:(int32_t) index;
- (Example_Builder*) replacePhoneAtIndex:(int32_t) index with:(Example_PhoneNumber*) value;
- (Example_Builder*) addPhone:(Example_PhoneNumber*) value;
- (Example_Builder*) addAllPhone:(NSArray*) values;
- (Example_Builder*) clearPhoneList;
@end

@interface ExampleList : PBGeneratedMessage {
@private
  NSMutableArray* mutableExampleList;
}
- (NSArray*) exampleList;
- (Example*) exampleAtIndex:(int32_t) index;

+ (ExampleList*) defaultInstance;
- (ExampleList*) defaultInstance;

- (BOOL) isInitialized;
- (void) writeToCodedOutputStream:(PBCodedOutputStream*) output;
- (ExampleList_Builder*) builder;
+ (ExampleList_Builder*) builder;
+ (ExampleList_Builder*) builderWithPrototype:(ExampleList*) prototype;

+ (ExampleList*) parseFromData:(NSData*) data;
+ (ExampleList*) parseFromData:(NSData*) data extensionRegistry:(PBExtensionRegistry*) extensionRegistry;
+ (ExampleList*) parseFromInputStream:(NSInputStream*) input;
+ (ExampleList*) parseFromInputStream:(NSInputStream*) input extensionRegistry:(PBExtensionRegistry*) extensionRegistry;
+ (ExampleList*) parseFromCodedInputStream:(PBCodedInputStream*) input;
+ (ExampleList*) parseFromCodedInputStream:(PBCodedInputStream*) input extensionRegistry:(PBExtensionRegistry*) extensionRegistry;
@end

@interface ExampleList_Builder : PBGeneratedMessage_Builder {
@private
  ExampleList* result;
}

- (ExampleList*) defaultInstance;

- (ExampleList_Builder*) clear;
- (ExampleList_Builder*) clone;

- (ExampleList*) build;
- (ExampleList*) buildPartial;

- (ExampleList_Builder*) mergeFrom:(ExampleList*) other;
- (ExampleList_Builder*) mergeFromCodedInputStream:(PBCodedInputStream*) input;
- (ExampleList_Builder*) mergeFromCodedInputStream:(PBCodedInputStream*) input extensionRegistry:(PBExtensionRegistry*) extensionRegistry;

- (NSArray*) exampleList;
- (Example*) exampleAtIndex:(int32_t) index;
- (ExampleList_Builder*) replaceExampleAtIndex:(int32_t) index with:(Example*) value;
- (ExampleList_Builder*) addExample:(Example*) value;
- (ExampleList_Builder*) addAllExample:(NSArray*) values;
- (ExampleList_Builder*) clearExampleList;
@end
