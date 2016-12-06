//
//  AEImagePlayerView.m
//  AETravel
//
//  Created by carshoel on 16/4/22.
//  Copyright © 2016年 carshoel. All rights reserved.
//

#import "AEImagePlayerView.h"
#import "UIImageView+WebCache.h"
#import "AEPageModel.h"
#import "AEPageView.h"
#import "AEElement.h"

typedef enum {
    AEImagePlayerViewMoveDirectionWait,//等待状态
    AEImagePlayerViewMoveDirectionRight,//向右滑动
    AEImagePlayerViewMoveDirectionLeft,//向左滑动
} AEImagePlayerViewMoveDirection;


@interface AEImagePlayerView ()<UIScrollViewDelegate>

/**
 *  本地图片
 */
@property (nonatomic, strong)NSArray *downloadImages;

/**
 *  当前显示的imageView
 */
@property (nonatomic, weak)UIImageView *currentImageView;

/**
 *  等待显示的imageView
 */
@property (nonatomic, weak)UIImageView *willAppearImageView;



/**
 *  解决同一个uiview 的画面掉用两次
 */
@property (nonatomic, assign,getter=isOnesAnimate)BOOL onesAnimate;//解决同一个uiview动画掉用两次

/**
 *  显示的数据的角标
 */
@property (nonatomic, assign)long long index;


/**
 *  用户手指滑动的方向
 */
@property (nonatomic, assign)AEImagePlayerViewMoveDirection  moveDirection;//用户移动方向


/**
 *  scrollView
 */
@property (nonatomic, weak)UIScrollView *scrollView;




@end


@implementation AEImagePlayerView


#pragma mark - 初始化方法

/**
 *  初始化滚动视图控件
 */
- (void)setupScrollview{
    //1,初始化scrollView
    //1,1创建scrollView
    UIScrollView *sv = [[UIScrollView alloc] init];
    [self addSubview:sv];
    sv.delegate = self;
    self.scrollView = sv;
    //1,2隐藏滚动条
    self.scrollView.showsHorizontalScrollIndicator = NO;
    //1,3设置自动分页
    self.scrollView.pagingEnabled = YES;
    
    //2,初始化两个图片视图
    //2.1 当前视图
    UIImageView *currentView = [[UIImageView alloc] init];
    currentView.backgroundColor = [UIColor blackColor];
    currentView.contentMode = UIViewContentModeScaleAspectFit;
    [self.scrollView addSubview:currentView];
    self.currentImageView = currentView;
    //2.2 移动视图
    UIImageView *willAppearView = [[UIImageView alloc] init];
    willAppearView.backgroundColor = [UIColor blackColor];
    willAppearView.contentMode = UIViewContentModeScaleAspectFit;
    [self.scrollView addSubview:willAppearView];
    self.willAppearImageView = willAppearView;
    
    //2.4 添加手势识别
    self.currentImageView.userInteractionEnabled = YES;
    UITapGestureRecognizer *curtap = [[UITapGestureRecognizer alloc] init];
    [curtap addTarget:self action:@selector(iconClick:)];
    [self.currentImageView addGestureRecognizer:curtap];
    
    self.willAppearImageView.userInteractionEnabled = YES;
    UITapGestureRecognizer *willtap = [[UITapGestureRecognizer alloc] init];
    [willtap addTarget:self action:@selector(iconClick:)];
    [self.willAppearImageView addGestureRecognizer:willtap];
    
}

/**
 *  初始化页码控制器
 */
- (void)setupPageView{
    

    //3,初始化页码显示器
    //3.1设置页码显示器参数
    AEPageModel *model = [AEPageModel pageModelWithPageImage:[self pageImage] currentImage:[self currentImage] pages:self.downloadImages.count gapsize:6 imageSize:CGSizeMake(10, 10)];
    
    //3.2创建显示器
    AEPageView *pv = [AEPageView pageViewWithModel:model];
    [self addSubview:pv];
    self.pageView = pv;
//    pv.backgroundColor = [UIColor redColor];//调试-------------------
    
}

