//
//  CustomCollectionViewCell.m
//  UCAniamtionDemo
//
//  Created by 索晓晓 on 16/11/18.
//  Copyright © 2016年 SXiao.RR. All rights reserved.
//

#import "CustomCollectionViewCell.h"

@interface CustomCollectionViewCell ()

@property (nonatomic ,strong)UIImageView *image1;

@property (nonatomic ,strong)UIView *bgView;

@end

@implementation CustomCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.clipsToBounds = YES;
        self.layer.masksToBounds = YES;
        
        self.bgView = [[UIView alloc] init];
        [self.contentView addSubview:self.bgView];
        
         self.backgroundColor = [UIColor colorWithRed:(arc4random_uniform(255)+1)/255.0 green:(arc4random_uniform(255)+1)/255.0 blue:(arc4random_uniform(255)+1)/255.0 alpha:1.0];
        
        self.image1 = [[UIImageView alloc] init];
        
        self.image1.contentMode = UIViewContentModeScaleAspectFit;
        
        
        [self.bgView addSubview:self.image1];
        
    }
    return self;
}

- (void)setImageUrl:(NSString *)imageUrl
{
    _imageUrl = imageUrl;
    
    [self.image1 setImage:[UIImage imageNamed:imageUrl]];
    self.bgView.transform = CGAffineTransformIdentity;
    
    [self setNeedsLayout];
    [self layoutIfNeeded];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.bgView.frame = self.bounds;
    self.image1.frame = self.bounds;
}

- (void)updateContentOffset
{
    CGRect converR = [self convertRect:self.bounds toView:self.window];
    
    CGFloat cellCenterx = CGRectGetMidX(converR);
    
    CGFloat windowCenterx = self.window.center.x;
    
    CGFloat gap = cellCenterx - windowCenterx;
    
    self.bgView.transform = CGAffineTransformMakeTranslation(-1 * gap * 0.5, 0);
}

- (void)resumeContentOffset
{
    self.bgView.transform = CGAffineTransformMakeTranslation(0, 0);
}

@end
