//
//  RicForumAllGroupFilterView.m
//  john
//
//  Created by rice on 16/4/13.
//  Copyright © 2016年 rice. All rights reserved.
//

#import "RicHorizonMenu.h"
#import "RicExpandBtn.h"
#import "RicHorizonMenuItemCell.h"
#import "RicHorizonMenuItem.h"
#import <WZLBadge/WZLBadgeImport.h>

@interface RicHorizonMenu ()<HorizonMenuItemDelegate,UIScrollViewDelegate>

@property (nonatomic, strong) UIViewController *parentVC;
@property (nonatomic, assign) BOOL supportExpand;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, readonly) CGFloat shrinkHeight;
@property (nonatomic, readonly) CGFloat cellHeight;
@property (nonatomic, readonly) NSInteger rowsCount;
@property (nonatomic, readonly) NSString *reusedCellId;
@property (nonatomic, strong) NSMutableArray <RicHorizonMenuItemCell *>*cells;
@property (nonatomic, strong) NSMutableArray <RicHorizonMenuItem *>*menuItems;
@property (nonatomic, strong) UIView *bottomLine;
@property (nonatomic, assign) CGRect highlightedRect;
@property (nonatomic, assign) NSInteger lastSelectedIndex;
@property (nonatomic, assign) NSInteger currentSelectedIndex;
@property (nonatomic, assign) CGFloat itemWidth;
@property (nonatomic, assign) CGFloat contentViewHeight;
@property (nonatomic, strong) UIScrollView *contentCollectionView;
@property (nonatomic, strong) NSMutableDictionary <NSString *,UIViewController *>*containerViews;
@property (nonatomic, assign) UITableViewStyle tableViewStyle;

@property (nonatomic, assign) BOOL isClickBtn;
/// 记录刚开始时的偏移量
@property (nonatomic, assign) NSInteger startOffsetX;

@end

#ifndef screenWidth
#define screenWidth   CGRectGetWidth([UIScreen mainScreen].bounds)
#endif

#ifndef screenHeight
#define screenHeight   CGRectGetHeight([UIScreen mainScreen].bounds)
#endif

static NSString *RicHorizonMenuReusedContentCellIdentify___  =   @"RicHorizonMenuReusedContentCellIdentify___";

@implementation RicHorizonMenu

+ (RicHorizonMenu *)menuWithJsonFile:(NSString *)jsonFileConfig contentViewHeight:(CGFloat)contentViewHeight contentViewStyle:(UITableViewStyle)tableViewStyle delegate:(id <RicHorizonMenuDelegate>)delegate parentVC:(UIViewController *)parentVC{
    
    NSMutableArray *itemValues = nil;
    
    if(jsonFileConfig){
        NSData *orderStatusTypesData = [NSData dataWithContentsOfURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:jsonFileConfig ofType:@"json"]]];
        NSArray *orderStatusTypes = [NSJSONSerialization JSONObjectWithData:orderStatusTypesData options:NSJSONReadingMutableContainers error:nil];
        
        itemValues = [NSMutableArray new];
        
        for(NSDictionary *dic in orderStatusTypes)
        {
            RicHorizonMenuItem *itemValue = [RicHorizonMenuItem new];
            [itemValue setValuesForKeysWithDictionary:dic];
            [itemValues addObject:itemValue];
        }
    }
    
    RicHorizonMenu *menu = [[RicHorizonMenu alloc] initWithFrame:CGRectMake(0, 0, screenWidth, [RicHorizonMenu menuHeight] + contentViewHeight) supportExpand:NO itemValues:itemValues contentViewHeight:contentViewHeight contentViewStyle:tableViewStyle delegate:delegate parentVC:parentVC];
    
    [menu updateExtendProperties:contentViewHeight menuBackgroundColor:[UIColor whiteColor] tagNormalColor:[UIColor darkGrayColor] tagHighlightedColor:[UIColor blueColor]];
    
    return menu;
}

