//
//  OEXGoogleConfig.h
//  edXVideoLocker
//
//  Created by Jotiram Bhagat on 22/02/15.
//  Copyright (c) 2015-2016 edX. All rights reserved.
//

#import "OEXConfig.h"

NS_ASSUME_NONNULL_BEGIN

@interface OEXNaverConfig : NSObject
@property(nonatomic, readonly, assign, getter = isEnabled) BOOL enabled;
@property(nonatomic, readonly, copy, nullable) NSString* apiKey;
@property(nonatomic, readonly, copy, nullable) NSString* apiKey2;

- (instancetype)initWithDictionary:(NSDictionary*)dictionary;

@end

@interface OEXConfig (Naver)

@property (nullable, readonly, strong, nonatomic) OEXNaverConfig* naverConfig;

@end

NS_ASSUME_NONNULL_END
