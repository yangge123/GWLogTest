//
//  ViewController.m
//  Demo1
//
//  Created by gowild on 16/4/21.
//  Copyright © 2016年 gowild. All rights reserved.
//

#import "ViewController.h"
#import "GWLAlertView.h"

@interface ViewController ()


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.

    //button click
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(60, 100, 80, 40)];
    button.backgroundColor = [UIColor redColor];
    [self.view addSubview:button];
    
    [button addTarget:self action:@selector(btnAction) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *button2 = [[UIButton alloc] initWithFrame:CGRectMake(60, 200, 80, 40)];
    button2.backgroundColor = [UIColor orangeColor];
    [self.view addSubview:button2];
    
    [button2 addTarget:self action:@selector(btn2Action) forControlEvents:UIControlEventTouchUpInside];
}

- (void)btn2Action {
    
    GWLAlertView *alert = [[GWLAlertView alloc] initWithTitle:@"余额不足" contentText:@"请确保机器人有40%以上的电量，点击 “[/pet_ok]” 确认机器人升级开始。"];
    
    alert.contentFont = [UIFont systemFontOfSize:16.0];
    
    
    [alert show];
    
    alert.contentTextrightBlock = ^{
        
    };
}

- (void)btnAction {
    GWLAlertView *alertView = [[GWLAlertView alloc] initWithTitle:@"请输入您要提交的对象" contentArr:@[@"公子小白语言老师",@"程序员",@"硬件工程师",@"产品汪",@"狗尾草草园长"]];
    
    [alertView show];
    
    alertView.contentArrRightBlock = ^(NSArray *selectedIndexArr){
        
        NSLog(@"%@",selectedIndexArr);
    };
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
