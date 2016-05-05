//
//  ViewController.m
//  Demo
//
//  Created by gowild on 16/5/5.
//  Copyright © 2016年 gowild. All rights reserved.
//

#import "ViewController.h"
#import "DDXML.h"
#import "DDXMLElementAdditions.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    //从工程目录获取XML文件
    NSString *path = [[NSBundle mainBundle] pathForResource:@"users" ofType:@"xml"];
    //获取NSData对象并开始解析
    NSData *xmlData = [NSData dataWithContentsOfFile:path];
    [self parseXML:xmlData];
}

-(void)parseXML:(NSData *) data
{
    //文档开始（KissXML和GDataXML一样也是基于DOM的解析方式）
    DDXMLDocument *xmlDoc = [[DDXMLDocument alloc] initWithData:data options:0 error:nil];
    
    //利用XPath来定位节点（XPath是XML语言中的定位语法，类似于数据库中的SQL功能）
    NSArray *users = [xmlDoc nodesForXPath:@"//cd" error:nil];
    for (DDXMLElement *user in users) {
        NSString *userId = [[user elementForName:@"id"] stringValue];
        NSLog(@"User id:%@",userId);
        
        DDXMLElement *nameEle = [user elementForName:@"name"];
        if (nameEle) {
            NSLog(@"User name:%@",[nameEle stringValue]);
        }
        
        DDXMLElement *ageEle = [user elementForName:@"age"];
        if (ageEle) {
            NSLog(@"User age:%@",[ageEle stringValue]);
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
