//
//  RicForumAllGroupFilterView.h
//  john
//
//  Created by rice on 16/4/13.
//  Copyright © 2016年 rice. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RicHorizonMenuItemCell.h"

typedef NS_ENUM(NSInteger, HorizonMenuStatusStyle) {
    HorizonMenuStatusStyleRedDot,
    HorizonMenuStatusStyleCompelete
};

@protocol RicHorizonMenuDelegate <NSObject>

@optional

// 选中某个菜单后做的事情
- (void)selectMenuAtIndex:(NSInteger)index menu:(id <RicHorizonMenuItemDataSource>)menu containerViewController:(UIViewController *)aViewController;

// 如果不是tableView则内容视图使用这个方法返回对应的视图
- (UIViewController *)containerViewControllerAtIndex:(NSInteger)index menu:(id <RicHorizonMenuItemDataSource>)menu;

- (NSArray <NSNumber *>*)indexsForShowStatus;

@end

/// 全部小组筛选
@interface RicHorizonMenu : UIView

@property (nonatomic, strong, readonly) UIViewController *parentVC;
@property (nonatomic, strong) NSArray <id <RicHorizonMenuItemDataSource>>*menus;

@property (nonatomic, weak) id <RicHorizonMenuDelegate> delegate;


@property (nonatomic, strong) UIColor *menuBackgroundColor;
@property (nonatomic, strong) UIColor *tagNormalColor;
@property (nonatomic, strong) UIColor *tagHighlightedColor;
@property (nonatomic, assign) UIEdgeInsets containerViewInsets;
@property (nonatomic, assign, readonly) BOOL supportExpand;
@property (nonatomic, assign) CGFloat contentHeight;
@property (nonatomic, readonly) CGFloat defaultHeight;
@property (nonatomic, assign) HorizonMenuStatusStyle statusStyle;

@property (nonatomic, readonly) NSInteger currentSelectedIndex;


- (instancetype)initWithFrame:(CGRect)frame supportExpand:(BOOL)supportExpand contentViewHeight:(CGFloat)contentViewHeight contentViewStyle:(UITableViewStyle)tableViewStyle delegate:(id <RicHorizonMenuDelegate>)delegat parentVC:(UIViewController *)parentVC;

- (instancetype)initWithFrame:(CGRect)frame supportExpand:(BOOL)supportExpand itemValues:(NSArray <id <RicHorizonMenuItemDataSource>>*)itemValues contentViewHeight:(CGFloat)contentViewHeight contentViewStyle:(UITableViewStyle)tableViewStyle delegate:(id <RicHorizonMenuDelegate>)delegate parentVC:(UIViewController *)parentVC;

+ (RicHorizonMenu *)menuWithJsonFile:(NSString *)jsonFileConfig contentViewHeight:(CGFloat)contentViewHeight contentViewStyle:(UITableViewStyle)tableViewStyle delegate:(id <RicHorizonMenuDelegate>)delegate parentVC:(UIViewController *)parentVC;

- (void)updateExtendProperties:(CGFloat)contentHeight menuBackgroundColor:(UIColor *)bgColor tagNormalColor:(UIColor *)tagNormalColor tagHighlightedColor:(UIColor *)tagHighlightedColor;

- (void)updateCurrentSelectedIndex:(NSUInteger)currentSelectedIndex;

+ (CGFloat)menuHeight;

- (void)makeRefreshStatus;

@end
