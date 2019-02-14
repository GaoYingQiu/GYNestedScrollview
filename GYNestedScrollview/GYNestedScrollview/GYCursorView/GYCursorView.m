//
//  GYCursorView.m
//  youhe
//
//  Created by qiugaoying on 2017/8/22.
//  Copyright © 2017年 qiugaoying. All rights reserved.
//

#import "GYCursorView.h"
#import "GYSelectorCell.h"

static NSString *const cellIdentifier = @"selectorCell";

@interface GYCursorView ()<UICollectionViewDelegateFlowLayout,UICollectionViewDataSource>

@property (nonatomic, strong) UICollectionViewFlowLayout *layout;

@end

@implementation GYCursorView

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
      
        //设置颜色默认值
        _normalFont = _selectedFont = [UIFont systemFontOfSize:14];
        _normalColor = [UIColor blackColor];
        _selectedColor = [UIColor redColor];
        _currentIndex = 0;
        _lineEdgeInsets = UIEdgeInsetsMake(0, 3, 2, 3);
        _cursorEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 10);
        
    }
    return self;
}


#pragma mark - SETUP UI
-(UIView*)lineView
{
    if (!_lineView) {
        _lineView = [[UIView alloc]init];
        _lineView.backgroundColor = [UIColor orangeColor];
        if(_lineViewColor){
            _lineView.backgroundColor = _lineViewColor;
        }
        
        [self.collectionView addSubview:_lineView];
    }
    return _lineView;
}

-(UICollectionView*)collectionView
{
    if (!_collectionView) {
        _layout = [[UICollectionViewFlowLayout alloc]init];
        _layout.minimumLineSpacing = 0;
        _layout.minimumInteritemSpacing = 0;
        _layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        
        CGRect rect = CGRectMake(_cursorEdgeInsets.left, _cursorEdgeInsets.top, CGRectGetWidth(self.bounds)-_cursorEdgeInsets.left-_cursorEdgeInsets.right, CGRectGetHeight(self.bounds)-_cursorEdgeInsets.top-_cursorEdgeInsets.bottom);
        _collectionView = [[UICollectionView alloc]initWithFrame:rect collectionViewLayout:_layout];
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.scrollsToTop = NO;
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.backgroundColor = _backGroundColor;
        [_collectionView registerClass:[GYSelectorCell class] forCellWithReuseIdentifier:cellIdentifier];
        [self addSubview:_collectionView];
    }
    return _collectionView;
}


-(void)reloadPages
{
    [self.collectionView reloadData];
}

-(void)setExtDataDicArr:(NSArray *)extDataDicArr
{
    _extDataDicArr = extDataDicArr;
    [self.collectionView reloadData];
}

/**
 *  设置collectionView的偏移量，使得选中的项目居中
 *
 *  @param frame cellFrame
 */
-(void)setContentOffsetWithCellFrame:(CGRect)frame
{
    CGFloat width = CGRectGetWidth(self.collectionView.frame)/2;
    CGFloat offsetX = 0;
    
    if (CGRectGetMidX(frame) <= width) {
        
        offsetX = 0;
        
    }else if (CGRectGetMidX(frame) + width >= self.collectionView.contentSize.width) {
        
        offsetX = self.collectionView.contentSize.width - CGRectGetWidth(self.collectionView.frame);
        if(self.collectionView.contentSize.width < CGRectGetWidth(self.collectionView.frame)){
            offsetX = 0; //防止不超界面的情况下滑动到右边去了 by qiu;
        }
        
    }else{
        offsetX = CGRectGetMidX(frame)-CGRectGetWidth(self.collectionView.frame)/2;
    }
    [self.collectionView setContentOffset:CGPointMake(offsetX, 0) animated:YES];
}
/**
 *  设置标识线的frame
 *
 *  @param frame cellFrame
 */
-(void)resizeLineViewWihtCellFrame:(CGRect)frame animated:(BOOL)animated
{
    CGFloat rightMargin = _lineEdgeInsets.right;
    CGFloat leftMargin = _lineEdgeInsets.left;
    if(_currentIndex != 0){
        rightMargin  += 3;
    }else{
        leftMargin += 5;
    }
    CGFloat height = 2.0f;
    CGRect rect = CGRectMake(CGRectGetMinX(frame)+ leftMargin,
                             CGRectGetHeight(self.collectionView.frame)-height-_lineEdgeInsets.bottom,
                             CGRectGetWidth(frame)- rightMargin, height-_lineEdgeInsets.top);
    
    if (animated) {
        [UIView animateWithDuration:0.3f animations:^{
            self.lineView.frame = rect;
        }];
    }else{
        self.lineView.frame = rect;
    }
    
    if(_lineViewColor){
        _lineView.backgroundColor = _lineViewColor;
    }

}
/**
 *  主动设置cursor选中item
 *
 *  @param index index
 */