//画页码图片
- (UIImage *)pageImage{
    //开启图形上下午
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(30, 30), NO, 0.0);
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    //画图
    CGContextSetLineWidth(ctx, 5);
    [[UIColor  whiteColor] set];
    CGContextAddArc(ctx, 15, 15, 12, 0, M_PI * 2, 0);
    CGContextStrokePath(ctx);
    
    //取图
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}


//画当前页码图片
- (UIImage *)currentImage{
    //开启上下文
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(30, 30), NO, 0.0);
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    //画图
    [[UIColor whiteColor] set];
    CGContextFillEllipseInRect(ctx, CGRectMake(0, 0, 30, 30));
    //取图
    UIImage *currentImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return currentImage;
}

/**
 *  初始化
 */
- (void)setup{
    //1,初始化滚动视图
    [self setupScrollview];
    
    //2,初始化页码显示器
    [self setupPageView];
    
    //3,默认角标
    self.index = 0;
    
    //4,创建定时器
//    [self addAETimer];  不能释放
    
    //5,背景
    self.backgroundColor = [UIColor grayColor];
}

/**
 *  初始化设置
 */
- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        _aotuNext = YES;
        [self setup];
    }
    return self;
}


/**
 *  通过xib掉用
 */
-(void)awakeFromNib{
    [self setup];
}


/**
 *  通过类方 创建一个图片播放器
 */
+ (instancetype)playerViewWithImages:(NSArray *)images{
    AEImagePlayerView *ipv = [[self alloc] init];
    ipv.images = images;
    
    return ipv;
}

- (void)layoutSubviews{
    
    if (self.downloadImages.count) {
        self.currentImageView.image = self.downloadImages[self.index];
    }
    
    //1,scrollView 的 frame
    self.scrollView.frame = self.bounds;
    
    //2,设置内部子控件的frame值
    CGFloat w = self.frame.size.width;
    CGFloat h = self.frame.size.height;
    self.currentImageView.frame = CGRectMake(w, 0, w, h);//默认在scrollView的中间
    self.currentImageView.contentMode = self.contentMode;
    self.willAppearImageView.frame = CGRectMake(2 * w, 0, w, h);//默认在右边
    self.willAppearImageView.contentMode = self.contentMode;
    
    //4,默认滚动到中间
    self.scrollView.contentOffset = CGPointMake(w, 0);
    
    //5,设置最大滚动尺寸
    self.scrollView.contentSize= CGSizeMake(w * 3, h);
    
    //6,调整页码显示器的位置
    if(self.pageLocation == AEPageViewLocationCenter){
        self.pageView.center = CGPointMake(self.frame.size.width * 0.5, self.frame.size.height * 0.8);
    }else if (self.pageLocation == AEPageViewLocationRight){
        //显示右边
        self.pageView.center = CGPointMake(self.frame.size.width - self.pageView.pageWidth - 10, self.frame.size.height * 0.8);//这个10 是右边的边距 0.8是控制y值的 到时候这两个参数可以提到外面去
    }else{
        //显示左边
        self.pageView.center = CGPointMake(self.pageView.pageWidth + 10, self.frame.size.height * 0.8);
    }
    self.pageView.frame = CGRectZero;
}

-(void)setPageLocation:(AEPageViewLocation)pageLocation{
    _pageLocation = pageLocation;
    //6,调整页码显示器的位置
    if(self.pageLocation == AEPageViewLocationCenter){
        self.pageView.center = CGPointMake(self.frame.size.width * 0.5, self.frame.size.height * 0.8);
    }else if (self.pageLocation == AEPageViewLocationRight){
        //显示右边
        self.pageView.center = CGPointMake(self.frame.size.width - self.pageView.pageWidth - 10, self.frame.size.height * 0.8);//这个10 是右边的边距 0.8是控制y值的 到时候这两个参数可以提到外面去
    }else{
        //显示左边
        self.pageView.center = CGPointMake(self.pageView.pageWidth + 10, self.frame.size.height * 0.8);
    }
    self.pageView.frame = CGRectZero;
}

#pragma mark - 重写属性方法


/**
 *  设置角标,同时自动设置相应要显示的图片
 */
