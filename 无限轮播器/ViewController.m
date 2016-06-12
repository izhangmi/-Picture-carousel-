//
//  AppDelegate.m
//  无限轮播器
//
//  Created by zhangmi on 16/5/16.
//  Copyright © 2016年 Paramount Pictures. All rights reserved.
//
#import "ViewController.h"
#import "SNInfiniteScrollView.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    NSMutableArray * images = [NSMutableArray array];
    for (int i = 0; i < 5; i++) {
        NSString * imageName = [NSString stringWithFormat:@"ad_%02d", i]; //img01
        UIImage * image = [UIImage imageNamed:imageName];
        [images addObject:image];
    }
    UIView * scrollView = [SNInfiniteScrollView scrollViewWithFrame:CGRectMake(0, 20, 414, 200) superView:self.view images:images scrollDirection:ScrollDirectionHorizontal pageIndicatorTintColor:[UIColor lightGrayColor] currentPageIndicatorTintColor:[UIColor orangeColor] imageViewcontentMode:UIViewContentModeScaleAspectFit];
    
    [self.view addSubview:scrollView];
}

@end
