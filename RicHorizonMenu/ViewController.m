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


@interface ViewController ()//<UITableViewDataSource,UITableViewDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
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
    
    RicHorizonMenu *menu = [[RicHorizonMenu alloc] initWithFrame:CGRectMake(0, 64.0f, CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds)-64.0f) supportExpand:YES];
    
    [menu updateExtendProperties:CGRectGetHeight(self.view.bounds)-64.0f menuBackgroundColor:[UIColor whiteColor] tagNormalColor:[UIColor lightGrayColor] tagHighlightedColor:[UIColor redColor]];
    
    menu.menus = theZones;
    
    [self.view addSubview:menu];
    
    
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
