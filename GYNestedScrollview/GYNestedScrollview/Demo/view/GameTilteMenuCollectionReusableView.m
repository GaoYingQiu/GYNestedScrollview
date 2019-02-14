
//
//  SportTypeCollectionReusableView.m
//  Ying2018
//
//  Created by qiugaoying on 2018/7/26.
//  Copyright © 2018年 qiugaoying. All rights reserved.
//

#import "GameTilteMenuCollectionReusableView.h"

@interface GameTilteMenuCollectionReusableView()

@property(nonatomic,strong) NSArray *parentDataArr; //model数组；
@property(nonatomic,strong) NSArray *conditionArr; //标题条件

@property(nonatomic,strong) ConditionFilter *selectedFilter;
@property(nonatomic,strong) Goods *selectedGoods;
@end

@implementation GameTilteMenuCollectionReusableView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        
        _cursorTitleView = [[GYCursorView alloc]initWithFrame:CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, 43)];
        //设置字体和颜色
        _cursorTitleView.bClearColorFlag = YES;
        _cursorTitleView.backgroundColor = [UIColor whiteColor];
        _cursorTitleView.normalColor = [UIColor blackColor];
        _cursorTitleView.selectedColor = [UIColor orangeColor];
        _cursorTitleView.selectedFont = [UIFont systemFontOfSize:20];
        _cursorTitleView.normalFont = [UIFont systemFontOfSize:16];
        _cursorTitleView.cursorEdgeInsets = UIEdgeInsetsMake(0,  -15,  0, 20);
        _cursorTitleView.lineView.hidden = YES;
        _cursorTitleView.collectionView.scrollEnabled = YES;
        _cursorTitleView.collectionView.showsHorizontalScrollIndicator = NO;
        _cursorTitleView.collectionView.showsVerticalScrollIndicator = NO;
        [self addSubview:_cursorTitleView];
        
        [self addSubview:self.cursorView];
        
        __weak typeof(self) weakSelf = self;
        //大类型点击后，刷新二级类型；
        self.cursorTitleView.selectItemBlock = ^(ConditionFilter *filter) {
            for(Goods *model in weakSelf.parentDataArr){
                if(filter.value == model.goodsApi){
                    weakSelf.selectedGoods = model;
                    weakSelf.selectedFilter = nil;
                    [weakSelf fitSecondLayoutDataSource];
                    
                    if(weakSelf.selectDoneBlock){
                        weakSelf.selectDoneBlock(weakSelf.selectedGoods, weakSelf.selectedFilter);
                    }
                    break;
                }
            }
        };
        
        self.cursorView.selectItemBlock = ^(ConditionFilter *filter) {
            weakSelf.selectedFilter = filter;
            if(weakSelf.selectDoneBlock){
                weakSelf.selectDoneBlock(weakSelf.selectedGoods, weakSelf.selectedFilter);
            }
        };
        
    }
    return self;
}


//刷新标题cusorView
-(void)fitGameTitleTypeDataSource
{
    NSInteger currentIndex = 0;
    for(int i=0; i<self.conditionArr.count; i++){
        ConditionFilter *findF = [_conditionArr objectAtIndex:i];
        if(findF.value == self.selectedFilter.value){
            currentIndex = i;
            break;
        }
    }
    
    _cursorView.currentIndex = currentIndex;
    _cursorView.extDataDicArr = self.conditionArr;
    [_cursorView selectItemAtCurrentIndex];
    
    //属性设置完成后，调用此方法绘制界面
    [_cursorView reloadPages];
}


-(void)fitDataSource:(NSArray *)extDicArr selectGoods:(Goods *)goods selectFilter:(ConditionFilter *)filter
{
    _parentDataArr = extDicArr;
    
    NSInteger currentIndex = 0;
    for(int i=0; i<_parentDataArr.count; i++){
        Goods *findF = [_parentDataArr objectAtIndex:i];
        if(findF.goodsApi == goods.goodsApi){
            currentIndex = i;
            break;
        }
    }
    
    NSMutableArray *gameTitleArr = [[NSMutableArray alloc]init];
    for (Goods *goods  in _parentDataArr) {
        ConditionFilter *f = [[ConditionFilter alloc]init];
        f.name = goods.goodsName;
        f.value = goods.goodsApi; //游戏类型；
        [gameTitleArr addObject:f];
    }
  
    _cursorTitleView.currentIndex = currentIndex;
    _cursorTitleView.extDataDicArr = gameTitleArr;
    [_cursorTitleView selectItemAtCurrentIndex];
    //属性设置完成后，调用此方法绘制界面
    [_cursorTitleView reloadPages];
    
    _selectedGoods = goods;
    _selectedFilter = filter;
    [self fitSecondLayoutDataSource];
}

//刷新二级数据；
-(void)fitSecondLayoutDataSource
{
    NSMutableArray *gameTypeArr = [[NSMutableArray alloc]init];
    ConditionFilter *allF = [[ConditionFilter alloc]init];
    allF.name = @"全部";
    allF.value = 0;
    [gameTypeArr addObject:allF];
    
    for (GoodsFilterModel *filter  in _selectedGoods.goodsTagList) {
        ConditionFilter *f = [[ConditionFilter alloc]init];
        f.name = filter.tagName;
        f.value = filter.Id;
        [gameTypeArr addObject:f];
    }
    self.conditionArr = gameTypeArr;
    if(self.selectedFilter == nil){
        self.selectedFilter = self.conditionArr.firstObject;
    }
    [self fitGameTitleTypeDataSource];
}

-(GYCursorView *)cursorView
{
    if(_cursorView == nil){
        _cursorView = [[GYCursorView alloc]initWithFrame:CGRectMake(0, 43, [[UIScreen mainScreen] bounds].size.width, 52)];
        //设置字体和颜色
        _cursorView.normalColor = [UIColor whiteColor];
        _cursorView.selectedColor = [UIColor blackColor];
        _cursorView.selectedFont = [UIFont systemFontOfSize:12];
        _cursorView.normalFont = [UIFont systemFontOfSize:12];
        _cursorView.cursorEdgeInsets = UIEdgeInsetsMake(0,  0,  0, 20);
        _cursorView.lineView.hidden = YES;
        _cursorView.bSmallGameFlag = YES;
        _cursorView.collectionView.scrollEnabled = YES;
        _cursorView.collectionView.showsHorizontalScrollIndicator = NO;
        _cursorView.collectionView.showsVerticalScrollIndicator = NO;
        
    }
    return _cursorView;
}

@end
