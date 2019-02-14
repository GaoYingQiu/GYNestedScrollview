

#import <Masonry.h>
#import "GY_NiineShopCollectionViewCell.h"

@implementation GY_NiineShopCollectionViewCell

-(instancetype)initWithFrame:(CGRect)frame{

    if (self = [super initWithFrame:frame]) {
        
        self.backgroundColor = [UIColor whiteColor];
        
        //图片
        self.imageView = [[UIImageView alloc]init];
        self.imageView.contentMode = UIViewContentModeScaleAspectFill;
        [self addSubview:self.imageView];
        
        _imageV = [[UIImageView alloc]init];
        [self addSubview:_imageV];
        [_imageV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(@2);
            make.right.mas_equalTo(-20);
            make.top.equalTo(self.imageView);
            make.bottom.mas_equalTo(0);
        }];
        
        
        //描述
        self.titleLabel = [[UILabel alloc]init];
        self.titleLabel.font = [UIFont systemFontOfSize:12];
        self.titleLabel.textColor = [UIColor blackColor];
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:self.titleLabel];
 
        [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(0);
            make.height.width.equalTo(@(48));
            make.centerX.mas_equalTo(self);
        }];
        
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.imageView.mas_bottom).offset(4);
            make.bottom.left.right.mas_equalTo(0);
        }];
    
    }

    return self;
}

@end
