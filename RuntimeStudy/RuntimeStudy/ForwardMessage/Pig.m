//
//  Pig.m
//  FZJDemo
//
//  Created by 陈舒澳 on 16/4/6.
//  Copyright © 2016年 FZJ.com. All rights reserved.
//

#import "Pig.h"
#import "Cat.h"
@implementation Pig
//第一步，我们不动态添加方法，返回NO
+ (BOOL)resolveInstanceMethod:(SEL)sel{
    return NO;
}
//第二步，备选提供响应Aseletor的对象，我们不备选，因此设置为nil，就会进入第三步
- (id)forwardingTargetForSelector:(SEL)aSelector{
    return nil;
}
//第三步，先返回方法选择器，如果放回nil，则表示无法处理信息
- (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector{
    if ([NSStringFromSelector(aSelector) isEqualToString:@"eat"] ) {
        return [NSMethodSignature signatureWithObjCTypes:"v@:"];
    }
    return [super methodSignatureForSelector:aSelector];
}
//第四步，第三步只有返回了方法签名，才会进入这一步，这一步用户调用方法
//改变调用对象等
- (void)forwardInvocation:(NSInvocation *)anInvocation{
    //我们改变调用对象为dog
    [anInvocation invokeWithTarget:self];
//    [anInvocation invokeWithTarget:[Cat new]];
//    target可以别的类的对象，但那个类的实现了eat方法
//    - (void)invokeWithTarget:(id)target;
}
- (void)eat{
    NSLog(@"%@ is eating",self);
}
//因为我们没有声明-eat方法，因此不能通过直接调用，但是我们可以通过performSelector来实现，也能通过objc_msgSend函数来实现
@end
