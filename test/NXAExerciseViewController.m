//
//  NXAExerciseViewController.m
//  nxa-netConnectCar
//
//  Created by  nxa-yutao on 16/8/19.
//  Copyright © 2016年 nxa-tankeke. All rights reserved.
//

#import "NXAExerciseViewController.h"
#import "NXAExerciseCollectionViewCell.h"
#import "NXAExerciseModel.h"
#import "NXAOptionModel.h"
#import "NXAExerciseCountCollectionViewCell.h"


#define color(r,g,b,al) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:al]
#define itemW (XAWIDTH * 8 / 9 - 35) / 6
#define itemH itemW * 4 / 3


@interface NXAExerciseViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,NXAExerciseCollectionViewCellDelegate,UIGestureRecognizerDelegate>

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UICollectionViewFlowLayout *flowLayout;
@property (nonatomic, strong) NSMutableArray *dataSource;   //


@property (nonatomic, assign) NSInteger score;    //记录答题分数

@property (nonatomic, strong) UIView *toolView;   //底部View

@property (nonatomic, strong) UICollectionView *countCollectionView;   //做题详情滚动视图

@property (nonatomic, strong) UIView *centerView;   //做题详情弹出的视图

@property (nonatomic, strong) UIView *BGView;  //做题详情半透明背景

@property (nonatomic, assign) NSInteger selectedQNumber;  //选过的题号


@end

@implementation NXAExerciseViewController

static NSString *const cellId = @"cellId";
static NSString *const countCellId = @"countCellId";

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.score = 0;
    //初始化视图
    [self initSubViews];
    
}

- (void)initSubViews{   //初始化collectionView
    self.flowLayout = [[UICollectionViewFlowLayout alloc]init];
    self.collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, XAWIDTH, XAHIGHT) collectionViewLayout:self.flowLayout];
    self.collectionView.backgroundColor = [UIColor clearColor];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.collectionView.showsHorizontalScrollIndicator = NO;
    //设置水平方向滑动
    self.flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    //设置分页
    self.collectionView.pagingEnabled = YES;
    self.collectionView.bounces = NO;
    
    [self.view addSubview:self.collectionView];
    
    //注册UICollectionViewCell
    [self.collectionView registerClass:[NXAExerciseCollectionViewCell class] forCellWithReuseIdentifier:cellId];
    
    
    //初始化底部按钮
    UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    leftBtn.frame = CGRectMake(0, XAHIGHT - 50, XAWIDTH / 3, 50);
    [leftBtn setTitle:@"上一题" forState:UIControlStateNormal];
    [leftBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [leftBtn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    leftBtn.backgroundColor = [UIColor clearColor];
    [self.view addSubview:leftBtn];
    
    UIButton *countBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    countBtn.frame = CGRectMake(XAWIDTH / 3, XAHIGHT - 50, XAWIDTH / 3, 50);
    [countBtn setTitle:@"第几题" forState:UIControlStateNormal];
    countBtn.backgroundColor = [UIColor clearColor];
    [countBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [countBtn addTarget:self action:@selector(countClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:countBtn];
    
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    rightBtn.frame = CGRectMake(XAWIDTH * 2 / 3, XAHIGHT - 50, XAWIDTH / 3, 50);
    [rightBtn setTitle:@"下一题" forState:UIControlStateNormal];
    rightBtn.backgroundColor = [UIColor clearColor];
    [rightBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [rightBtn addTarget:self action:@selector(next) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:rightBtn];
    
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
//    return self.dataSource.count;
    if (collectionView == self.collectionView) {
        return self.dataSource.count;
    }else if (collectionView == self.countCollectionView){
        return 4;
    }else{
        return 0;
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    if (collectionView == self.collectionView) {
        NXAExerciseCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellId forIndexPath:indexPath];
        
        NXAExerciseModel *model = self.dataSource[indexPath.row];
        model.questionNumber = indexPath.row;
        cell.collectionView = collectionView;
        cell.model = model;
        cell.delegate = self;
        
//        self.indexPath = indexPath;
        
        [cell.tableView reloadData];
        return cell;
    }else if (collectionView == self.countCollectionView){
        NXAExerciseCountCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:countCellId forIndexPath:indexPath];
        
//        NXAExerciseModel *model = self.dataSource[indexPath.row];
//        model.questionNumber = indexPath.row;
//        cell.exerciseModel = model;
//        cell.backgroundColor = [UIColor redColor];
//
//        if (indexPath.row == self.selectedQNumber) {
//            cell.backgroundColor = [UIColor yellowColor];
//        }
       
        return cell;
    }else{
        return nil;
    }
}

#pragma mark - UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    if (collectionView == self.collectionView) {
        return (CGSize){XAWIDTH ,XAHIGHT};
    }else if (collectionView == self.countCollectionView){
        return (CGSize){itemW ,itemH};
    }else{
        return (CGSize){0,0};
    }
    
}


- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    if (collectionView == self.collectionView) {
        return UIEdgeInsetsMake(0, 0, 0, 0);
    }else if (collectionView == self.countCollectionView){
        return UIEdgeInsetsMake(5, 5, 5, 5);
    }else{
        return UIEdgeInsetsMake(0, 0, 0, 0);
    }
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    if (collectionView == self.collectionView) {
        return 0;
    }else if (collectionView == self.countCollectionView){
        return 5;
    }else{
        return 0;
    }
    
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    if (collectionView == self.collectionView) {
        return 0;
    }else if (collectionView == self.countCollectionView){
        return 5;
    }else{
        return 0;
    }
}


