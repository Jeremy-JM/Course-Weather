//
//  MainViewController.h
//  Weather
//
//  Created by Jeremy on 10/23/15.
//  Copyright © 2015 Yisheng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WeatherManager.h"
#import "MBProgressHUD.h"
#import "WeParameter.h"
#import "WConst.h"

#import "CityTableViewController.h"

@interface MainViewController : UIViewController<ParameterDelegate>

@property (weak, nonatomic) IBOutlet UIScrollView *mainScrollView;
@property (weak, nonatomic) IBOutlet UILabel *mainCurrentTemp;
@property (weak, nonatomic) IBOutlet UILabel *mainCityName;
@property (weak, nonatomic) IBOutlet UILabel *mainHighTemp;
@property (weak, nonatomic) IBOutlet UILabel *mainLowTemp;
@property (weak, nonatomic) IBOutlet UIView *mainContentView;



@end
