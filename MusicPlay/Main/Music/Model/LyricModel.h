//
//  LyricModel.h
//  MusicPlay
//
//  Created by 张建军 on 15/11/5.
//  Copyright © 2015年 张建军. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LyricModel : NSObject

@property (nonatomic, copy) NSString *lyricString;

@property (nonatomic, assign) float time;



+ (id)lyricWithLyricString:(NSString *)lyric andtime:(float)time;
@end
