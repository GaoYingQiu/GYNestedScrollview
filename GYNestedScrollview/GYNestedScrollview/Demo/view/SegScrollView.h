//
//  HomeScrollCell.h
//  Ying2018
//
//  Created by qiugaoying on 2018/10/24.
//  Copyright © 2018年 qiugaoying. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^ScrollItemIndexBlock)(NSInteger index);

@interface SegScrollView : UIView
@property(nonatomic,strong) UIScrollView *scrollView;

@property(nonatomic,copy) ScrollItemIndexBlock itemBlock;
@end
