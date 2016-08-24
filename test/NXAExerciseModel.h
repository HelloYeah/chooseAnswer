//
//  NXAExerciseModel.h
//  nxa-netConnectCar
//
//  Created by  nxa-yutao on 16/8/19.
//  Copyright © 2016年 nxa-tankeke. All rights reserved.
//

#import <Foundation/Foundation.h>
#define XAWIDTH 375
#define XAHIGHT 667
@interface NXAExerciseModel : NSObject

@property (nonatomic, strong) NSString *title;    //题目
@property (nonatomic, strong) NSArray *options;   //选项
@property (nonatomic, strong) NSString *answer;   //答案
@property (nonatomic, assign) BOOL isChoose;   // 选项是否选择过（选项点过一次就不能改变）
@property (nonatomic, assign) NSInteger questionNumber;  //题号


- (instancetype)initWithDict:(NSDictionary *)dict;

@end
