//
//  RicHorizonMenuItem.h
//  RicHorizonMenu
//
//  Created by rice on 16/6/2.
//
//

#import <Foundation/Foundation.h>
#import "RicHorizonMenuItemCellDataSource.h"

@interface RicHorizonMenuItem : NSObject

@property (nonatomic, readonly) NSString *title;

@property (nonatomic, assign) BOOL isSelected;

@property (nonatomic, strong) id <RicHorizonMenuItemDataSource> itemValue;

@end
