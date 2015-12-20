//
//  PlayerHelpers.h
//  MusicPlay
//
//  Created by 张建军 on 15/11/3.
//  Copyright © 2015年 张建军. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol PlayerHelpersDelegate <NSObject>

// 这个代理方法的作用是告诉外界当前音乐播放的时间
- (void)musicPlayTime:(float)time;

// 当前音乐结束播放的代理方法

- (void)currentMusicDidFinish;

@end

@interface PlayerHelpers : NSObject


// 代理指针使用assign的原因是 防治父类对象作为子类对象代理人的时候造成的循环引用
@property (nonatomic, assign) id<PlayerHelpersDelegate>delegate;

@property (nonatomic, assign) NSInteger playStatus;


+ (PlayerHelpers *)defaultPlayerHelpers;


- (void)playWithURL:(NSString *)urlString;


- (void)play;

- (void)pause;

- (void)stop;

- (BOOL)isPlaying;

- (void)seekToTime:(float)time;

- (BOOL)isCurrentMusicWithURLString:(NSString *)urlString;


@end
