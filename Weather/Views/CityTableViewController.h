//
//  CityTableViewController.h
//  Weather
//
//  Created by Jeremy on 11/5/15.
//  Copyright © 2015 Yisheng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WConst.h"
#import "WeParameter.h"
#import "WeatherManager.h"

@interface CityTableViewController : UITableViewController<UISearchBarDelegate, UISearchDisplayDelegate>

/**
 *  搜索的控制器
 */
@property (strong, nonatomic) IBOutlet UISearchDisplayController *searchController;

/**
 *  当前页面的TableView的数据源
 */
@property (strong, nonatomic) NSMutableArray *dataArray;
/**
 *  筛选视图的TableView的数据源
 */
@property (strong, nonatomic) NSArray *filterData;

/**
 *  用于页面回传的代码
 */
@property (strong, nonatomic) id<ParameterDelegate> passParameters;

@end
