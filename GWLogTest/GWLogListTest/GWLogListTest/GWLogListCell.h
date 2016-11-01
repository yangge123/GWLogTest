//
//  GWLogListCell.h
//  Holoera
//
//  Created by yangye on 16/10/31.
//  Copyright © 2016年 gowild. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GWLogModel.h"

@interface GWLogListCell : UITableViewCell


+ (instancetype)createLogListCell:(UITableView *)tableView;

- (void)configCell:(GWLogModel *)logModel;


+ (CGFloat)caculateCellH:(GWLogModel *)logModel;

@end
