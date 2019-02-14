//
//  GYBaseCollectView.m
//  Ying2018
//
//  Created by qiugaoying on 2018/12/15.
//  Copyright © 2018年 qiugaoying. All rights reserved.
//

#import "GYBaseCollectView.h"

@implementation GYBaseCollectView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES; //支持多事件传递；
}

@end
