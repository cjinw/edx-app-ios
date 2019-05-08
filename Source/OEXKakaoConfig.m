//
//  OEXGoogleConfig.m
//  edXVideoLocker
//
//  Created by Jotiram Bhagat on 22/02/15.
//  Copyright (c) 2015 edX. All rights reserved.
//

#import "OEXKakaoConfig.h"

static NSString* const OEXKakaoConfigKey = @"KAKAO";

@interface OEXKakaoConfig () {
    BOOL _enabled;
}

@end

@implementation OEXKakaoConfig

- (instancetype)initWithDictionary:(NSDictionary*)dictionary {
    self = [super init];
    if(self) {
        _enabled = [dictionary[@"ENABLED"] boolValue];
//        _apiKey = dictionary[@"GOOGLE_PLUS_KEY"];
    }
    return self;
}

- (BOOL)isEnabled
{
    //In order for Google+ To work, the API Key must also be set.
//    return _enabled && _apiKey != nil;
    return _enabled;

}

@end

@implementation OEXConfig (Kakao)

- (OEXKakaoConfig*)kakaoConfig {
    NSDictionary* dictionary = [self objectForKey:OEXKakaoConfigKey];
    OEXKakaoConfig* kakaoConfig = [[OEXKakaoConfig alloc] initWithDictionary:dictionary];
    return kakaoConfig;
}

@end
