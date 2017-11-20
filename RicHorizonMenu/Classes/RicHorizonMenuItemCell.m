//
//  RicForumAllGroupFilterItemView.m
//  john
//
//  Created by rice on 16/4/13.
//  Copyright © 2016年 rice. All rights reserved.
//

#import "RicHorizonMenuItemCell.h"
#import "RicExpandBtn.h"
#import "RicHorizonMenuItem.h"

@interface RicHorizonMenuItemCell ()

@property (nonatomic, strong) RicExpandBtn *titleButton;

@end

@implementation RicHorizonMenuItemCell

- (instancetype)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    
    if(self){
        
        self.titleButton = [[RicExpandBtn alloc] init];
        self.titleButton.touchAreaRadius = 50.0f;
        self.titleButton.frame = CGRectMake(0.0f, 12.0f, 30.0f, 21.0f);
        self.titleButton.titleLabel.font = [UIFont systemFontOfSize:13.0f];
        [self.titleButton addTarget:self action:@selector(clickedItem) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.titleButton];
    }
    
    return self;
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
    if(_item.title.length > 2){
        [self.titleButton.titleLabel sizeThatFits:self.titleButton.frame.size];
    }
    
    if(_item.isSelected){
        [self.titleButton setTitleColor:self.highlightedColor forState:UIControlStateNormal];
    }else{
        [self.titleButton setTitleColor:self.normalColor forState:UIControlStateNormal];
    }
}



@end
