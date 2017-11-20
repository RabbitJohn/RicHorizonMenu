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
#import "RicHorizonMenuContentCell.h"
#import "RicHorizonMenuItem.h"

@interface RicHorizonMenu ()<RicHorizonMenuItemDelegate,UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic, assign) BOOL supportExpand;
@property (nonatomic, strong) UIView *scrollBG;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) RicExpandBtn *expandBtn;
@property (nonatomic, readonly) CGFloat collectionViewExpandHeight;
@property (nonatomic, readonly) CGFloat shrinkHeight;
@property (nonatomic, readonly) CGFloat cellHeight;
@property (nonatomic, readonly) NSInteger rowsCount;
@property (nonatomic, readonly) NSString *reusedCellId;
@property (nonatomic, strong) NSMutableArray <RicHorizonMenuItemCell *>*cells;
@property (nonatomic, strong) NSMutableArray <RicHorizonMenuItem *>*menuItems;
@property (nonatomic, assign) BOOL isExpand;
@property (nonatomic, strong) UIView *bottomLine;
@property (nonatomic, assign) CGRect highlightedRect;
@property (nonatomic, assign) NSInteger lastSelectedIndex;
@property (nonatomic, assign) NSInteger currentSelectedIndex;
@property (nonatomic, readonly) CGFloat horizonGap;

@property (nonatomic, strong) UICollectionView *contentCollectionView;

@property (nonatomic, strong) UIView *mask;

/**
 每行的数量
 */
@property (nonatomic, assign) NSInteger columnCount;

- (void)shrinkOrExpand;

@end

#ifndef screenWidth
#define screenWidth   CGRectGetWidth([UIScreen mainScreen].bounds)
#endif

#ifndef screenHeight
#define screenHeight   CGRectGetHeight([UIScreen mainScreen].bounds)
#endif

static NSString *RicHorizonMenuReusedContentCellIdentify___  =   @"RicHorizonMenuReusedContentCellIdentify___";

@implementation RicHorizonMenu

- (void)setUpWithFrame:(CGRect)frame{
    self.scrollBG = [[UIView alloc] init];
    [self addSubview:self.scrollBG];
    self.cells = [NSMutableArray new];
    self.menuItems = [NSMutableArray new];
    self.columnCount = screenWidth > 320.0f ? 5 : 4;
    self.expandHeight = screenHeight - 64.0f;
    
    CGFloat offset = self.supportExpand ? 36 : 0;
    
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(7.0f, 0.0f, screenWidth-offset, self.shrinkHeight)];
    self.scrollView.backgroundColor = [UIColor whiteColor];
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.showsVerticalScrollIndicator = NO;
    self.scrollBG.frame = CGRectMake(0.0, 0.0f, screenWidth, CGRectGetHeight(self.scrollView.frame));
    [self addSubview:self.scrollView];
    CGFloat contentViewHeight = screenHeight - 64.0f - self.shrinkHeight;
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.minimumInteritemSpacing = 0.0f;
    layout.minimumLineSpacing = 0.0f;
    layout.sectionInset = UIEdgeInsetsZero;
    layout.itemSize = CGSizeMake(screenWidth, contentViewHeight);
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    
    self.contentCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, self.shrinkHeight, screenWidth,contentViewHeight) collectionViewLayout:layout];
    self.contentCollectionView.delegate = self;
    self.contentCollectionView.dataSource = self;
    self.contentCollectionView.backgroundColor = [UIColor clearColor];
    self.contentCollectionView.showsVerticalScrollIndicator = NO;
    self.contentCollectionView.showsHorizontalScrollIndicator = NO;
    self.contentCollectionView.pagingEnabled = YES;
    [self.contentCollectionView registerClass:[RicHorizonMenuContentCell class] forCellWithReuseIdentifier:RicHorizonMenuReusedContentCellIdentify___];
    
    [self addSubview:self.contentCollectionView];
    if(self.supportExpand){
        self.scrollBG.backgroundColor = self.scrollView.backgroundColor;
        self.expandBtn = [RicExpandBtn new];
        self.expandBtn.touchAreaRadius = 50.0f;
        self.expandBtn.frame = CGRectMake(screenWidth-23.5f, 20.0f, 13.5f, 7.5f);
        [self.expandBtn setImage:[UIImage imageNamed:@"ic_details_down_arrows"] forState:UIControlStateNormal];
        [self.expandBtn addTarget:self action:@selector(shrinkOrExpand) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.expandBtn];
        
        self.bottomLine = [[UIView alloc] initWithFrame:CGRectMake(19.0f, 45.0f, 30.0f, 1.0f)];
        self.bottomLine.backgroundColor = [UIColor redColor];
        [self.scrollView addSubview:self.bottomLine];
        
        self.highlightedRect = CGRectMake(19, 0.0f, 30.0f, 45.0f);
        [self bringSubviewToFront:self.scrollBG];
        [self bringSubviewToFront:self.scrollView];
        [self bringSubviewToFront:self.expandBtn];
        
        self.mask = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.bounds), self.expandHeight - self.shrinkHeight)];
        self.mask.backgroundColor = [UIColor whiteColor];
        self.mask.hidden = YES;
        [self.contentCollectionView addSubview:self.mask];
    }
}

