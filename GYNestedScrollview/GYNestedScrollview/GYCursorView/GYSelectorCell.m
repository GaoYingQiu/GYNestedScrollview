

#import "GYSelectorCell.h"

@interface GYSelectorCell ()

@property (nonatomic, strong) UILabel *detailLabel;
@end

@implementation GYSelectorCell
-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.contentView.backgroundColor = [UIColor clearColor];
        
        _selectedColor = [UIColor redColor];
        _normalColor = [UIColor whiteColor];
        _selectedFont = _normalFont = [UIFont systemFontOfSize:14];
        
        _titleLabel = [[UILabel alloc]init];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:_titleLabel];
        
        _titleLabel.layer.cornerRadius = 2;
        _titleLabel.layer.masksToBounds = YES;
    }
    return self;
}

-(void)setDetailTitle:(NSString *)detailTitle
{
    _detailTitle = detailTitle;
    _detailLabel.text = _detailTitle;
}

-(void)setTitle:(NSString *)title
{
    _title = title;
    _titleLabel.text = _title;
}

-(void)setSelected:(BOOL)selected
{
    super.selected = selected;
    
//    self.contentView.backgroundColor = _backGroundColor;
    if (selected) {
        _titleLabel.font = _selectedFont;
        _titleLabel.textColor = _selectedColor;
        _titleLabel.backgroundColor = [UIColor orangeColor];
        
    }else{
        _titleLabel.font = _normalFont;
        _titleLabel.textColor = _normalColor;
        _titleLabel.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.75];
    }
    
    if(_bClearColorFlag){
        _titleLabel.backgroundColor = [UIColor clearColor];
    }
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
     _titleLabel.frame = CGRectMake(2.5, 10, self.bounds.size.width-5, self.bounds.size.height-20);
    if(_bClearColorFlag){
        if(_bClearColorFirstFlag){
            _titleLabel.frame = CGRectMake(10, 10, self.bounds.size.width-10, self.bounds.size.height-20);
        }
    }
    
    if(_bBackColorFlag){
        if(_bClearColorFirstFlag){
            _titleLabel.frame = CGRectMake(15, 10, self.bounds.size.width-10-7.5, self.bounds.size.height-20);
        }
    }
}

@end
