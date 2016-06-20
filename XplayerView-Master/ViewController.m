//
//  ViewController.m
//  XplayerView-Master
//
//  Created by xueyongwei on 16/6/20.
//  Copyright © 2016年 xueyongwei. All rights reserved.
//

#import "ViewController.h"
#import "XplayView.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //创建播放器
    XplayView *playerView = [[XplayView alloc]initWithFrame:CGRectMake(0, 50, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.width)];
    [self.view addSubview:playerView];
    //模拟网络加载过程
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [playerView Xinit];
    });

   
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
