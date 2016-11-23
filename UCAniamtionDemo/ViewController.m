//
//  ViewController.m
//  UCAniamtionDemo
//
//  Created by 索晓晓 on 16/11/18.
//  Copyright © 2016年 SXiao.RR. All rights reserved.
//

#import "ViewController.h"
#import "CustomCollectionViewCell.h"
#import "CategorySliderView.h"
#define WIDTH [UIScreen mainScreen].bounds.size.width
#define HEIGHT [UIScreen mainScreen].bounds.size.height

NSString *const HomeCollectionTableViewCellID = @"HomeCollectionTableViewCellID";

@interface ViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic ,strong)UILabel *test;

@property (nonatomic ,strong)UICollectionView *collectionView;

@property (nonatomic ,strong)NSMutableArray *dataArray;

@property (nonatomic , strong)NSIndexPath *indexPath;

@property (nonatomic , assign)CGPoint startMovePoint;

@property (nonatomic ,strong)CategorySliderView *sliderView;

@property (nonatomic , assign)BOOL isCanAniamtion;


//@property (nonatomic ,strong)UIImageView *testimage;

@end

@implementation ViewController

- (NSMutableArray *)dataArray
{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor grayColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.isCanAniamtion = YES;
    
    for (int j = 0; j < 2; j++) {
        for (int i = 0; i < 7; i++) {
            [self.dataArray addObject:[NSString stringWithFormat:@"%d.jpg",i+1]];
        }
    }
    
    [self createUI];
    
    [self getCategroyData];
}

- (void)getCategroyData
{
    NSMutableArray *temp = [NSMutableArray array];
    
    for (int j = 0; j < 2; j++) {
        for (int i = 0; i < 7; i++) {
            [temp addObject:[NSString stringWithFormat:@"题%d",i+1]];
        }

    }
    
    [self.sliderView updateData:[temp mutableCopy]];
}

- (void)createUI
{
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.itemSize = CGSizeMake(self.view.frame.size.width, self.view.frame.size.height);
    layout.minimumLineSpacing = 0;
    layout.minimumInteritemSpacing = 0;
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 64 + 50, self.view.frame.size.width, self.view.frame.size.height - 64 - 50) collectionViewLayout:layout];
    _collectionView.dataSource = self;
    _collectionView.delegate = self;
    _collectionView.backgroundColor = [UIColor whiteColor];
    _collectionView.pagingEnabled = YES;
    [self.view addSubview:_collectionView];
    [_collectionView registerClass:[CustomCollectionViewCell class] forCellWithReuseIdentifier:HomeCollectionTableViewCellID];
    
    
    
    self.sliderView = [[CategorySliderView alloc] initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, 50) WithData:@[]];
    self.sliderView.dependOnViewCellWidth = layout.itemSize.width;
    [self.view addSubview:self.sliderView];
    
    
    __weak typeof(self)weakSelf = self;
    
    
    self.sliderView.touchIndex = ^(NSInteger index){
        
        weakSelf.isCanAniamtion = NO;
        
        [weakSelf.collectionView setContentOffset:CGPointMake(index * layout.itemSize.width, 0) animated:NO];
        
//        CustomCollectionViewCell *cell = (CustomCollectionViewCell *)[weakSelf.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0]];
//        
//        [cell resumeContentOffset];
//        
//
        [weakSelf.collectionView reloadData];
        
        [weakSelf performSelector:@selector(resetAnimation) withObject:nil afterDelay:0.1];
    };
    
    [self.collectionView addObserver:self.sliderView forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];
    
//    self.testimage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 180, WIDTH, 50)];
//    self.testimage.backgroundColor = [UIColor cyanColor];
//    [self.view addSubview:self.testimage];
    
    
    
}

- (void)resetAnimation
{
    self.isCanAniamtion = YES;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.dataArray.count;
}

- ( UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    CustomCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:HomeCollectionTableViewCellID forIndexPath:indexPath];
    
    cell.imageUrl = self.dataArray[indexPath.row];
    
    return cell;
}


- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (!self.isCanAniamtion) {
        return ;
    }
    
    
    self.indexPath = [NSIndexPath indexPathForRow:(NSInteger)fabs(scrollView.contentOffset.x/self.view.frame.size.width) inSection:0];
    
    if (CGPointEqualToPoint(scrollView.contentOffset, self.startMovePoint)) {
        
//        NSLog(@"未移动");
        
    }
    CustomCollectionViewCell *cell1 = (CustomCollectionViewCell *)[self.collectionView cellForItemAtIndexPath:self.indexPath];
    [cell1 updateContentOffset];
    
    NSIndexPath *next = [NSIndexPath indexPathForRow:self.indexPath.row +1 inSection:self.indexPath.section];
    
    if (next.row > self.dataArray.count) {
        return ;
    }
    
    CustomCollectionViewCell *cell = (CustomCollectionViewCell *)[self.collectionView cellForItemAtIndexPath:next];
    [cell updateContentOffset];
    
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    self.startMovePoint = scrollView.contentOffset;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
    NSLog(@"%s",__func__);
    // Dispose of any resources that can be recreated.
}

@end
