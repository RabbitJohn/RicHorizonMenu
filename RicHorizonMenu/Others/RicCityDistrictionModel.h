//
//  RicSubCityModel.h
//  ric
//
//  Created by rice on 16/5/3.
//  Copyright © 2016年 rice. All rights reserved.
//

#import "RicBaseModel.h"
#import "RicHorizonMenuItemCellDataSource.h"

@interface RicCityDistrictionModel : RicBaseModel<RicHorizonMenuItemDataSource>
@property (nonatomic, strong) NSString *name;
@property (nonatomic, assign) NSInteger id;
@property (nonatomic, assign) NSString *parent_id;

@property (nonatomic, readonly) NSString *title;


@end