- (void)updateExtendProperties:(CGFloat)expandHeight menuBackgroundColor:(UIColor *)bgColor tagNormalColor:(UIColor *)tagNormalColor tagHighlightedColor:(UIColor *)tagHighlightedColor{
    self.expandHeight = expandHeight;
    self.menuBackgroundColor = bgColor;
    self.tagNormalColor = tagNormalColor;
    self.tagHighlightedColor = tagHighlightedColor;
}

- (instancetype)initWithFrame:(CGRect)frame supportExpand:(BOOL)supportExpand{
    self = [super initWithFrame:frame];
    if(self){
        self.supportExpand = supportExpand;
        [self setUpWithFrame:frame];
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

#pragma mark -logic for collectionView.
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.menus.count;
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    RicHorizonMenuContentCell *riCell = (RicHorizonMenuContentCell *)[collectionView dequeueReusableCellWithReuseIdentifier:RicHorizonMenuReusedContentCellIdentify___ forIndexPath:indexPath];
    
    riCell.menuIdx = indexPath.item;
    riCell.tableView.backgroundColor = [UIColor colorWithRed:(random()%255)*1.0f/255.0f green:(random()%255)*1.0f/255.0f blue:(random()%255)*1.0f/255.0f alpha:1];
    if(self.delegate && [self.delegate respondsToSelector:@selector(configTableView:ofMenuIndex:)]){
        [self.delegate configTableView:riCell.tableView ofMenuIndex:riCell.menuIdx];
    }
    return riCell;
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return  CGSizeMake(screenWidth,self.expandHeight);
}

-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    UIEdgeInsets top = {0,0,0,0};
    return top;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    CGFloat width = CGRectGetWidth(scrollView.bounds);
    if(width){
        CGFloat x = scrollView.contentOffset.x;
        
        NSInteger idx = floor(x/width);
        
        [self clickedMenuItemAtIndex:idx];
    }
}


