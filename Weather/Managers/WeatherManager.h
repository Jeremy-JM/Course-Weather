//
//  WeatherManager.h
//  Weather
//
//  Created by Jeremy on 10/23/15.
//  Copyright © 2015 Yisheng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NetwrokManager.h"

@interface WeatherManager : NSObject

@property (nonatomic,strong) NetwrokManager *networkManager;

+ (instancetype)defaultManager;

- (void)getWeatherByCityCode:(NSString *)citycode
                     onSuccess:(void(^)(NSDictionary *responseObject))success;

- (void)cityInfoWithPinyin:(NSString *)pinyin
                 onSuccess:(void(^)(NSDictionary *responseObject))success;

@end
