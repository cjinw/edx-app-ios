//
//  OEXAppDelegate.m
//  edXVideoLocker
//
//  Created by Nirbhay Agarwal on 15/05/14.
//  Copyright (c) 2014 edX. All rights reserved.
//

@import edXCore;
#import <Crashlytics/Crashlytics.h>
#import <Fabric/Fabric.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <GoogleSignIn/GoogleSignIn.h>
#import <NewRelicAgent/NewRelic.h>
#import <Analytics/SEGAnalytics.h>
#import <Branch/Branch.h>

#import "OEXAppDelegate.h"

#import "edX-Swift.h"
#import "Logger+OEXObjC.h"

#import "OEXAuthentication.h"
#import "OEXConfig.h"
#import "OEXDownloadManager.h"
#import "OEXEnvironment.h"
#import "OEXFabricConfig.h"
#import "OEXFacebookConfig.h"
#import "OEXGoogleConfig.h"
#import "OEXGoogleSocial.h"
#import "OEXInterface.h"
#import "OEXNewRelicConfig.h"
#import "OEXPushProvider.h"
#import "OEXPushNotificationManager.h"
#import "OEXPushSettingsManager.h"
#import "OEXRouter.h"
#import "OEXSession.h"
#import "OEXSegmentConfig.h"

#import <KakaoOpenSDK/KakaoOpenSDK.h>
#import "OEXKakaoConfig.h"
#import "OEXKakaoSocial.h"

#import <UserNotifications/UserNotifications.h>

#import <NaverThirdPartyLogin/NaverThirdPartyLogin.h>
#import "OEXNaverConfig.h"
#import "OEXNaverSocial.h"



@import Firebase;

@interface OEXAppDelegate () <UIApplicationDelegate, UNUserNotificationCenterDelegate>


@property (nonatomic, strong) NSMutableDictionary* dictCompletionHandler;
@property (nonatomic, strong) OEXEnvironment* environment;

@end


@implementation OEXAppDelegate

@synthesize window = _window;

- (BOOL)application:(UIApplication*)application didFinishLaunchingWithOptions:(NSDictionary*)launchOptions {
#if DEBUG
    // Skip all this initialization if we're running the unit tests
    // So they can start from a clean state.
    // dispatch_async so that the XCTest bundle (where TestEnvironmentBuilder lives) has already loaded
    if([[NSProcessInfo processInfo].arguments containsObject:@"-UNIT_TEST"]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            Class builder = NSClassFromString(@"TestEnvironmentBuilder");
            NSAssert(builder != nil, @"Can't find test environment builder");
            (void)[[builder alloc] init];
        });
        return YES;
    }
    if([[NSProcessInfo processInfo].arguments containsObject:@"-END_TO_END_TEST"]) {
        [[[OEXSession alloc] init] closeAndClearSession];
        [OEXFileUtility nukeUserData];
    }
#endif

    // logout user automatically if server changed
    [[[ServerChangedChecker alloc] init] logoutIfServerChanged];

    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];

    [self setupGlobalEnvironment];
    [self.environment.session performMigrations];

    [self.environment.router openInWindow:self.window];
    
    [self configureFabricKits:launchOptions];
    
    application.applicationIconBadgeNumber = 0;
    
    
    //Naver Login
    
   
    NaverThirdPartyLoginConnection *thirdConn = [NaverThirdPartyLoginConnection getSharedInstance];
    [thirdConn setServiceUrlScheme:kServiceAppUrlScheme];
    [thirdConn setConsumerKey:kConsumerKey];
    [thirdConn setConsumerSecret:kConsumerSecret];
    [thirdConn setAppName:kServiceAppName];
    
    [thirdConn setIsInAppOauthEnable:YES];
    [thirdConn setIsNaverAppOauthEnable:YES];
    
    
    return [[FBSDKApplicationDelegate sharedInstance] application:application didFinishLaunchingWithOptions:launchOptions];
}

- (UIInterfaceOrientationMask)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window{
    
    UIViewController *topController = self.window.rootViewController;
    
    application.applicationIconBadgeNumber = 0;
    
    return [topController supportedInterfaceOrientations];
}


