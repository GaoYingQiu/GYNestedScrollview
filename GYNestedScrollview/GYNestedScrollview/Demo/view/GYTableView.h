//
//  GYTableView.h
//  GYNestedScrollview
//
//  Created by qiugaoying on 2019/2/14.
//  Copyright © 2019年 qiugaoying. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GYTableView : UITableView<UIGestureRecognizerDelegate>

@property(nonatomic,assign) BOOL supportGesScrollPassEvent; //是否支持多手势
@end

