//
//  NetwrokManager.m
//  Weather
//
//  Created by Jeremy on 10/23/15.
//  Copyright © 2015 Yisheng. All rights reserved.
//

#import "NetwrokManager.h"

@implementation NetwrokManager

- (instancetype)init
{
    self = [super init];
    if (self) {
        _manager = [AFHTTPRequestOperationManager manager];
        [_manager.requestSerializer setValue:BAIDU_APIKEY
                          forHTTPHeaderField:@"apikey"];
    }
    return self;
}

- (void)getJsonFromURL:(NSString *)url
        withParameters:(NSDictionary *)parameters
             onSuccess:(void(^)(NSDictionary *responseObject))success
{
    _manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects: @"text/html", nil];
    
    [_manager GET:url
       parameters: parameters
          success:^(AFHTTPRequestOperation *operation, id responseObject){
              if (responseObject)
              {
                  success(responseObject);
              } else {
                  success(nil);
              }
          }
          failure:^(AFHTTPRequestOperation *operation, NSError *error) {
              NSLog(@"Send Message Failed, %@",error.userInfo);
          }];
}

@end
