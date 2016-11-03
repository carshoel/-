//
//  AEPageModel.m
//  textforAEPlayer
//
//  Created by carshoel on 16/4/26.
//  Copyright © 2016年 carshoel. All rights reserved.
//

#import "AEPageModel.h"

@implementation AEPageModel

+ (instancetype)pageModelWithPageImage:(UIImage *)pageImage currentImage:(UIImage *)curentImage pages:(long long )pages gapsize:(CGFloat)gapsize imageSize:(CGSize)imageSize{

    AEPageModel *model = [[self alloc] init];
    model.numberOfPages = pages;
    model.pageImage = pageImage;
    model.currentImage = curentImage;
    model.gapSize = gapsize;
    model.imageSize = imageSize;
    return model;
}
@end
