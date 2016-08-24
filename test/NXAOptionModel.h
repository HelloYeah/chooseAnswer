//
//  NXAOptionModel.h
//  nxa-netConnectCar
//
//  Created by  nxa-yutao on 16/8/20.
//  Copyright © 2016年 nxa-tankeke. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NXAOptionModel : NSObject

@property (nonatomic,assign) BOOL isSelected;   //选项是否被点击
@property (nonatomic,copy) NSString * imageName;
@property (nonatomic,copy) NSString * optionText;

@property (nonatomic, assign) BOOL isRight;  //答案正确

- (instancetype)initWithDict:(NSDictionary *)dict;

@end
