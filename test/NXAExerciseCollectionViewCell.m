//
//  NXAExerciseCollectionViewCell.m
//  nxa-netConnectCar
//
//  Created by  nxa-yutao on 16/8/19.
//  Copyright © 2016年 nxa-tankeke. All rights reserved.
//

#import "NXAExerciseCollectionViewCell.h"
#import "NXAOptionModel.h"
#import "NXAExerciseTableViewCell.h"

static CGFloat headerHeight = 120;
@interface NXAExerciseCollectionViewCell ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic , strong) NSArray * dataSouce;
@end

@implementation NXAExerciseCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self setUpCell];
    }
    return self;
}

- (void)setModel:(NXAExerciseModel *)model{
    
    _model = model;
    self.tableView.allowsSelection = !_model.isChoose;
}


- (void)setUpCell{
    
    //创建tableView
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height) style:UITableViewStylePlain];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.scrollEnabled = NO;
    
    //设置分割线
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.contentView addSubview:self.tableView];
    [self.tableView registerClass:[NXAExerciseTableViewCell class] forCellReuseIdentifier:@"ExerciseTableViewCell"];
}


#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.model.options.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return headerHeight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    for(NXAOptionModel * optionModel in self.model.options){
        
        if (optionModel.isSelected == YES) {
            
            return 80;
        }
    }
    return 0.000001;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NXAExerciseTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ExerciseTableViewCell" forIndexPath:indexPath];
    
    cell.optionModel = self.model.options[indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

#pragma mark - UITableViewDelegate

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    //顶部题目视图
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, XAWIDTH, headerHeight)];
    
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(30, 0, XAHIGHT, headerHeight)];
    titleLabel.text = _model.title;
    [view addSubview:titleLabel];
    
    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, headerHeight - 1, XAWIDTH, 1)];
    line.backgroundColor = [UIColor grayColor];
    [view addSubview:line];
    return view;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{

    for(NXAOptionModel * optionModel in self.model.options){
        
        if (optionModel.isSelected == YES) {
            //顶部题目视图
            UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, XAWIDTH, 80)];
            
            UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(30, 0, XAHIGHT, 80)];
            titleLabel.text = [NSString stringWithFormat:@"正确答案是%@",_model.answer];
            [view addSubview:titleLabel];
            
            return view;
        }
    }
    return nil;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
   
    
    NSLog(@"第%ld行被选中",(long)indexPath.row);
    for (NXAOptionModel * optionModel in self.model.options) {
        optionModel.isSelected = NO;
    }
    NXAOptionModel * optionModel = self.model.options[indexPath.row];
    optionModel.isSelected = YES;
    
    //该题已选
    _model.isChoose = YES;
    self.tableView.allowsSelection = NO;    //禁用点击
    [self.tableView reloadData];
    
#warning 这是什么玩意 if(1)?
    
    //代理方法，用来计分
    if (1) {
        optionModel.isRight = YES;
        if (_delegate && [_delegate performSelector:@selector(sendScore:)]) {
//            [_delegate sendScore:_model.questionNumber];
        }
    }
    
}


@end