#pragma mark - logic for top menu.
- (void)setMaskColor:(UIColor *)maskColor
{
    _maskColor = maskColor;
    self.mask.backgroundColor = maskColor;
}
- (void)setMenuBackgroundColor:(UIColor *)menuBackgroundColor
{
    _menuBackgroundColor = menuBackgroundColor;
    self.scrollView.backgroundColor = _menuBackgroundColor;
    self.scrollBG.backgroundColor = _menuBackgroundColor;
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

- (void)shrinkOrExpand{
    
    self.isExpand = !self.isExpand;
    
    if(self.isExpand){
        [UIView animateWithDuration:0.26f animations:^{
            
            CGFloat assumeHeight = self.collectionViewExpandHeight;
            
            CGFloat height =  assumeHeight> (screenHeight - 64.0f) ? (screenHeight - 64.0f) : assumeHeight;
            
            self.scrollView.frame = CGRectMake(CGRectGetMinX(self.scrollView.frame), CGRectGetMinY(self.scrollView.frame), CGRectGetWidth(self.scrollView.frame),height);
            self.scrollBG.frame = CGRectMake(0.0, 0.0f, screenWidth, self.expandHeight);

            self.scrollView.contentSize = CGSizeMake(CGRectGetWidth(self.scrollView.frame),  self.collectionViewExpandHeight);
        } completion:^(BOOL finished) {
            [self shuZhiPaiBan];
            [self.scrollView scrollRectToVisible:self.highlightedRect animated:NO];
        }];

    }else{
        [UIView animateWithDuration:0.26f animations:^{
            self.scrollView.frame = CGRectMake(CGRectGetMinX(self.scrollView.frame), CGRectGetMinY(self.scrollView.frame), CGRectGetWidth(self.scrollView.frame), self.shrinkHeight);
            self.scrollBG.frame = CGRectMake(0.0, 0.0f, screenWidth, self.shrinkHeight);
            self.scrollView.contentSize = CGSizeMake(38+(30.0f+self.horizonGap)*_menus.count, self.shrinkHeight);
            

        } completion:^(BOOL finished) {
            [self shuiPinPaiBan];
            [self.scrollView scrollRectToVisible:self.highlightedRect animated:NO];
            
            [self selectOperationForIndex:self.currentSelectedIndex];
        }];
    }
    [self.expandBtn setImage:[UIImage imageNamed:self.isExpand ? @"ic_details_up_arrows":@"ic_details_down_arrows"] forState:UIControlStateNormal];
}

- (void)shuiPinPaiBan{
    
    for(int i=0; i<self.cells.count ; i++){
        RicHorizonMenuItemCell *cell = self.cells[i];
        cell.frame = CGRectMake(19+i*(30+self.horizonGap), 0.0f, 30.0f, 45.0f);
        RicHorizonMenuItem *menuItem = self.menuItems[i];
        if(menuItem.isSelected){
            self.bottomLine.frame = CGRectMake(CGRectGetMinX(cell.frame), 45.0f, 30.0f, 1.0f);
            self.highlightedRect = cell.frame;
        }
    }
}

- (void)shuZhiPaiBan{
    
    for(int i=0; i<self.cells.count ; i++){
        RicHorizonMenuItemCell *cell = self.cells[i];
        cell.frame = CGRectMake(19+(i%self.columnCount)*(30+self.horizonGap), 45.0f * (i/self.columnCount),30, 45.0f);
        RicHorizonMenuItem *item = self.menuItems[i];
        if(item.isSelected){
            self.bottomLine.frame = CGRectMake(CGRectGetMinX(cell.frame), CGRectGetMinY(cell.frame) + 45.0f, 30.0f, 1.0f);
            self.highlightedRect = cell.frame;
        }
    }
}

- (void)setMenus:(NSArray<id<RicHorizonMenuItemDataSource>> *)menus
{
    _menus = menus;
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
    self.scrollView.contentSize = CGSizeMake(38+(30.0f+self.horizonGap)*_menuItems.count, self.shrinkHeight);
    for(UIView *cell in self.cells){
        [cell removeFromSuperview];
    }
    [self.cells removeAllObjects];
    for(int i=0; i< _menus.count; i++){
        RicHorizonMenuItemCell *cell = [[RicHorizonMenuItemCell alloc] init];
        cell.delegate = self;
        cell.index = i;
        cell.normalColor = self.tagNormalColor;
        cell.highlightedColor = self.tagHighlightedColor;
        cell.item = _menuItems[i];
        [self.scrollView addSubview:cell];
        [self.cells addObject:cell];
    }
    [self shuiPinPaiBan];
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
        if(self.isExpand){
            self.bottomLine.frame = CGRectMake(CGRectGetMinX(cell.frame), CGRectGetMinY(cell.frame) + 45.0f, 30.0f, 1.0f);
            [cell layoutIfNeeded];
            [cell setNeedsLayout];
            
        }else{
            [UIView animateWithDuration:0.26f animations:^{
                [cell layoutIfNeeded];
                [cell setNeedsLayout];
                self.bottomLine.frame = CGRectMake(CGRectGetMinX(cell.frame), CGRectGetMinY(cell.frame) + 45.0f, 30.0f, 1.0f);
            }];
        }
    }
    if(!self.isExpand){
        
        if(index >= self.lastSelectedIndex){
            if(index+1 < self.cells.count){
                RicHorizonMenuItemCell *nextCell = self.cells[index+1];
                if(CGRectGetMaxX(nextCell.frame) >= self.scrollView.contentOffset.x+CGRectGetWidth(self.scrollView.frame)){
                    CGPoint startPoint = CGPointMake(self.scrollView.contentOffset.x+30.0f+self.horizonGap, self.scrollView.contentOffset.y);
                    [self.scrollView setContentOffset:startPoint animated:YES];
                }else{
                    [self.scrollView scrollRectToVisible:nextCell.frame animated:YES];
                }
            }
        }
        else {
            if (index-1 >= 0){
                RicHorizonMenuItemCell *lastCell = self.cells[index-1];
            if(CGRectGetMinX(lastCell.frame)<self.scrollView.contentOffset.x){
                    CGPoint startPoint = CGPointMake(lastCell.frame.origin.x-19, self.scrollView.contentOffset.y);
                    [self.scrollView setContentOffset:startPoint animated:YES];
                }else{
                    [self.scrollView scrollRectToVisible:lastCell.frame animated:YES];
                }
            }
        }
    }
}

