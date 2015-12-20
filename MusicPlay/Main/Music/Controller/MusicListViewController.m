//
//  MusicListViewController.m
//  MusicPlay
//
//  Created by 张建军 on 15/11/2.
//  Copyright © 2015年 张建军. All rights reserved.
//

#import "MusicListViewController.h"
#import "MusicListTableViewCell.h"
#import "MusicPlayerViewController.h"
#import "DataHandle.h"
#import <AVFoundation/AVFoundation.h>

@interface MusicListViewController ()<UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation MusicListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // 默认是yes，再iOS7.0之后出现的，会将UIScrollView及其它的子类，自动的向下偏移64个单位。
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    
    
    [DataHandle defaultDataHandle];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(finishLoadData) name:@"finishData" object:nil];
}

- (void)finishLoadData
{
    [self.tableView reloadData];
}

#pragma mark-UITableViewDelegateAndDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[DataHandle defaultDataHandle] modelCount];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MusicListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ListCell" forIndexPath:indexPath];
    
//    MusicModel *model = [[DataHandle defaultDataHandle] modelWithIndex:indexPath.row];
//    
//    [cell bindModel:model];
    
    [cell bindModel:[[DataHandle defaultDataHandle] modelWithIndex:indexPath.row]];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 120;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    MusicPlayerViewController *player = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"musicPlayer"];
    player.index = indexPath.row;
    
    [self presentViewController:player animated:YES completion:nil];
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
