//
//  OEXGoogleConfig.m
//  edXVideoLocker
//
//  Created by Jotiram Bhagat on 22/02/15.
//  Copyright (c) 2015 edX. All rights reserved.
//

#import "OEXNaverConfig.h"

static NSString* const OEXNaverConfigKey = @"NAVER";

@interface OEXNaverConfig () {
    BOOL _enabled;
}

@end

@implementation OEXNaverConfig

- (instancetype)initWithDictionary:(NSDictionary*)dictionary {
    self = [super init];
        if(self) {
        _enabled = [dictionary[@"ENABLED"] boolValue];
        _apiKey = dictionary[@"CONSUMERKEY"];
        _apiKey2 = dictionary[@"CONSUMERSECRET"];
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

@implementation OEXConfig (Naver)

- (OEXNaverConfig*)naverConfig {
    NSDictionary* dictionary = [self objectForKey:OEXNaverConfigKey];
    OEXNaverConfig* naverConfig = [[OEXNaverConfig alloc] initWithDictionary:dictionary];
    return naverConfig;
}

@end