-(void)selectItemAtCurrentIndex
{
    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:_currentIndex inSection:0];
   
    [self selectItemAtIndexPath:indexPath];
    
    [self.collectionView selectItemAtIndexPath:indexPath
                                      animated:YES
                                scrollPosition:UICollectionViewScrollPositionCenteredHorizontally];
    
}
/**
 *  设置计算选中的item状态
 *
 *  @param indexPath indexPath
 */
-(void)selectItemAtIndexPath:(NSIndexPath*)indexPath
{
    GYSelectorCell *cell = (GYSelectorCell*)[self.collectionView cellForItemAtIndexPath:indexPath];
    cell.selected = YES;
    CGRect rect = cell.frame;
    if (!cell) {
        UICollectionViewLayoutAttributes *attributes = [self.collectionView layoutAttributesForItemAtIndexPath:indexPath];
        rect = attributes.frame;
    }
    
    [self setContentOffsetWithCellFrame:rect];
    [self resizeLineViewWihtCellFrame:rect animated:YES];

//    [self addChildViewController];
}
/**
 *  主动设置使item变为不可选
 *
 *  @param index index
 */
-(void)deselectItemAtIndex:(NSInteger)index
{
    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:index inSection:0];
    [self.collectionView deselectItemAtIndexPath:indexPath animated:NO];
    GYSelectorCell *cell = (GYSelectorCell*)[self.collectionView cellForItemAtIndexPath:indexPath];
    cell.selected = NO;
}


#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    
    return _extDataDicArr.count;
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    GYSelectorCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    cell.bClearColorFlag = self.bClearColorFlag;
    cell.bBackColorFlag = self.bBackColorFlag;
    cell.backGroundColor = self.backGroundColor;
    cell.bClearColorFirstFlag = indexPath.item == 0;
    ConditionFilter *data = [_extDataDicArr objectAtIndex:indexPath.item];
    cell.title = data.name;
  
    cell.normalFont = self.normalFont;
    cell.selectedFont = self.selectedFont;
    cell.normalColor = self.normalColor;
    cell.selectedColor = self.selectedColor;
    
    cell.selected = (indexPath.item == _currentIndex);
    if (collectionView.indexPathsForSelectedItems.count <= 0) {
        [self.collectionView selectItemAtIndexPath:[NSIndexPath indexPathForItem:_currentIndex inSection:0]
                                          animated:NO
                                    scrollPosition:UICollectionViewScrollPositionNone];
        
//        [self resizeLineViewWihtCellFrame:cell.frame animated:NO];
    }
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{

    if(!_clickSameItemNeedReloadFlag){
        if (_currentIndex == indexPath.item) {
            return;
        }
    }
    
    self.currentIndex = indexPath.item;
    
    [self selectItemAtIndexPath:indexPath];
    
    if (self.selectItemBlock) {
        self.selectItemBlock([self.extDataDicArr objectAtIndex:indexPath.item]);
    }
}

- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath
{
    GYSelectorCell *cell = (GYSelectorCell*)[collectionView cellForItemAtIndexPath:indexPath];
    cell.selected = NO;
}


#pragma mark - UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
//    if(self.fixItemSize.width >0){
//        //有固定大小就显示 固定大小；
//        return CGSizeMake(56, CGRectGetHeight(self.bounds));
//    }else{
    
        ConditionFilter *data = _extDataDicArr[indexPath.item];
        NSString *title = data.name;
        CGSize size = [title sizeWithAttributes:@{NSFontAttributeName:self.selectedFont}];
        CGFloat spance = 16*2;
        if(self.bClearColorFlag){
            spance = 20;
        }
    
        if(self.bSmallGameFlag){
            spance = 25.4;
        }
    
        // 第一个子项 左边距 15；多12.5
        CGFloat firstAddWidth = 0;
        if(indexPath.row == 0 && self.bBackColorFlag){
            firstAddWidth = 5;
        }
        size = CGSizeMake(size.width+spance + 5 + firstAddWidth, CGRectGetHeight(self.bounds));
        return size;
//    }
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0, 0, 0, 0);
}


@end
