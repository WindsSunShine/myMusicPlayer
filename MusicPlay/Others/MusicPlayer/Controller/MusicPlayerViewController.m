//
//  MusicPlayerViewController.m
//  MusicPlay
//
//  Created by 张建军 on 15/11/2.
//  Copyright © 2015年 张建军. All rights reserved.
//

#import "MusicPlayerViewController.h"
#import "DataHandle.h"
#import "MusicModel.h"
#import "PlayerHelpers.h"
#import "UIImageView+WebCache.h"
#import "LyricHelpers.h"
#import <MediaPlayer/MPMediaItem.h>
#import <MediaPlayer/MPNowPlayingInfoCenter.h>



@interface MusicPlayerViewController ()<PlayerHelpersDelegate, UITableViewDataSource, UITableViewDelegate>

// 模型
@property (nonatomic, strong) MusicModel *model;
@property (weak, nonatomic) IBOutlet UITableView *tableView;


@property (weak, nonatomic) IBOutlet UIImageView *MyImageView;

@property (weak, nonatomic) IBOutlet UIButton *lastButton;

@property (weak, nonatomic) IBOutlet UIButton *playButton;

@property (weak, nonatomic) IBOutlet UIButton *nextButton;

@property (weak, nonatomic) IBOutlet UILabel *musicName;

@property (weak, nonatomic) IBOutlet UILabel *singerName;

@property (weak, nonatomic) IBOutlet UIImageView *musicImage;
@property (weak, nonatomic) IBOutlet UIButton *backButton;
@property (weak, nonatomic) IBOutlet UISlider *musicSlider;

@end

@implementation MusicPlayerViewController

- (void)dealloc
{
    [PlayerHelpers defaultPlayerHelpers].delegate      = nil;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.MyImageView layoutIfNeeded];
    self.MyImageView.layer.masksToBounds = YES;
    
    self.MyImageView.layer.cornerRadius = self.MyImageView.bounds.size.height / 2;
    
    [PlayerHelpers defaultPlayerHelpers].delegate = self;
    
    
    MusicModel *model = [[DataHandle defaultDataHandle] modelWithIndex:self.index];
    
    
    
    
    if (![[PlayerHelpers defaultPlayerHelpers] isCurrentMusicWithURLString:model.mp3Url]) {
        self.model = model;
    } else {
        [self changeUIWithModel:model];
    }
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"CELL"];
    
    
    
}

#pragma mark- buttonAction

- (IBAction)backButtonAction:(UIButton *)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}



- (IBAction)lastButtonClicked:(id)sender {
    
    if (self.index == 0) {
        self.index = [[DataHandle defaultDataHandle] modelCount] - 1;
    } else {
        self.index -= 1;
    }
    self.model = [[DataHandle defaultDataHandle] modelWithIndex:self.index];
}

- (IBAction)controlButtonClicked:(id)sender {
    
    UIButton *button = (UIButton *)sender;
    if ([[PlayerHelpers defaultPlayerHelpers] isPlaying]) {
        [[PlayerHelpers defaultPlayerHelpers] pause];
        [button setTitle:@"播放" forState:UIControlStateNormal];
    } else {
        [[PlayerHelpers defaultPlayerHelpers] play];
        [button setTitle:@"暂停" forState:UIControlStateNormal];
    }
}

- (IBAction)nextButtonClicked:(id)sender {
    
    switch ([PlayerHelpers defaultPlayerHelpers].playStatus) {
        case 0:
            if (self.index == [[DataHandle defaultDataHandle] modelCount] - 1) {
                self.index = 0;
            } else {
                self.index += 1;
            }
            self.model = [[DataHandle defaultDataHandle] modelWithIndex:self.index];

            break;
        case 1:
            self.index = arc4random() % [[DataHandle defaultDataHandle] modelCount];
            self.model = [[DataHandle defaultDataHandle] modelWithIndex:self.index];
      
            break;
        case 2:
            self.model = [[DataHandle defaultDataHandle] modelWithIndex:self.index];
            break;
        default:
            break;
    }
    
}



#pragma mark- sliderAction
- (IBAction)musicSliderAction:(id)sender {
    UISlider *slider = (UISlider *)sender;
    
    [[PlayerHelpers defaultPlayerHelpers] seekToTime:slider.value];
}


