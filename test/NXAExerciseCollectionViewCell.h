//
//  NXAExerciseCollectionViewCell.h
//  nxa-netConnectCar
//
//  Created by  nxa-yutao on 16/8/19.
//  Copyright © 2016年 nxa-tankeke. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NXAExerciseModel.h"

@protocol NXAExerciseCollectionViewCellDelegate <NSObject>

- (void)sendScore:(NSInteger)qnumber;

@end


@interface NXAExerciseCollectionViewCell : UICollectionViewCell


@property (nonatomic, weak) id<NXAExerciseCollectionViewCellDelegate>delegate;

@property (nonatomic, weak) UICollectionView *collectionView;

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NXAExerciseModel *model;

@end
