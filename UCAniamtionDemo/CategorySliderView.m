//
//  CategorySliderView.m
//  UCAniamtionDemo
//
//  Created by 索晓晓 on 16/11/21.
//  Copyright © 2016年 SXiao.RR. All rights reserved.
//



#import "CategorySliderView.h"
#import "CategoryCollectionViewCell.h"
#import <Foundation/NSUnit.h>

NSInteger const bottomLineHeight = 10;

NSString *const CategoryCollectionViewCellID = @"CategoryCollectionViewCellID";

@interface CategorySliderView ()
<UICollectionViewDelegate,UICollectionViewDataSource>


@property (nonatomic ,strong)UICollectionViewFlowLayout *layout;
@property (nonatomic ,strong)UICollectionView *collectionView;
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
        
        [self setUp];
    }
    return self;
}

- (void)updateData:(NSMutableArray *)data
{
    self.dataArray = data;
    
    [self setNeedsLayout];
    [self layoutIfNeeded];
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


- (void)setUp
{
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.itemSize = CGSizeMake(0,0);
    layout.minimumLineSpacing = 0;
    layout.minimumInteritemSpacing = 0;
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    self.layout = layout;
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0,0,0,0) collectionViewLayout:layout];
    _collectionView.dataSource = self;
    _collectionView.delegate = self;
    [self addSubview:_collectionView];
    _collectionView.showsHorizontalScrollIndicator = NO;
    _collectionView.backgroundColor = [UIColor clearColor];
    [_collectionView registerClass:[CategoryCollectionViewCell class] forCellWithReuseIdentifier:CategoryCollectionViewCellID];
    [_collectionView setBounces:NO];
    
    
    self.bottomLine = [[UIImageView alloc] init];
    self.bottomLine.backgroundColor = [UIColor greenColor];
    [self.bottomLine setContentMode:UIViewContentModeScaleAspectFit];
    [_collectionView addSubview:self.bottomLine];
    
    self.loadTitleColorView = [[UIView alloc] init];
    [self addSubview:self.loadTitleColorView];
    
    self.isClickCelllTriggerAction = NO;
    
}

- (UIImage *)captureScrollView:(UIScrollView *)scrollView{
    UIImage* image = nil;
    UIGraphicsBeginImageContextWithOptions(scrollView.contentSize, NO, 0);
//    UIGraphicsBeginImageContext(scrollView.contentSize);
    {
        [scrollView.layer renderInContext: UIGraphicsGetCurrentContext()];
        image = UIGraphicsGetImageFromCurrentImageContext();
    }
    UIGraphicsEndImageContext();
    
    
    if (image != nil)
    {
        return image;
    }
    
    return nil;
}


- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"contentOffset"]) {
        
        //获取当前collectionView的屏幕显示视图 使用的屏幕缩放因子是当前分辨率 尺寸为当前collectionView的大小
        self.captureImage = [self captureScrollView:self.collectionView];
        
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
        CGFloat smallCellW = self.layout.itemSize.width;
        
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
            
            self.collectionView.contentOffset = CGPointMake(smallContentOffset -  smallCellW * afterRow, 0);
            
        }else{
            
            //获取当前的移动距离
            CGFloat currentOffset = self.collectionView.contentOffset.x;
            
            if (currentOffset + self.frame.size.width >= smallCellW * (self.dataArray.count - 1)) {//当前屏幕显示最后一个是倒数第二个
                //当前是第几个
                NSInteger index = self.bottomLine.frame.origin.x/smallCellW;
                
                if (index == self.dataArray.count - 2) {//当前选中的是倒数第二个
                    
                    self.collectionView.contentOffset = CGPointMake((self.dataArray.count - cellRow) * smallCellW, 0);
                }
                
            }else if(fabs(currentOffset - smallCellW) < smallCellW){//当偏移量小于等于2个宽度的时候
            
                NSInteger index = self.bottomLine.frame.origin.x/smallCellW;
                
                if (index == 1) {//当前选中的是倒数第二个
                    
                    self.collectionView.contentOffset = CGPointMake(0, 0);
                    
                }
                
            }
            
            
        }
        NSLog(@"%f",smallContentOffset);
        
        if (smallContentOffset > 0 && smallContentOffset < (self.dataArray.count - 1) * smallCellW) {
            
            CGRect bottomF = self.bottomLine.frame;
            bottomF.origin.x = smallContentOffset;
            self.bottomLine.frame = bottomF;
            
//            CGPoint loadCenter = [self.bottomLine convertRect:self.bottomLine.bounds toView:self.window];
            CGRect loadO = [self.bottomLine convertRect:self.bottomLine.bounds toView:self.bottomLine.window];
            CGRect loadF = self.loadTitleColorView.frame;
            loadF.origin.x = loadO.origin.x;
            self.loadTitleColorView.frame = loadF;
//            return;
        }
        
        //截图当前滑动块占据的位置的image
        UIImage *titleImage;
        titleImage = [self getImageFromImage:self.captureImage myImageRect:CGRectMake(self.bottomLine.frame.origin.x, 0, self.bottomLine.frame.size.width, self.frame.size.height - bottomLineHeight)];
        
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
    
    UIGraphicsBeginImageContextWithOptions(size,NO,0);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextDrawImage(context, myImageRect, subImageRef);
    
    UIImage* smallImage = [UIImage imageWithCGImage:subImageRef];
    
    UIGraphicsEndImageContext();
    
    return smallImage;
    
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.dataArray.count;
}

- ( UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    CategoryCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CategoryCollectionViewCellID forIndexPath:indexPath];
    
    cell.title = self.dataArray[indexPath.row];
    
    
    
    return cell;
}


- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    //将bottomLine 移动到这
    //将loadceng移动到这
    // 滑动条
    CGRect bottomF = self.bottomLine.frame;
    bottomF.origin.x = self.layout.itemSize.width * indexPath.row;
    self.bottomLine.frame = bottomF;
    
    // 遮盖层
    CGRect loadO = [self.bottomLine convertRect:self.bottomLine.bounds toView:self.bottomLine.window];
    CGRect loadF = self.loadTitleColorView.frame;
    loadF.origin.x = loadO.origin.x;
    self.loadTitleColorView.frame = loadF;
    
    self.isClickCelllTriggerAction = YES;
    
    if (self.touchIndex) {
        self.touchIndex(indexPath.row);
    }
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.collectionView.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    self.layout.itemSize = CGSizeMake(self.frame.size.width/4,self.frame.size.height);
    self.bottomLine.frame = CGRectMake(0, self.frame.size.height - bottomLineHeight, self.layout.itemSize.width, bottomLineHeight);
    
    self.loadTitleColorView.frame = CGRectMake(0, 0, self.layout.itemSize.width, self.frame.size.height - bottomLineHeight);
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end