- (void)setModel:(MusicModel *)model
{
        _model = model;
    [[LyricHelpers defaultLyricHelpers] changeLyricString:model.lyric];

    [[PlayerHelpers defaultPlayerHelpers] playWithURL:self.model.mp3Url];
    [self changeUIWithModel:model];
}

- (void)changeUIWithModel:(MusicModel *)model
{
    
    self.musicName.text = model.name;
    self.singerName.text = model.singer;
    [self.musicImage sd_setImageWithURL:[NSURL URLWithString:model.picUrl]];
    self.musicSlider.value = 0;
    self.musicSlider.minimumValue = 0;
    
    float musicTime = [model.duration floatValue] / 1000;
    self.musicSlider.maximumValue = musicTime;
    
    [self.tableView reloadData];
    
    
    
}

#pragma mark- playerDelegate

- (void)musicPlayTime:(float)time
{
    self.musicSlider.value = time;
    self.musicImage.transform = CGAffineTransformRotate(self.musicImage.transform, 0.01);
    
    NSInteger index = [[LyricHelpers defaultLyricHelpers] lyricItemWithTime:time];
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
    
    [self.tableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionBottom];
}

- (IBAction)changeMusicStatus:(id)sender {
    
    UIButton *button = (UIButton *)sender;
    
    [PlayerHelpers defaultPlayerHelpers].playStatus = button.tag - 10000;
}



- (void)currentMusicDidFinish
{
    [self nextButtonClicked:nil];
}

#pragma mark- tableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return [[LyricHelpers defaultLyricHelpers] lyricItemCount];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CELL" forIndexPath:indexPath];
    
    cell.textLabel.text = [[LyricHelpers defaultLyricHelpers] lyricStringWithIndex:indexPath.row];
    
    cell.textLabel.highlightedTextColor = [UIColor greenColor];
    
    cell.textLabel.font = [UIFont systemFontOfSize:12];
    
    cell.textLabel.textAlignment = NSTextAlignmentCenter;
    
    return cell;
}

#pragma mark- 后台播放
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    //后台播放
    [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
    
    [self becomeFirstResponder];
    [self configNowPlayingInfoCenter];
    
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    [[UIApplication sharedApplication] endReceivingRemoteControlEvents];
    [self resignFirstResponder];
}


- (void)remoteControlReceivedWithEvent:(  UIEvent *)event
{
    if (event.type == UIEventTypeRemoteControl) {
        
        switch (event.subtype) {
            case UIEventSubtypeRemoteControlPlay: {
                [self controlButtonClicked:nil];
                break;
            }
            case UIEventSubtypeRemoteControlPause: {
                [self controlButtonClicked:nil];
                break;
            }
            case UIEventSubtypeRemoteControlPreviousTrack: {
                [self lastButtonClicked:nil];
                [self configNowPlayingInfoCenter];
                break;
            }
            case UIEventSubtypeRemoteControlNextTrack: {
                [self nextButtonClicked:nil];
                [self configNowPlayingInfoCenter];
                break;
            }
                
            default:
                break;
        }
        
    }
    
}

#pragma mark - 设置锁屏面板信息
- (void)configNowPlayingInfoCenter {
    
    MusicModel *musicModel =[[DataHandle defaultDataHandle] modelWithIndex:self.index];
    
    if(NSClassFromString(@"MPNowPlayingInfoCenter"))
    {
        
        NSMutableDictionary * dict = [[NSMutableDictionary alloc] init];
        
        //歌曲名
        [dict setObject:[musicModel name] forKey:MPMediaItemPropertyTitle];
        //歌手
        [dict setObject:musicModel.singer forKey:MPMediaItemPropertyArtist];
        
        //播放时长
        [dict setObject:[NSNumber numberWithDouble:[self.model.duration doubleValue]/1000] forKey:MPMediaItemPropertyPlaybackDuration];
        //专辑名
        [dict setObject:musicModel.album forKey:MPMediaItemPropertyAlbumTitle];
        
        
        //图片
        UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:self.model.picUrl]]];
        
        MPMediaItemArtwork * mArt = [[MPMediaItemArtwork alloc] initWithImage:image];
        
        [dict setObject:mArt forKey:MPMediaItemPropertyArtwork];
        
        //设置锁屏状态下显示歌曲信息
        [[MPNowPlayingInfoCenter defaultCenter] setNowPlayingInfo:dict];
        
    }
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
