//
//  OEXGoogleAuthProvider.m
//  edXVideoLocker
//
//  Created by Akiva Leffert on 3/24/15.
//  Copyright (c) 2015 edX. All rights reserved.
//

#import "OEXKakaoAuthProvider.h"

#import "edX-Swift.h"

#import "OEXExternalAuthProviderButton.h"
#import "OEXKakaoSocial.h"
#import "OEXRegisteringUserDetails.h"

@implementation OEXKakaoAuthProvider

- (UIColor*)kakaoBrown {
    return [UIColor colorWithRed:60/255. green:30/255. blue:30./255. alpha:1];
}

- (NSString*)displayName {
    return [Strings kakao];
}

- (NSString*)backendName {
    return @"kakao";
}

- (OEXExternalAuthProviderButton*)freshAuthButton {
    OEXExternalAuthProviderButton* button = [[OEXExternalAuthProviderButton alloc] initWithFrame:CGRectZero];
    button.provider = self;
    // Because of the '+' the G icon is off center. This accounts for that.
    [button setImageEdgeInsets:UIEdgeInsetsMake(0, 3, 0, -3)];
    [button setImage:[UIImage imageNamed:@"icon_kakao_brown"] forState:UIControlStateNormal];
    [button useBackgroundImageOfColor:[self kakaoBrown]];
    return button;
}

- (void)authorizeServiceFromController:(UIViewController *)controller requestingUserDetails:(BOOL)loadUserDetails withCompletion:(void (^)(NSString *, OEXRegisteringUserDetails *, NSError *))completion {
    
    OEXKakaoSocial* kakaoManager = [[OEXKakaoSocial alloc] init]; //could be named facebookHelper.
    [kakaoManager loginFromController:controller completion:^(NSString *accessToken, NSError *error) {
        
       
//        completion([KOSession sharedSession].accessToken, nil, error);
        
        
        [KOSessionTask accessTokenInfoTaskWithCompletionHandler:^(KOAccessTokenInfo *accessTokenInfo, NSError *error) {
            if (error) {
                switch (error.code) {
                    case KOErrorDeactivatedSession:
                        // 세션이 만료된(access_token, refresh_token이 모두 만료된 경우) 상태
                        break;
                    default:
                        // 예기치 못한 에러. 서버 에러
                        
                        break;
                }
            } else {
                
                // 성공 (토큰이 유효함)
                NSLog(@"남은 유효시간: %@ (단위: ms)", accessTokenInfo.expiresInMillis);
                NSLog(@"성공시 accessToken : %@",[KOSession sharedSession].accessToken);
                
                completion([KOSession sharedSession].accessToken, nil, error);
                
            }
            completion([KOSession sharedSession].accessToken, nil, error);
        }];
        
    }];


 }

@end
