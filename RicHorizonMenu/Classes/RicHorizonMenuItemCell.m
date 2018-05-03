//
//  ForumAllGroupFilterItemView.m
//  john
//
//  Created by john on 16/4/13.
//  Copyright © 2016年 john. All rights reserved.
//

#import "RicHorizonMenuItemCell.h"
#import "RicExpandBtn.h"
#import "RicHorizonMenuItem.h"
#import <WZLBadge/WZLBadgeImport.h>
@interface RicHorizonMenuItemCell ()

@property (nonatomic, strong) RicExpandBtn *titleButton;
@property (nonatomic, strong) UIImageView *compeleteIcon;

@end

@implementation RicHorizonMenuItemCell

- (instancetype)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    
    if(self){
        
        self.titleButton = [[RicExpandBtn alloc] init];
        self.titleButton.frame = self.bounds;
        self.titleButton.titleLabel.font = [UIFont systemFontOfSize:14];
        [self.titleButton addTarget:self action:@selector(clickedItem) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.titleButton];
        self.compeleteIcon = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 14, 14)];
        self.compeleteIcon.image = [UIImage imageNamed:@"icon_check-1"];
        [self addSubview:self.compeleteIcon];
        self.compeleteIcon.hidden = YES;
    }
    
    return self;
}

- (void)setFrame:(CGRect)frame{
    [super setFrame:frame];
    self.titleButton.bounds = self.bounds;
    self.badgeCenterOffset = CGPointMake(frame.origin.x-5, (self.titleButton.frame.size.height-self.titleButton.titleLabel.font.pointSize)/2.0);
    [self clearBadge];
}

- (void)clickedItem{
    
    if(self.delegate && [self.delegate respondsToSelector:@selector(clickedMenuItemAtIndex:)]){
        [self.delegate clickedMenuItemAtIndex:self.index];
    }
}

- (void)setItem:(RicHorizonMenuItem *)item{
    _item = item;
}

- (void)layoutSubviews{
    
    [super layoutSubviews];
    
    [self.titleButton setTitle:_item.title forState:UIControlStateNormal];
    CGSize titleSize = [self.titleButton.titleLabel sizeThatFits:self.titleButton.frame.size];;
    self.compeleteIcon.center = CGPointMake(CGRectGetWidth(self.bounds)/2.0 + titleSize.width/2.0, (self.titleButton.frame.size.height-self.titleButton.titleLabel.font.pointSize)/2.0);
    if(_item.isSelected){
        [self.titleButton setTitleColor:self.highlightedColor forState:UIControlStateNormal];
    }else{
        [self.titleButton setTitleColor:self.normalColor forState:UIControlStateNormal];
    }
}



@end
