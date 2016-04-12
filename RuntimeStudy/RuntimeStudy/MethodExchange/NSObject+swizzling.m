//
//  NSObject+swizzling.m
//  RuntimeStudy
//
//  Created by 陈舒澳 on 16/4/11.
//  Copyright © 2016年 xingbida. All rights reserved.
//

#import "NSObject+swizzling.h"
#import <objc/runtime.h>
@implementation NSObject (swizzling)
+ (void)swizzleSelector:(SEL)originalSelector withSwizzledSelector:(SEL)swizzledSeletor{
    Class class = [self class];
    
    Method originalMethod = class_getInstanceMethod(class, originalSelector);
    Method swizzleMethod = class_getInstanceMethod(class, swizzledSeletor);
    
    //若已经存在，则添加失败
    BOOL didAddMethod = class_addMethod(class, originalSelector, method_getImplementation(swizzleMethod), method_getTypeEncoding(swizzleMethod));
    //若原来的方法并不存在，则添加即可
    if (didAddMethod) {
        class_replaceMethod(class, swizzledSeletor, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod));
    }else{
        method_exchangeImplementations(originalMethod, swizzleMethod);
    }
}
@end
