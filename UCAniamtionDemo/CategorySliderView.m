//
//  CategorySliderView.m
//  UCAniamtionDemo
//
//  Created by 索晓晓 on 16/11/21.
//  Copyright © 2016年 SXiao.RR. All rights reserved.
//



#import "CategorySliderView.h"
#import <Foundation/NSUnit.h>

NSInteger const bottomLineHeight = 10;
NSInteger const buttonTagGap = 10000;

@interface CategorySliderView ()<UIScrollViewDelegate>

@property (nonatomic ,strong)UIScrollView *bgScrollView;
@property (nonatomic , assign)CGFloat blockWidth;

@property (nonatomic ,strong)NSMutableArray *dataArray;

@property (nonatomic ,strong)UIImageView *bottomLine;

@property (nonatomic ,strong)UIImage *captureImage;
@property (nonatomic ,strong)UIView *loadTitleColorView;

@property (nonatomic , assign)BOOL isClickCelllTriggerAction;

@end


@implementation CategorySliderView

- (NSMutableArray *)dataArray
{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}


- (instancetype)initWithFrame:(CGRect)frame WithData:(NSArray *)array
{
    if (self = [super initWithFrame:frame]) {
        
        self.backgroundColor = [UIColor clearColor];
        
        self.dataArray = [array mutableCopy];
        _blockWidth = frame.size.width/4.0;
        [self setUp];
    }
    return self;
}

- (void)updateData:(NSMutableArray *)data
{
    self.dataArray = data;
    
    for (UIView *sub in self.bgScrollView.subviews) {
        if (sub == self.bottomLine) {
            continue;
        }
        
        [sub removeFromSuperview];
    }
    
    for (int i = 0; i < data.count; i++) {
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        
        btn.tag = i + buttonTagGap;
        
        btn.frame = CGRectMake(i * _blockWidth, 0, _blockWidth, self.frame.size.height);
        
        [btn setTitle:self.dataArray[i] forState:0];
        
        [btn setTitleColor:[UIColor whiteColor] forState:0];
        
        btn.titleLabel.textAlignment = NSTextAlignmentCenter;
        
        [btn addTarget:self action:@selector(handleCategoryClickAction:) forControlEvents:UIControlEventTouchUpInside];
        
        [self.bgScrollView addSubview:btn];
        
    }
    self.bgScrollView.contentSize = CGSizeMake(data.count * _blockWidth, 0);
    
     //获取当前scrollView的屏幕显示视图
   self.captureImage = [self updateCaptureImage];
    
}

- (void)updateCellTitleColorImage:(UIImage *)image
{
    for (CALayer *sub in self.loadTitleColorView.layer.sublayers) {
        [sub removeFromSuperlayer];
    }
    
    CALayer *tempLayer;
    if (tempLayer) {
        tempLayer = nil;
    }
    tempLayer = [CALayer layer];
    
    tempLayer.opacity = 1.0f;
    CGFloat width = self.loadTitleColorView.frame.size.width;
    CGFloat x = 0;
    CGFloat height = self.loadTitleColorView.frame.size.height;
    CGFloat y = 0;
    tempLayer.frame = CGRectMake(x,y,width,height);
    
    CALayer *maskLayer;
    if (maskLayer) {
        maskLayer = nil;
    }
    maskLayer = [CALayer layer];
    maskLayer.frame = CGRectMake(0, 0, width, height);
    maskLayer.contents = (__bridge id)(image.CGImage);
    maskLayer.contentsGravity = kCAGravityResizeAspect;
    tempLayer.mask = maskLayer;
    tempLayer.backgroundColor = [UIColor blueColor].CGColor;
    
    //maskLayer遮盖层控制的是形状
    //tempLayer控制的是颜色
    [self.loadTitleColorView.layer addSublayer:tempLayer];
}

