//
//  MusicListTableViewCell.h
//  MusicPlay
//
//  Created by 张建军 on 15/11/2.
//  Copyright © 2015年 张建军. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MusicModel.h"

@interface MusicListTableViewCell : UITableViewCell

- (void)bindModel:(MusicModel *)model;


@end
