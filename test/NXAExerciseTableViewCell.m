//
//  NXAExerciseTableViewCell.m
//  nxa-netConnectCar
//
//  Created by  nxa-yutao on 16/8/19.
//  Copyright © 2016年 nxa-tankeke. All rights reserved.
//

#import "NXAExerciseTableViewCell.h"

@interface NXAExerciseTableViewCell ()

@property (nonatomic, strong) UIButton *optionBtn;      //选项按钮
@property (nonatomic, strong) UILabel *optionLabel;     //选项文本

@end

@implementation NXAExerciseTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setUpCell];
    }
    return self;
}


- (void)setOptionModel:(NXAOptionModel *)optionModel{
    
    _optionModel = optionModel;
    self.imageView.image = [UIImage imageNamed:optionModel.imageName];   //选项图片A
    self.textLabel.text = optionModel.optionText;
    
    if (_optionModel.isSelected) {    //如果cell选项被点击
        self.backgroundColor = [UIColor lightGrayColor];
        if (_optionModel.isRight) {     //如果选项正确
            self.textLabel.textColor = [UIColor yellowColor];
        }else{
            self.textLabel.textColor = [UIColor redColor];
        }
        
    }else{  //选项未被点击
        self.backgroundColor = [UIColor whiteColor];
        self.textLabel.textColor = [UIColor blackColor];

    }
}


- (void)setUpCell{
//    自定义cell分割线
    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, 79, [UIScreen mainScreen].bounds.size.width, 1)];
    line.backgroundColor = [UIColor grayColor];
    [self addSubview:line];
}


@end
