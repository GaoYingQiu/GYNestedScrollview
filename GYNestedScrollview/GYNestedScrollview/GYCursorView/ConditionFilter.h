//
//  ConditionFilter.h
//  Ying2018
//
//  Created by qiugaoying on 2018/11/5.
//  Copyright © 2018年 qiugaoying. All rights reserved.
//

#import <Foundation/Foundation.h>
@class ConditionFilter;

@interface ConditionFilter : NSObject

@property(nonatomic,assign) NSInteger value;
@property(nonatomic,strong) NSString *name;
@property(nonatomic,strong) NSArray *statusItem;
@end