#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (collectionView == self.collectionView) {
        
    }else if (collectionView == self.countCollectionView){
        //通过动画滚动到下一个位置
        [self.BGView removeFromSuperview];
        [self.collectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
        
    }else{
        
    }
    
}


- (NSMutableArray *)dataSource{
    
    if (!_dataSource) {
        
        
        NXAOptionModel * item0 = [[NXAOptionModel alloc]initWithDict:@{
                                                                 @"isSelected":@"NO",
                                                                 @"imageName":@"8.jpg",
                                                                 @"optionText":@"optionText1",
                                                                 @"isRight":@"NO"
                                                                 }];
        NXAOptionModel * item1 = [[NXAOptionModel alloc]initWithDict:@{
                                                                 @"isSelected":@"NO",
                                                                 @"imageName":@"8.jpg",
                                                                 @"optionText":@"optionText2",
                                                                 @"isRight":@"NO"
                                                                 }];
        NXAOptionModel * item2 = [[NXAOptionModel alloc]initWithDict:@{
                                                                 @"isSelected":@"NO",
                                                                 @"imageName":@"8.jpg",
                                                                 @"optionText":@"optionText1",
                                                                 @"isRight":@"NO"
                                                                 }];
        NXAOptionModel * item3 = [[NXAOptionModel alloc]initWithDict:@{
                                                                 @"isSelected":@"NO",
                                                                 @"imageName":@"8.jpg",
                                                                 @"optionText":@"optionText2",
                                                                 @"isRight":@"NO"
                                                                 }];
        
        NXAOptionModel * item4 = [[NXAOptionModel alloc]initWithDict:@{
                                                                 @"isSelected":@"NO",
                                                                 @"imageName":@"8.jpg",
                                                                 @"optionText":@"optionText3",
                                                                 @"isRight":@"NO"
                                                                 }];
        NXAOptionModel * item5 = [[NXAOptionModel alloc]initWithDict:@{
                                                                 @"isSelected":@"NO",
                                                                 @"imageName":@"8.jpg",
                                                                 @"optionText":@"optionText1",
                                                                 @"isRight":@"NO"
                                                                 }];
        NXAOptionModel * item6 = [[NXAOptionModel alloc]initWithDict:@{
                                                                 @"isSelected":@"NO",
                                                                 @"imageName":@"8.jpg",
                                                                 @"optionText":@"optionText2",
                                                                 @"isRight":@"NO"
                                                                 }];
        NXAOptionModel * item7 = [[NXAOptionModel alloc]initWithDict:@{
                                                                 @"isSelected":@"NO",
                                                                 @"imageName":@"8.jpg",
                                                                 @"optionText":@"optionText3",
                                                                 @"isRight":@"NO"
                                                                 }];
        
        NXAOptionModel * item8 = [[NXAOptionModel alloc]initWithDict:@{
                                                                       @"isSelected":@"NO",
                                                                       @"imageName":@"8.jpg",
                                                                       @"optionText":@"optionText4",
                                                                       @"isRight":@"NO"
                                                                       }];
        NXAOptionModel * item9 = [[NXAOptionModel alloc]initWithDict:@{
                                                                       @"isSelected":@"NO",
                                                                       @"imageName":@"8.jpg",
                                                                       @"optionText":@"optionText3",
                                                                       @"isRight":@"NO"
                                                                       }];
        NXAOptionModel * item10 = [[NXAOptionModel alloc]initWithDict:@{
                                                                       @"isSelected":@"NO",
                                                                       @"imageName":@"8.jpg",
                                                                       @"optionText":@"optionText4",
                                                                       @"isRight":@"NO"
                                                                       }];
        
        NXAExerciseModel * exerciseItem0 = [[NXAExerciseModel alloc]init];
        exerciseItem0.answer = @"A";
        exerciseItem0.options = @[item0,item1];
        exerciseItem0.title = @"第1题?";
        exerciseItem0.isChoose = NO;
        
        NXAExerciseModel * exerciseItem1 = [[NXAExerciseModel alloc]init];
        exerciseItem1.answer = @"B";
        exerciseItem1.options = @[item2,item3,item4];
        exerciseItem1.title = @"第2题?";
        exerciseItem1.isChoose = NO;
        
        NXAExerciseModel * exerciseItem2 = [[NXAExerciseModel alloc]init];
        exerciseItem2.answer = @"A";
        exerciseItem2.options = @[item5,item6,item7,item8];
        exerciseItem2.title = @"第3题?";
        exerciseItem2.isChoose = NO;
        
        NXAExerciseModel * exerciseItem3 = [[NXAExerciseModel alloc]init];
        exerciseItem3.answer = @"C";
        exerciseItem3.options = @[item9,item10];
        exerciseItem3.title = @"第4题?";
        exerciseItem3.isChoose = NO;
        
        _dataSource = [NSMutableArray arrayWithArray:@[exerciseItem0,exerciseItem1,exerciseItem2,exerciseItem3]];
        
        
    }
    return _dataSource;
}

