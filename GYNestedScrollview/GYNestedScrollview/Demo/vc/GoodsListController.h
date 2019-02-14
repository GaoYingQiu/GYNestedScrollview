//
//  GoodsListController.h
//  GYNestedScrollview
//
//  Created by qiugaoying on 2019/2/14.
//  Copyright © 2019年 qiugaoying. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GYTableView.h"

NS_ASSUME_NONNULL_BEGIN

@interface GoodsListController : UIViewController
@property(nonatomic,strong) GYTableView *tableView;
@property(nonatomic,assign) BOOL canVcScroll; //是否可以滑动；

@property(nonatomic,assign) BOOL fullFlag; //是否充满;/
@end

NS_ASSUME_NONNULL_END
