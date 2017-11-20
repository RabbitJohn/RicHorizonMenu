//
//  RicHorizonMenuContentCell.h
//  RicHorizonMenu
//
//  Created by rice on 16/6/2.
//
//

#import <UIKit/UIKit.h>
#import "RicHorizonMenuTableView.h"

@interface RicHorizonMenuContentCell : UICollectionViewCell

@property (nonatomic, readonly, nonnull) RicHorizonMenuTableView *tableView;

@property (nonatomic, assign) NSInteger menuIdx;

@end
