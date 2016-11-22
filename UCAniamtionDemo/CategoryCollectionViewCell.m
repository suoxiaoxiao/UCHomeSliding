//
//  CategoryCollectionViewCell.m
//  UCAniamtionDemo
//
//  Created by 索晓晓 on 16/11/21.
//  Copyright © 2016年 SXiao.RR. All rights reserved.
//

#import "CategoryCollectionViewCell.h"

@interface CategoryCollectionViewCell ()

@property (nonatomic ,strong)UILabel *label;

@end

@implementation CategoryCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        self.label = [[UILabel alloc] init];
        
        self.backgroundColor = [UIColor clearColor];
        
        self.contentView.backgroundColor = [UIColor clearColor];
        
        self.label.backgroundColor = [UIColor clearColor];
        
        self.label.textColor = [UIColor whiteColor];
        
        self.label.font = [UIFont systemFontOfSize:14];
        
        self.label.textAlignment = NSTextAlignmentCenter;
        
        [self.contentView addSubview:self.label];
        
    }
    return self;
}

- (void)setTitle:(NSString *)title
{
    _title = title;
    
    self.label.text = title;
    
    [self setNeedsLayout];
    [self layoutIfNeeded];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.label.frame = self.bounds;
}


@end
