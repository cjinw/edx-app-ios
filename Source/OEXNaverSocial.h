//
//  OEXNaverSocial
//  edXVideoLocker
//
//  Created by Prashant Kurhade on 20/11/14.
//  Copyright (c) 2014-2016 edX. All rights reserved.
//

#import <NaverThirdPartyLogin/NaverThirdPartyLogin.h>

NS_ASSUME_NONNULL_BEGIN

@interface OEXNaverSocial : NSObject


- (void)loginFromController:(UIViewController*)controller completion:(void(^)(NSString* accessToken,NSError* error))completionHandler;
- (void)logout;
- (BOOL)isLogin;

- (void)requestUserProfileInfoWithCompletion:(void(^)(NSDictionary* userProfile, NSError* error))completion;

@end

extern void (^myHandler)(NSString *, NSError *);


NS_ASSUME_NONNULL_END
