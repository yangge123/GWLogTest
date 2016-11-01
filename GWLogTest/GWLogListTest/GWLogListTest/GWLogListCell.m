//
//  GWLogListCell.m
//  Holoera
//
//  Created by yangye on 16/10/31.
//  Copyright © 2016年 gowild. All rights reserved.
//

#import "GWLogListCell.h"
#import "GWCommonTool.h"


@interface GWLogListCell()

@property (nonatomic,weak)UIButton *logTypeBtn;
@property (nonatomic,weak)UILabel *timeLabel;
@property (nonatomic,weak)UILabel *versionLabel;
@property (nonatomic,weak)UILabel *classLabel;
@property (nonatomic,weak)UILabel *msgLabel;

@end

@implementation GWLogListCell

+ (instancetype)createLogListCell:(UITableView *)tableView
{
    static NSString *cellId = @"cellId";
    GWLogListCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[GWLogListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }
    return cell;
}


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        //logType
        UIButton *logTypeBtn = [[UIButton alloc] init];
        logTypeBtn.titleLabel.font = [UIFont systemFontOfSize:12.0f];
        [self.contentView addSubview:logTypeBtn];
        self.logTypeBtn = logTypeBtn;
        
        //time
        UILabel *timeLabel = [[UILabel alloc] init];
        timeLabel.textColor = [UIColor blackColor];
        timeLabel.font = [UIFont systemFontOfSize:14.0];
        [self.contentView addSubview:timeLabel];
        self.timeLabel = timeLabel;
        
        //版本号
        UILabel *versionLabel = [[UILabel alloc] init];
        versionLabel.textColor = [UIColor blackColor];
        versionLabel.font = [UIFont systemFontOfSize:13.0];
        [self.contentView addSubview:versionLabel];
        self.versionLabel = versionLabel;
        
        //class row
        UILabel *classLabel = [[UILabel alloc] init];
        classLabel.textColor = [UIColor blackColor];
        classLabel.font = [UIFont systemFontOfSize:10.0f];
        [self.contentView addSubview:classLabel];
        self.classLabel = classLabel;
        
        //msg
        UILabel *msgLabel = [[UILabel alloc] init];
        msgLabel.textColor = [UIColor blackColor];
        msgLabel.numberOfLines = 0;
        msgLabel.font = [UIFont systemFontOfSize:14.0f];
        [self.contentView addSubview:msgLabel];
        self.msgLabel = msgLabel;
    }
    
    return self;
}

- (void)configCell:(GWLogModel *)logModel
{
    if (logModel.logType == 0) //出现异常
    {
        [self.logTypeBtn setTitle:@"异常" forState:UIControlStateNormal];
        self.logTypeBtn.backgroundColor = [UIColor redColor];
        self.msgLabel.textColor = [UIColor redColor];
    }
    else
    {
        [self.logTypeBtn setTitle:@"普通" forState:UIControlStateNormal];
        self.logTypeBtn.backgroundColor = [UIColor greenColor];
        self.msgLabel.textColor = [UIColor blackColor];
    }
    
    NSDate *logCreatTime = [NSDate dateWithTimeIntervalSince1970:logModel.logCreatTime];
    
    NSString *createTime = [GWCommonTool dateToNSString:logCreatTime format:@"yyyy-MM-dd HH:mm:ss"];
    
    self.timeLabel.text = createTime;
    self.versionLabel.text = [NSString stringWithFormat:@"当前版本号：%@",logModel.softVersion];
    self.classLabel.text = logModel.fileMsg;
    
    self.msgLabel.text = logModel.logMsg;
}

+ (CGFloat)caculateCellH:(GWLogModel *)logModel
{
    CGRect logMsgRect = [logModel.logMsg boundingRectWithSize:CGSizeMake(SCREEN_WIDTH - 50.0, SCREEN_HEIGHT - 40.0) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15.0]} context:NULL];
    
    return logMsgRect.size.height + 40.0 + 20.0;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.logTypeBtn.frame = CGRectMake(5, 12, 30, 30);
    self.logTypeBtn.clipsToBounds = YES;
    self.logTypeBtn.layer.cornerRadius = 15;
    
    self.timeLabel.frame = CGRectMake(40, 10, 140, 16);
    self.versionLabel.frame = CGRectMake(185, 10, self.bounds.size.width - 195, 16);
    self.classLabel.frame = CGRectMake(40, 30, self.bounds.size.width - 50, 12);
    
    self.msgLabel.frame = CGRectMake(40, 45, self.bounds.size.width - 50.0, self.bounds.size.height - 50);
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
