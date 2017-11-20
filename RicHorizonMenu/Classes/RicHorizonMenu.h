//
//  RicForumAllGroupFilterView.h
//  john
//
//  Created by rice on 16/4/13.
//  Copyright © 2016年 rice. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RicHorizonMenuItemCell.h"
#import "RicHorizonMenuContentCell.h"

@protocol RicHorizonMenuDelegate <NSObject>

@optional

// 配置tableView 比如配置tableView的背景,配置下来刷新和加载更多。
- (void)configTableView:(UITableView *)tableView ofMenuIndex:(NSInteger)menuIndex;

// 选中某个菜单后做的事情
- (void)selectMenuAtIndex:(NSInteger)index menu:(id)menu;

@end

/// 全部小组筛选
@interface RicHorizonMenu : UIView

@property (nonatomic, weak) id <RicHorizonMenuDelegate> delegate;

@property (nonatomic, strong) NSArray <id <RicHorizonMenuItemDataSource>>*menus;

@property (nonatomic, assign) CGFloat expandHeight;

@property (nonatomic, readonly) CGFloat defaultHeight;

@property (nonatomic, readonly) NSInteger currentSelectedIndex;

@property (nonatomic, strong) UIColor *menuBackgroundColor;
@property (nonatomic, strong) UIColor *tagNormalColor;
@property (nonatomic, strong) UIColor *tagHighlightedColor;
@property (nonatomic, strong) UIColor *maskColor;

@end