- (void)setUpWithFrame:(CGRect)frame{
    self.cells = [NSMutableArray new];
    self.menuItems = [NSMutableArray new];
    
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0.0f, screenWidth, self.shrinkHeight)];
    self.scrollView.backgroundColor = [UIColor whiteColor];
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.showsVerticalScrollIndicator = NO;
    [self addSubview:self.scrollView];
    
    self.contentCollectionView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, screenWidth,CGRectGetHeight(self.bounds))];
    self.contentCollectionView.delegate = self;
    self.contentCollectionView.backgroundColor = self.backgroundColor;
    self.contentCollectionView.showsVerticalScrollIndicator = NO;
    self.contentCollectionView.showsHorizontalScrollIndicator = NO;
    self.contentCollectionView.pagingEnabled = YES;
    self.contentCollectionView.alwaysBounceHorizontal = YES;
    self.contentCollectionView.bouncesZoom = NO;
    
    [self addSubview:self.contentCollectionView];
    
    self.highlightedRect = CGRectMake(19, 0.0f, self.itemWidth, [RicHorizonMenu menuHeight]);
    [self bringSubviewToFront:self.scrollView];
    self.bottomLine = [[UIView alloc] initWithFrame:CGRectMake(19.0f, [RicHorizonMenu menuHeight]-1, self.itemWidth, 1.0f)];
    
    self.bottomLine.backgroundColor = [UIColor blueColor];
    self.bottomLine.hidden = NO;
    [self.scrollView addSubview:self.bottomLine];
}

- (void)updateExtendProperties:(CGFloat)contentHeight menuBackgroundColor:(UIColor *)bgColor tagNormalColor:(UIColor *)tagNormalColor tagHighlightedColor:(UIColor *)tagHighlightedColor{
    self.contentHeight = contentHeight;
    self.menuBackgroundColor = bgColor;
    self.tagNormalColor = tagNormalColor;
    self.tagHighlightedColor = tagHighlightedColor;
}

