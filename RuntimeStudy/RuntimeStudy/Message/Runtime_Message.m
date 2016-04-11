//
//  Runtime_Message.m
//  FZJDemo
//
//  Created by 陈舒澳 on 16/4/6.
//  Copyright © 2016年 FZJ.com. All rights reserved.
//

#import "Runtime_Message.h"
#import <objc/runtime.h>
#import <objc/message.h>
#import <UIKit/UIKit.h>
@implementation Runtime_Message
- (void)noArgumentAndNoReturnValue{
     NSLog(@"%s was called,and it has no argument and return value",__FUNCTION__);
}
- (void)hasArguments:(NSString *)arg{
     NSLog(@"%s was called,and argument is %@",__FUNCTION__,arg);
}
- (NSString *)noArgumentButReturnValue{
     NSLog(@"%s was called,and return value is %@",__FUNCTION__,@"不带参数，但是带有返回值");
    return @"不带参数，但是带有返回值";
}
- (NSString *)hasArgument:(NSString *)arg andReturnValue:(int)arg1{
     NSLog(@"%s was called,and argument is %@,return value is %d",__FUNCTION__,arg,arg1);
    return arg;
}
//C函数
int cStyleFunc(id receiver,SEL sel,const void * arg1,const void * arg2){
     NSLog(@"%s was called,arg1 is %@,and arg2 is %@",__FUNCTION__,[NSString stringWithUTF8String:arg1],[NSString stringWithUTF8String:arg2]);
    return 1;
}
- (float)returnFloatType {
    NSLog(@"%s was called, and has return value", __FUNCTION__);
    return 3.121592612321323123;
}

- (CGRect)returnTypeIsStruct {
    NSLog(@"%s was called", __FUNCTION__);
    
    return CGRectMake(0, 0, 10, 10);
}
+(void)test{
    //1、创建对象
    Runtime_Message * message = ((Runtime_Message * (*)(id,SEL))objc_msgSend)((id)[Runtime_Message class],@selector(alloc));
    //2、初始化对象
    message = ((Runtime_Message * (*)(id,SEL))objc_msgSend)((id)message,@selector(init));
    //3、调用无参数无返回值方法
    ((void (*)(id,SEL))objc_msgSend)((id)message,@selector(noArgumentAndNoReturnValue));
    //4、调用带一个参数但无返回值的方法
    ((void (*) (id,SEL,NSString *))objc_msgSend)((id)message,@selector(hasArguments:),@"带一个参数，但无返回值");
    //5、调用带有返回值，但是不带参数
    NSString * returnValue = ((NSString * (*)(id,SEL))objc_msgSend)((id)message,@selector(noArgumentButReturnValue));
     NSLog(@"5.返回值为：%@",returnValue);
    //6、带参数带返回值
    int returnIntValue = ((int (*)(id,SEL,NSString *,int))objc_msgSend)(message,@selector(hasArgument:andReturnValue:),@"参数1",2016);
     NSLog(@"6.return value is %d",returnIntValue);
    //7、动态添加方法，然后调用C函数
    class_addMethod(message.class, NSSelectorFromString(@"cStyleFunc"), (IMP)cStyleFunc, "i@:r^vr^v");
    int retvalue = ((int (*)(id,SEL,const void *,const void *)) objc_msgSend)((id)message,NSSelectorFromString(@"cStyleFunc"),@"参数一",@"参数二");
     NSLog(@"7. return value is %d",retvalue);
    // 8.返回浮点型时，调用objc_msgSend/objc_msgSend_fpret,其结果是一样的。
    // float retFloatValue = ((float (*)(id, SEL))objc_msgSend_fpret)((id)msg, @selector(returnFloatType));
    //  NSLog(@"%f", retFloatValue);
    
    //   retFloatValue = ((float (*)(id, SEL))objc_msgSend)((id)msg, @selector(returnFloatType));
    //  NSLog(@"%f", retFloatValue);
    
    // 9.返回结构体时，不能使用objc_msgSend，而是要使用objc_msgSend_stret，否则会crash
    //  CGRect frame = ((CGRect (*)(id, SEL))objc_msgSend_stret)((id)msg, @selector(returnTypeIsStruct));
    //  NSLog(@"9. return value is %@", NSStringFromCGRect(frame));
}
@end
