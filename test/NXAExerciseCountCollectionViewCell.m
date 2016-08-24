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

@interface NXAExerciseCountCollectionViewCell ()
@property (nonatomic,weak) UILabel * numberLabel;
@end

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
    self.backgroundColor = _exerciseModel.isChoose ? [UIColor orangeColor]:[UIColor redColor];
    _numberLabel.textColor = _exerciseModel.isChoose ? [UIColor greenColor]:[UIColor blackColor];
    _numberLabel.text = [NSString stringWithFormat:@"第%ld题",_exerciseModel.questionNumber];
}

- (void)setUpCell{
    
    self.layer.cornerRadius = 4;
    UILabel *numberLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, itemW, itemH)];
    numberLabel.textColor = [UIColor blackColor];
    numberLabel.textAlignment = NSTextAlignmentCenter;
    numberLabel.font = [UIFont systemFontOfSize:16];
    [self.contentView addSubview:numberLabel];
    _numberLabel = numberLabel;
}

@end
