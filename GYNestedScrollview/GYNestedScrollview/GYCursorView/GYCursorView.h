//
//  GYCursorView.h
//  youhe
//
//  Created by qiugaoying on 2017/8/22.
//  Copyright © 2017年 qiugaoying. All rights reserved.
//


#import <UIKit/UIKit.h>

#import "ConditionFilter.h"

typedef void (^DidSelectItemBlock)(ConditionFilter * filter);

@interface GYCursorView : UIView
/**
 *  底部标识线
 */
@property (nonatomic, strong) UIView *lineView;

@property (nonatomic, copy) NSArray *extDataDicArr; //扩展字段 [{@"Month":@"8月",@"Year":@"2017"}]
@property (nonatomic, strong) UIColor *selectedColor;
@property (nonatomic, strong) UIColor *normalColor;
@property (nonatomic, strong) UIColor *backGroundColor;

@property (nonatomic, assign) BOOL bClearColorFlag;

@property (nonatomic, assign) BOOL bBackColorFlag;
@property (nonatomic, assign) BOOL bSmallGameFlag;

@property (nonatomic, assign) BOOL clickSameItemNeedReloadFlag;
@property (nonatomic, assign) CGSize fixItemSize; //固定的ItemSize
@property (nonatomic, strong) UIColor *lineViewColor;
@property (nonatomic, strong) UIFont *selectedFont;
@property (nonatomic, strong) UIFont *normalFont;

@property (nonatomic, strong) UICollectionView *collectionView;

@property(nonatomic,copy)DidSelectItemBlock selectItemBlock;

/**
 *  当前选中的index。可以设置当前的index
 */
@property (nonatomic, assign) NSInteger currentIndex;
/**
 *  分割线位置调整。总是居中显示  默认(0,3,2,3)
    分割线默认高度为3， left可调整宽度，top可调整高度，bottom可调整lineView的y值
 */
@property (nonatomic, assign) UIEdgeInsets lineEdgeInsets;
/**
 *  选择区域调整。默认(0,10,0,10)
 */
@property (nonatomic, assign) UIEdgeInsets cursorEdgeInsets;
/**
 *  必须调用此方法来绘制界面
 */
-(void)reloadPages;

//选中当前item
-(void)selectItemAtCurrentIndex;

-(void)didSelectItemIndexWithBlock:(DidSelectItemBlock)selectItemBlock;
@end
