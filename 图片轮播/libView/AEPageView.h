//
//  AEPageView.h
//  textforAEPlayer
//
//  Created by carshoel on 16/4/26.
//  Copyright © 2016年 carshoel. All rights reserved.
//

#import <UIKit/UIKit.h>


@class AEPageModel;

@interface AEPageView : UIView

@property (nonatomic, assign)long long  numberOfPages;

@property (nonatomic, assign)long long  currentPage;

@property (nonatomic, assign)CGFloat gapSize;

@property (nonatomic, strong)UIImage *currentImage;//当前显示页码图片

@property (nonatomic, strong)UIImage *pageImage;//页码图片

@property (nonatomic, assign)CGSize imageSize;

@property (nonatomic, assign)CGFloat yScle;//竖直方向的位置比例距离顶部

@property (nonatomic, assign,readonly)CGFloat pageWidth;

+ (instancetype)pageViewWithModel:(AEPageModel *)model;

@end
