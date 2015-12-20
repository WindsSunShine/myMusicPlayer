//
//  DataHandle.m
//  MusicPlay
//
//  Created by 张建军 on 15/11/3.
//  Copyright © 2015年 张建军. All rights reserved.
//

#import "DataHandle.h"

@interface DataHandle()

@property (nonatomic, strong) NSMutableArray *dataArray;


@end

@implementation DataHandle


+ (DataHandle *)defaultDataHandle
{
    static dispatch_once_t onceToken;
    static DataHandle *dataHandle = nil;
    dispatch_once(&onceToken, ^{
        dataHandle = [DataHandle new];
        dataHandle.dataArray = [NSMutableArray array];
        [dataHandle loadData];
    });
    return dataHandle;
}

- (void)loadData
{
    // 开辟一个子线程获取数据
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        
        NSString *string = @"http://project.lanou3g.com/teacher/UIAPI/MusicInfoList.plist";
        
        NSURL *url = [NSURL URLWithString:string];
        
        
        // 获取到存储到远程服务器的plist文件
        NSArray *array = [NSArray arrayWithContentsOfURL:url];
        
        // 如果数组里面有字典，则初始化一个model，再通过KVC给model赋值,然后添加到数组里面
        for (NSDictionary *dic in array) {
            MusicModel *model = [[MusicModel alloc] init];
            
            [model setValuesForKeysWithDictionary:dic];
            [self.dataArray addObject:model];
        }
        
        // 当数据处理完毕，回到主线程发送通知
        dispatch_async(dispatch_get_main_queue(), ^{
            [[NSNotificationCenter defaultCenter] postNotificationName:@"finishData" object:nil];
        });
    });
   
}

- (NSInteger)modelCount
{
    return self.dataArray.count;
}

- (MusicModel *)modelWithIndex:(NSInteger)index
{
    return self.dataArray[index];
}








@end
