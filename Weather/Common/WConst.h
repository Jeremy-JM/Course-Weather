//
//  WConst.h
//  Weather
//
//  Created by Jeremy on 10/23/15.
//  Copyright © 2015 Yisheng. All rights reserved.
//

#import <Foundation/Foundation.h>

//Const
//Baidu api key
#define BAIDU_APIKEY @"3fb17e810b0a286f848bb7ac5bfabb4c"

//API
//当天天气详情 + 带历史7天和未来4天的天气
#define API_RECENTWEATHERS @"http://apis.baidu.com/apistore/weatherservice/recentweathers"

//根据拼音查询城市信息
#define API_WEATHER @"http://apis.baidu.com/apistore/weatherservice/weather"

//本地存储的城市信息
#define LOCAL_SAVED_CITYS @"LOCAL_SAVED_CITYS"

#define CITY_CODE @"citycode"

@interface WConst : NSObject

@end