- (void)setIndex:(long long)index{
    
    //如本地图片数组里没有图片 或者 要赋值的角标和当前的角标一样 直接返回
    if (!self.downloadImages.count)return;

    //设置角标越界问题
    if (index < 0) index = self.downloadImages.count - 1;
    if (index > self.downloadImages.count - 1) index = 0;
    //设置角标
    _index = index;
    _showIndext = (int)_index;
    
    //设置显示的图片
    self.currentImageView.image = self.downloadImages[_index];
    self.currentImageView.tag = _index;
    self.pageView.currentPage = _index;
    //设置willshow的图片 自动播放时调用
    if (self.timer) {
        long long next = index + 1;
        if (next < 0) next = self.downloadImages.count - 1;
        if (next > self.downloadImages.count - 1) next = 0;
        self.willAppearImageView.image = self.downloadImages[next];;
    }
}
//结束外面传入的参数
-(void)setCurrentIndext:(int)currentIndext{
    self.index = currentIndext;
}


/**
 *  拦截本地图片数据
 */
@synthesize downloadImages = _downloadImages;

- (void)setDownloadImages:(NSArray *)downloadImages{
    _downloadImages = downloadImages;
    if (downloadImages.count == 0 || downloadImages == nil) return;
    if([downloadImages.firstObject isKindOfClass:[UIImage class]])self.currentImageView.image = downloadImages.firstObject;
     self.pageView.numberOfPages = self.downloadImages.count;
    [self addAETimer];
}
-(NSArray *)downloadImages{
    if (!_downloadImages) {
        _downloadImages = [NSArray array];
    }
    return _downloadImages;
}



/**
 *  设置图片url数组
 */
- (void)setImageUrls:(NSArray *)imageUrls{
    _imageUrls = imageUrls;
    
    //通过sdimage 加载对应地址的图片
    SDWebImageManager *webImageMgr = [SDWebImageManager sharedManager];
    self.downloadImages = nil;

    //定义一个临时可变数组
    NSMutableArray *temp = [NSMutableArray array];
    
    for (int i = 0; i < self.imageUrls.count;i++) {
        
        NSString *url  = _imageUrls[i];
        if (!url) break;
        url = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        
        
        NSURL *imgUrl = [NSURL URLWithString:url];
        
        [webImageMgr downloadImageWithURL:imgUrl options:SDWebImageCacheMemoryOnly progress:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
            
            //把加载到的图片存进本地图片数组
            if (image)[temp addObject:image];
            
            if (temp.count == self.imageUrls.count) {//遍历到最后一个时 赋值给控件
                self.currentImageView.image = temp.firstObject;
                self.downloadImages = temp;
                 
                //添加定时器
                [self addAETimer];
            }
        }];
    }

}

/**
 *  直接传递图片数组
 */
-(void)setImages:(NSArray *)images{
    _images = images;
    self.downloadImages = images;
}


/**
 *  设置滑动方向
 */
- (void)setMoveDirection:(AEImagePlayerViewMoveDirection)moveDirection{
    
    if (_moveDirection == moveDirection)return;//同一次滑动中方向相同,直接返回
    _moveDirection = moveDirection;
    if (self.moveDirection == AEImagePlayerViewMoveDirectionWait)return;// 滑动结束,赋值等待状态,直接返回.
    
    CGFloat x ;
    long long index = 0;
    if (self.moveDirection == AEImagePlayerViewMoveDirectionRight) {// 向右滑动
        x = 0;
        index = (self.index == 0) ? (self.downloadImages.count - 1) : (self.index - 1);
       
    }else if(self.moveDirection == AEImagePlayerViewMoveDirectionLeft){//向左滑动
        x = self.frame.size.width * 2;
        index = (self.index == self.downloadImages.count - 1) ? 0 : (self.index + 1);
        
    }
    
    //设置将要显示的视图的位置 (根据滑动的方向)
    self.willAppearImageView.frame = CGRectMake(x, 0, self.frame.size.width, self.frame.size.height);
    if (self.downloadImages.count) {
        self.willAppearImageView.image = self.downloadImages[index];
    }
    self.willAppearImageView.tag = index;
}


#pragma mark - 自动播放下一张方法


/**
 *  创建定时器
 */
