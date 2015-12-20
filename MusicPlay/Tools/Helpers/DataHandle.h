//
//  DataHandle.h
//  MusicPlay
//
//  Created by 张建军 on 15/11/3.
//  Copyright © 2015年 张建军. All rights reserved.
//


//获取数据的工具类
#import <Foundation/Foundation.h>
#import "MusicModel.h"



@interface DataHandle : NSObject

+ (DataHandle *)defaultDataHandle;


- (NSInteger)modelCount;


- (MusicModel *)modelWithIndex:(NSInteger)index;




@end
