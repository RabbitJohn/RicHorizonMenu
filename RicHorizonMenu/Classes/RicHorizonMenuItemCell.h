//
//  RicForumAllGroupFilterItemView.h
//  john
//
//  Created by rice on 16/4/13.
//  Copyright © 2016年 rice. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RicHorizonMenuItemCellDataSource.h"

@class RicHorizonMenuItemCell;
@class RicHorizonMenuItem;

@protocol RicHorizonMenuItemDelegate <NSObject>

@optional

- (void)clickedMenuItemAtIndex:(NSInteger)index;

@end

@interface RicHorizonMenuItemCell : UIView

@property (nonatomic, strong) RicHorizonMenuItem *item;

@property (nonatomic, assign) NSInteger index;

@property (nonatomic, weak) id <RicHorizonMenuItemDelegate> delegate;

@property (nonatomic, strong) UIColor *highlightedColor;

@property (nonatomic, strong) UIColor *normalColor;


@end
