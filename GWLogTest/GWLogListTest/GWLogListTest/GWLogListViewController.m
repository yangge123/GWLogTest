//
//  GWLogListView.m
//  Holoera
//
//  Created by yangye on 16/10/29.
//  Copyright © 2016年 gowild. All rights reserved.
//

#import "GWLogListViewController.h"
#import "GWLogListManager.h"
#import "GWLogListCell.h"

@interface GWLogListViewController()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,weak) UILabel *textLabel;

@property (nonatomic,strong)UITableView *tableView;

@property (nonatomic,strong)NSMutableArray<GWLogModel *> *dataArrM;

@end

@implementation GWLogListViewController

- (NSMutableArray<GWLogModel *> *)dataArrM {
    if (!_dataArrM) {
        _dataArrM = [NSMutableArray<GWLogModel *> array];
    }
    return _dataArrM;
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height) style:UITableViewStyleGrouped];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
        [_tableView addGestureRecognizer:tap];
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    return _tableView;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:self.tableView];
}

- (void)tapAction:(UITapGestureRecognizer *)tap {
    [self dismissViewControllerAnimated:YES completion:NULL];
}

#pragma mark UITableViewDelegate,UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArrM.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    GWLogListCell *cell = [GWLogListCell createLogListCell:tableView];
    
    [cell configCell:self.dataArrM[indexPath.row]];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [GWLogListCell caculateCellH:self.dataArrM[indexPath.row]];
}

- (void)getLogMessage
{
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        // 处理耗时操作的代码块...
        NSArray<GWLogModel *> * logsArr = [[GWLogListManager shareInstance] queryLogs];
        //通知主线程刷新
        dispatch_async(dispatch_get_main_queue(), ^{
            //回调或者说是通知主线程刷新，
            [self.dataArrM removeAllObjects];
            [self.dataArrM addObjectsFromArray:logsArr];
            [self.tableView reloadData];
        });
    });
}

@end
