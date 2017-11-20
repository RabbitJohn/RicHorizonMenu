//
//  RicHorizonMenuItemCellDataSource.h
//  RicHorizonMenu
//
//  Created by rice on 16/6/2.
//
//

#ifndef RicHorizonMenuItemCellDataSource_h
#define RicHorizonMenuItemCellDataSource_h

@protocol RicHorizonMenuItemDataSource <NSObject>

@optional

@property (nonatomic, readonly) NSString *title;

- (void)setTitle:(NSString *)title;

@end

#endif /* RicHorizonMenuItemCellDataSource_h */
