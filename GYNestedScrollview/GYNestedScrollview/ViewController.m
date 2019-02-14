//
//  ViewController.m
//  GYNestedScrollview
//
//  Created by qiugaoying on 2019/2/14.
//  Copyright © 2019年 qiugaoying. All rights reserved.
//

#import "ViewController.h"
#import "SDCycleScrollView.h"
#import "GYCursorView.h"
#import "ConditionFilter.h"

#import "SegScrollView.h"
#import <Masonry.h>

#import "GoodsCollectionViewController.h"
#import "GoodsListController.h"

#define LStatusBarHeight                [[UIApplication sharedApplication] statusBarFrame].size.height
#define LNavBarHeight                   44.0
#define LTabBarHeight                   ([[UIApplication sharedApplication] statusBarFrame].size.height>20?83:49)

#define SCREEN_H  [UIScreen mainScreen].bounds.size.height


#define AdViewHeight 126

@interface ViewController ()<SDCycleScrollViewDelegate>

@property(nonatomic,strong) SDCycleScrollView *cycleScrollView;
@property(nonatomic,strong) GYCursorView  *cursorView;
@property(nonatomic,strong) SegScrollView  *segScrollView;
@property(nonatomic,assign) NSInteger selectIndex;

@property(nonatomic,strong) GoodsListController *num1VC;
@property(nonatomic,strong) GoodsListController *num2VC;
@property(nonatomic,strong) GoodsCollectionViewController *num3VC;
@property(nonatomic,assign) BOOL canScroll; //是否可以滚动
@property(nonatomic,strong) UIView *footerView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"ScrollView 嵌套滑动";
    // Do any additional setup after loading the view, typically from a nib.
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(leaveTopCanScrollAction) name:@"leaveTop" object:nil];
    
    UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, AdViewHeight)];
    
    //轮播广告
    self.cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, self.view.frame.size.width,headerView.frame.size.height) delegate:self placeholderImage:nil];
    self.cycleScrollView.pageControlAliment = SDCycleScrollViewPageContolAlimentCenter;
    self.cycleScrollView.autoScrollTimeInterval = 3;
    self.cycleScrollView.currentPageDotColor = [UIColor orangeColor];
    self.cycleScrollView.pageDotColor = [UIColor colorWithWhite:1 alpha:0.5];
    self.cycleScrollView.backgroundColor = [UIColor whiteColor];
    [headerView addSubview:self.cycleScrollView];
    self.cycleScrollView.localizationImageNamesGroup = @[@"banner1",@"banner2"];
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.tableHeaderView = headerView;
    
    
    //ScrollView
    _footerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 50)];
    _segScrollView = [[SegScrollView alloc] init];
    [_footerView addSubview:_segScrollView];
    [_segScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.mas_equalTo(0);
    }];
    __weak typeof(self) weakSelf = self;
    _segScrollView.itemBlock = ^(NSInteger index) {
        weakSelf.selectIndex = index;
        weakSelf.cursorView.currentIndex = index;
        [weakSelf fitDataSource];
        [weakSelf redrawChildView];
    };
    
    
    //ChildViewController
    _num1VC = [[GoodsListController alloc] init];
    _num1VC.fullFlag = YES;
    [self addChildViewController:_num1VC];
    
    _num2VC = [[GoodsListController alloc] init];
    [self addChildViewController:_num2VC];

    _num3VC = [[GoodsCollectionViewController alloc]init];
    [self addChildViewController:_num3VC];
    
    [self setFirstView];
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if(scrollView == self.tableView ){
        CGFloat bottom = [self.tableView rectForSection:0].origin.y;
        if (scrollView.contentOffset.y>=bottom) {
            scrollView.contentOffset = CGPointMake(0, bottom);
            if (self.canScroll) {
                self.canScroll = NO;
                //子项可以滚动；
                switch (self.selectIndex) {
                    case 0:
                        self.num1VC.canVcScroll = YES;
                        break;
                    case 1:
                        self.num2VC.canVcScroll = YES;
                        break;
                    case 2:
                        self.num3VC.canVcScroll = YES;
                        break;
                    default:
                        break;
                }
            }
        }else{
            
            if (!self.canScroll) {
                //子cell没到顶
                BOOL subViewCanScrollFlag = YES;
                switch (self.selectIndex) {
                    case 0:
                        if(self.num1VC.tableView.contentSize.height <= self.view.frame.size.height){
                            subViewCanScrollFlag = NO;
                        }
                        break;
                    case 1:
                        if(self.num2VC.tableView.contentSize.height <= self.view.frame.size.height){
                            subViewCanScrollFlag = NO;
                        }
                        break;
                    case 2:
                        if(self.num3VC.dataCollection.contentSize.height <= self.view.frame.size.height){
                            subViewCanScrollFlag = NO;
                        }
                        break;
                    default:
                        break;
                }
                
                if(!subViewCanScrollFlag){
                    scrollView.contentOffset = CGPointMake(0, scrollView.contentOffset.y);
                }else{
                    scrollView.contentOffset = CGPointMake(0, bottom);
                }
            }
        }
    }
}


#pragma mark - notify
-(void)leaveTopCanScrollAction{
    
    self.canScroll = YES;
    self.num1VC.canVcScroll = NO;
    self.num2VC.canVcScroll = NO;
    self.num3VC.canVcScroll = NO;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [UITableViewCell new];
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return  43;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return  0.000001f;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return self.cursorView;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 0;
}


