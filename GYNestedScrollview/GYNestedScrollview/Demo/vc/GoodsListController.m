//
//  GoodsListController.m
//  GYNestedScrollview
//
//  Created by qiugaoying on 2019/2/14.
//  Copyright © 2019年 qiugaoying. All rights reserved.
//

#import "GoodsListController.h"
#import "GameTypeCell.h"
#import <Masonry.h>
#import "UINavigationController+FDFullscreenPopGesture.h"



@interface GoodsListController ()<UITableViewDelegate,UITableViewDataSource>

@end

@implementation GoodsListController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
 
     self.extendedLayoutIncludesOpaqueBars = NO;
     self.edgesForExtendedLayout = UIRectEdgeTop;
    [self addLayoutTableView];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if(scrollView == self.tableView){
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

-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return  80 * (self.view.frame.size.width-30)/345 + 10;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.fullFlag?10:3;
}


-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.000001f;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"GameTypeCell";
    GameTypeCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if(cell == nil){
        cell=[[[NSBundle mainBundle]loadNibNamed:@"GameTypeCell" owner:nil options:nil]
              firstObject];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    cell.gameImageView.image = [UIImage imageNamed:@"goodsBanner"];
    cell.gameNameLabel.text = [NSString stringWithFormat:@"商品%ld",indexPath.row];
    return cell;
}

- (void)addLayoutTableView{
    
    _tableView                              = [[GYTableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    _tableView.separatorInset               = UIEdgeInsetsMake(0, 0, 0, 0);
    _tableView.estimatedRowHeight           = 0;
    _tableView.estimatedSectionHeaderHeight = 0;
    _tableView.estimatedSectionFooterHeight = 0;
    _tableView.backgroundColor = [UIColor whiteColor];
    _tableView.scrollsToTop                 = YES;
    _tableView.tableFooterView              = [[UIView alloc] init];
    _tableView.delegate                     = self;
    _tableView.dataSource                   = self;
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
    _tableView.rowHeight = 44;
    _tableView.separatorStyle = 0;
    _tableView.supportGesScrollPassEvent = YES;
    _tableView.tableHeaderView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 15)];
    [self.view addSubview:_tableView];
    
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.mas_equalTo(0);
        make.bottom.mas_equalTo(-(43));
    }];
    
    [self iOS11ContentInset:self.tableView];
    
   
}

#pragma mark ————— 适配ios11偏移问题 —————
-(void)iOS11ContentInset:(UIScrollView *)scrollView{
    
    if (@available(iOS 11.0, *))
    {
        scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
    else
    {
        self.automaticallyAdjustsScrollViewInsets = NO;
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
