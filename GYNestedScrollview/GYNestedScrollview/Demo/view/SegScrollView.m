//
//  HomeScrollCell.m
//  Ying2018
//
//  Created by qiugaoying on 2018/10/24.
//  Copyright © 2018年 qiugaoying. All rights reserved.
//

#import "SegScrollView.h"
#import <Masonry.h>

#define SCREEN_W   [UIScreen mainScreen].bounds.size.width
#define SCREEN_H  [UIScreen mainScreen].bounds.size.height

#define ScrollSubViewCount 3

@interface SegScrollView()<UIScrollViewDelegate>

@end

@implementation SegScrollView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
   
        self.scrollView = [[UIScrollView alloc]init];
        self.scrollView.pagingEnabled = YES;
        self.scrollView.delegate = self;
        self.scrollView.bounces = NO;
        self.scrollView.backgroundColor = [UIColor whiteColor];
        self.scrollView.showsHorizontalScrollIndicator = NO;
//        self.scrollView.contentSize = CGSizeMake(SCREEN_W*1, self.scrollView.frame.size.height);
        [self addSubview:self.scrollView];
        [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.right.mas_equalTo(0);
            make.bottom.mas_equalTo(0);
        }];
        
        UIView *lastSubView = nil;
        for (int i=0; i< ScrollSubViewCount; i++) {
            UIView *subView = [[UIView alloc]init];
            subView.backgroundColor = [UIColor whiteColor];
            [self.scrollView addSubview:subView];
            subView.tag = 1000+i;
            [subView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.bottom.mas_equalTo(0);
                make.width.equalTo(@(SCREEN_W));
                if(lastSubView){
                    make.left.equalTo(lastSubView.mas_right).offset(0);
                }else{
                    make.left.mas_equalTo(0);
                }
                if(i == ScrollSubViewCount-1){
                    make.right.mas_equalTo(0);
                }
            }];
            lastSubView = subView;
        }
    }
    return self;
}

#pragma mark - UIScrollViewDelegate
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    
    NSInteger index = scrollView.contentOffset.x/self.scrollView.frame.size.width;
    //通知更改选择框
    if(self.itemBlock){
        self.itemBlock(index);
    }
}
@end
