//
//  Goods.h
//  GYNestedScrollview
//
//  Created by qiugaoying on 2019/2/14.
//  Copyright © 2019年 qiugaoying. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Goods : NSObject

@property(nonatomic,assign) NSInteger goodsId; //商品id
@property(nonatomic,assign) NSInteger goodsType; //商品类型
@property(nonatomic,assign) NSInteger goodsApi; //商品 二级子类型
@property(nonatomic,assign) NSInteger goodsState; //商品状态
@property(nonatomic,assign) NSInteger storeCount; //仓库数
@property(nonatomic,strong) NSString *goodsName; //商品名
@property(nonatomic,strong) NSString *logoUrl;  //图片
@property(nonatomic,strong) NSString *content; //描述
@property(nonatomic,strong) NSArray *goodsTagList;

@end

@interface GoodsFilterModel : NSObject

@property(nonatomic,assign) NSInteger Id;
@property(nonatomic,strong) NSString *tagName;
@property(nonatomic,strong) NSString *logoUrl;

@end


NS_ASSUME_NONNULL_END
