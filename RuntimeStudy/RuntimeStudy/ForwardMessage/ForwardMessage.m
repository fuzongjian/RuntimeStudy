//
//  ForwardMessage.m
//  RuntimeStudy
//
//  Created by 陈舒澳 on 16/4/11.
//  Copyright © 2016年 xingbida. All rights reserved.
//

#import "ForwardMessage.h"
#import "Cat.h"
#import "Dog.h"
#import "Pig.h"

@implementation ForwardMessage
+ (void)test{
    
    [[Cat new] eat];
    
    Pig * pig = [Pig new];
    [pig performSelector:@selector(eat) withObject:nil afterDelay:0];
    
    Dog * dog = [Dog new];
    [dog performSelector:@selector(eat) withObject:nil afterDelay:0];
}

@end
