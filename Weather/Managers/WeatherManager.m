//
//  WeatherManager.m
//  Weather
//
//  Created by Jeremy on 10/23/15.
//  Copyright © 2015 Yisheng. All rights reserved.
//

#import "WeatherManager.h"

@implementation WeatherManager

+ (instancetype)defaultManager
{
    return [[self alloc] init];
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _networkManager = [[NetwrokManager alloc] init];
    }
    return self;
}


- (void)getWeatherByCityCode:(NSString *)citycode
                     onSuccess:(void(^)(NSDictionary *responseObject))success
{
    NSDictionary *parameters = @{/*@"cityname":@"成都",*/
                                 @"cityid"  :citycode};
    
    [_networkManager getJsonFromURL:API_RECENTWEATHERS
                     withParameters:parameters
                          onSuccess:success];
}

/**
 *  Get the city info by the pinyin string.
 *
 *  @param pinyin Pinyin code, only input a full string can get a result.
 *  @param success The code will execute when the request executed successfully.
 */
- (void)cityInfoWithPinyin:(NSString *)pinyin
                 onSuccess:(void(^)(NSDictionary *responseObject))success
{
    NSDictionary *parameters = @{@"citypinyin":pinyin};
    
    [_networkManager getJsonFromURL:API_WEATHER
                     withParameters:parameters
                          onSuccess:success];
}

@end
