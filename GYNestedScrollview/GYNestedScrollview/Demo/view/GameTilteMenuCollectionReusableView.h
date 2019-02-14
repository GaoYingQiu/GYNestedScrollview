//
//  SportTypeCollectionReusableView.h
//  Ying2018
//
//  Created by qiugaoying on 2018/7/26.
//  Copyright © 2018年 qiugaoying. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GYCursorView.h"
#import "Goods.h"

typedef void(^GameTilteMenuCollectionReusableViewItemBlock)(id selectGoods,id selectItemFilter);

@interface GameTilteMenuCollectionReusableView : UICollectionReusableView

@property(nonatomic,strong) GYCursorView *cursorView;

@property(nonatomic,strong) GYCursorView *cursorTitleView;

@property (nonatomic,copy) GameTilteMenuCollectionReusableViewItemBlock selectDoneBlock;


//gameModel  List; //点击的是大的；
-(void)fitDataSource:(NSArray *)extDicArr selectGoods:(Goods *)goods selectFilter:(ConditionFilter *)filter;

@end
