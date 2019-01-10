//
//  MTXNeophyteGuideView.h
//  新手引导视图
//
//  Created by MountainX on 2019/1/9.
//  Copyright © 2019年 MTX Software Technology Co.,Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MTXNeophyteGuideView : UIView

/**
 非透明图片数组
 */
@property (nonatomic, copy) NSArray <UIImage *> *opaqueImages;

/**
 非透明图片坐标数组
 */
@property (nonatomic, copy) NSArray <NSValue *> *opaqueRects;

/**
 透明图片数组
 */
@property (nonatomic, copy) NSArray <UIImage *> *lucencyImages;

/**
 透明图片坐标数组
 */
@property (nonatomic, copy) NSArray <NSValue *> *lucencyRects;

/**
 引导视图的填充颜色，默认为[UIColor colorWithWhite:0 alpha:0.6]
 */
@property (nonatomic, strong) UIColor *fillColor;

/**
 所有图片圆角大小，默认为5
 */
@property (nonatomic, assign) CGFloat cornerRadius;

/**
 展示的渐变动画时长，默认为0.5
 */
@property (nonatomic, assign) NSTimeInterval showTime;

/**
 隐藏的渐变动画时长，默认为0.5
 */
@property (nonatomic, assign) NSTimeInterval hideTime;

/**
 所有的图片是否在同一时间展示，默认为NO，即单击一次显示一张直到消失
 */
@property (nonatomic, assign) BOOL showAtOnce;

/**
 每次单击回调，回调参数为单击次数
 */
@property (nonatomic, copy) void(^clickBlock)(NSInteger clickTimes);

/**
 快速创建初始化新手引导视图
 
 @warning 图片和图片坐标必须一一对应

 @param opaqueImages 非透明图片数组
 @param opaqueRects 非透明图片坐标数组
 @param lucencyImages 透明图片数组
 @param lucencyRects 透明图片坐标数组
 @return 新手引导视图
 */
- (instancetype)initWithOpaqueImages:(nullable NSArray <UIImage *>*)opaqueImages opaqueRects:(nullable NSArray <NSValue *>*)opaqueRects lucencyImages:(nullable NSArray <UIImage *>*)lucencyImages lucencyRects:(nullable NSArray <NSValue *>*)lucencyRects;

- (void)show;

- (void)hide;

@end

NS_ASSUME_NONNULL_END
