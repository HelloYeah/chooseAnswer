//
//  NXAExerciseModel.m
//  nxa-netConnectCar
//
//  Created by  nxa-yutao on 16/8/19.
//  Copyright © 2016年 nxa-tankeke. All rights reserved.
//

#import "NXAExerciseModel.h"

@implementation NXAExerciseModel

- (instancetype)initWithDict:(NSDictionary *)dict{
    self = [super init];
    if (self) {
        [self setValuesForKeysWithDictionary:dict];
    }
    return self;
}


@end