- (UIImage *)updateCaptureImage
{
    //获取当前scrollView的屏幕显示视图 使用的屏幕缩放因子是当前分辨率 尺寸为当前collectionView的大小
    UIImage *image = nil;
    CGRect frame = self.frame;
    CGRect tempF = self.bgScrollView.frame;
    tempF.size = CGSizeMake(self.bgScrollView.contentSize.width, 50);
    self.bgScrollView.frame = tempF;
    self.frame = tempF;
    image = [self captureScrollView:self.bgScrollView];
    //这里将会影响重新布局
    self.frame = frame;
    return image;
}

- (void)setUp
{
    self.bgScrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
    self.bgScrollView.delegate = self;
    self.bgScrollView.bounces = NO;
    [self addSubview:self.bgScrollView];
    
    self.bottomLine = [[UIImageView alloc] init];
    self.bottomLine.backgroundColor = [UIColor greenColor];
    [self.bottomLine setContentMode:UIViewContentModeScaleToFill];
    [self.bgScrollView addSubview:self.bottomLine];
    
    self.loadTitleColorView = [[UIView alloc] init];
    [self addSubview:self.loadTitleColorView];
    
    self.isClickCelllTriggerAction = NO;
    
}


- (UIImage *)captureScrollView:(UIScrollView *)scrollView{
    UIImage* image = nil;
    
    //这边设置的size 是截取当前layer的大小
    UIGraphicsBeginImageContextWithOptions(scrollView.frame.size,NO,0);
    {
        [scrollView.layer renderInContext: UIGraphicsGetCurrentContext()];
        image = UIGraphicsGetImageFromCurrentImageContext();
    }
    UIGraphicsEndImageContext();
    
    if (image != nil) {
        return image;
    }
    return nil;
}


- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"contentOffset"]) {
        
        //外界的偏移量
        CGPoint waijieContentOffset = [change[NSKeyValueChangeNewKey] CGPointValue];
        
        //当外界移动的偏移量为外界的cell宽度的整数倍时   自己也要移动自己的cell整数倍
        
        //外界的移动偏移量与外界cell宽度比 == 里面移动量与自己cell宽度比
        
        //外界cell宽度 = xxx    自己的cell宽度 = yyy
        /*
         
         外界的偏移量 = aaa   
                           aaa * yyy
          里面的偏移量为 =   ----------
                             xxx
         
         */
        
        //自己cell的宽度为定值
        CGFloat smallCellW = _blockWidth;
        
        //外界cell的宽度
//        self.dependOnViewCellWidth;
        
        //外界偏移量
//        waijieContentOffset;
        
//        自己的偏移量
        CGFloat smallContentOffset = waijieContentOffset.x * smallCellW / self.dependOnViewCellWidth;
        
        //自己的宽度
//        self.frame.size.width;
        
//        最多显示几个cell
        int cellRow = (NSInteger)self.frame.size.width/smallCellW;
        
        int afterRow = (int)cellRow - 2;//要从第几个开始产生滑动
        
        
        if (smallContentOffset <= (self.dataArray.count - 2) * smallCellW && smallContentOffset >= smallCellW * (afterRow)) {
            
            self.bgScrollView.contentOffset = CGPointMake(smallContentOffset -  smallCellW * afterRow, 0);
            
        }else{
            
            //获取当前的移动距离
            CGFloat currentOffset = self.bgScrollView.contentOffset.x;
            
            if (currentOffset + self.frame.size.width >= smallCellW * (self.dataArray.count - 1)) {//当前屏幕显示最后一个是倒数第二个
                //当前是第几个
                NSInteger index = self.bottomLine.frame.origin.x/smallCellW;
                
                if (index == self.dataArray.count - 2) {//当前选中的是倒数第二个
                    
                    self.bgScrollView.contentOffset = CGPointMake((self.dataArray.count - cellRow) * smallCellW, 0);
                }
                
            }else if(fabs(currentOffset - smallCellW) < smallCellW){//当偏移量小于等于2个宽度的时候
            
                NSInteger index = self.bottomLine.frame.origin.x/smallCellW;
                
                if (index == 1) {//当前选中的是倒数第二个
                    
                    self.bgScrollView.contentOffset = CGPointMake(0, 0);
                    
                }
                
            }
            
            
        }
        NSLog(@"%f",smallContentOffset);
        
        if (smallContentOffset > 0 && smallContentOffset < (self.dataArray.count - 1) * smallCellW) {
            
            CGRect bottomF = self.bottomLine.frame;
            bottomF.origin.x = smallContentOffset;
            self.bottomLine.frame = bottomF;
            
            CGRect loadO = [self.bottomLine convertRect:self.bottomLine.bounds toView:self.bottomLine.window];
            CGRect loadF = self.loadTitleColorView.frame;
            loadF.origin.x = loadO.origin.x;
            self.loadTitleColorView.frame = loadF;
        }
        
        //截图当前滑动块占据的位置的image
        UIImage *titleImage;
        titleImage = [self getImageFromImage:self.captureImage myImageRect:CGRectMake(self.bottomLine.frame.origin.x, 0, self.bottomLine.frame.size.width, self.frame.size.height - bottomLineHeight)];
//
        [self updateCellTitleColorImage:titleImage];
        
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGRect loadO = [self.bottomLine convertRect:self.bottomLine.bounds toView:self.bottomLine.window];
    CGRect loadF = self.loadTitleColorView.frame;
    loadF.origin.x = loadO.origin.x;
    self.loadTitleColorView.frame = loadF;
}