- (void)clickedMenuItemAtIndex:(NSInteger)index{
    
    if(index != self.currentSelectedIndex){
        [self selectOperationForIndex:index];
        
        if(self.currentSelectedIndex != index && self.lastSelectedIndex != index){
            self.lastSelectedIndex = index;
        }
        self.currentSelectedIndex = index;
        CGFloat width = CGRectGetWidth(self.contentCollectionView.bounds);
        [UIView beginAnimations:@"scrollViewAnimation" context:NULL];
        self.contentCollectionView.contentOffset = CGPointMake(index * width, 0);
        [UIView setAnimationWillStartSelector:@selector(showMask)];
        [UIView setAnimationDidStopSelector:@selector(hideMask)];
        [UIView setAnimationDelegate:self];
        [UIView commitAnimations];
        if(self.delegate && [self.delegate respondsToSelector:@selector(selectMenuAtIndex:menu:)]){
            RicHorizonMenuItem *item = self.menuItems[self.currentSelectedIndex];
            [self.delegate selectMenuAtIndex:self.currentSelectedIndex menu:item.itemValue];
        }
    }
    
    if(self.isExpand){
        [self shrinkOrExpand];
    }
}
- (void)showMask
{
    self.mask.hidden = NO;
}
- (void)hideMask
{
    self.mask.hidden = YES;
}
- (NSInteger)rowsCount{
    
    if(self.isExpand){
        NSInteger rowCount = self.menus.count/self.columnCount;
        if(self.menus.count%self.columnCount > 0 ){
            rowCount += 1;
        }
        
        if(rowCount == 0){
            rowCount = 1;
        }
        
        return rowCount;
    }else{
        return 1;
    }
}

- (CGFloat)collectionViewExpandHeight{
    
    return self.rowsCount * self.cellHeight;
    
}

- (CGFloat)shrinkHeight{
    return self.cellHeight;
}

- (CGFloat)cellHeight {
    return 46.0f;
}

- (CGFloat)horizonGap{
    return screenWidth > 375.0f ? screenWidth/375.0f*40.0f:40.0f;
}

- (CGFloat)defaultHeight{
    return self.cellHeight;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint location = [touch locationInView:self];
    if(CGRectContainsPoint(CGRectMake(0, CGRectGetMinY(self.scrollView.frame), CGRectGetWidth(self.frame), CGRectGetHeight(self.scrollView.frame)), location) == NO){
        [self shrinkOrExpand];
    }
}


@end
