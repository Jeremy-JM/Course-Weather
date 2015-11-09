//
//  MainViewController.m
//  Weather
//
//  Created by Jeremy on 10/23/15.
//  Copyright © 2015 Yisheng. All rights reserved.
//

#import "MainViewController.h"

#import "SCLAlertView.h"

@interface MainViewController ()
{
    WeatherManager *_weManager;
    
    MBProgressHUD *_hud;
    
    SCLAlertView *_alert;
    
    NSDictionary *_currentCity;
}

@end

@implementation MainViewController

//- (instancetype)initWithCoder:(NSCoder *)coder
//{
//    self = [super initWithCoder:coder];
//    if (self) {
//        
//    }
//    return self;
//}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _weManager = [[WeatherManager alloc] init];
        //_hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        
        UIImage *image = [UIImage imageNamed:@"background.jpeg"];
        
        self.view.backgroundColor = [UIColor colorWithPatternImage:image];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self init];
    
    //从本地plist文件读取所有城市信息
    NSArray *localCitys = [[NSUserDefaults standardUserDefaults] valueForKey:LOCAL_SAVED_CITYS];
    
    
    if (localCitys.count > 0) {
        //取第一个城市信息
        NSString *cityCode = [[localCitys objectAtIndex:0] objectForKey:CITY_CODE];;
        
        [self getWeatherWithCityCode:cityCode];
    }
    
    //_alert = [[SCLAlertView alloc] initWithNewWindow];
    //[_alert showSuccess:@"成功" subTitle:@"这是副标题" closeButtonTitle:@"关闭" duration:.0f];
    
    
    
    //[_alert showSuccess:@"成功1" subTitle:@"这是副标题1" closeButtonTitle:@"关闭1" duration:3.0f];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)getWeatherWithCityCode:(NSString *)cityCode
{
    _hud.labelText = @"正在从网络获取数据...";
    [_hud show:YES];
    
    [_weManager getWeatherByCityCode:cityCode onSuccess:^(NSDictionary *responseObject) {
        
        if ([[responseObject objectForKey:@"errNum"] integerValue] == 0) {
            NSDictionary *returnData = [responseObject objectForKey:@"retData"];
            NSDictionary *today = [returnData objectForKey:@"today"];
            _mainCurrentTemp.text = [today objectForKey:@"curTemp"]; //当前温度。
            _mainCityName.text = [returnData objectForKey:@"city"];
            _mainHighTemp.text = [today objectForKey:@"hightemp"];
            _mainLowTemp.text = [today objectForKey:@"lowtemp"];
            
            
            [_hud hide:YES];
        }
        
    }];
}

- (void)sendParameter:(NSDictionary *)para
{
    _currentCity = para;
    [self getWeatherWithCityCode:[_currentCity objectForKey:CITY_CODE]];
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    UINavigationController *navi =  (UINavigationController *)segue.destinationViewController;
    CityTableViewController *city = (CityTableViewController *)[navi.viewControllers objectAtIndex:0];
    city.passParameters = self;
}


@end
