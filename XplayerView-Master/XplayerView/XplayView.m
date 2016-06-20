//
//  XplayView.m
//  Player
//
//  Created by xueyongwei on 16/6/20.
//  Copyright © 2016年 xueyongwei. All rights reserved.
//

#import "XplayView.h"

@implementation XplayView
{
    UIActivityIndicatorView *WaitView;
    int autoDismiss;
}
-(UIView *)controlView
{
    if (!_controlView) {
        _controlView = [[UIView alloc]initWithFrame:CGRectMake(0, self.bounds.size.height-30, self.bounds.size.width, 30)];
        _controlView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.6];
        [self addSubview:_controlView];
    }
    return _controlView;
}
-(UILabel *)yiboTimeLabel
{
    if (!_yiboTimeLabel) {
        _yiboTimeLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, self.controlView.bounds.size.height/2-5, 30, 10)];
        _yiboTimeLabel.textColor = [UIColor whiteColor];
        _yiboTimeLabel.textAlignment = NSTextAlignmentRight;
        _yiboTimeLabel.font = [UIFont systemFontOfSize:10];
        _yiboTimeLabel.text = @"00:00";
    }
    return _yiboTimeLabel;
}
-(UILabel *)zongTimeLabel
{
    if (!_zongTimeLabel) {
        _zongTimeLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.controlView.bounds.size.width-30, self.controlView.bounds.size.height/2-5, 30, 10)];
        _zongTimeLabel.textColor = [UIColor whiteColor];
        _zongTimeLabel.textAlignment = NSTextAlignmentLeft;
        _zongTimeLabel.font = [UIFont systemFontOfSize:10];
        _zongTimeLabel.text = @"00:00";
    }
    return _zongTimeLabel;
}

-(UISlider*)videoSlider
{
    if (!_videoSlider) {
        _videoSlider = [[UISlider alloc]initWithFrame:CGRectMake(30, self.controlView.bounds.size.height/2-8, self.controlView.bounds.size.width - 60, 15)];
        [_videoSlider setThumbImage:[UIImage imageNamed:@"指针"] forState:UIControlStateNormal];
    }
    return _videoSlider;
}
-(UIProgressView *)progress
{
    if (!_progress) {
        _progress = [[UIProgressView alloc]initWithFrame:CGRectMake(0, 0, 0, 2)];
//        [self addSubview:_progress];
    }
    return _progress;
}
-(UIImageView *)playOrPause
{
    if (!_playOrPause) {
        _playOrPause = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 65, 65)];
        _playOrPause.center = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds));
        _playOrPause.image = [UIImage imageNamed:@"播放按钮"];
        _playOrPause.alpha = 0;
    }
    return _playOrPause;
}
-(UIProgressView *)bottomProgress
{
    if (!_bottomProgress) {
        _bottomProgress = [[UIProgressView alloc]initWithFrame:CGRectMake(0, self.frame.size.height, self.frame.size.width, 1)];
        _bottomProgress.progressTintColor = [UIColor redColor];
        _bottomProgress.trackTintColor = [UIColor lightGrayColor];
        _bottomProgress.progress = 0.0;
        _bottomProgress.alpha = 0;
    }
    return _bottomProgress;
}
- (void)Xinit {
    autoDismiss = 0;
    [WaitView stopAnimating];
    [WaitView removeFromSuperview];
    [self setupUI];
    [self.player play];
}
-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor blackColor];
        WaitView = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        WaitView.center = CGPointMake(CGRectGetMidX(self.bounds),CGRectGetMidY(self.bounds));
        [WaitView startAnimating];
        [self addSubview:WaitView];
    }
    return self;
}
-(id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        self.backgroundColor = [UIColor blackColor];
        WaitView = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        WaitView.center = CGPointMake(CGRectGetMidX(self.bounds),CGRectGetMidY(self.bounds));
        [WaitView startAnimating];
    }
    return self;
}
-(void)dealloc{
    [self removeObserverFromPlayerItem:self.player.currentItem];
    [self removeNotification];
}