- (instancetype)initWithFrame:(CGRect)frame supportExpand:(BOOL)supportExpand contentViewHeight:(CGFloat)contentViewHeight contentViewStyle:(UITableViewStyle)tableViewStyle delegate:(id <RicHorizonMenuDelegate>)delegate parentVC:(UIViewController *)parentVC{
    self = [super initWithFrame:frame];
    if(self){
        self.parentVC = parentVC;
        self.delegate = delegate;
        self.currentSelectedIndex = -1;
        self.contentViewHeight = contentViewHeight;
        self.supportExpand = supportExpand;
        [self setUpWithFrame:frame];
        self.tableViewStyle = tableViewStyle;
        self.containerViewInsets = UIEdgeInsetsZero;
        self.isClickBtn = NO;
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame supportExpand:(BOOL)supportExpand itemValues:(NSArray <id <RicHorizonMenuItemDataSource>>*)itemValues contentViewHeight:(CGFloat)contentViewHeight contentViewStyle:(UITableViewStyle)tableViewStyle delegate:(id <RicHorizonMenuDelegate>)delegate parentVC:(UIViewController *)parentVC{
    self = [[RicHorizonMenu alloc] initWithFrame:frame supportExpand:supportExpand contentViewHeight:contentViewHeight contentViewStyle:tableViewStyle delegate:delegate parentVC:(UIViewController *)parentVC];
    if(self){
        self.menus = [itemValues mutableCopy];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    
    if(self){
        self.supportExpand = YES;
        [self setUpWithFrame:frame];
    }
    return self;
}
- (void)setBackgroundColor:(UIColor *)backgroundColor{
    [super setBackgroundColor:backgroundColor];
    self.contentCollectionView.backgroundColor = backgroundColor;
}
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    self.isClickBtn = NO;
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    CGFloat width = CGRectGetWidth(scrollView.bounds);
    CGFloat x = scrollView.contentOffset.x;
    NSInteger idx = MAX(floor(x/width), 0);
    [self clickedMenuItemAtIndex:idx];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if(self.isClickBtn){
        return;
    }
    CGFloat maxX = MAX(0, (self.menuItems.count - 1) * CGRectGetWidth(self.scrollView.frame));
    CGFloat currentOffsetX = MIN(MAX(scrollView.contentOffset.x, 0), maxX);
    CGFloat scrollViewWidth = CGRectGetWidth(self.scrollView.frame);
    CGRect bottomFrame = self.bottomLine.frame;
    bottomFrame.origin.x = currentOffsetX/scrollViewWidth * CGRectGetWidth(bottomFrame);
    self.bottomLine.frame = bottomFrame;
}

- (void)updateCurrentSelectedIndex:(NSUInteger)currentSelectedIndex{
    if(currentSelectedIndex < self.menuItems.count){
        [self clickedMenuItemAtIndex:currentSelectedIndex];
    }
    self.currentSelectedIndex = currentSelectedIndex;
}
#pragma mark - logic for top menu.
- (void)setMenuBackgroundColor:(UIColor *)menuBackgroundColor
{
    _menuBackgroundColor = menuBackgroundColor;
    self.scrollView.backgroundColor = _menuBackgroundColor;
}

- (void)setTagNormalColor:(UIColor *)tagNormalColor
{
    _tagNormalColor = tagNormalColor;
    [self.cells enumerateObjectsUsingBlock:^(RicHorizonMenuItemCell * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        obj.normalColor = tagNormalColor;
    }];
}

- (void)setTagHighlightedColor:(UIColor *)tagHighlightedColor
{
    _tagHighlightedColor = tagHighlightedColor;
    [self.cells enumerateObjectsUsingBlock:^(RicHorizonMenuItemCell * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        obj.highlightedColor = tagHighlightedColor;
    }];
}

- (void)shuiPinPaiBan{
    
    for(int i=0; i<self.cells.count ; i++){
        RicHorizonMenuItemCell *cell = self.cells[i];
        cell.frame = CGRectMake(i*(self.itemWidth), 0.0f, self.itemWidth, [RicHorizonMenu menuHeight]);
        RicHorizonMenuItem *menuItem = self.menuItems[i];
        if(menuItem.isSelected){
            self.bottomLine.frame = CGRectMake(CGRectGetMinX(cell.frame), CGRectGetMaxY(cell.frame)-1.0, self.itemWidth, 1.0f);
            self.highlightedRect = cell.frame;
        }
    }
}

- (void)setMenus:(NSArray<id<RicHorizonMenuItemDataSource>> *)menus
{
    _menus = menus;
    if(_menus.count > 0){
        CGFloat maxVisableCount = MAX(1, MIN(_menus.count, 5));
        self.itemWidth = (screenWidth - (MAX(_menus.count - 1, 0)))/maxVisableCount;
        if(self.itemWidth == 0){
            self.itemWidth = 120;
        }
    }
    [_menuItems removeAllObjects];
    for(int i=0;i<menus.count; i++)
    {
        id<RicHorizonMenuItemDataSource> itemValue = _menus[i];
        RicHorizonMenuItem *menuItem = [RicHorizonMenuItem new];
        menuItem.itemValue = itemValue;
        if(i==0){
            menuItem.isSelected = YES;
        }
        [_menuItems addObject:menuItem];
    }
    self.scrollView.contentSize = CGSizeMake((self.itemWidth)*_menuItems.count, self.shrinkHeight);
    self.contentCollectionView.contentSize = CGSizeMake(_menuItems.count*CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds)-[RicHorizonMenu menuHeight]);
    for(UIView *cell in self.cells){
        [cell removeFromSuperview];
    }
    if(!self.containerViews){
        self.containerViews = [NSMutableDictionary new];
    }else{
        [self.containerViews removeAllObjects];
    }
    [self.cells removeAllObjects];
    for(int i=0; i< _menus.count; i++){
        RicHorizonMenuItemCell *cell = [[RicHorizonMenuItemCell alloc] initWithFrame:CGRectMake(i*(self.itemWidth), 0, self.itemWidth, [RicHorizonMenu menuHeight])];
        cell.delegate = self;
        cell.index = i;
        cell.normalColor = self.tagNormalColor;
        cell.highlightedColor = self.tagHighlightedColor;
        cell.item = _menuItems[i];
        [self.scrollView addSubview:cell];
        [self.cells addObject:cell];
    }
    [self shuiPinPaiBan];
    [self scrollViewDidEndDecelerating:self.contentCollectionView];
}

- (void)setContainerViewInsets:(UIEdgeInsets)containerViewInsets{
    _containerViewInsets = containerViewInsets;
    if(self.containerViews.count > 0){
        [self.containerViews enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, UIViewController*  _Nonnull aViewController, BOOL * _Nonnull stop) {
            CGRect frame = CGRectMake(self->_containerViewInsets.left+CGRectGetMinX(aViewController.view.frame), self.containerViewInsets.top+CGRectGetMinY(aViewController.view.frame), CGRectGetWidth(aViewController.view.frame)-self.containerViewInsets.left-self.containerViewInsets.right, CGRectGetHeight(aViewController.view.bounds)-self.containerViewInsets.top-self.containerViewInsets.bottom);
            aViewController.view.frame = frame;
        }];
    }
}

