//
//  ViewController.m
//  RuntimeStudy
//
//  Created by 陈舒澳 on 16/4/8.
//  Copyright © 2016年 xingbida. All rights reserved.
//

#import "ViewController.h"
#import "UIButton+Click.h"
#import "Property.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self runtime_property];
    
}
- (void)runtime_property{
    
    [Property test];
    
    UIButton * button = [UIButton buttonWithType:UIButtonTypeSystem];
    button.indentifier = @"fuzongjian";
//    [button addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    button.frame = CGRectMake(10, 10, 100, 50);
    [self.view addSubview:button]; 
    [button setTitle:@"点我" forState:UIControlStateNormal];
    button.clickAction = ^(UIButton * sender){
         NSLog(@"%@",sender.indentifier);
    };
//    [button setClickAction:^(UIButton * sender) {
//         NSLog(@"%@",sender.indentifier);
//    }];
}
- (void)buttonClicked:(UIButton *)sender{
     NSLog(@"%@",sender.indentifier);
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
