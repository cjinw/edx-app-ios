//
//  OEXGoogleAuthProvider.m
//  edXVideoLocker
//
//  Created by Akiva Leffert on 3/24/15.
//  Copyright (c) 2015 edX. All rights reserved.
//



#import "OEXNaverAuthProvider.h"

#import "edX-Swift.h"

#import "OEXExternalAuthProviderButton.h"
#import "OEXNaverSocial.h"
#import "OEXRegisteringUserDetails.h"

@implementation OEXNaverAuthProvider

- (UIColor*)naverGreen {
    return [UIColor colorWithRed:30/255. green:198/255. blue:0./255. alpha:1];
}

- (NSString*)displayName {
    return [Strings naver];
}

- (NSString*)backendName {
    return @"naver";
}

- (OEXExternalAuthProviderButton*)freshAuthButton {
    OEXExternalAuthProviderButton* button = [[OEXExternalAuthProviderButton alloc] initWithFrame:CGRectZero];
    button.provider = self;
    // Because of the '+' the G icon is off center. This accounts for that.
    [button setImageEdgeInsets:UIEdgeInsetsMake(0, 3, 0, -3)];
    [button setImage:[UIImage imageNamed:@"icon_naver_green"] forState:UIControlStateNormal];
    [button useBackgroundImageOfColor:[self naverGreen]];
    return button;
}

- (void)authorizeServiceFromController:(UIViewController *)controller requestingUserDetails:(BOOL)loadUserDetails withCompletion:(void (^)(NSString *, OEXRegisteringUserDetails *, NSError *))completion {
    
//    OEXNaverSocial* naverManager = [[OEXNaverSocial alloc] init]; //could be named facebookHelper.
//    [naverManager loginFromController:controller completion:^(NSString *accessToken, NSError *error) {
//        
//        NSLog(@"%@",[KOSession sharedSession].accessToken);
//        
//        //        if(error){
//        //            completion(accessToken, nil, error);
//        //
//        //        }
//        //        else{
//        //            completion(accessToken, nil, error);
//        //        }
//        
//        
//        [KOSessionTask accessTokenInfoTaskWithCompletionHandler:^(KOAccessTokenInfo *accessTokenInfo, NSError *error) {
//            if (error) {
//                switch (error.code) {
//                    case KOErrorDeactivatedSession:
//                        // 세션이 만료된(access_token, refresh_token이 모두 만료된 경우) 상태
//                        break;
//                    default:
//                        // 예기치 못한 에러. 서버 에러
//                        
//                        break;
//                }
//            } else {
//                
//                //                [KOSession sharedSession].accessToken;
//                
//                
//                // 성공 (토큰이 유효함)
//                NSLog(@"남은 유효시간: %@ (단위: ms)", accessTokenInfo.expiresInMillis);
//                NSLog(@"성공시 accessToken : %@",[KOSession sharedSession].accessToken);
//                
//                completion([KOSession sharedSession].accessToken, nil, error);
//                
//                
//            }
//        }];
    
        
        
        //        completion(accessToken, nil, error);
        //        if(error) {
        //            if([error.domain isEqual:FBSDKErrorDomain] && error.code == FBSDKNetworkErrorCode) {
        //                // Hide FB specific errors inside this abstraction barrier
        //                error = [NSError errorWithDomain:NSURLErrorDomain code:NSURLErrorNetworkConnectionLost userInfo:error.userInfo];
        //            }
        //            completion(accessToken, nil, error);
        //            return;
        //        }
        //        if(loadUserDetails) {
        //            [facebookManager requestUserProfileInfoWithCompletion:^(NSDictionary *userInfo, NSError *error) {
        //                // userInfo is a facebook user object
        //                OEXRegisteringUserDetails* profile = [[OEXRegisteringUserDetails alloc] init];
        //                profile.email = userInfo[@"email"];
        //                profile.name = userInfo[@"name"];
        //                completion(accessToken, profile, error);
        //            }];
        //        }
        //        else {
        //            completion(accessToken, nil, error);
        //
        //        }
        
//    }];
    
    
}

@end
