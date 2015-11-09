//
//  NetwrokManager.h
//  Weather
//
//  Created by Jeremy on 10/23/15.
//  Copyright © 2015 Yisheng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WConst.h"
#import "AFNetworking.h"

@interface NetwrokManager : NSObject

@property (nonatomic, strong) AFHTTPRequestOperationManager *manager;


- (void)getJsonFromURL:(NSString *)url
        withParameters:(NSDictionary *)parameters
             onSuccess:(void(^)(NSDictionary *responseObject))success;

@end
