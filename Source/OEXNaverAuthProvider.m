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
    
   
    OEXNaverSocial* naverManager = [[OEXNaverSocial alloc] init]; //could be named facebookHelper.
    

    
    [naverManager loginFromController:controller completion:^(NSString *accessToken, NSError *error) {

        
        completion(accessToken, nil, error);

//        if(accessToken)
//        {
//            NSLog(@"accessToken in Provider  :  %@", accessToken);
//            completion(accessToken, nil, error);
//        }
//        else
//        {
//            NSLog(@"accessToken in Provider22  :  %@", accessToken);
//            completion(accessToken, nil, error);
//
//            
//        }
        

    }];
    
    
    
}

@end
