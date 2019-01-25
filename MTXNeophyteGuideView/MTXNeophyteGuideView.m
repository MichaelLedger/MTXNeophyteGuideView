//
//  MTXNeophyteGuideView.m
//  新手引导视图
//
//  Created by MountainX on 2019/1/9.
//  Copyright © 2019年 MTX Software Technology Co.,Ltd. All rights reserved.
//

#import "MTXNeophyteGuideView.h"

@interface MTXNeophyteGuideView ()

/**
  单击次数
 */
@property (nonatomic, assign) NSInteger clickTimes;

/**
 蒙版图层
 */
@property (nonatomic, strong) CAShapeLayer *shapeLayer;

@end

@implementation MTXNeophyteGuideView

#pragma mark - Public Method
#pragma mark - Convient Initialization
- (instancetype)initWithOpaqueImages:(NSArray<UIImage *> *)opaqueImages opaqueRects:(NSArray<NSValue *> *)opaqueRects lucencyImages:(NSArray<UIImage *> *)lucencyImages lucencyRects:(NSArray<NSValue *> *)lucencyRects {
    if (self = [super init]) {
        _opaqueImages = opaqueImages;
        _opaqueRects = opaqueRects;
        _lucencyImages = lucencyImages;
        _lucencyRects = lucencyRects;
        
        [self setup];
    }
    return self;
}

- (void)show {
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    [[UIApplication sharedApplication].keyWindow bringSubviewToFront:self];
    
    self.alpha = 0.f;
    [UIView animateWithDuration:self.showTime animations:^{
        self.alpha = 1.f;
    } completion:^(BOOL finished) {
    }];
}

- (void)hide {
    self.alpha = 1.f;
    [UIView animateWithDuration:self.hideTime animations:^{
        self.alpha = 0.f;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

#pragma mark - Private Method
- (void)setup {
    self.frame = [UIScreen mainScreen].bounds;
    self.backgroundColor = [UIColor clearColor];
    self.fillColor = [UIColor colorWithWhite:0 alpha:0.6];
    self.cornerRadius = 5.f;
    self.showTime = .5f;
    self.hideTime = .5f;
    [self.layer addSublayer:self.shapeLayer];
    [self refresh];
}

- (void)refresh {
    NSAssert(self.opaqueImages.count == self.opaqueRects.count, @"opaqueImages.count must equal opaqueRects.count!");
    NSAssert(self.lucencyImages.count == self.lucencyRects.count, @"lucencyImages.count must equal lucencyRects.count!");
    
    [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    UIBezierPath *overlayPath = [UIBezierPath bezierPathWithRect:self.bounds];
    [overlayPath setUsesEvenOddFillRule:YES];
    
    if (!_showAtOnce) {
        if (_clickTimes < self.lucencyImages.count) {
            CGRect lucencyRect = [[self.lucencyRects objectAtIndex:_clickTimes] CGRectValue];
            if (!_disableAutoFitSize) {
                CGSize lucencyImgSize = [self.lucencyImages objectAtIndex:_clickTimes].size;
                lucencyRect = CGRectMake(lucencyRect.origin.x, lucencyRect.origin.y, lucencyImgSize.width, lucencyImgSize.height);
            }
            //缩小空白区域
            lucencyRect = CGRectMake(lucencyRect.origin.x + 1, lucencyRect.origin.y + 1, lucencyRect.size.width - 2, lucencyRect.size.height - 2);
            UIBezierPath *lucencyPath = [UIBezierPath bezierPathWithRoundedRect:lucencyRect cornerRadius:self.cornerRadius];
            [overlayPath appendPath:lucencyPath];
        }
        
        self.shapeLayer.path = overlayPath.CGPath;
        
        if (_clickTimes < self.opaqueImages.count) {
            [self addImageViewWithImage:[self.opaqueImages objectAtIndex:_clickTimes] Rect:[self.opaqueRects objectAtIndex:_clickTimes]];
        }
        if (_clickTimes < self.lucencyImages.count) {
            [self addImageViewWithImage:[self.lucencyImages objectAtIndex:_clickTimes] Rect:[self.lucencyRects objectAtIndex:_clickTimes]];
        }
    } else {
        [self.lucencyRects enumerateObjectsUsingBlock:^(NSValue * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            CGRect lucencyRect = [obj CGRectValue];
            if (!self->_disableAutoFitSize) {
                CGSize lucencyImgSize = [self.lucencyImages objectAtIndex:idx].size;
                lucencyRect = CGRectMake(lucencyRect.origin.x, lucencyRect.origin.y, lucencyImgSize.width, lucencyImgSize.height);
            }
            //缩小空白区域
            lucencyRect = CGRectMake(lucencyRect.origin.x + 1, lucencyRect.origin.y + 1, lucencyRect.size.width - 2, lucencyRect.size.height - 2);
            UIBezierPath *lucencyPath = [UIBezierPath bezierPathWithRoundedRect:lucencyRect cornerRadius:self.cornerRadius];
            [overlayPath appendPath:lucencyPath];
        }];
        
        self.shapeLayer.path = overlayPath.CGPath;
        
        [self.opaqueImages enumerateObjectsUsingBlock:^(UIImage * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [self addImageViewWithImage:obj Rect:[self.opaqueRects objectAtIndex:idx]];
        }];
        [self.lucencyImages enumerateObjectsUsingBlock:^(UIImage * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [self addImageViewWithImage:obj Rect:[self.lucencyRects objectAtIndex:idx]];
        }];
    }
}

- (void)addImageViewWithImage:(UIImage *)image Rect:(NSValue *)rect {
    CGRect imageFrame = [rect CGRectValue];
    if (!_disableAutoFitSize) imageFrame = CGRectMake(imageFrame.origin.x, imageFrame.origin.y, image.size.width, image.size.height);
    UIImageView *iv = [[UIImageView alloc] initWithFrame:imageFrame];
    iv.image = image;
    [self addSubview:iv];
}

#pragma mark - Lazy Loader
- (CAShapeLayer *)shapeLayer {
    if (!_shapeLayer) {
        _shapeLayer = [CAShapeLayer layer];
        _shapeLayer.frame = self.bounds;
        _shapeLayer.fillRule = kCAFillRuleEvenOdd;//Odd-even Rule
    }
    return _shapeLayer;
}

#pragma mark - Setter
- (void)setFillColor:(UIColor *)fillColor {
    _fillColor = fillColor;
    self.shapeLayer.fillColor = _fillColor.CGColor;
    [self refresh];
}

- (void)setShowAtOnce:(BOOL)showAtOnce {
    _showAtOnce = showAtOnce;
    [self refresh];
}

- (void)setCornerRadius:(CGFloat)cornerRadius {
    _cornerRadius = cornerRadius;
    [self refresh];
}

- (void)setDisableAutoFitSize:(BOOL)disableAutoFitSize {
    _disableAutoFitSize = disableAutoFitSize;
    [self refresh];
}

#pragma mark - Override
- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    _clickTimes ++;

    if (self.clickBlock) {
        self.clickBlock(_clickTimes);
    }
    
    if (_showAtOnce) {
        [self hide];
        return;
    }
    
    if (_clickTimes >= self.opaqueImages.count && _clickTimes >= self.lucencyImages.count) {
        [self hide];
    } else {
        [self refresh];
    }
}

#pragma mark - Dealloc
- (void)dealloc {
    // NSLog(@"====Dealloc====");
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
