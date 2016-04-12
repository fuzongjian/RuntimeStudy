//
//  UIButton+Click.m
//  RuntimeStudy
//
//  Created by  on 16/4/8.
//  Copyright © 2016年 xingbida. All rights reserved.
//

#import "UIButton+Click.h"
#import <objc/runtime.h>
#pragma mark --- 动态添加属性
static const void * TouchUpInSideBlockKey = @"TouchUpInSideBlockKey";
static const void *  Indentifier = @"indentifier";
@implementation UIButton (Click)
- (void)setClickAction:(void (^)(UIButton *))clickAction{
//    object：与谁关联，通常传self
//    key：唯一键，在获取值时通过该键获取，通常使用static const void * 来声明
//    value：关联所设置的值
//    policy：内存管理策略，比如使用copy
//        OBJC_ASSOCIATION_ASSIGN = 0,  表示弱引用关联，通常是基本数据类型，如int、float
//
//        OBJC_ASSOCIATION_RETAIN_NONATOMIC = 1, 表示强（strong）引用关联
//
//        OBJC_ASSOCIATION_COPY_NONATOMIC = 3,表示关联对象copy
//
//        OBJC_ASSOCIATION_RETAIN = 01401,  表示强（strong）引用关联对象，线程安全
//
//        OBJC_ASSOCIATION_COPY = 01403  表示关联对象copy 线程安全
//    OBJC_EXPORT void objc_setAssociatedObject(id object, const void *key, id value, objc_AssociationPolicy policy);

    objc_setAssociatedObject(self, TouchUpInSideBlockKey, clickAction, OBJC_ASSOCIATION_COPY);
    if (clickAction) {
        [self addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
}
-(void (^)(UIButton *))clickAction{
    return objc_getAssociatedObject(self, TouchUpInSideBlockKey);
}
- (void)buttonClicked:(UIButton *)sender{
    if (self.clickAction) {
        self.clickAction(sender);
    }
}
-(void)setIndentifier:(NSString *)indentifier{
    objc_setAssociatedObject(self, Indentifier, indentifier, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
-(NSString *)indentifier{
    return objc_getAssociatedObject(self, Indentifier);
}
@end
