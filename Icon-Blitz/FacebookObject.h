//
//  FacebookObject.h
//  Icon-Blitz
//
//  Created by Danny on 4/5/13.
//
//

#import <Foundation/Foundation.h>
#import <FacebookSDK/FacebookSDK.h>

@interface FacebookObject : NSObject {

}

- (void)facebookLogin;
- (BOOL)fbDidLogin;
- (void)signUpWithFacebook;
- (UIView *)publishWithPostParams:(NSMutableDictionary *)postParams;
- (void)publishWithoutUIAndParams:(NSMutableDictionary *)postParams;

@end
