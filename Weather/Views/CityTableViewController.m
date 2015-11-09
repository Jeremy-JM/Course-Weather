//
//  CityTableViewController.m
//  Weather
//
//  Created by Jeremy on 11/5/15.
//  Copyright © 2015 Yisheng. All rights reserved.
//

#import "CityTableViewController.h"

@interface CityTableViewController ()
{
    WeatherManager *_weManager;
}

@end

@implementation CityTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    //得到一个实例化的 WeatherManager 对象
    _weManager = [WeatherManager defaultManager];
    //读取本地城市列表
    _dataArray = [NSMutableArray arrayWithArray:[[NSUserDefaults standardUserDefaults] valueForKey:LOCAL_SAVED_CITYS]];
    //数组在使用的时候必须初始化，如果不初始化，将无法操作数据的实力方法。
    _filterData = [[NSArray alloc] init];
    
    //打印本地程序运行的目录，方便查看本地程序的目录。
    NSLog(@"%@",NSHomeDirectory());
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source
/*
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
#warning Incomplete implementation, return the number of sections
    return 0;
}*/


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView == self.tableView) {
        return _dataArray.count;
    }
    else
    {
        return _filterData.count;
    }
}

/**
 *  绘制每一个表格，绘制时需要初始化表格样式与数据
 *
 *  @param tableView
 *  @param indexPath
 *
 *  @return 绘制好的表格
 */
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellId = @"cellId";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }
    
    if (tableView == self.tableView) {
        cell.textLabel.text = [_dataArray[indexPath.row] objectForKey:@"city"];
    }else{
        cell.textLabel.text = [_filterData[indexPath.row] objectForKey:@"city"];
    }
    
    return cell;
}


/**
 *  选中一个表格过后，要执行的事件
 *
 *  @param tableView 操作的TabelView
 *  @param indexPath 操作的索引
 */
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //本页面上有两个TableView，一个是本页面，刚刚进入（原本）就可以看到的TableView,
    //另一个是点击搜索框会出现的一个TableView，叫ResultTableView.
    //所以下面的判断，是为了识别是哪个TableView，其他地方同样的代码也是为了判断是哪个TableView
    if (tableView == self.tableView) //传入的TableView是否是当前页面原本的TableView，否则就是ResulatTableView
    {
        //取出该城市的数据，向代码发送消息，该事件会响应到上一个页面的 sendParameter方法。
        [self.passParameters sendParameter: [_dataArray objectAtIndex:indexPath.row]];
        
        //关闭当前View
        [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    }
    else
    {
        NSDictionary *cityData = [_filterData objectAtIndex:indexPath.row];
        NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
        
        if (![self cityIsExist:cityData]) { //如果当前数据不在本地
            [_dataArray addObject:cityData]; //向数组里写入当前的城市信息对象
            [userDefault setValue:_dataArray forKey:LOCAL_SAVED_CITYS];//向本地文件定里写入数据，覆盖之前的数据
            [userDefault synchronize];//将修改提交到本地文件
            
            [self.tableView reloadData];//重载前tableview.
            
            //取出该城市的数据，向代码发送消息，该事件会响应到上一个页面的 sendParameter方法。
            [self.passParameters sendParameter: [_dataArray lastObject]];
            
            [self.navigationController dismissViewControllerAnimated:YES completion:nil];
        }
        //删除UserDefault信息的方法。
        //[userDefault removeObjectForKey:@""];
        else
        {
            //如果存在，则提示用户，该城市已经存在
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"已经添加该城市"
                                                            message:@"点击取消可返回"
                                                           delegate:nil
                                                  cancelButtonTitle:@"关闭"
                                                  otherButtonTitles:nil, nil];
            [alert show];
        }
        
        //这里需要隐藏 searchDisplayViewController.
        //[self.searchController.searchBar];
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

/**
 *  用于判断 UserDefault 里是否存在已经添加了的城市，这里只判断了城市代码(city_code)，因为城市代码是唯一的。
 *
 *  @param city 城市的完整信息 NSDictionary
 *
 *  @return 是否存在
 */
- (BOOL)cityIsExist:(NSDictionary *)city
{
    for (NSDictionary *dict in _dataArray) {
        //比较两个城市的代码是否相同
        if ([[dict objectForKey:CITY_CODE] isEqualToString:[city objectForKey:CITY_CODE]]) {
            return YES;
        }
    }
    return NO;
}


- (void)searchDisplayController:(UISearchDisplayController *)controller didLoadSearchResultsTableView:(UITableView *)tableView {
    NSLog(@"did load table");
}

/**
 *  搜索时需要重载的Result Table View
 *
 *  @param controller
 *  @param searchString
 *
 *  @return
 */
- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
    //使用代码初始化一个 UIActivityIndicatorView 控件
    UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [indicator setFrame:CGRectMake(258, 14, 18, 18)]; //设置指示器的大小与位置
    
    [indicator startAnimating]; //动画开始
    indicator.hidesWhenStopped = YES;
    [controller.searchBar addSubview:indicator];
    [_weManager cityInfoWithPinyin:searchString onSuccess:^(NSDictionary *responseObject) {
        NSLog(@"%@",responseObject);
        
        //判断返回的 errNum 是否为0，若为0 则说明没有错误。注意下面的 integer 值的取法，其他 intValue, stringValue取法也一样
        //以后要习惯使用在字典里使用 objectForKey 方法取值
        if ([[responseObject objectForKey:@"errNum"] integerValue] == 0) {
            _filterData = @[[responseObject objectForKey:@"retData"]];
        }
        else
        {
            _filterData = @[];
        }
        
        //重载结果表格
        [controller.searchResultsTableView reloadData];
        [indicator stopAnimating]; //动画停止
    }];
    return YES;
}

/**
 *  关闭当前View
 *
 *  @param sender
 */
- (IBAction)closeView:(UIBarButtonItem *)sender
{
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/


// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == self.tableView) {
        if (editingStyle == UITableViewCellEditingStyleDelete) {//如果提交的是删除操作
            // Delete the row from the data source
            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            
            [_dataArray removeObjectAtIndex:indexPath.row];//从数组(数组存在于内存里)里删除该条数据
            [[NSUserDefaults standardUserDefaults] setValue:_dataArray forKey:LOCAL_SAVED_CITYS]; //存储到UserDefault
            [[NSUserDefaults standardUserDefaults] synchronize];//同步数据到文件
            
            [tableView reloadData];
            
        } else if (editingStyle == UITableViewCellEditingStyleInsert) {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
    }
}


/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
