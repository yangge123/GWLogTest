//
//  ViewController.m
//  GWLog
//
//  Created by gowild on 16/11/1.
//  Copyright © 2016年 gowild. All rights reserved.
//

#import "ViewController.h"
#import "GWCommon.h"
#import <GWLogListTest/GWLogListTest.h>

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    
    UIButton *settingBut = [UIButton buttonWithType:UIButtonTypeCustom];
    [settingBut setTitle:@"log记录" forState:UIControlStateNormal];
    [settingBut setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [settingBut setFrame:CGRectMake(100, 200, 100, 100)];
    [settingBut addTarget:self
                   action:@selector(popLogControlloer)
         forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:settingBut];
    
    
    DDLog(@"%@,%@",@"viewDidLoad",@"loading the view");
/*
    NSArray *arr = @[@"2"];
    //出现异常，记录到日志
    DDLog(@"%@",arr[2]);*/
}

- (void)popLogControlloer
{
    [[GWLogListManager shareInstance] popOrDismissConfigWithViewController:self];

}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
