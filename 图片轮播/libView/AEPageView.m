//
//  AEPageView.m
//  textforAEPlayer
//
//  Created by carshoel on 16/4/26.
//  Copyright © 2016年 carshoel. All rights reserved.
//

#import "AEPageView.h"
#import "AEPageModel.h"

@implementation AEPageView

#pragma mark - 初始化

/**
 *  通过模型创建
 */
+(instancetype)pageViewWithModel:(AEPageModel *)model{
    AEPageView *pv = [[self alloc] init];
    pv.gapSize = model.gapSize;
    pv.pageImage = model.pageImage;
    pv.imageSize = model.imageSize;
    pv.numberOfPages = model.numberOfPages;
    pv.currentImage = model.currentImage;
    pv.frame = CGRectZero;
    return pv;
}


- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        //在这里做默认值
        self.currentImage = nil;
        self.pageImage = nil;
        self.numberOfPages = 3;
        self.currentPage = 0;
        self.gapSize = 10;
        self.imageSize = CGSizeMake(self.gapSize, self.gapSize);
        self.frame = CGRectZero;
    }
    return self;
}


//-(CGSize)imageSize{
//    return CGSizeMake(25, 9);
//}



//在view有页码数和页数后掉用有效，返回它的宽度，便于调整左右位置,
-(CGFloat)pageWidth{
    return self.numberOfPages *(self.gapSize + self.imageSize.width) - self.gapSize;
}

#pragma mark - 重写属性方法

-(void)setImageSize:(CGSize)imageSize{
    _imageSize = imageSize;
}

/**
 *  拦截过滤 修改frame
 */
-(void)setFrame:(CGRect)frame{

    CGFloat w = self.numberOfPages *(self.gapSize + self.imageSize.width) - self.gapSize;
    CGFloat h = self.imageSize.height;
    frame =  CGRectMake(self.center.x - w * 0.5, self.center.y, w, h);
    
    [super setFrame:frame];
    
}




-(void)setCurrentPage:(long long )currentPage{
    
    if (!self.subviews.count)return;
    if (currentPage < 0)currentPage = self.subviews.count - 1;
    if (currentPage > self.subviews.count - 1)currentPage = 0;
    
    UIImageView *cur = self.subviews[_currentPage];
    cur.image = self.pageImage;
    
    UIImageView *willcur = self.subviews[currentPage];
    willcur.image = self.currentImage;
    
    _currentPage = currentPage;
}

-(void)setNumberOfPages:(long long )numberOfPages{
    
    if (numberOfPages == _numberOfPages)return;//页码相同,不再创建
    if (numberOfPages == 1)return;//只有一张图片
    _numberOfPages = numberOfPages;
    
    for (UIView *v in self.subviews) {
        [v removeFromSuperview];
    }
    
    CGFloat x;
    CGFloat y = 0;
    CGFloat w = self.imageSize.width;
    CGFloat h = self.imageSize.height;
    for (int i = 0; i < numberOfPages; i++) {
        
        x = (self.gapSize + w ) * i;
        UIImageView *iv = [[UIImageView alloc] initWithImage:(i == self.currentPage) ?self.currentImage :self.pageImage];
        
        [self addSubview:iv];
        iv.frame = CGRectMake(x, y, w, h);
    }
    self.frame = CGRectZero;
}


-(void)setCurrentImage:(UIImage *)currentImage{
    _currentImage = currentImage;
    
    for (int i = 0; i < self.subviews.count; i++) {
        UIImageView *v = self.subviews[i];
        v.image = (i == self.currentPage) ?self.currentImage :self.pageImage;

    }
}

- (void)setPageImage:(UIImage *)pageImage{
    _pageImage = pageImage;
    for (int i = 0; i < self.subviews.count; i++) {
        UIImageView *v = self.subviews[i];
        v.image = (i == self.currentPage) ?self.currentImage :self.pageImage;
        
    }
}

-(void)layoutSubviews{
    CGFloat x;
    CGFloat y = 0;
    CGFloat w = self.imageSize.width;
    CGFloat h = self.imageSize.height;
    for (int i = 0; i < self.numberOfPages; i++) {
        
        x = (self.gapSize + w ) * i;
        UIImageView *iv = self.subviews[i];
        iv.image = (i == self.currentPage) ?self.currentImage :self.pageImage;
        
        iv.frame = CGRectMake(x, y, w, h);
    }
}



@end