- (BOOL)application:(UIApplication*)application openURL:(NSURL*)url sourceApplication:(NSString*)sourceApplication annotation:(id)annotation {
    BOOL handled = false;
    if (self.environment.config.facebookConfig.enabled) {
        handled = [[FBSDKApplicationDelegate sharedInstance] application:application openURL:url sourceApplication:sourceApplication annotation:annotation];
        if(handled) {
            return handled;
        }

    }
    
    if (self.environment.config.googleConfig.enabled){
        handled = [[GIDSignIn sharedInstance] handleURL:url sourceApplication:sourceApplication annotation:annotation];
        [[OEXGoogleSocial sharedInstance] setHandledOpenUrl:YES];
    }
    
    if (self.environment.config.kakaoConfig.enabled){
        if ([KOSession isKakaoAccountLoginCallback:url]) {
            return [KOSession handleOpenURL:url];
        }
    }
    
    if (self.environment.config.naverConfig.enabled){
        NSLog(@"annotation");
        return [[NaverThirdPartyLoginConnection getSharedInstance] application:application openURL:url sourceApplication:sourceApplication annotation:annotation];
    }
    
   
    return handled;
}


- (void)applicationDidBecomeActive:(UIApplication *)application
{
    [KOSession handleDidBecomeActive];
}




// Respond to URI scheme links
- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey,id> *)options {
    // pass the url to the handle deep link call
    BOOL handled = false;
    if (self.environment.config.fabricConfig.kits.branchConfig.enabled) {
        handled = [[Branch getInstance] application:app openURL:url options:options];
        if (handled) {
            return handled;
        }
    }
    
    if (self.environment.config.facebookConfig.enabled) {
        handled = [[FBSDKApplicationDelegate sharedInstance] application:app openURL:url options:options];
        if (handled) {
            return handled;
        }
    }
    
    if (self.environment.config.googleConfig.enabled){
        handled = [[GIDSignIn sharedInstance] handleURL:url
                                   sourceApplication:options[UIApplicationOpenURLOptionsSourceApplicationKey]
                                          annotation:options[UIApplicationOpenURLOptionsAnnotationKey]];
    }
    
    
    if (self.environment.config.kakaoConfig.enabled) {
        if ([KOSession isKakaoAccountLoginCallback:url]) {
            return [KOSession handleOpenURL:url];
        }
        
        
    }
    
    if (self.environment.config.naverConfig.enabled){
        NSLog(@"options222222222\n\n\n\n\n\n");
        return [[NaverThirdPartyLoginConnection getSharedInstance] application:app openURL:url options:options];
    }
    
    return handled;
}

// Respond to Universal Links
- (BOOL)application:(UIApplication *)application continueUserActivity:(NSUserActivity *)userActivity restorationHandler:(void (^)(NSArray *restorableObjects))restorationHandler {
    
    if (self.environment.config.fabricConfig.kits.branchConfig.enabled) {
        return [[Branch getInstance] continueUserActivity:userActivity];
    }
    return NO;
}

#pragma mark Push Notifications

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    
    NSLog(@"Remote Notification: %@", [userInfo description]);
    NSDictionary *apsInfo = [userInfo objectForKey:@"aps"];
    
    
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil
                                                        message:[apsInfo objectForKey:@"alert"]
                                                       delegate:self
                                              cancelButtonTitle:NSLocalizedString(@"OK", nil)
                                              otherButtonTitles:nil];
    
    
    [alertView show];
    
    application.applicationIconBadgeNumber = [[apsInfo objectForKey:@"badge"] integerValue];
    
//    if (userInfo[kGCMMessageIDKey]) {
//        NSLog(@"Message ID: %@", userInfo[kGCMMessageIDKey]);
//    }
    
    // Print full message.
    NSLog(@"%@", userInfo);
    
    
    [self.environment.pushNotificationManager didReceiveRemoteNotificationWithUserInfo:userInfo];
    completionHandler(UIBackgroundFetchResultNewData);
}

- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification {
    [self.environment.pushNotificationManager didReceiveLocalNotificationWithUserInfo:notification.userInfo];
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    
    NSLog(@"APNs device token retrieved: %@", deviceToken);
    
    // With swizzling disabled you must set the APNs device token here.
    
    [[FIRInstanceID instanceID] setAPNSToken:deviceToken type:FIRInstanceIDAPNSTokenTypeSandbox];
    
    [self.environment.pushNotificationManager didRegisterForRemoteNotificationsWithDeviceToken:deviceToken];
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    [self.environment.pushNotificationManager didFailToRegisterForRemoteNotificationsWithError:error];
}

#pragma mark Background Downloading

