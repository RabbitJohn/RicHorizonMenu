//
//  ForumAllGroupFilterItemView.h
//  john
//
//  Created by john on 16/4/13.
//  Copyright © 2016年 john. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RicHorizonMenuItemCellDataSource.h"
#import "RicHorizonMenuItem.h"

@class RicHorizonMenuItemCell;

@protocol HorizonMenuItemDelegate <NSObject>

@optional

- (void)clickedMenuItemAtIndex:(NSInteger)index;

@end

@interface RicHorizonMenuItemCell : UIView

@property (nonatomic, strong) RicHorizonMenuItem *item;

@property (nonatomic, assign) NSInteger index;

@property (nonatomic, weak) id <HorizonMenuItemDelegate> delegate;

@property (nonatomic, strong) UIColor *highlightedColor;

@property (nonatomic, strong) UIColor *normalColor;

@property (nonatomic, strong, readonly) UIImageView *compeleteIcon;

@end
