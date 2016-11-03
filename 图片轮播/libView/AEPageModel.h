//
//  AEPageModel.h
//  textforAEPlayer
//
//  Created by carshoel on 16/4/26.
//  Copyright © 2016年 carshoel. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AEPageModel : NSObject

@property (nonatomic, assign)long long  numberOfPages;

@property (nonatomic, assign)long long  currentPage;

@property (nonatomic, assign)CGFloat gapSize;

@property (nonatomic, strong)UIImage *currentImage;

@property (nonatomic, strong)UIImage *pageImage;

@property (nonatomic, assign)CGSize imageSize;



+ (instancetype)pageModelWithPageImage:(UIImage *)pageImage currentImage:(UIImage *)curentImage pages:(long long )pages gapsize:(CGFloat)gapsize imageSize:(CGSize)imageSize;

@end
