//
//  Property.m
//  RuntimeStudy
//
//  Created by 陈舒澳 on 16/4/8.
//  Copyright © 2016年 xingbida. All rights reserved.
//

#import "Property.h"
#import <objc/runtime.h>
#import <objc/message.h>
#import "Property_Model.h"
@implementation Property
+ (void)test{
//    [self runtime_private_Property];
    [self runtime_property];
}
#pragma mark --- 快速归档
/*
 原理：用runtime提供的函数遍历Model自身所有的属性，并对属性进行encode和decode操作
 核心方法：在Property_Model的基类中重写下面方法
 -(id)initWithCoder:(NSCoder *)aDecoder
 -(id)encodeWithCoder:(NSCoder *)aCoder
 */
#pragma mark --- json到Model的转化
/*
     我们知道字典转模型的方法，但并不明白其中真正的方法实现，我们需要知其然也要知其所以然
     原理：用runtime提供的函数遍历Model自身所有属性，如果属性在json中有对应的值，则将其赋值
     核心方法：在NSObject的分类中添加下面方法
     -(instancetype)initWithDict:(NSDictionary *)dic;(转到Property_Model类中写)
     用runtime去解析json来给Model赋值
 */
#pragma mark --- 获取成员变量（成员变量）
/*
 一、 Ivar：实例变量类型，是一个指向objc_ivar结构体的指针,可以获取成员变量（包括私有成员变量）、属性
 typedef struct objc_ivar *Ivar;
 二、  操作函数
 class_copyIvarList          获取所有成员变量
 ivar_getName                获取成员变量名
 ivar_getTypeEncoding        获取成员变量类型编码
 class_getInstanceVarialbe   获取指定名称的成员变量
 object_getIvar              获取某个对象成员变量的值
 object_setIvar              设置某个对象成员变量的值
 */
+ (void)runtime_Ivars{
    unsigned int outCount = 0;
    Ivar * ivars = class_copyIvarList([Property_Model class], &outCount);
    for (unsigned int i = 0; i < outCount; i ++) {
        Ivar ivar = ivars[i];
        const char * name = ivar_getName(ivar);
        const char * type = ivar_getTypeEncoding(ivar);
        NSLog(@"类型为%s的%s",type,name);
    }
    free(ivars);
}

#pragma mark --- 访问私有变量
+ (void)runtime_private_Property{
    
/**
       我们知道，OC中没有真正意义上的私有变量和方法，要让成员变量私有，要放在m文件中声明，不对外暴露。如果我们知道这个成员变量的名称，可以通过runtime获取成员变量，再通过getIvar来获取它的值

 */
    
    Ivar ivar = class_getInstanceVariable([Property_Model class], "str_private");
    Property_Model * model = [[Property_Model alloc] init];
    [model modelPlay];
     NSLog(@"%@",object_getIvar(model, ivar));
    
}
#pragma mark --- 获取所有属性
/*
 一、objc_property_t:声明属性的类型，是一个指向objc_property结构体的指针,只能获取所有的属性，并不能获取成员变量
 typedef struct objc_property *objc_porperty_t;
 二、操作函数
 class_copyPropertyList      获取所有属性（并不会获取无@property声明的成员变量）
 property_getName            获取属性名
 property_copyAttributeList  获取所有属性特性
 property_getAttributes      获取属性特性描述字符串
 （返回的是objc_property_attribute_t结构体列表，objc_property_attribute_t结构体包含name和value，常用属性如下：
 属性类型   name值：T  value：变化
 编码类型   name值：C(copy) &(strong) W(weak) 空(assign)等  value：无
 非/原子性  name值：空（atomic）  N（nonatomic）             value：无
 变量名称   name值：V   value:变化
 ）
 */
+ (void)runtime_property{
    unsigned int outCount = 0;
    //获取所有属性
    objc_property_t * properties = class_copyPropertyList([Property_Model class], &outCount);
    for (unsigned int i = 0; i < outCount; i ++) {
        objc_property_t property = properties[i];
        //属性名
        const char * name = property_getName(property);
        //属性的描述
        const char * propertyAttr = property_getAttributes(property);
         NSLog(@"属性描述为%s的%s",propertyAttr,name);
        //属性的特性
        unsigned int attrCount = 0;
        objc_property_attribute_t * attrs = property_copyAttributeList(property, &attrCount);
        for (unsigned int i = 0;  i < attrCount; i ++) {
            objc_property_attribute_t attr = attrs[i];
            const char * name = attr.name;
            const char * value = attr.value;
             NSLog(@"属性的描述%s值%s",name,value);
        }
        free(attrs);
    }
    free(properties);
}
@end