//根据给定得图片，从其指定区域截取一张新得图片
-(UIImage *)getImageFromImage:(UIImage *)bigImage myImageRect:(CGRect)myImageRect {
    
    CGImageRef imageRef = bigImage.CGImage;
    
    myImageRect.origin.x *= [UIScreen mainScreen].scale;
    
    CGSize size = {myImageRect.size.width * [UIScreen mainScreen].scale,myImageRect.size.height* [UIScreen mainScreen].scale};
    
    //因为截图使用的是当前分辨率因子来放大到正确位置
    myImageRect.size = size;
    
    CGImageRef subImageRef =CGImageCreateWithImageInRect(imageRef, myImageRect);
    
    UIGraphicsBeginImageContext(size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextDrawImage(context, myImageRect, subImageRef);
    
    UIImage* smallImage = [UIImage imageWithCGImage:subImageRef];

    CGImageRelease(subImageRef);
    UIGraphicsEndImageContext();
    
    return smallImage;
    
}

- (void)handleCategoryClickAction:(UIButton *)sender
{
    //将bottomLine 移动到这
    //将loadceng移动到这
    // 滑动条
    CGRect bottomF = self.bottomLine.frame;
    bottomF.origin.x = _blockWidth * (sender.tag - buttonTagGap);
    self.bottomLine.frame = bottomF;
    
    // 遮盖层
    CGRect loadO = [self.bottomLine convertRect:self.bottomLine.bounds toView:self.bottomLine.window];
    CGRect loadF = self.loadTitleColorView.frame;
    loadF.origin.x = loadO.origin.x;
    self.loadTitleColorView.frame = loadF;
    
    self.isClickCelllTriggerAction = YES;
    
    if (self.touchIndex) {
        self.touchIndex(sender.tag - buttonTagGap);
    }
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    NSLog(@"layoutSubviews======");
    self.bgScrollView.frame = self.bounds;
    self.bottomLine.frame = CGRectMake(0, self.frame.size.height - bottomLineHeight, _blockWidth, bottomLineHeight);
    
    self.loadTitleColorView.frame = CGRectMake(0, 0, _blockWidth, self.frame.size.height - bottomLineHeight);
    
    UIImage *titleImage;
    titleImage = [self getImageFromImage:self.captureImage myImageRect:CGRectMake(self.bottomLine.frame.origin.x, 0, self.bottomLine.frame.size.width, self.frame.size.height - bottomLineHeight)];
    
    [self updateCellTitleColorImage:titleImage];
    
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end
