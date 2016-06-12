//
//  AppDelegate.m
//  无限轮播器
//
//  Created by zhangmi on 16/5/16.
//  Copyright © 2016年 Paramount Pictures. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, ScrollDirection) {
    ScrollDirectionVertical,
    ScrollDirectionHorizontal,
};


@interface SNInfiniteScrollView : UIView

@property(nonatomic, strong) NSArray<UIImage *> * images;
@property(nonatomic, weak) UIPageControl * pageControl;
@property(nonatomic, assign) ScrollDirection scrollDirection;
/** imageViewcontentMode */
@property(nonatomic, assign) UIViewContentMode imageViewcontentMode;

/** 简单调用 */
+ (instancetype)scrollViewWithFrame:(CGRect)frame superView:(UIView *)superView images:(NSArray<UIImage *> *)images scrollDirection:(ScrollDirection)scrollDirection pageIndicatorTintColor:(UIColor *)pageIndicatorTintColor currentPageIndicatorTintColor:(UIColor *)currentPageIndicatorTintColor  imageViewcontentMode:(UIViewContentMode)imageViewcontentMode;
@end
