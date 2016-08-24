//
//  NXAExerciseCountCollectionViewCell.m
//  nxa-netConnectCar
//
//  Created by  nxa-yutao on 16/8/23.
//  Copyright © 2016年 nxa-tankeke. All rights reserved.
//

#import "NXAExerciseCountCollectionViewCell.h"

#define itemW (XAWIDTH * 8 / 9 - 35) / 6
#define itemH itemW * 4 / 3

@implementation NXAExerciseCountCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self setUpCell];
    }
    return self;
}


- (void)setExerciseModel:(NXAExerciseModel *)exerciseModel{
    _exerciseModel = exerciseModel;
    
}

- (void)setUpCell{
    
    self.backgroundColor = [UIColor redColor];
    
    UILabel *numberLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, itemW, itemH)];
    numberLabel.text = @"6";
    numberLabel.textColor = [UIColor blackColor];
    numberLabel.textAlignment = NSTextAlignmentCenter;
    numberLabel.font = [UIFont systemFontOfSize:18];
    
    [self.contentView addSubview:numberLabel];
}

@end
