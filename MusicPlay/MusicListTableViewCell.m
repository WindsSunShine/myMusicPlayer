//
//  MusicListTableViewCell.m
//  MusicPlay
//
//  Created by 张建军 on 15/11/2.
//  Copyright © 2015年 张建军. All rights reserved.
//

#import "MusicListTableViewCell.h"
#import "UIImageView+WebCache.h"

@interface MusicListTableViewCell()
@property (weak, nonatomic) IBOutlet UILabel *MusicNameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *MyImageView;
@property (weak, nonatomic) IBOutlet UILabel *playerNameLabel;

@end


@implementation MusicListTableViewCell

// 拖控件出来的cell会走这个方法
- (void)awakeFromNib {
    // Initialization code
}



- (void)bindModel:(MusicModel *)model
{
    self.MusicNameLabel.text = model.name;
    self.playerNameLabel.text = model.singer;
    //老版本的SDWebImage提供的方法
//    self.MyImageView setImageWithURL:<#(NSURL *)#>
    
    [self.MyImageView sd_setImageWithURL:[NSURL URLWithString:model.picUrl]];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
