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
        
        UIImage *image = [UIImage imageNamed:@"background.jpeg"];
        
        self.view.backgroundColor = [UIColor colorWithPatternImage:image];
    }
    return self;
}

- (void)viewDidDisappear:(BOOL)animated
{
    [self.locationManager stopUpdatingLocation];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self init];
     
    //从本地plist文件读取所有城市信息
    NSArray *localCitys = [[NSUserDefaults standardUserDefaults] valueForKey:LOCAL_SAVED_CITYS];
    
    
    if (localCitys.count > 0) {
        _hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        //取第一个城市信息
        NSString *cityCode = [[localCitys objectAtIndex:0] objectForKey:CITY_CODE];;
        
        [self getWeatherWithCityCode:cityCode];
    }
    else
    {
        _alert = [[SCLAlertView alloc] initWithNewWindow];
        [_alert showTitle:@"请添加你的城市"
                 subTitle:nil
                    style:Info
         closeButtonTitle:@"好"
                 duration:0.0f];
    }
    
    
    //[self locate];
}



- (void)locate

{
    // 判断定位操作是否被允许
    if([CLLocationManager locationServicesEnabled]) {
        self.locationManager = [[CLLocationManager alloc] init] ;
        self.locationManager.delegate = self;
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        self.locationManager.distanceFilter = 10.0f;
        [self.locationManager requestAlwaysAuthorization];
        
        // 开始定位
        [self.locationManager startUpdatingLocation];
    }
    else
    {
        //提示用户无法进行定位操作
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示"
                                                            message:@"定位不成功 ,请确认开启定位"
                                                           delegate:nil
                                                  cancelButtonTitle:@"取消"
                                                  otherButtonTitles:@"确定", nil];
        
        [alertView show];
        
    }
}

#pragma mark - CoreLocation Delegate
- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation {
    NSLog(@"%@",[NSString stringWithFormat:@"经度:%3.5f\n纬度:%3.5f",newLocation.coordinate.latitude,newLocation.coordinate.longitude]);
    
    CLGeocoder * geoCoder = [[CLGeocoder alloc] init];
    [geoCoder reverseGeocodeLocation:newLocation completionHandler:^(NSArray *placemarks, NSError *error) {
        for (CLPlacemark * placemark in placemarks) {
            
            NSDictionary *test = [placemark addressDictionary];
            //  Country(国家)  State(城市)  SubLocality(区)
            NSLog(@"%@", [test objectForKey:@"State"]);
        }
    }];
    
}

/*
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    CLLocation *currLocation = [locations lastObject];
    NSLog(@"经度=%f 纬度=%f 高度=%f", currLocation.coordinate.latitude, currLocation.coordinate.longitude, currLocation.altitude);
    
    CLGeocoder * geoCoder = [[CLGeocoder alloc] init];
    [geoCoder reverseGeocodeLocation:currLocation completionHandler:^(NSArray *placemarks, NSError *error) {
        for (CLPlacemark * placemark in placemarks) {
            
            NSDictionary *test = [placemark addressDictionary];
            //  Country(国家)  State(城市)  SubLocality(区)
            NSLog(@"%@", [test objectForKey:@"State"]);
        }
    }];
}


- (void)locationManager:(CLLocationManager *)manager
    didUpdateToLocation:(CLLocation *)newLocation
           fromLocation:(CLLocation *)oldLocation
{
    NSLog(@"%@",newLocation);
}

- (void)locationManager:(CLLocationManager *)manager
     didUpdateLocations:(NSArray<CLLocation *> *)locations

{
    //此处locations存储了持续更新的位置坐标值，取最后一个值为最新位置，如果不想让其持续更新位置，
    //则在此方法中获取到一个值之后让locationManager stopUpdatingLocation
    CLLocation *currentLocation = [locations lastObject];
    // 获取当前所在的城市名
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    //根据经纬度反向地理编译出地址信息
    [geocoder reverseGeocodeLocation:currentLocation completionHandler:^(NSArray *array, NSError *error)
    {
        if (array.count > 0)
        {
            CLPlacemark *placemark = [array objectAtIndex:0];
            //将获得的所有信息显示到label上
            NSLog(@"%@",placemark.name);
            //获取城市
            NSString *city = placemark.locality;
            if (!city) {
                //四大直辖市的城市信息无法通过locality获得，只能通过获取省份的方法来获得（如果city为空，则可知为直辖市）
                city = placemark.administrativeArea;
            }
            NSLog(@"%@",city);
        }
        else if (error == nil && [array count] == 0)
        {
            NSLog(@"No results were returned.");
        }
        else if (error != nil)
        {
            NSLog(@"An error occurred = %@", error);
        }
    }];
    //系统会一直更新数据，直到选择停止更新，因为我们只需要获得一次经纬度即可，所以获取之后就停止更新
    [manager stopUpdatingLocation];
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    if (error.code == kCLErrorDenied) {
        // 提示用户出错原因，可按住Option键点击 KCLErrorDenied的查看更多出错信息，可打印error.code值查找原因所在
    }
}
 */
 
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
