//
//  WeParameter.h
//  Weather
//
//  Created by Jeremy on 11/7/15.
//  Copyright © 2015 Yisheng. All rights reserved.
//

#import <Foundation/Foundation.h>

//页面与页面之前传参，除了用代理(delegate)，还可以用NSNotificationCenter(通知：一种传编程概念)
@protocol ParameterDelegate <NSObject>

/**
 *  本方法只用于传参
 *
 *  @param para 传入的参数
 */
- (void)sendParameter:(NSDictionary *)para;

@end