#pragma mark - 私有方法
-(void)setupUI{
    //创建播放器层
    self.backgroundColor = [UIColor blackColor];
    self.opaque = YES;
    //添加点击事件
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapPlayerView:)];
    [self addGestureRecognizer:tap];
    
    AVPlayerLayer *playerLayer=[AVPlayerLayer playerLayerWithPlayer:self.player];
    playerLayer.frame=CGRectMake(0, 0, self.frame.size.width, self.frame.size.height-1);
    //playerLayer.videoGravity=AVLayerVideoGravityResizeAspect;//视频填充模式
    [self.layer addSublayer:playerLayer];
    
    [self.controlView addSubview:self.yiboTimeLabel];
    [self.controlView addSubview:self.progress];
    [self.controlView addSubview:self.videoSlider];
    [self.controlView addSubview:self.zongTimeLabel];
    
    [self addSubview:self.bottomProgress];
    [self addSubview:self.playOrPause];
    
    
}
-(void)tapPlayerView:(UITapGestureRecognizer *)recognizer
{
    NSLog(@"点击了播放器");
    autoDismiss = 0;
    if (self.controlView.alpha ==0) {//没有控制器
        [self showControll];
    }else{//有控制器
        if(self.player.rate==0){ //说明时暂停
            [self.player play];
            self.playOrPause.alpha = 0;
            [self hiddenControll];
        }else if(self.player.rate==1){//正在播放
            [self.player pause];
            self.playOrPause.alpha = 1;
        }
    }
}
/**
 *  隐藏控制面板
 */
-(void)hiddenControll
{
    [UIView animateWithDuration:0.5f animations:^{
        self.controlView.alpha = 0;
        self.bottomProgress.alpha = 1;
        
    } completion:^(BOOL finished) {
//        self.controlView.hidden = YES;
//        self.bottomProgress.hidden = NO;
    }];
    
    [self bringSubviewToFront:self.controlView];
//    self.playOrPause.hidden = YES;
//    self.progress.hidden = YES;
}
/**
 *  显示控制面板
 */
-(void)showControll
{
//    self.controlView.hidden = NO;
//    self.bottomProgress.hidden = YES;
    [UIView animateWithDuration:0.5f animations:^{
        self.controlView.alpha = 1;
        self.bottomProgress.alpha = 0;
    } completion:^(BOOL finished) {
       
    }];
    
    [self bringSubviewToFront:self.controlView];
//    self.playOrPause.hidden = NO;
//    self.progress.hidden = NO;
}
/**
 *  初始化播放器
 *
 *  @return 播放器对象
 */
-(AVPlayer *)player{
    if (!_player) {
        AVPlayerItem *playerItem=[self getPlayItem:0];
        _player=[AVPlayer playerWithPlayerItem:playerItem];
        [self addProgressObserver];
        [self addObserverToPlayerItem:playerItem];
    }
    return _player;
}

/**
 *  根据视频索引取得AVPlayerItem对象
 *
 *  @param videoIndex 视频顺序索引
 *
 *  @return AVPlayerItem对象
 */
