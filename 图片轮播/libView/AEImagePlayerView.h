//
//  AEImagePlayerView.h
//  AETravel
//
//  Created by carshoel on 16/4/22.
//  Copyright © 2016年 carshoel. All rights reserved.
//  图片轮播器  (两个视图的切换)

#import <UIKit/UIKit.h>
@class AEImagePlayerView,AEPageView;

@protocol AEImagePlayerViewDelegate <NSObject>

@optional

- (void)imagePlayerViewDidLoadImage:(AEImagePlayerView *)playerview;
- (void)imagePlayerView:(AEImagePlayerView *)playerview didClickIndex:(long long)index;

@end

//页码显示的位置
typedef enum {
    AEPageViewLocationCenter,//显示在中间
    AEPageViewLocationLeft,//显示在左边
    AEPageViewLocationRight//显示在右边
}AEPageViewLocation;


@interface AEImagePlayerView : UIView

/**
 *  图片的url数组(NSString)
 */
@property (nonatomic, strong)NSArray <NSString *>*imageUrls;

/**
 * 要显示的图片数组(UIImage)
 */
@property (nonatomic, strong)NSArray <UIImage *>*images;

/**
 * 首次要显示的角标
 */
@property (nonatomic, assign)int currentIndext;
@property (nonatomic, assign,readonly)int showIndext;

/**
 * 是否自动轮播
 */
@property (nonatomic, assign,getter=isAotuNext)BOOL aotuNext; //默认YES

#warning 在使用这个控件的类的dealloc方法里要移除这个定时器,本控件才能被销毁
/**
 *  定时器
 */
@property (nonatomic, strong)NSTimer *timer;


/**
 *  自定义页码显示器
 */
@property (nonatomic, weak)AEPageView *pageView;

/**
 *页码显示的位置
 */
@property (nonatomic, assign)AEPageViewLocation pageLocation; //默认居中 ,其它如左边 右边

@property (nonatomic, weak)id<AEImagePlayerViewDelegate> delegate;

+ (instancetype)playerViewWithImages:(NSArray *)images;

@end
