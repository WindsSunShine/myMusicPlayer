//
//  PlayerHelpers.m
//  MusicPlay
//
//  Created by 张建军 on 15/11/3.
//  Copyright © 2015年 张建军. All rights reserved.
//

#import "PlayerHelpers.h"
#import <AVFoundation/AVFoundation.h>

@interface PlayerHelpers()

@property (nonatomic, strong) AVPlayer *player;

@property (nonatomic, assign) BOOL isPlaying;

@property (nonatomic, strong) NSTimer *timer;




@end

@implementation PlayerHelpers

+ (PlayerHelpers *)defaultPlayerHelpers
{
    static dispatch_once_t onceToken;
    static PlayerHelpers *playerHelpers = nil;
    dispatch_once(&onceToken, ^{
        playerHelpers = [PlayerHelpers new];
        playerHelpers.player = [[AVPlayer alloc] init];
        playerHelpers.playStatus = 0;
        [[NSNotificationCenter defaultCenter] addObserver:playerHelpers selector:@selector(musicDidFinish) name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
        
    });
    
    return playerHelpers;
}

#pragma mark- notificationAction
- (void)musicDidFinish
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(currentMusicDidFinish)]) {
        [self.delegate currentMusicDidFinish];
    }
}


- (void)playWithURL:(NSString *)urlString
{
    if (self.player.currentItem) {
        [self.player.currentItem removeObserver:self forKeyPath:@"status"];
    }
    
    NSURL *url = [NSURL URLWithString:urlString];
//    
    AVPlayerItem *item = [[AVPlayerItem alloc] initWithURL:url];
    
    // 观察者模式
    [item addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew context:nil];
    
    [self.player replaceCurrentItemWithPlayerItem:item];    
}

- (void)play
{
    [self.player play];
    self.isPlaying = YES;
    
    if (self.timer == nil) {
        self.timer = [NSTimer scheduledTimerWithTimeInterval:0.02 target:self selector:@selector(timerAction) userInfo:nil repeats:YES];
        
        [self.timer fire];
    }
}

#pragma mark- timerAction

- (void)timerAction
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(musicPlayTime:)]) {
        
        
        // 因为CMTime的结构体已经告诉了。 time.value / time.timescale 可以得到秒数，所以，我们这里通过这个方法计算出来当前播放到多少秒了。
        float progress = self.player.currentTime.value / self.player.currentTime.timescale;
        
        [self.delegate musicPlayTime:progress];
        
    }
}

#pragma mark -musicControl

- (void)pause
{
    [self.player pause];
    self.isPlaying = NO;
    [self.timer invalidate];
    self.timer = nil;

}

- (void)stop
{
    [self pause];
}

- (BOOL)isPlaying
{
    return _isPlaying;
}

- (void)seekToTime:(float)time
{
    CMTime musicTime = CMTimeMakeWithSeconds(time, self.player.currentTime.timescale);
    [self pause];
    [self.player seekToTime:musicTime completionHandler:^(BOOL finished) {
        if (finished) {
            [self play];
        }
    }];
}


#pragma mark- observe
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"status"]) {
        switch ([change[@"new"] integerValue]) {
            case AVPlayerItemStatusUnknown:
                break;
            case AVPlayerItemStatusReadyToPlay:
                [self play];
                break;
            case AVPlayerItemStatusFailed:
                break;
            default:
                break;
        }
    }
}


- (BOOL)isCurrentMusicWithURLString:(NSString *)urlString
{
    //获取当前播放的音乐的URL
    NSString *string = [(AVURLAsset *) self.player.currentItem.asset URL].absoluteString;
    
    // 对比 传进来的URL和当前播放音乐的URL是否是一个
    return [urlString isEqualToString:string];
}


@end
