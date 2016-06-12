//
//  AppDelegate.m
//  无限轮播器
//
//  Created by zhangmi on 16/5/16.
//  Copyright © 2016年 Paramount Pictures. All rights reserved.
//

#import "SNInfiniteScrollView.h"

static int const ImageViewCount = 3;
#define scrollViewWidth self.scrollView.frame.size.width
#define scrollViewHeight self.scrollView.frame.size.height

@interface SNInfiniteScrollView () <UIScrollViewDelegate>

@property(weak, nonatomic) UIScrollView * scrollView;
@property(weak, nonatomic) NSTimer * timer;
/** pageIndex */
@property(nonatomic, assign) NSInteger pageIndex;

@end

@implementation SNInfiniteScrollView

- (void)setImages:(NSArray<UIImage *> *)images {
    
    _images = images;
    
    // 设置页码
    self.pageIndex = 0;
    
    //	 设置内容
    [self updateContent];
    
    //	 开始定时器
    [self startTimer];
}

/** 代码创建的时候调用. */
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        // 滚动视图
        UIScrollView * scrollView = [[UIScrollView alloc] init];
        
        self.scrollView = scrollView;
        scrollView.delegate = self;
        // scroller属性
        scrollView.showsHorizontalScrollIndicator = NO;
        scrollView.showsVerticalScrollIndicator = NO;
        scrollView.pagingEnabled = YES;
        scrollView.bounces = NO;
        // 添加scrollView
        [self addSubview:scrollView];
        
        // 图片控件
        for (int i = 0; i < ImageViewCount; i++) {
            UIImageView * imageView = [[UIImageView alloc] init];
            // 图片不变形处理.
            imageView.contentMode = self.imageViewcontentMode;
            [scrollView addSubview:imageView];
        }
    }
    return self;
}
/** 布局 子控件, 只执行一次 */
- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.scrollView.frame = self.bounds;
    if (self.scrollDirection == ScrollDirectionVertical) {
        self.scrollView.contentSize = CGSizeMake(0, ImageViewCount * self.bounds.size.height);
    } else {
        self.scrollView.contentSize = CGSizeMake(ImageViewCount * self.bounds.size.width, 0);
    }
    
    for (int i = 0; i < ImageViewCount; i++) {
        UIImageView * imageView = self.scrollView.subviews[i];
        
        if (self.scrollDirection == ScrollDirectionVertical) {
            imageView.frame = CGRectMake(0, i * self.scrollView.frame.size.height, self.scrollView.frame.size.width, self.scrollView.frame.size.height);
        } else {
            imageView.frame = CGRectMake(i * self.scrollView.frame.size.width, 0, self.scrollView.frame.size.width, self.scrollView.frame.size.height);
        }
    }
    // 设置内容
    [self updateContent];
}
#pragma mark - 内容更新
- (void)updateContent {
    // 设置图片
    for (int i = 0; i < self.scrollView.subviews.count; i++) {
        
        NSInteger pageIndex = self.pageIndex;
        // 遍历每一个imageView
        UIImageView * imageView = self.scrollView.subviews[i];
        
        if (i == 0) {
            pageIndex--;
        } else if (i == 2) {
            pageIndex++;
        }
        
        if (pageIndex < 0) {
            pageIndex = self.images.count - 1;
        } else if (pageIndex >= self.images.count) {
            pageIndex = 0;
        }
        // 图片角标 赋值给 imageView的tag
        imageView.tag = pageIndex;
        imageView.image = self.images[imageView.tag];
    }
    
    // 设置偏移量在中间 // 不能使用带动画 contentOffset
    if (self.scrollDirection == ScrollDirectionVertical) {
        self.scrollView.contentOffset = CGPointMake(0, scrollViewHeight);
    } else {
        self.scrollView.contentOffset = CGPointMake(scrollViewWidth, 0);
    }
}
#pragma mark - <UIScrollViewDelegate>
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    // 找出最中间的那个图片控件
    NSInteger page = self.pageIndex;
    CGPoint point = CGPointZero;
    for (int i = 0; i < self.scrollView.subviews.count; i++) {
        UIImageView * imageView = self.scrollView.subviews[i];
        point = [scrollView convertPoint:imageView.frame.origin toView:self.superview];
        //=****** other way ****************** stone ***
        if (self.scrollDirection == ScrollDirectionVertical) {
            if (ABS(point.y - self.frame.origin.y) < 1.0) {
                page = imageView.tag;
            }
        } else {
            if (ABS(point.x - self.frame.origin.x) < 1.0) {
                page = imageView.tag;
            }
        }
    }
    self.pageIndex = page;
    self.pageControl.currentPage = page;
    
    //拖动结束会调用 [self updateContent];
    //#warning mark - 没有动画正常 , 有动画不动, 一直是原点
    // [self updateContent]; // 没有动画正常 , 有动画不动, 一直是原点
}
/** 开始拖拽 */
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    // 停止定时器
    [self stopTimer];
}
/** 结束拖拽 */
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    // 开启定时器
    [self startTimer];
}
/** 减速完毕 */
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    // 更新内容 , 如果contentOffset 不带动画的话 不走这个方法
    [self updateContent];
}
/** 结束滚动动画 */ // 这是保险的做法吧... 如果contentOffset 不带动画的话 不走这个方法
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    // 更新内容
    [self updateContent];
}

#pragma mark - 定时器处理
- (void)startTimer {
    
    NSTimer * timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(next:) userInfo:nil repeats:YES];
    //	[[NSRunLoop mainRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
    [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
    self.timer = timer;
}

- (void)stopTimer {
    [self.timer invalidate];
    self.timer = nil;
}

- (void)next:(NSTimer *)timer {
    if (self.scrollDirection == ScrollDirectionVertical) {
        [self.scrollView setContentOffset:CGPointMake(0, 2 * self.scrollView.frame.size.height) animated:YES];
    } else {
        [self.scrollView setContentOffset:CGPointMake(2 * self.scrollView.frame.size.width, 0) animated:YES];
    }
}
//=****** 简单调用 ****************** stone ***
+ (instancetype)scrollViewWithFrame:(CGRect)frame superView:(UIView *)superView images:(NSArray<UIImage *> *)images scrollDirection:(ScrollDirection)scrollDirection pageIndicatorTintColor:(UIColor *)pageIndicatorTintColor currentPageIndicatorTintColor:(UIColor *)currentPageIndicatorTintColor imageViewcontentMode:(UIViewContentMode)imageViewcontentMode {
    
    //=****** 添加自定义scrollView ****************** stone ***
    SNInfiniteScrollView * scrollView = [[SNInfiniteScrollView alloc] init];
    scrollView.frame = frame;
    scrollView.imageViewcontentMode = imageViewcontentMode;
    scrollView.scrollDirection = scrollDirection;
    //=****** 添加image ****************** stone ***
    scrollView.images = images;
    //=****** 添加pageControl ****************** stone ***
    UIPageControl * pageControl = [[UIPageControl alloc] init];
    scrollView.pageControl = pageControl;
    pageControl.enabled = NO;
    pageControl.currentPageIndicatorTintColor = currentPageIndicatorTintColor;
    pageControl.pageIndicatorTintColor = pageIndicatorTintColor;
    pageControl.numberOfPages = scrollView.images.count;
    pageControl.bounds = CGRectMake(0, 0, scrollView.bounds.size.width, 44);
    pageControl.center = CGPointMake(scrollView.bounds.size.width * 0.5, scrollView.bounds.size.height * 0.9);
    [scrollView addSubview:pageControl];
    [superView addSubview:scrollView];
    //=************************ stone ***
    return scrollView;
}

@end
