//
//  ViewController.m
//  RicHorizonMenu
//
//  Created by rice on 16/6/2.
//
//

#import "ViewController.h"
#import "RicCityDistrictionModel.h"

#import "RicHorizonMenu.h"


@interface ViewController ()<RicHorizonMenuDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.title = @"menu demo";
    
    NSData *data = [NSData dataWithContentsOfURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"zone" ofType:@"json"]]];
    
    NSArray *zones = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
    
    NSMutableArray *theZones = [NSMutableArray new];
    
    for(NSDictionary *dic in zones)
    {
        RicCityDistrictionModel *zone = [RicCityDistrictionModel new];
        [zone setValuesForKeysWithDictionary:dic];
        [theZones addObject:zone];
    }
    RicCityDistrictionModel *allZone = [RicCityDistrictionModel new];
    allZone.name = @"所有";
    [theZones insertObject:allZone atIndex:0];
    
    RicHorizonMenu *menu = [RicHorizonMenu menuWithJsonFile:nil contentViewHeight:CGRectGetHeight(self.view.bounds)-36 contentViewStyle:UITableViewStylePlain delegate:self parentVC:self];
    menu.menus =  theZones;
    
    [self.view addSubview:menu];
    
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)selectMenuAtIndex:(NSInteger)index menu:(id <RicHorizonMenuItemDataSource>)menu containerViewController:(UIViewController *)aViewController{
    NSLog(@"click at %ld",index);
}

// 如果不是tableView则内容视图使用这个方法返回对应的视图
- (UIViewController *)containerViewControllerAtIndex:(NSInteger)index menu:(id <RicHorizonMenuItemDataSource>)menu{
    UIViewController *vc = [UIViewController new];
    
    return vc;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
