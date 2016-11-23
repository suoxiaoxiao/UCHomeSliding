//
//  CategorySliderView.h
//  UCAniamtionDemo
//
//  Created by 索晓晓 on 16/11/21.
//  Copyright © 2016年 SXiao.RR. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CategorySliderView : UIView


@property (nonatomic , assign)CGFloat dependOnViewCellWidth;

@property (nonatomic ,copy)void(^touchIndex)(NSInteger index);



- (UIImage *)updateCaptureImage;

- (instancetype)initWithFrame:(CGRect)frame WithData:(NSArray *)array;


- (void)updateData:(NSMutableArray *)data;




@end