#pragma mark - NXAExerciseCollectionViewCellDelegate
- (void)sendScore:(NSInteger )qnumber{
    self.selectedQNumber = qnumber;
    self.score ++;
    NSLog(@"%ld",self.score);
    [self.countCollectionView reloadData];
}



#pragma mark - 各种响应事件
//上一页
- (void)back{
   
    CGFloat offsetX = self.collectionView.contentOffset.x - [UIScreen mainScreen].bounds.size.width;
    if (offsetX < 0) {
        [self showAlert:@"第一题"];
    }else if (offsetX == 0){
        
        [UIView animateWithDuration:0.25 animations:^{
            self.collectionView.contentOffset = CGPointZero;
        }];
    }else{
        
        [UIView animateWithDuration:0.25 animations:^{
            self.collectionView.contentOffset = CGPointMake(offsetX, 0);
        }];
    }
}


//下一页
- (void)next{
  
    CGFloat offsetX = self.collectionView.contentOffset.x + [UIScreen mainScreen].bounds.size.width;
    if (offsetX > self.collectionView.contentSize.width - [UIScreen mainScreen].bounds.size.width ) {
        [self showAlert:@"最后一题"];
    }else {
        
        [UIView animateWithDuration:0.25 animations:^{
            self.collectionView.contentOffset = CGPointMake(offsetX, 0);
        }];
    }
    
}

//弹出提示框
- (void)timerFireMethod:(NSTimer*)theTimer//弹出框
{
    UIAlertView *promptAlert = (UIAlertView*)[theTimer userInfo];
    [promptAlert dismissWithClickedButtonIndex:0 animated:NO];
    promptAlert =NULL;
}


- (void)showAlert:(NSString *) _message{//时间
    UIAlertView *promptAlert = [[UIAlertView alloc] initWithTitle:nil message:_message delegate:nil cancelButtonTitle:nil otherButtonTitles:nil];
    
    [NSTimer scheduledTimerWithTimeInterval:1.5f
                                     target:self
                                   selector:@selector(timerFireMethod:)
                                   userInfo:promptAlert
                                    repeats:YES];
    [promptAlert show];
}


//做题详情
- (void)countClick{
    //创建灰色透明背景视图
    self.BGView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
    self.BGView.backgroundColor = [[UIColor grayColor]colorWithAlphaComponent:0.5];
    
    //添加手势移除视图
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tap:)];
    tap.delegate = self;
    [self.BGView addGestureRecognizer:tap];
    
    //创建居中白色视图
    self.centerView = [[UIView alloc]initWithFrame:CGRectMake(XAWIDTH / 18, XAHIGHT / 4, XAWIDTH * 8 / 9, XAHIGHT / 2)];
    self.centerView.backgroundColor = [UIColor whiteColor];
    [self.BGView addSubview:self.centerView];
    [self.view addSubview:self.BGView];
    
    //创建collectionView
    UICollectionViewFlowLayout *countFlowLayout = [[UICollectionViewFlowLayout alloc]init];
    self.countCollectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, self.centerView.bounds.size.width, self.centerView.bounds.size.height) collectionViewLayout:countFlowLayout];
    self.countCollectionView.delegate = self;
    self.countCollectionView.dataSource = self;
    
    self.countCollectionView.backgroundColor = [UIColor whiteColor];
    self.countCollectionView.showsHorizontalScrollIndicator = NO;
    
    //设置水平方向滑动
    countFlowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    //设置分页
    self.countCollectionView.bounces = NO;
    
    [self.centerView addSubview:self.countCollectionView];
    
    //注册UICollectionViewCell
    [self.countCollectionView registerClass:[NXAExerciseCountCollectionViewCell class] forCellWithReuseIdentifier:countCellId];
    
}

//移除答题详情页面
- (void)tap:(UITapGestureRecognizer *)sender{
    
    [sender.view removeFromSuperview];
    
}

//取消中间视图的tap手势响应
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    if ([touch.view isDescendantOfView:self.centerView]) {
        return NO;
    }
    return YES;
}


@end









