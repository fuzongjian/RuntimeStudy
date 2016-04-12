//
//  Dictionary-Model.m
//  RuntimeStudy
//
//  Created by 陈舒澳 on 16/4/12.
//  Copyright © 2016年 xingbida. All rights reserved.
//

#import "Dictionary-Model.h"

@implementation Dictionary_Model
#pragma mark --- 将字典转成模型
- (instancetype)initWithDictionary:(NSDictionary *)dictionary{
    if (self = [super init]) {
        for (NSString * key in dictionary.allKeys) {
            id value = [dictionary objectForKey:key];
            
            if ([key isEqualToString:@"model"]) {
                Dictionary_Model * model = [[Dictionary_Model alloc] initWithDictionary:value];
                value = model;
                self.model = model;
                continue;
            }
            SEL setter = [self propertySetterWithKey:key];
            if (setter != nil) {
                //这个函数可以有很多歌参数，必须手动转换成对应类型参数
                // 下面一行代码是将对应的值赋值给对应的属性
                //(void (*)(id,SEL,id) C语言的函数指针
                ((void (*)(id,SEL,id))objc_msgSend)(self,setter,value);
            }
        }
    }
    return self;
}
- (NSDictionary *)toDictionary{
    unsigned int outCount = 0;
    objc_property_t * properties = class_copyPropertyList([self class], &outCount);
    if (outCount != 0) {
        NSMutableDictionary * dict = [[NSMutableDictionary alloc] initWithCapacity:outCount];
        for (unsigned int i = 0; i < outCount; i ++) {
            objc_property_t property = properties[i];
            const void * propertyName = property_getName(property);
            NSString * key = [NSString stringWithUTF8String:propertyName];
            //继承于NSObject的类都会有这几个在NSObject中的属性需要过滤掉
            if ([key isEqualToString:@"description"] || [key isEqualToString:@"debugDescription"] || [key isEqualToString:@"hash"] || [key isEqualToString:@"superclass"]) {
                continue;
            }
            if ([key isEqualToString:@"model"]) {
                if ([self respondsToSelector:@selector(toDictionary)]) {
                    id model = [self.model toDictionary];
                    if (model != nil) {
                        [dict setObject:model forKey:key];
                    }
                    continue;
                }
            }
            SEL getter = [self propertyGetterWithKey:key];
            if (getter != nil) {
                //获取方法的签名
                NSMethodSignature * signature = [self methodSignatureForSelector:getter];
                //根据方法签名获取NSInvocation对象
                NSInvocation * invocation = [NSInvocation invocationWithMethodSignature:signature];
                //设置target
                [invocation setTarget:self];
                //设置selector
                [invocation setSelector:getter];
                //方法调用
                [invocation invoke];
                //接受返回的值
                __unsafe_unretained NSObject * propertyValue = nil;
                [invocation getReturnValue:&propertyValue];
                if (propertyValue == nil) {
                    if ([self respondsToSelector:@selector(defaultValueForEmptyProperty)]) {
                        NSDictionary * defaultValueDict = [self defaultValueForEmptyProperty];
                        id defaultValue = [defaultValueDict objectForKey:key];
                        propertyValue = defaultValue;
                    }
                }
                if (propertyValue != nil) {
                    [dict setObject:propertyValue forKey:key];
                }
            }
        }
        free(properties);
        return dict;
    }
    free(properties);
    return nil;
}
#pragma mark --- 生成setter方法
- (SEL)propertySetterWithKey:(NSString *)key{
    //capitalizedString 返回每个单词的首字母大写，其余字母小写
    NSString * propertySetter = key.capitalizedString;
    propertySetter = [NSString stringWithFormat:@"set%@:",propertySetter];
    //生成setter方法
    SEL setter = NSSelectorFromString(propertySetter);
    if ([self respondsToSelector:setter]) {
        return setter;
    }
    return nil;
}
#pragma mark --- 生成getter方法
- (SEL)propertyGetterWithKey:(NSString *)key{
    if (key != nil) {
        SEL getter = NSSelectorFromString(key);
        if ([self respondsToSelector:getter]) {
            return getter;
        }
    }
    return nil;
}
- (NSDictionary *)defaultValueForEmptyProperty {
    return @{@"name" : [NSNull null],
             @"title" : [NSNull null],
             @"count" : @(1),
             @"commentCount" : @(1),
             @"classVersion" : @"1.2.1"};
}
+ (void)test{
    NSMutableSet *set = [NSMutableSet setWithArray:@[@"可变集合", @"字典->不可变集合->可变集合"]];
    NSDictionary *dict = @{@"name"  : @"好好学习",
                           @"title" : @"天天向上",
                           @"count" : @(11),
                           @"results" : [NSSet setWithObjects:@"我是集合值1", @"我也是集合值2", set , nil],
                           @"summaries" : @[@"sm1", @"sm2", @{@"keysm": @{@"stkey": @"字典->数组->字典->字典"}}],
                           @"parameters" : @{@"key1" : @"value1", @"key2": @{@"key11" : @"value11", @"key12" : @[@"三层", @"字典->字典->数组"]}},
                           @"classVersion" : @(1.1),
                           @"testModel" : @{@"name"  : @"好好学习",
                                            @"title" : @"天天向上",
                                            @"count" : @(11),
                                            @"results" : [NSSet setWithObjects:@"集合值1", @"集合值2", set , nil],
                                            @"summaries" : @[@"sm1", @"sm2", @{@"keysm": @{@"stkey": @"字典->数组->字典->字典"}}],
                                            @"parameters" : @{@"key1" : @"value1", @"key2": @{@"key11" : @"value11", @"key12" : @[@"三层", @"字典->字典->数组"]}},
                                            @"classVersion" : @(1.1)}};
    Dictionary_Model *model = [[Dictionary_Model alloc] initWithDictionary:dict];
    
    NSLog(@"%@", model);
    
    NSLog(@"model->dict: %@", [model toDictionary]);
    
    
}
@end
