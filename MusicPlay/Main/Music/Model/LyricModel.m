//
//  LyricModel.m
//  MusicPlay
//
//  Created by 张建军 on 15/11/5.
//  Copyright © 2015年 张建军. All rights reserved.
//

#import "LyricModel.h"

@interface LyricModel()


@end

@implementation LyricModel


- (id)initWithLyric:(NSString *)lyric andTime:(float)time
{
    self = [super init];
    if (self) {
        _lyricString = lyric;
        _time = time;
    }
    return self;
}

+ (id)lyricWithLyricString:(NSString *)lyric andtime:(float)time
{
    return [[LyricModel alloc] initWithLyric:lyric andTime:time];
}


@end
