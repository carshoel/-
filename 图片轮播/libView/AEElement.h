//
//  AEAEElement.h
//  AETravel
//
//  Created by carshoel on 16/4/24.
//  Copyright © 2016年 carshoel. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AEElement : NSObject

@property (nonatomic, strong)NSString *name;//图片的名称

@property (nonatomic, strong)NSString *imageUrl;//图片的网络地址

@property (nonatomic, strong)NSString *title;//图片的标题

@property (nonatomic, strong)NSData *imageData;//图片的二进制数据

@property (nonatomic, strong)UIImage *image;//图片

@property (nonatomic, strong)NSString *hostUrl;//点击图片要跳转的地址

+ (instancetype)elementWithImageName:(NSString *)name title:(NSString *)title;

+ (instancetype)elementWithImageUrl:(NSString *)url title:(NSString *)title host:(NSString *)host;

+ (instancetype)elementWithImageName:(NSString *)name title:(NSString *)title host:(NSString *)host;

+ (instancetype)elementWithImageUrl:(NSString *)url name:(NSString *)name title:(NSString *)title host:(NSString *)host;
+ (instancetype)elementWithImage:(UIImage *)image;
+ (instancetype)elementWithImageData:(NSData *)data;

@end
