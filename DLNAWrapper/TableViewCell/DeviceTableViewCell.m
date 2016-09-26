//
//  DeviceTableViewCell.m
//  DLNAWrapper
//
//  Created by Key.Yao on 16/9/21.
//  Copyright © 2016年 Key. All rights reserved.
//

#import "DeviceTableViewCell.h"
#import "Masonry.h"

@implementation DeviceTableViewCell

@synthesize titleLabel;

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        titleLabel = [[UILabel alloc] init];
        
        titleLabel.textColor = [UIColor blackColor];
        
        titleLabel.numberOfLines = 1;
        
        titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        
        [self addSubview:titleLabel];
        
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.mas_left).offset(20);
            make.right.equalTo(self.mas_right).offset(-20);
            make.centerY.equalTo(self);
        }];
    }
    
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
