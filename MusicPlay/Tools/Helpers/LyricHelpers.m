//
//  LyricHelpers.m
//  MusicPlay
//
//  Created by 张建军 on 15/11/5.
//  Copyright © 2015年 张建军. All rights reserved.
//

#import "LyricHelpers.h"
#import "LyricModel.h"

@interface LyricHelpers()

@property (nonatomic, strong) NSMutableArray *lyricItemArray;

@property (nonatomic, assign) NSInteger index;

@end

@implementation LyricHelpers

+ (LyricHelpers *)defaultLyricHelpers
{
    static dispatch_once_t onceToken;
    static LyricHelpers *lyricHelpers = nil;
    dispatch_once(&onceToken, ^{
        lyricHelpers = [[LyricHelpers alloc] init];
    });
    
    return lyricHelpers;
}

- (void)changeLyricString:(NSString *)string
{
    // 初始化我的数据源数组
    self.lyricItemArray = [NSMutableArray array];
    // 因为歌词字符串的每句歌词之间都有一个\n,所以 通过\n 把歌词字符串拆成一个大的数组，数组里面每个字符串的格式基本上都是
    // [00:01.123]歌词
    NSArray *array = [string componentsSeparatedByString:@"\n"];
    // 因为数组里面保存的都是字符串，所以对数组做了一个循环遍历
    for (NSString *str in array) {
        // 因为有什么都没有的字符串，所以对字符串的长度做了一个判断，如果长度为0 则随便初始化一个model 加到数据源数组里面
        if (str.length == 0) {
            // 因为是随便的model，所以歌词没给，时间给个大的数
            LyricModel *item = [LyricModel lyricWithLyricString:@"" andtime:4000];
            [self.lyricItemArray addObject:item];
        } else {
            // 因为到这里的字符串的格式是[00:01.123]歌词， 在“]”之前代表的是时间，之后代表的是歌词, 所以 根据"]"把一句歌词 拆成一个小的数组。
            NSArray *array = [str componentsSeparatedByString:@"]"];
            // [
            //    "[01:20.120";
            //    "歌词"
            // ]
            //
            // 排除掉我们不想要的数据，就是数组count小于等于1的数据
            if (array.count > 1) {
                // 数组的第一位存的是时间
                NSString *timeString = array[0];
                // 数组的第二位存的是歌词
                NSString *lyricString = array[1];
                // 因为时间字符串的格式是"[01:20.120", 第一位是“[”，对我们有影响，所以从第一位截取字符串，到最后一位,截取的结果就是"01:20.120"
                NSString *newTimeString = [timeString substringFromIndex:1];
                
                // 因为时间字符串的格式是"01:20.120"的,所以根据":"将时间字符串拆成一个包含两个元素的数组,
//                [
//                    "minute";
//                    "second";
//                ]
                NSArray *timeArray = [newTimeString componentsSeparatedByString:@":"];
                // 一个排除的判断
                if (timeArray.count > 1) {
                    // 接受数组的第一位,为minute，因为minute是一个字符串类型的，所以要转成floatValue类型的
                    float minute = [timeArray[0] floatValue];
                    // 接受数组的第一位,为second，因为second是一个字符串类型的，所以要转成floatValue类型的
                    float second = [timeArray[1] floatValue];
                    
                    // 计算总时间(以秒为单位的)
                    float time = minute * 60 + second;
                    
                    // 创建新的model
                    LyricModel *model = [LyricModel lyricWithLyricString:lyricString andtime:time];
                    // 加到数组里面
                    [self.lyricItemArray addObject:model];
                }
            } else {
              
            }
        }
}
}


- (NSInteger)lyricItemCount
{
    return self.lyricItemArray.count;
}

- (NSString *)lyricStringWithIndex:(NSInteger)index
{
    LyricModel *model = self.lyricItemArray[index];
    
    return model.lyricString;
}


- (NSInteger)lyricItemWithTime:(float)time
{
    for (int i = 0; i < self.lyricItemArray.count; i++) {
        LyricModel *model = self.lyricItemArray[i];
        if (time < model.time) {
            
            _index = i - 1 > 0 ? i - 1 : 0;
            break;
        }
    }
    
    return _index;
}
@end
