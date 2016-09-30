//
//  AssetTableViewCell.m
//  DLNAWrapper
//
//  Created by Key.Yao on 16/9/28.
//  Copyright © 2016年 Key. All rights reserved.
//

#import "Masonry.h"
#import "AssetTableViewCell.h"

@implementation AssetTableViewCell

@synthesize iconView;
@synthesize titleLabel;

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        iconView = [[UIImageView alloc] init];
        iconView.contentMode = UIViewContentModeScaleAspectFit;
        iconView.layer.masksToBounds = YES;
        [self addSubview:iconView];
        
        titleLabel = [[UILabel alloc] init];
        titleLabel.textColor = [UIColor blackColor];
        titleLabel.numberOfLines = 1;
        titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        [self addSubview:titleLabel];
        
        [iconView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self);
            make.left.equalTo(self.mas_left).offset(20);
            make.size.mas_equalTo(CGSizeMake(50, 50));
        }];
        
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self);
            make.left.equalTo(iconView.mas_right).offset(20);
            make.right.equalTo(self.mas_right).offset(-20);
        }];
    }
    
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
