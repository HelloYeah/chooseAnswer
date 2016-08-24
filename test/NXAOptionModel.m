//
//  NXAOptionModel.m
//  nxa-netConnectCar
//
//  Created by  nxa-yutao on 16/8/20.
//  Copyright © 2016年 nxa-tankeke. All rights reserved.
//

#import "NXAOptionModel.h"

@implementation NXAOptionModel

- (instancetype)initWithDict:(NSDictionary *)dict{
    self = [super init];
    if (self) {
        [self setValuesForKeysWithDictionary:dict];
    }
    return self;
}

@end
