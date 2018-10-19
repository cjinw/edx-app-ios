//
//  OEXKakaoSocial
//  edXVideoLocker
//
//  Created by Prashant Kurhade on 20/11/14.
//  Copyright (c) 2014-2016 edX. All rights reserved.
//

#import <KakaoOpenSDK/KakaoOpenSDK.h>

NS_ASSUME_NONNULL_BEGIN

@interface OEXKakaoSocial : NSObject

- (void)loginFromController:(UIViewController*)controller completion:(void(^)(NSString* accessToken,NSError* error))completionHandler;
- (void)logout;
- (BOOL)isLogin;

- (void)requestUserProfileInfoWithCompletion:(void(^)(NSDictionary* userProfile, NSError* error))completion;

@end

NS_ASSUME_NONNULL_END
