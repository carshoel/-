//
//  ViewController.m
//  图片轮播
//
//  Created by carshoel on 16/11/3.
//  Copyright © 2016年 carshoel. All rights reserved.
//

#import "ViewController.h"
#import "AEImagePlayerView.h"
#import "AEPageView.h"

@interface ViewController ()<AEImagePlayerViewDelegate>

@property (nonatomic, weak)AEImagePlayerView *playerView;//图片轮播器

@property (nonatomic, strong)NSArray <UIImage *>*locaImages;//本地图片

@property (nonatomic, strong)NSMutableArray<NSString *> *imageUrls;//网络获取图片

@property (nonatomic, weak)UILabel *clickResultL;//暂时点击的结果

@end

@implementation ViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    
    //1 设置控制器背景色
    self.view.backgroundColor = [UIColor whiteColor];
    
    //2 设置本地和网络图片测试数据
    [self setUpArrayForImages];
    
    //3 设置图片轮播器
    [self setUpPlayer];
    
    //4 设置展示 "点击了 第几张图"的label
    [self setUpShowImageClick];
    
    //5 设置操作按钮
    [self setUpOperationViews];
}

//设置本地和网络图片测试数据
- (void)setUpArrayForImages{
    
    //1 本地图片资源
    _locaImages = @[[UIImage imageNamed:@"01.jpg"],[UIImage imageNamed:@"02.jpg"],[UIImage imageNamed:@"03.jpg"],[UIImage imageNamed:@"04.jpg"]];
    
    //2 网络图片资源
    NSString *u = @"http://pic2.ooopic.com/12/83/15/60b1OOOPICf8.jpg";
    NSString *u1 = @"http://img01.tooopen.com/Downs/images/2011/8/5/sy_20110805142827920039.jpg";
    NSString *u2 = @"http://cdn.duitang.com/uploads/blog/201402/21/20140221165528_Q3N35.thumb.600_0.jpeg";
    _imageUrls = [NSMutableArray arrayWithObjects:u,u1,u2,nil];
}

//设置图片轮播器
- (void)setUpPlayer{
    CGFloat x = 0;
    CGFloat y = 20;
    CGFloat w = [UIScreen mainScreen].bounds.size.width;
    CGFloat h = 150;
    AEImagePlayerView *playerView = [[AEImagePlayerView alloc] initWithFrame:CGRectMake(x, y, w, h)];
    _playerView = playerView;
    playerView.images = self.locaImages;//设置默认图片
    playerView.delegate = self;
    [self.view addSubview:playerView];
}

//图片轮播器代理
- (void)imagePlayerView:(AEImagePlayerView *)playerview didClickIndex:(long long)index{
    _clickResultL.text = [NSString stringWithFormat:@"点击了 第%lld张图",index];
}

//设置展示 "点击了 第几张图"的label
- (void)setUpShowImageClick{
    CGFloat w = 220;
    CGFloat h = 30;
    CGFloat x = ([UIScreen mainScreen].bounds.size.width - w) * 0.5;
    CGFloat y = CGRectGetMaxY(self.playerView.frame) + 25;
    UILabel *clickResultL = [[UILabel alloc] initWithFrame:CGRectMake(x, y, w, h)];
    clickResultL.text = @"点击图片，这里可显示结果";
    _clickResultL = clickResultL;
    clickResultL.backgroundColor = [UIColor redColor];
    clickResultL.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:clickResultL];
}

//设置操作按钮
- (void)setUpOperationViews{
    CGFloat w = 220;
    CGFloat h = 30;
    CGFloat x = ([UIScreen mainScreen].bounds.size.width - w) * 0.5;
    CGFloat y = CGRectGetMaxY(self.playerView.frame) + 80;
    
    UIButton *custPageImageBtn = [self btnWithTitle:@"自定义页码显示器图片" frame:CGRectMake(x, y, w, h) action:@selector(useCustomPageImage)];
    [self.view addSubview:custPageImageBtn];
    
    y = CGRectGetMaxY(custPageImageBtn.frame) + 25;
    UIButton *useLocaImagesBtn = [self btnWithTitle:@"使用本地图片" frame:CGRectMake(x, y, w, h) action:@selector(useLocaImages)];
    [self.view addSubview:useLocaImagesBtn];
    
    y = CGRectGetMaxY(useLocaImagesBtn.frame) + 25;
    UIButton *useUrlImagesBtn = [self btnWithTitle:@"使用网路图片" frame:CGRectMake(x, y, w, h) action:@selector(useUrlImages)];
    [self.view addSubview:useUrlImagesBtn];
    
    y = CGRectGetMaxY(useUrlImagesBtn.frame) + 25;
    UIButton *pageRightBtn = [self btnWithTitle:@"页码显示右边" frame:CGRectMake(x, y, w, h) action:@selector(pageRight)];
    [self.view addSubview:pageRightBtn];
    
    y = CGRectGetMaxY(pageRightBtn.frame) + 25;
    UIButton *pageLeftBtn = [self btnWithTitle:@"页码显示左边" frame:CGRectMake(x, y, w, h) action:@selector(pageLeft)];
    [self.view addSubview:pageLeftBtn];
    
    y = CGRectGetMaxY(pageLeftBtn.frame) + 25;
    UIButton *pageCenterBtn = [self btnWithTitle:@"页码显示中间" frame:CGRectMake(x, y, w, h) action:@selector(pageCenter)];
    [self.view addSubview:pageCenterBtn];
    
}
//创建一个按钮
- (UIButton *)btnWithTitle:(NSString *)title frame:(CGRect)frame action:(SEL)action{
    UIButton *btn = [[UIButton alloc] initWithFrame:frame];
    btn.titleLabel.font = [UIFont boldSystemFontOfSize:15];
    [btn setTitle:title forState:UIControlStateNormal];
    [btn addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
    btn.layer.cornerRadius = 5;
    btn.backgroundColor = [UIColor orangeColor];
    btn.layer.masksToBounds = YES;

    return btn;
}


//使用本地图片
- (void)useLocaImages{
    self.playerView.images = self.locaImages;
}


//使用网路图片
- (void)useUrlImages{
    self.playerView.imageUrls = self.imageUrls;
}

//页码显示右边
- (void)pageRight{
    self.playerView.pageLocation = AEPageViewLocationRight;
}
//页码显示左边
- (void)pageLeft{
    self.playerView.pageLocation = AEPageViewLocationLeft;
}
//页码显示中间
- (void)pageCenter{
    self.playerView.pageLocation = AEPageViewLocationCenter;
}
//自定义页码显示器图片
- (void)useCustomPageImage{
    self.playerView.pageView.currentImage = [UIImage imageNamed:@"login_btn_show"];
    self.playerView.pageView.pageImage = [UIImage imageNamed:@"login_btn_hidden"];
}


-(void)dealloc{
    [_playerView.timer invalidate];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