- (void)addAETimer{
    
    if (self.isAotuNext == NO)return;
    
    if (self.downloadImages.count < 2 || self.timer) {
        [self removeAETimer];
    }
    self.timer = nil;
    //这里的掉用时间要和动画时间吻合
    self.timer = [NSTimer timerWithTimeInterval:4.0 target:self selector:@selector(nextImageByScroll) userInfo:nil repeats:YES];
    //添加到主运行循环
    [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
}

/**
 *  移除定时器
 */
- (void)removeAETimer
{
    [self.timer invalidate];
    self.timer = nil;
    
}

/**
 *  自动播放方法1: 滚动的方式掉用掉用下一张(正在使用)
 */
- (void)nextImageByScroll{
    [self.scrollView scrollRectToVisible:CGRectMake(self.frame.size.width * 2, 0, self.frame.size.width, self.frame.size.height) animated:YES];
}

/**
 *  自动播放方法2: 动画改变内部控件的frame (不耗性能,待完善)
 */
- (void)nextImage{

    
//    self.onesAnimate = YES;//防止同一个动画连续掉用两次 yes 表示正在动画
//    
//    CGFloat w = self.currentImageView.frame.size.width;
//    CGFloat h = self.currentImageView.frame.size.height;
//
//    
//    //通过动画改变current 和 willAppear 的frame
//    //注意 duration 和 delay 的时间和 一定要 和定时器的时间吻合(至少不能大于定时器的掉用时间)
//    [UIView animateWithDuration:1.0 delay:1.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
//        
//        //动画代码
//        self.currentImageView.frame = CGRectMake(0, 0, w, h);
//        self.willAppearImageView.frame = CGRectMake(w, 0, w, h);
//        
//    } completion:^(BOOL finished) {
//        
//        //恢复frame
//        if (finished && self.isOnesAnimate) {//同一个动画 这里回来两次，故让第二次进不来
//            self.onesAnimate = NO;//动画结束 设置动画状态为no
//            
//            //掉换指针
//            UIImageView *temp = self.currentImageView;//临时保存指针用
//            
//            self.currentImageView = self.willAppearImageView;
//            self.willAppearImageView = temp;
//            
//            //把将要显示的视图的位置移动到当前视图的右边
//            self.willAppearImageView.frame = CGRectMake(2 * w, 0, w, h);
//            
//            //索引加加
//            self.index++;
//
//        }
//    }];
//    
}


#pragma mark - 滑动掉用
//开始拖拽,移除定时器
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    
    //开始拖拽,移除定时器
    [self removeAETimer];
    
}


//正在拖拽,判断方向
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    //判断拖拽左右方向
    if (scrollView.contentOffset.x < self.frame.size.width) {
  
        self.moveDirection = AEImagePlayerViewMoveDirectionRight;
        
        //滚动超长
        if (scrollView.contentOffset.x <= 0) {
           
            self.moveDirection = AEImagePlayerViewMoveDirectionWait;
            self.index--;
            //置中scrollView
            scrollView.contentOffset = CGPointMake(self.frame.size.width, 0);
        }
        
    }else if(scrollView.contentOffset.x > self.frame.size.width){
        
        self.moveDirection = AEImagePlayerViewMoveDirectionLeft;
        //滚动超长
        if (scrollView.contentOffset.x >= 2 * self.frame.size.width) {
            self.moveDirection = AEImagePlayerViewMoveDirectionWait;
            
            self.index++;
            
            //置中scrollView
            scrollView.contentOffset = CGPointMake(self.frame.size.width, 0);
        }
    }
}


/**
 *  滑动结束,添加定时器,改变索引
 */
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
 
    //添加定时器
    [self addAETimer];
}

#pragma mark - 手势识别

- (void)iconClick:(UIImageView *)view{
    //通知代理
    if ([self.delegate respondsToSelector:@selector(imagePlayerView:didClickIndex:)]) {
        //取出点击的图片等tag
        long long index = self.currentImageView.tag;//(1) ? self.currentImageView.tag : self.willAppearImageView.tag;
        [self.delegate imagePlayerView:self didClickIndex:index];
    }
}

-(void)setFrame:(CGRect)frame{
    [super setFrame:frame];
    
    self.scrollView.contentSize = CGSizeMake(0, 0);
}

-(void)dealloc{
    [self removeAETimer];
    NSLog(@"++++++++dalloc-------%s---",__func__);
}



@end








