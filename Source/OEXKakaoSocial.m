    //
//  OEXFBSocial.m
//  edXVideoLocker
//
//  Created by Prashant Kurhade on 20/11/14.
//  Copyright (c) 2014 edX. All rights reserved.
//



#import "edX-Swift.h"
#import "Logger+OEXObjC.h"

#import "NSNotificationCenter+OEXSafeAccess.h"
#import "OEXConfig.h"
#import "OEXSession.h"



#import "OEXKakaoSocial.h"
#import <KakaoOpenSDK/KakaoOpenSDK.h>
#import "OEXKakaoConfig.h"

@interface OEXKakaoSocial ()


@end

@implementation OEXKakaoSocial

- (id)init {
    self = [super init];
    if(self != nil) {
        [[NSNotificationCenter defaultCenter] oex_addObserver:self notification:OEXSessionEndedNotification action:^(NSNotification *notification, OEXKakaoSocial* observer, id<OEXRemovable> removable) {
            [observer logout];
        }];
    }
    return self;
}

- (void)loginFromController:(UIViewController *)controller completion:(void (^)(NSString *, NSError *))completionHandler {
//    FBSDKLoginManager* fbLoginManager = [[FBSDKLoginManager alloc]init];
//    [fbLoginManager logInWithReadPermissions:@[@"email", @"public_profile"] fromViewController:controller handler:^(FBSDKLoginManagerLoginResult *result, NSError *error) {
//        FBSDKAccessToken* accessToken = [FBSDKAccessToken currentAccessToken];
//        
//        if (error) {
//            completionHandler(nil, error);
//        } else if (result.isCancelled) {
//            completionHandler(nil, error); //Reflecting as an error for now, before further discussion
//        } else {
//            if (![result.grantedPermissions containsObject:@"email"]) {
//                OEXLogInfo(@"SOCIAL", @"Email permission is missing");
//            }
//            if (![result.grantedPermissions containsObject:@"public_profile"]) {
//                OEXLogInfo(@"SOCIAL", @"Public profile permission is missing");
//            }
//            completionHandler([accessToken tokenString],error);
//        }
//    }];
    
    
//    KOSession *session = [KOSession sharedSession];
//    
//    if (session.isOpen) {
//        [session close];
//    }
//    
//    [session openWithCompletionHandler:^(NSError *error) {
//        if (!session.isOpen) {
//            switch (error.code) {
//                case KOErrorCancelled:
//                    break;
//                default:
//                    [[[UIAlertView alloc] initWithTitle:@"에러" message:error.description delegate:nil cancelButtonTitle:@"확인" otherButtonTitles:nil, nil] show];
//                    break;
//            }
//        }
//        else
//        {
//            completionHandler([KOSession sharedSession].accessToken,error);
//        }
//    }];

    
    
    
    [[KOSession sharedSession] close];
    
    [[KOSession sharedSession] openWithCompletionHandler:^(NSError *error) {
        if ([[KOSession sharedSession] isOpen]) {
            // login success
            NSLog(@"login succeeded.");
            
            NSLog(@"%@",[KOSession sharedSession].accessToken);
            
            completionHandler([KOSession sharedSession].accessToken,error);
        } else {
            // failed
            NSLog(@"login failed.");
        }
    }];
    
    
}

- (BOOL)isLogin {
//    OEXConfig* config = [OEXConfig sharedConfig];
//    OEXFacebookConfig* facebookConfig = [config facebookConfig];
//    if(facebookConfig.appId && facebookConfig.enabled) {
//        return [FBSDKAccessToken currentAccessToken] != nil;
//    }
    return NO;
}

- (void)logout {
    
    [[KOSession sharedSession] logoutAndCloseWithCompletionHandler:^(BOOL success, NSError *error) {
        if (success) {
            // logout success.
        } else {
            // failed
            NSLog(@"failed to logout.");
        }
    }];
    
    
    
//    if([self isLogin]) {
//        FBSDKLoginManager* fbLoginManager = [[FBSDKLoginManager alloc]init];
//        [fbLoginManager logOut];
//    }
}

- (void)requestUserProfileInfoWithCompletion:(void (^)(NSDictionary*, NSError *))completion {
//    if([FBSDKAccessToken currentAccessToken])
//    {
//        [[[FBSDKGraphRequest alloc]initWithGraphPath:@"me" parameters:nil] startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
//            completion(result, error);
//        }];
//    }
}

@end