- (void)application:(UIApplication*)application handleEventsForBackgroundURLSession:(NSString*)identifier completionHandler:(void (^)())completionHandler {
    [OEXDownloadManager sharedManager];
    [self addCompletionHandler:completionHandler forSession:identifier];
}

- (void)addCompletionHandler:(void (^)())handler forSession:(NSString*)identifier {
    if(!_dictCompletionHandler) {
        _dictCompletionHandler = [[NSMutableDictionary alloc] init];
    }
    if([self.dictCompletionHandler objectForKey:identifier]) {
        OEXLogError(@"DOWNLOADS", @"Error: Got multiple handlers for a single session identifier.  This should not happen.\n");
    }
    [self.dictCompletionHandler setObject:handler forKey:identifier];
}

- (void)callCompletionHandlerForSession:(NSString*)identifier {
    dispatch_block_t handler = [self.dictCompletionHandler objectForKey: identifier];
    if(handler) {
        [self.dictCompletionHandler removeObjectForKey: identifier];
        OEXLogInfo(@"DOWNLOADS", @"Calling completion handler for session %@", identifier);
        //[self presentNotification];
        handler();
    }
}

#pragma mark Environment

- (void)setupGlobalEnvironment {
    [UserAgentOverrideOperation overrideUserAgentWithCompletion:nil];
    
    self.environment = [[OEXEnvironment alloc] init];
    [self.environment setupEnvironment];

    OEXConfig* config = self.environment.config;

    //Logging
    [DebugMenuLogger setup];

    //Rechability
    self.reachability = [[InternetReachability alloc] init];
    [_reachability startNotifier];

    //SegmentIO
    OEXSegmentConfig* segmentIO = [config segmentConfig];
    if(segmentIO.apiKey && segmentIO.isEnabled) {
        [SEGAnalytics setupWithConfiguration:[SEGAnalyticsConfiguration configurationWithWriteKey:segmentIO.apiKey]];
    }
    
    //Initialize Firebase
    if (config.isFirebaseEnabled) {
        [FIRApp configure];
        
        if (floor(NSFoundationVersionNumber) <= NSFoundationVersionNumber_iOS_9_x_Max) {
            UIUserNotificationType allNotificationTypes =
            (UIUserNotificationTypeSound | UIUserNotificationTypeAlert | UIUserNotificationTypeBadge);
            UIUserNotificationSettings *settings =
            [UIUserNotificationSettings settingsForTypes:allNotificationTypes categories:nil];
            [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
        } else {
            // iOS 10 or later
#if defined(__IPHONE_10_0) && __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_10_0
            // For iOS 10 display notification (sent via APNS)
            [UNUserNotificationCenter currentNotificationCenter].delegate = self;
            UNAuthorizationOptions authOptions =
            UNAuthorizationOptionAlert
            | UNAuthorizationOptionSound
            | UNAuthorizationOptionBadge;
            [[UNUserNotificationCenter currentNotificationCenter] requestAuthorizationWithOptions:authOptions completionHandler:^(BOOL granted, NSError * _Nullable error) {
            }];
#endif
        }
        
        [[UIApplication sharedApplication] registerForRemoteNotifications];
       
        
        [[FIRAnalyticsConfiguration sharedInstance] setAnalyticsCollectionEnabled:YES];
    }

    //NewRelic Initialization with edx key
    OEXNewRelicConfig* newrelic = [config newRelicConfig];
    if(newrelic.apiKey && newrelic.isEnabled) {
        [NewRelicAgent enableCrashReporting:NO];
        [NewRelicAgent startWithApplicationToken:newrelic.apiKey];
    }

    //Initialize Fabric
    OEXFabricConfig* fabric = [config fabricConfig];
    if(fabric.appKey && fabric.isEnabled) {
        [Fabric with:@[CrashlyticsKit]];
    }
    
}

- (void) configureFabricKits:(NSDictionary*) launchOptions {
    if (self.environment.config.fabricConfig.kits.branchConfig.enabled) {
        [Branch setBranchKey:self.environment.config.fabricConfig.kits.branchConfig.branchKey];
        if ([Branch branchKey]){
            [[Branch getInstance] initSessionWithLaunchOptions:launchOptions andRegisterDeepLinkHandler:^(NSDictionary *params, NSError *error) {
                // params are the deep linked params associated with the link that the user clicked -> was re-directed to this app
                // params will be empty if no data found
            }];
        }
    }
}

@end