- (void)selectOperationForIndex:(NSInteger)index{
    for(int i=0; i<self.menuItems.count; i++){
        RicHorizonMenuItem *item = self.menuItems[i];
        item.isSelected = index == i;
        if(i < self.cells.count && i != index){
            RicHorizonMenuItemCell *cell = self.cells[i];
            [cell layoutIfNeeded];
            [cell setNeedsLayout];
        }
    }
    
    if(index < self.cells.count){
        RicHorizonMenuItemCell *cell = self.cells[index];
        if(self.currentSelectedIndex >= 0){
            [UIView animateWithDuration:0.26f animations:^{
                [cell layoutIfNeeded];
                [cell setNeedsLayout];
                self.bottomLine.frame = CGRectMake(CGRectGetMinX(cell.frame), [RicHorizonMenu menuHeight]-1.0, self.itemWidth, 1.0f);
            }];
        }
    }
    
    if(index >= self.lastSelectedIndex){
        //往右
        NSInteger scrollToIndex = index;
        if(index+1 < self.cells.count){
            scrollToIndex = index + 1;
        }
        RicHorizonMenuItemCell *nextCell = self.cells[scrollToIndex];
        if(CGRectGetMaxX(nextCell.frame) >= self.scrollView.contentOffset.x+CGRectGetWidth(self.scrollView.frame)){
            CGPoint startPoint = CGPointMake(self.scrollView.contentOffset.x+self.itemWidth, self.scrollView.contentOffset.y);
            [self.scrollView setContentOffset:startPoint animated:YES];
        }else{
            [self.scrollView scrollRectToVisible:nextCell.frame animated:YES];
        }
    }
    else {
        //往左
        NSInteger scrollToIndex = index;
        if(index-1 >= 0){
            scrollToIndex = index-1;
        }
        RicHorizonMenuItemCell *lastCell = self.cells[scrollToIndex];
        if(CGRectGetMinX(lastCell.frame)<self.scrollView.contentOffset.x){
            CGPoint startPoint = CGPointMake(lastCell.frame.origin.x, self.scrollView.contentOffset.y);
            [self.scrollView setContentOffset:startPoint animated:YES];
        }else{
            [self.scrollView scrollRectToVisible:lastCell.frame animated:YES];
        }
    }
}

