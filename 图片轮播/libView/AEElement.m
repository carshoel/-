//
//  AEElement.m
//  AETravel
//
//  Created by carshoel on 16/4/24.
//  Copyright © 2016年 carshoel. All rights reserved.
//

#import "AEElement.h"

@implementation AEElement


+ (instancetype)elementWithImageName:(NSString *)name title:(NSString *)title{
    return [self elementWithImageUrl:nil name:name title:title host:nil];
}

+ (instancetype)elementWithImageName:(NSString *)name title:(NSString *)title host:(NSString *)host{
    return [self elementWithImageUrl:nil name:name title:title host:host];
}

+ (instancetype)elementWithImageUrl:(NSString *)url title:(NSString *)title host:(NSString *)host{
    return [self elementWithImageUrl:url name:nil title:title host:host];
}

+ (instancetype)elementWithImageUrl:(NSString *)url name:(NSString *)name title:(NSString *)title host:(NSString *)host{
    AEElement *element = [[self alloc] init];
    element.imageUrl = url;
    element.name = name;
    element.title = title;
    element.hostUrl = host;
    return element;
}

+ (instancetype)elementWithImage:(UIImage *)image{
    AEElement *ele = [[self alloc] init];
    ele.image = image;
    return ele;
}

+ (instancetype)elementWithImageData:(NSData *)data{
    AEElement *ele = [[self alloc] init];
    ele.imageData = data;
    return ele;
}

@end
