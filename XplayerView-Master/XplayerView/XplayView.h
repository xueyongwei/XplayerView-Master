//
//  XplayView.h
//  Player
//
//  Created by xueyongwei on 16/6/20.
//  Copyright © 2016年 xueyongwei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
@interface XplayView : UIView
@property (nonatomic,strong) AVPlayer *player;//播放器对象


@property (strong, nonatomic)  UIImageView *playOrPause; //底部控制视图
@property (strong, nonatomic)  UIView *controlView; //底部控制视图
@property (strong, nonatomic)  UILabel *yiboTimeLabel; //已播时长
@property (strong, nonatomic)  UILabel *zongTimeLabel; //已播时长
@property (strong, nonatomic)  UISlider *videoSlider;//播放进度可拖动
@property (strong, nonatomic)  UIProgressView *progress;//播放进度
@property (strong, nonatomic)  UIProgressView *bottomProgress;//底部显示播放进度




- (void)Xinit;
@end