- (void)setLastSelectedIndex:(NSInteger)lastSelectedIndex{
    if(self.delegate && self.lastSelectedIndex >= 0){
        id<RicHorizonMenuItemDataSource>lastItem = nil;
        if(self.menus.count > _lastSelectedIndex){
            lastItem = self.menus[_lastSelectedIndex];
        }
    }
    _lastSelectedIndex = lastSelectedIndex;
}
- (void)clickedMenuItemAtIndex:(NSInteger)index{
    self.isClickBtn = YES;
    if(index < self.menus.count){
        if(index != self.currentSelectedIndex){
            
            [self prepareContainerViewForIndex:index];
            
            [self selectOperationForIndex:index];
            
            if(self.currentSelectedIndex != index && self.lastSelectedIndex != index){
                self.lastSelectedIndex = index;
            }
            self.currentSelectedIndex = index;
            CGFloat width = CGRectGetWidth(self.contentCollectionView.bounds);
            
            [self.contentCollectionView scrollRectToVisible:CGRectMake(index * width, 0, width, CGRectGetHeight(self.contentCollectionView.bounds)) animated:YES];
            
            UIViewController *lastVC = [self.containerViews objectForKey:[self keyOfIndex:self.lastSelectedIndex]];
            if(lastVC){
                [lastVC.view removeFromSuperview];
                [lastVC removeFromParentViewController];
            }
            
            UIViewController *aViewController = [self prepareContainerViewForIndex:index];
            [aViewController willMoveToParentViewController:self.parentVC];
            [self.parentVC addChildViewController:aViewController];
            [aViewController didMoveToParentViewController:self.parentVC];
            [self.contentCollectionView addSubview:aViewController.view];
            
            
            //            self.contentCollectionView.currentContainerView = aView;
            if(self.delegate && [self.delegate respondsToSelector:@selector(selectMenuAtIndex:menu:containerViewController:)]){
                RicHorizonMenuItem *item = self.menuItems[self.currentSelectedIndex];
                [self.delegate selectMenuAtIndex:self.currentSelectedIndex menu:item.itemValue containerViewController:aViewController];
            }
        }
    }
}
- (UIViewController *)prepareContainerViewForIndex:(NSInteger)index{
    UIViewController *containerVC = nil;
    if(index < self.menuItems.count){
        RicHorizonMenuItem *item = self.menuItems[index];
        containerVC = [self.containerViews objectForKey:[self keyOfIndex:index]];
        if(!containerVC){
            if(self.delegate && [self.delegate respondsToSelector:@selector(containerViewControllerAtIndex:menu:)]){
                containerVC = [self.delegate containerViewControllerAtIndex:index menu:item.itemValue];
                if(containerVC){
                    containerVC.view.frame = CGRectMake(index*CGRectGetWidth(self.bounds), [RicHorizonMenu menuHeight], CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds)-[RicHorizonMenu menuHeight]);
                }else{
                    NSAssert(false, @"error usage");
                }
            }else{
                containerVC = [[UIViewController alloc] init];
                containerVC.view.backgroundColor = [UIColor grayColor];
                containerVC.view.frame = CGRectMake(index*CGRectGetWidth(self.bounds), [RicHorizonMenu menuHeight], CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds)-[RicHorizonMenu menuHeight]);
            }
            //reset frame.
            CGRect frame = CGRectMake(_containerViewInsets.left+CGRectGetMinX(containerVC.view.frame), self.containerViewInsets.top+CGRectGetMinY(containerVC.view.frame), CGRectGetWidth(containerVC.view.frame)-self.containerViewInsets.left-self.containerViewInsets.right, CGRectGetHeight(containerVC.view.bounds)-self.containerViewInsets.top-self.containerViewInsets.bottom);
            containerVC.view.frame = frame;
            
            NSAssert(containerVC != nil, @"请返回一个容器视图控制器");
            
            [self.containerViews setObject:containerVC forKey:[self keyOfIndex:index]];
        }
    }
    return containerVC;
}
- (NSString *)keyOfIndex:(NSInteger)index{
    return [NSString stringWithFormat:@"%ld",index];
}
- (NSInteger)rowsCount{
    return 1;
}

+ (CGFloat)menuHeight{
    return 36.0;
}
- (CGFloat)shrinkHeight{
    return self.cellHeight;
}

- (CGFloat)cellHeight {
    return [RicHorizonMenu menuHeight];
}

- (CGFloat)defaultHeight{
    return self.cellHeight;
}

- (void)makeRefreshStatus{
    if(self.delegate && [self.delegate respondsToSelector:@selector(indexsForShowStatus)]){
        NSArray *indexs = [self.delegate indexsForShowStatus];
        [self.cells enumerateObjectsUsingBlock:^(RicHorizonMenuItemCell * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if([indexs containsObject:@(idx)]){
                if(self.statusStyle == HorizonMenuStatusStyleRedDot){
                    [obj showBadge];
                }else if(self.statusStyle == HorizonMenuStatusStyleCompelete){
                    obj.compeleteIcon.hidden = NO;
                }
            }else{
                if(self.statusStyle == HorizonMenuStatusStyleRedDot){
                    [obj clearBadge];
                    
                }else if(self.statusStyle == HorizonMenuStatusStyleCompelete){
                    obj.compeleteIcon.hidden = YES;
                }
            }
        }];
    }
}


@end
