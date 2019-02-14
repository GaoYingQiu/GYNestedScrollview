
#import <UIKit/UIKit.h>

@interface GYSelectorCell : UICollectionViewCell
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *detailTitle;


@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) UIColor *selectedColor;
@property (nonatomic, strong) UIColor *normalColor;
@property (nonatomic, strong) UIColor *backGroundColor;

@property (nonatomic, strong) UIFont *selectedFont;
@property (nonatomic, strong) UIFont *normalFont;

@property(nonatomic,assign) BOOL bClearColorFlag;
@property(nonatomic,assign) BOOL bClearColorFirstFlag;

@property(nonatomic,assign) BOOL bBackColorFlag;

@end
