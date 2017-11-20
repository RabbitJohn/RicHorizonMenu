//
//  RicHorizonMenuContentCell.m
//  RicHorizonMenu
//
//  Created by rice on 16/6/2.
//
//

#import "RicHorizonMenuContentCell.h"

@interface RicHorizonMenuContentCell ()

@property (nonatomic, strong) RicHorizonMenuTableView *tableView;

@end


@implementation RicHorizonMenuContentCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self){
        [self setUpSubViews];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if(self)
    {
        [self setUpSubViews];
    }
    return self;
}

- (void)setUpSubViews
{
    self.tableView = [[RicHorizonMenuTableView alloc] initWithFrame:self.bounds];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self addSubview:self.tableView];
    
}

- (void)setMenuIdx:(NSInteger)menuIdx
{
    _menuIdx = menuIdx;
    [self.tableView setValue:@(_menuIdx) forKey:@"menuIndex"];
}

@end
