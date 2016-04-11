//
//  NSMutableArray+Swizzling.m
//  FZJDemo
//
//  Created by 陈舒澳 on 16/4/6.
//  Copyright © 2016年 FZJ.com. All rights reserved.
//

#import "NSMutableArray+Swizzling.h"
#import <objc/runtime.h>
#import "NSObject+Swizzling.h"
@implementation NSMutableArray (Swizzling)
//方法在+load方法中实现，因为+load方法可以保证在类最开始加载时会调用。
+ (void)load{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [self swizzleSelector:@selector(removeObject:) withSwizzledSelector:@selector(runtime_removeObject:)];
        [self swizzleSelector:@selector(addObject:) withSwizzledSelector:@selector(runtime_addObject:)];
    });
}
- (void)runtime_removeObject:(id)obj{
    if (obj == nil) {
        return;
    }
    //自己调用自己，因为我们交换了方法的实现，系统在调用removeObject：方法是runtime_removeObject：方法的实现，而手动调用runtime_removeObject：方法时，会调用removeObject：方法实现
    [self runtime_removeObject:obj];
}
- (void)runtime_addObject:(id)obj{
    if (obj == nil) {
        return;
    }
    [self runtime_removeObject:obj];
}
@end
