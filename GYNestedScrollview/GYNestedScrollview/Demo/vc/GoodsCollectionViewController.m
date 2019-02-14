//
//  GoodsCollectionViewController.m
//  GYNestedScrollview
//
//  Created by qiugaoying on 2019/2/14.
//  Copyright © 2019年 qiugaoying. All rights reserved.
//

#import "GoodsCollectionViewController.h"
#import <MJRefresh/MJRefreshAutoFooter.h>
#import "GYBaseCollectView.h"
#import "ConditionFilter.h"
#import "GameTilteMenuCollectionReusableView.h"
#import <Masonry.h>
#import "GY_NiineShopCollectionViewCell.h"
#import "Goods.h"
#import <UIImageView+WebCache.h>

@interface GoodsCollectionViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>

@property(nonatomic,strong) NSArray * tagListArr; //标题栏数组；MG 和 PT ; gameApi
@property(nonatomic,strong) NSMutableArray *smallGameArr;
@property(nonatomic,strong) NSArray *conditionArr; //标题条件
@property(nonatomic,strong) ConditionFilter *selectFilter; //选中的条件

@property(nonatomic,strong) Goods *parentGoods; //选中的一级类型

@end

@implementation GoodsCollectionViewController

static NSString  *const nineDataID = @"nineDataID";
static NSString  *const GameHeaderIdentifier = @"GameHeaderIdentifier";


- (void)viewDidLoad {
    [super viewDidLoad];
     _smallGameArr = [[NSMutableArray alloc]init];
    // Do any additional setup after loading the view.
    
    [self addDataCollection];
    
    [self demoLocalData];
}



-(void)addDataCollection{
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
    layout.minimumLineSpacing = 10;
    layout.minimumInteritemSpacing = 5;
    
    layout.footerReferenceSize = CGSizeMake(self.view.frame.size.width, 7);
    _dataCollection = [[GYBaseCollectView alloc]initWithFrame:CGRectZero collectionViewLayout:layout];
    _dataCollection.delegate = self;
    _dataCollection.dataSource = self;
    _dataCollection.backgroundColor = self.view.backgroundColor; // Color(246, 246, 246, 1);
    _dataCollection.showsVerticalScrollIndicator= NO;
    _dataCollection.tag = 2;
    [self.view addSubview:_dataCollection];
    [_dataCollection mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10);
        make.right.mas_equalTo(-10);
        make.top.mas_equalTo(0);
        make.bottom.mas_equalTo(-43);
    }];
    
    _dataCollection.mj_footer = [MJRefreshAutoFooter footerWithRefreshingBlock:^{
        //加载更多；
    }];
    
    [self.dataCollection registerClass:[GameTilteMenuCollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:GameHeaderIdentifier];
    
    [self.dataCollection registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"space"];
    
    [self.dataCollection registerClass:[GY_NiineShopCollectionViewCell class] forCellWithReuseIdentifier:nineDataID];
}


#pragma mark----UICollectionViewDelegate

-(UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    if (kind == UICollectionElementKindSectionHeader)
    {
        GameTilteMenuCollectionReusableView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:GameHeaderIdentifier forIndexPath:indexPath];
        
        if(self.tagListArr.count){
            [headerView fitDataSource:self.tagListArr selectGoods:self.parentGoods selectFilter:self.selectFilter ];
        }
        
        MJWeakSelf
        headerView.selectDoneBlock = ^(id selectGoods, id selectItemFilter) {
            weakSelf.selectFilter = selectItemFilter;
            weakSelf.parentGoods = selectGoods;
            [weakSelf requestFirstPage];
        };
        
        return headerView;
    }else{
        UICollectionReusableView *footerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"space" forIndexPath:indexPath];
        footerView.backgroundColor = [UIColor whiteColor];
        return footerView;
    }
}

-(NSInteger)numberOfSectionsInCollectionView:(nonnull UICollectionView *)collectionView{
    
    return 1;
    
}

-(NSInteger)collectionView:(nonnull UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return  self.smallGameArr.count;
}

-(UICollectionViewCell *)collectionView:(nonnull UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath{
    
    GY_NiineShopCollectionViewCell *shopcell = [collectionView dequeueReusableCellWithReuseIdentifier:nineDataID forIndexPath:indexPath];
    
//    Goods *model=self.smallGameArr[indexPath.row];
//    shopcell.titleLabel.text = model.goodsName;
//     [shopcell.imageView sd_setImageWithURL:[NSURL URLWithString:model.logoUrl] placeholderImage:nil];
    
    shopcell.titleLabel.text = [NSString stringWithFormat:@"%@-%@%ld",self.parentGoods.goodsName, self.selectFilter.name?:@"全部",indexPath.row];
    NSInteger index = arc4random_uniform(5);
    shopcell.imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"goods%ld",index]];
    shopcell.imageView.layer.cornerRadius = 5;
    shopcell.imageView.layer.masksToBounds = YES;
    
    return shopcell;
}

//设置元素的大小
-(CGSize)collectionView:(nonnull UICollectionView *)collectionView layout:(nonnull UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(nonnull NSIndexPath *)indexPath{
    
    CGFloat collectionViewWidth = self.view.frame.size.width - 12*2 - 60;
    return CGSizeMake(collectionViewWidth/4, 48 + 30);
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    if(self.selectFilter.value == 0 && self.smallGameArr.count == 0){
        return CGSizeMake(0, 0);
    }
    return CGSizeMake(self.view.frame.size.width, 112);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
}

//请求第一页数据；
-(void)requestFirstPage
{
    [_smallGameArr removeAllObjects];
    
    // 从网络请求后拿到数据；
    for(int i = 0 ;i<32; i++){
        [_smallGameArr addObject:[Goods new]];
    }
    
    [self.dataCollection reloadData];
}

-(void)demoLocalData
{
    GoodsFilterModel *filter1 = [GoodsFilterModel new];
    filter1.Id = 11;
    filter1.tagName = @"科幻";
    
    GoodsFilterModel *filter2 = [GoodsFilterModel new];
    filter2.Id = 12;
    filter2.tagName = @"文学";
    
    GoodsFilterModel *filter3 = [GoodsFilterModel new];
    filter3.Id = 13;
    filter3.tagName = @"艺术";
    
    Goods *goodsType1 = [[Goods alloc]init];
    goodsType1.goodsName = @"书店";
    goodsType1.goodsApi = 1;
    goodsType1.goodsTagList = @[filter1,filter2,filter3];
    
    
    
    GoodsFilterModel *filter21 = [GoodsFilterModel new];
    filter21.Id = 21;
    filter21.tagName = @"水果";
    
    GoodsFilterModel *filter22 = [GoodsFilterModel new];
    filter22.Id = 22;
    filter22.tagName = @"零食";
    
    
    Goods *goodsType2 = [[Goods alloc]init];
    goodsType2.goodsName = @"超市";
    goodsType2.goodsApi = 2;
    goodsType2.goodsTagList = @[filter21,filter22];
    
    self.tagListArr = @[goodsType1,goodsType2];
    self.parentGoods = self.tagListArr.firstObject;
    
    //请求数据
    [self requestFirstPage];
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if(scrollView == self.dataCollection){
        if (!self.canVcScroll) {
            scrollView.contentOffset = CGPointZero;
        }
        if (scrollView.contentOffset.y <= 0) {
            self.canVcScroll = NO;
            scrollView.contentOffset = CGPointZero;
            [[NSNotificationCenter defaultCenter] postNotificationName:@"leaveTop" object:nil];//到顶通知父视图改变状态
        }
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
