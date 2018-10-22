//
//  OEXLoginViewController.h
//  edXVideoLocker
//
//  Created by Nirbhay Agarwal on 15/05/14.
//  Copyright (c) 2014-2016 edX. All rights reserved.
//

@import UIKit;

#import <NaverThirdPartyLogin/NaverThirdPartyLogin.h>
#import "OEXNaverAuthProvider.h"
#import "OEXNaverConfig.h"
#import "OEXNaverSocial.h"

NS_ASSUME_NONNULL_BEGIN

@class OEXLoginViewController;
@class RouterEnvironment;

@protocol OEXLoginViewControllerDelegate <NSObject>

- (void)loginViewControllerDidLogin:(OEXLoginViewController*)loginController;

@end


@interface OEXLoginViewController : UIViewController<NaverThirdPartyLoginConnectionDelegate>
{
    NaverThirdPartyLoginConnection *_thirdPartyLoginConn;
}

@property (weak, nonatomic, nullable) id <OEXLoginViewControllerDelegate> delegate;
@property (strong, nonatomic) RouterEnvironment* environment;

@end

NS_ASSUME_NONNULL_END
