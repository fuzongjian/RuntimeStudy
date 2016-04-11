//
//  Cat.m
//  FZJDemo
//
//  Created by 陈舒澳 on 16/4/6.
//  Copyright © 2016年 FZJ.com. All rights reserved.
//

#import "Cat.h"
#import <objc/runtime.h>

@implementation Cat
//第一步：实现此方法，在调用对象的某方法找不到时，会先调用此方法，允许
//我们动态添加方法实现
+ (BOOL)resolveInstanceMethod:(SEL)sel{
    if ([NSStringFromSelector(sel) isEqualToString:@"eat"]) {
        class_addMethod(self, sel, (IMP)addEat, "v@:");
        return YES;
    }
    return [super resolveInstanceMethod:sel];
}
//下面的方法是我们动态添加的
void addEat(id self,SEL cmd){
     NSLog(@"%@ is eating",self);
}
@end
