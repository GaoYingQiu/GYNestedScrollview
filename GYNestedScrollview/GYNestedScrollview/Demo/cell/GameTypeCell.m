//
//  GameRecordCell.m
//  Ying2018
//
//  Created by qiugaoying on 2018/10/30.
//  Copyright © 2018年 qiugaoying. All rights reserved.
//

#import "GameTypeCell.h"

@implementation GameTypeCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.gameImageView.contentMode = UIViewContentModeScaleToFill;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
