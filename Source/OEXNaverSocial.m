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



#import "OEXNaverSocial.h"
#import "OEXNaverConfig.h"

@interface OEXNaverSocial ()


@end

@implementation OEXNaverSocial

- (id)init {
    self = [super init];
    if(self != nil) {
        [[NSNotificationCenter defaultCenter] oex_addObserver:self notification:OEXSessionEndedNotification action:^(NSNotification *notification, OEXNaverSocial* observer, id<OEXRemovable> removable) {
            [observer logout];
        }];
        
       
    }
    return self;
}


- (BOOL)shouldAutorotate {
    return YES;
}


- (void)requestThirdpartyLogin
{
    // NaverThirdPartyLoginConnection의 인스턴스에 서비스앱의 url scheme와 consumer key, consumer secret, 그리고 appName을 파라미터로 전달하여 3rd party OAuth 인증을 요청한다.
    
    
    
    NaverThirdPartyLoginConnection *tlogin = [NaverThirdPartyLoginConnection getSharedInstance];
    
    if ( tlogin.isValidAccessTokenExpireTimeNow ) {
        [tlogin resetToken];
        NSLog(@"resetToken before 3rd party login\n\n\n");
    }
    
    [tlogin setServiceUrlScheme:kServiceAppUrlScheme];
    [tlogin requestThirdPartyLogin];
//    return YES;
}

void (^myHandler)(NSString *, NSError *);

- (void)loginFromController:(UIViewController *)controller completion:(void (^)(NSString *, NSError *))completionHandler {
    

    
    [self requestThirdpartyLogin];
     
    myHandler = completionHandler;
    
    
    
    
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
    
    [[NaverThirdPartyLoginConnection getSharedInstance] resetToken];
    
    
//    NaverThirdPartyLoginConnection *tlogin = [NaverThirdPartyLoginConnection getSharedInstance];
//    [tlogin requestDeleteToken];
    
//    [[KOSession sharedSession] logoutAndCloseWithCompletionHandler:^(BOOL success, NSError *error) {
//        if (success) {
//            // logout success.
//        } else {
//            // failed
//            NSLog(@"failed to logout.");
//        }
//    }];
    
    
    
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