#pragma mark - 设置视图；
-(void)setFirstView
{
    [_num2VC.view removeFromSuperview];
    [_num3VC.view removeFromSuperview];
 
    UIView *view1 = [_segScrollView.scrollView viewWithTag:1000];
    [view1 addSubview:_num1VC.view];
    
    CGFloat subContentH = self.view.frame.size.height;
    [_num1VC.view mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.mas_equalTo(0);
        make.bottom.mas_equalTo(0);
        make.height.equalTo(@(subContentH));
    }];
    [_segScrollView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@(subContentH));
    }];
    [_segScrollView layoutIfNeeded];
    
    CGRect newFrame      = self.footerView.frame;
    newFrame.size.height = _segScrollView.frame.size.height;
    self.footerView.frame = newFrame;
    
    self.tableView.tableFooterView = nil;
    self.tableView.tableFooterView = _footerView;
}

-(void)setSecondView
{
    [_num1VC.view removeFromSuperview];
    [_num3VC.view removeFromSuperview];
    
    UIView *view1 = [_segScrollView.scrollView viewWithTag:1001];
    [view1 addSubview:_num2VC.view];
    
    CGFloat subContentH = self.view.frame.size.height  - AdViewHeight - (LNavBarHeight+LStatusBarHeight) ;
    if(_num2VC.tableView.contentSize.height > subContentH){
        subContentH = self.view.frame.size.height;
    }
    [_num2VC.view mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.mas_equalTo(0);
        make.bottom.mas_equalTo(0);
        make.height.equalTo(@(subContentH));
    }];
    [_segScrollView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@(subContentH));
    }];
    [_segScrollView layoutIfNeeded];
    
    CGRect newFrame      = self.footerView.frame;
    newFrame.size.height = _segScrollView.frame.size.height;
    self.footerView.frame = newFrame;
    
    self.tableView.tableFooterView = nil;
    self.tableView.tableFooterView = _footerView;
}

-(void)setThirdView
{
    [_num1VC.view removeFromSuperview];
    [_num2VC.view removeFromSuperview];
    
    UIView *view3 = [_segScrollView.scrollView viewWithTag:1002];
    [view3 addSubview:_num3VC.view];
    
    CGFloat subContentH = self.view.frame.size.height;
    [_num3VC.view mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.mas_equalTo(0);
        make.bottom.mas_equalTo(0);
        make.height.equalTo(@(subContentH));
    }];
    [_segScrollView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@(subContentH));
    }];
    [_segScrollView layoutIfNeeded];
    
    CGRect newFrame      = self.footerView.frame;
    newFrame.size.height = _segScrollView.frame.size.height;
    self.footerView.frame = newFrame;
    
    self.tableView.tableFooterView = nil;
    self.tableView.tableFooterView = _footerView;
}

-(void)redrawChildView
{
    switch (self.selectIndex) {
        case 0:
            [self setFirstView];
            break;
        case 1: [self setSecondView];
            break;
        case 2: [self setThirdView];
            break;
        default:
            break;
    }
}

-(void)fitDataSource
{
    [_cursorView selectItemAtCurrentIndex];
    
    //属性设置完成后，调用此方法绘制界面
    [_cursorView reloadPages];
}


-(GYCursorView *)cursorView
{
    if(_cursorView == nil){
        
        NSMutableArray *extDicArr = [[NSMutableArray alloc]init];
        ConditionFilter *f1 = [[ConditionFilter alloc]init];
        f1.value = 0;
        f1.name = @"商品列表";
        ConditionFilter *f2 = [[ConditionFilter alloc]init];
        f2.value = 1;
        f2.name = @"部分商品";
        ConditionFilter *f3 = [[ConditionFilter alloc]init];
        f3.value = 3;
        f3.name = @"商品集合";
        [extDicArr addObjectsFromArray:@[f1,f2,f3]];
        
        _cursorView = [[GYCursorView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 43)];
        //设置字体和颜色
        _cursorView.bClearColorFlag = YES;
        _cursorView.backGroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.85];
        
        _cursorView.normalColor = [UIColor whiteColor];
        _cursorView.selectedColor = [UIColor orangeColor];
        _cursorView.selectedFont = [UIFont systemFontOfSize:16];
        _cursorView.normalFont = [UIFont systemFontOfSize:14];
        _cursorView.lineEdgeInsets = UIEdgeInsetsMake(0, 10,  0, 20);
        _cursorView.cursorEdgeInsets = UIEdgeInsetsMake(0,  0,  0, 0);
        _cursorView.lineView.hidden = NO;
        _cursorView.lineViewColor  = [UIColor orangeColor];
        _cursorView.collectionView.scrollEnabled = YES;
        _cursorView.collectionView.showsHorizontalScrollIndicator = NO;
        _cursorView.collectionView.showsVerticalScrollIndicator = NO;
        
        __weak typeof(self) weakSelf = self;
        self.cursorView.selectItemBlock = ^(ConditionFilter *filter) {
            
            NSInteger index = [extDicArr indexOfObject:filter];
            weakSelf.selectIndex = index;
            
            weakSelf.segScrollView.scrollView.contentOffset = CGPointMake(weakSelf.segScrollView.scrollView.frame.size.width * weakSelf.selectIndex, 0);
            [weakSelf redrawChildView];
        };
        _cursorView.currentIndex = 0;
        _cursorView.extDataDicArr = extDicArr;
        [self fitDataSource];
        
    }
    return _cursorView;
}

@end
