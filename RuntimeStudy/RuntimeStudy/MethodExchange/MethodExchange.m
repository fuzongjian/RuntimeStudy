//
//  MethodExchange.m
//  FZJDemo
//
//  Created by 陈舒澳 on 16/4/6.
//  Copyright © 2016年 FZJ.com. All rights reserved.
//

#import "MethodExchange.h"

@implementation MethodExchange
+(void)test{
    NSMutableArray * array = [NSMutableArray arrayWithObjects:@"fu",@"zong",@"jian", nil];
     NSLog(@"%@",array);
    [array removeObject:@"zong"];
     NSLog(@"%@",array);
    [array addObject:@"zong"];
     NSLog(@"%@",array);
}
@end
