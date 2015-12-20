//
//  LyricHelpers.h
//  MusicPlay
//
//  Created by 张建军 on 15/11/5.
//  Copyright © 2015年 张建军. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LyricHelpers : NSObject

+ (LyricHelpers *)defaultLyricHelpers;

- (void)changeLyricString:(NSString *)string;

- (NSInteger)lyricItemCount;

- (NSString *)lyricStringWithIndex:(NSInteger)index;

- (NSInteger)lyricItemWithTime:(float)time;









@end