-(AVPlayerItem *)getPlayItem:(int)videoIndex{
    if (videoIndex == 0) {//测试用
        NSString *urlStr=[NSString stringWithFormat:@"http://125.39.109.33/flv2.bn.netease.com/videolib3/1603/18/Kjxcu2321/SD/Kjxcu2321-mobile.mp4"];
        urlStr =[urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSURL *url=[NSURL URLWithString:urlStr];
        AVPlayerItem *playerItem=[AVPlayerItem playerItemWithURL:url];
        return playerItem;
    }
    NSString *urlStr=[NSString stringWithFormat:@"http://192.168.1.161/%i.mp4",videoIndex];
    urlStr =[urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *url=[NSURL URLWithString:urlStr];
    AVPlayerItem *playerItem=[AVPlayerItem playerItemWithURL:url];
    return playerItem;
}
#pragma mark - 通知
/**
 *  添加播放器通知
 */
-(void)addNotification{
    //给AVPlayerItem添加播放完成通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playbackFinished:) name:AVPlayerItemDidPlayToEndTimeNotification object:self.player.currentItem];
}

-(void)removeNotification{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

/**
 *  播放完成通知
 *
 *  @param notification 通知对象
 */
-(void)playbackFinished:(NSNotification *)notification{
    NSLog(@"视频播放完成.");
}

#pragma mark - 监控
/**
 *  给播放器添加进度更新
 */
-(void)addProgressObserver{
     __block AVPlayerItem *playerItem=self.player.currentItem;
    __block UIProgressView *wkBottomProgress = self.bottomProgress;
    __block UISlider *wkVideoSlider = self.videoSlider;
    __block UILabel *wkYiboLabel = self.yiboTimeLabel;
    __block  int wekDismiss = autoDismiss;
    __weak typeof(self) wkSelf = self;
    //这里设置每秒执行一次
    [self.player addPeriodicTimeObserverForInterval:CMTimeMake(1.0, 1.0) queue:dispatch_get_main_queue() usingBlock:^(CMTime time) {
        wekDismiss ++;
        if (wkSelf.controlView.alpha == 0) {
            wekDismiss = 0;
        }
        NSLog(@"diss = %d",wekDismiss);
        if (wekDismiss>=3) {
            [wkSelf hiddenControll];
            wekDismiss = 0;
            NSLog(@"aa diss = %d",wekDismiss);
        }
        float current=CMTimeGetSeconds(time);
        float total=CMTimeGetSeconds([playerItem duration]);
        NSLog(@"当前已经播放%.2fs.",current);
        
        if (current) {
            wkYiboLabel.text = [NSString stringWithFormat:@"%.2f",current];
            [wkBottomProgress setProgress:(current/total) animated:YES];
            [wkVideoSlider setValue:(current/total) animated:YES];
        }
    }];
}

/**
 *  给AVPlayerItem添加监控
 *
 *  @param playerItem AVPlayerItem对象
 */
-(void)addObserverToPlayerItem:(AVPlayerItem *)playerItem{
    //监控状态属性，注意AVPlayer也有一个status属性，通过监控它的status也可以获得播放状态
    [playerItem addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew context:nil];
    //监控网络加载情况属性
    [playerItem addObserver:self forKeyPath:@"loadedTimeRanges" options:NSKeyValueObservingOptionNew context:nil];
}
-(void)removeObserverFromPlayerItem:(AVPlayerItem *)playerItem{
    [playerItem removeObserver:self forKeyPath:@"status"];
    [playerItem removeObserver:self forKeyPath:@"loadedTimeRanges"];
}
/**
 *  通过KVO监控播放器状态
 *
 *  @param keyPath 监控属性
 *  @param object  监视器
 *  @param change  状态改变
 *  @param context 上下文
 */
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
    AVPlayerItem *playerItem=object;
    [self bringSubviewToFront:self.controlView];
    if ([keyPath isEqualToString:@"status"]) {
        AVPlayerStatus status= [[change objectForKey:@"new"] intValue];
        if(status==AVPlayerStatusReadyToPlay){
            NSLog(@"正在播放...，视频总长度:%.2f",CMTimeGetSeconds(playerItem.duration));
            self.zongTimeLabel.text = [NSString stringWithFormat:@"%.2f", CMTimeGetSeconds(playerItem.duration)];
        }
    }else if([keyPath isEqualToString:@"loadedTimeRanges"]){
        NSArray *array=playerItem.loadedTimeRanges;
        CMTimeRange timeRange = [array.firstObject CMTimeRangeValue];//本次缓冲时间范围
        float startSeconds = CMTimeGetSeconds(timeRange.start);
        float durationSeconds = CMTimeGetSeconds(timeRange.duration);
        NSTimeInterval totalBuffer = startSeconds + durationSeconds;//缓冲总长度
        NSLog(@"共缓冲：%.2f",totalBuffer);
        
        //
    }
}

#pragma mark - UI事件
/**
 *  点击播放/暂停按钮
 *
 *  @param sender 播放/暂停按钮
 */
- (void)playClick:(UIButton *)sender {
    //    AVPlayerItemDidPlayToEndTimeNotification
    //AVPlayerItem *playerItem= self.player.currentItem;
    if(self.player.rate==0){ //说明时暂停
        [sender setImage:[UIImage imageNamed:@"player_pause"] forState:UIControlStateNormal];
        [self.player play];
    }else if(self.player.rate==1){//正在播放
        [self.player pause];
        [sender setImage:[UIImage imageNamed:@"player_play"] forState:UIControlStateNormal];
    }
}
-(void)testPlay:(UIButton *)sender
{
    [self removeNotification];
    [self removeObserverFromPlayerItem:self.player.currentItem];
    AVPlayerItem *playerItem=[self getPlayItem:0];
    [self addObserverToPlayerItem:playerItem];
    //切换视频
    [self.player replaceCurrentItemWithPlayerItem:playerItem];
    [self addNotification];
     [self.player play];

}
- (NSString *)convertTime:(CGFloat)second{
    NSDate *d = [NSDate dateWithTimeIntervalSince1970:second];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    if (second/3600 >= 1) {
        [dateFormatter setDateFormat:@"HH:mm:ss"];
    } else {
        [dateFormatter setDateFormat:@"mm:ss"];
    }
    NSString *showtimeNew = [dateFormatter stringFromDate:d];
    return showtimeNew;
}
/**
 *  切换选集，这里使用按钮的tag代表视频名称
 *
 *  @param sender 点击按钮对象
 */
//- (IBAction)navigationButtonClick:(UIButton *)sender {
//    [self removeNotification];
//    [self removeObserverFromPlayerItem:self.player.currentItem];
//    AVPlayerItem *playerItem=[self getPlayItem:sender.tag];
//    [self addObserverToPlayerItem:playerItem];
//    //切换视频
//    [self.player replaceCurrentItemWithPlayerItem:playerItem];
//    [self addNotification];
//}

@end

