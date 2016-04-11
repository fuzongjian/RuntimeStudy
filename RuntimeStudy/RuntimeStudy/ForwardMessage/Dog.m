//
//  Dog.m
//  FZJDemo
//
//  Created by 陈舒澳 on 16/4/6.
//  Copyright © 2016年 FZJ.com. All rights reserved.
//

#import "Dog.h"

@implementation Dog
//1、在没有找到方法是，会先调用此方法，可用于动态添加方法
//不需要动态添加
+ (BOOL)resolveInstanceMethod:(SEL)sel{
    return NO;
}
//2、上一步返回NO，就会进入这一步，用于指定备选响应次SEL的对象
//千万不能返回self，否则会进入死循环
//因为自己没有实现这个方法才会进入这一流程，因此成为死循环
- (id)forwardingTargetForSelector:(SEL)aSelector{
    return nil;
}
//3、指定方法签名，若返回nil，则不会进入下一步，而是无法处理消息
- (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector{
    if ([NSStringFromSelector(aSelector) isEqualToString:@"eat"]) {
        return [NSMethodSignature signatureWithObjCTypes:"v@:"];
    }
    return [super methodSignatureForSelector:aSelector];
}
//当我们实现了此方法，-doesNotRecognizeSelector:不会再被调用
//如果要测试找不到方法，可以注释到这一个方法
- (void)forwardInvocation:(NSInvocation *)anInvocation{
    //我们还可以改变方法选择器
    [anInvocation setSelector:@selector(jump)];
    //改变方法选择器后，还需要指定是哪一个对象的方法
    [anInvocation invokeWithTarget:self];
}
// 注意：两个方法只能实现一个
//- (void)eat{
//    NSLog(@"eat");
//}
- (void)jump{
    NSLog(@"方法改变");
}
@end
