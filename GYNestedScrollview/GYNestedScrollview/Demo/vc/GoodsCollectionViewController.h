//
//  GoodsCollectionViewController.h
//  GYNestedScrollview
//
//  Created by qiugaoying on 2019/2/14.
//  Copyright © 2019年 qiugaoying. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GYBaseCollectView.h"

NS_ASSUME_NONNULL_BEGIN

@interface GoodsCollectionViewController : UIViewController

@property(nonatomic,assign) BOOL canVcScroll;
@property (nonatomic, strong) GYBaseCollectView *dataCollection;

@end

NS_ASSUME_NONNULL_END
