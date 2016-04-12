//
//  Property_Model.m
//  RuntimeStudy
//
//  Created by 陈舒澳 on 16/4/8.
//  Copyright © 2016年 xingbida. All rights reserved.
//

#import "Property_Model.h"
#import <objc/runtime.h>
@interface Property_Model ()
{
    @private
    NSString * str_private;
}
@end
@implementation Property_Model
-(void)modelPlay{
     NSLog(@"modelPlay");
    str_private = @"private";
}
-(instancetype)initWithDict:(NSDictionary *)dic{
    if (self = [self init]) {
        NSMutableArray * keys = [NSMutableArray array];
        NSMutableArray * attributes = [NSMutableArray array];
        unsigned int outCount;
        objc_property_t * properties = class_copyPropertyList([self class], &outCount);
        for (int i = 0 ; i < outCount; i ++) {
            objc_property_t property = properties[i];
            //通过property_getName函数获得属性的名字
            NSString * propertyName = [NSString stringWithCString:property_getName(property) encoding:NSUTF8StringEncoding];
            [keys addObject:propertyName];
            //通过property_getAttributes函数可以获得属性的名字和@encode编码
            NSString * propertyAttribute = [NSString stringWithCString:property_getAttributes(property) encoding:NSUTF8StringEncoding];
            [attributes addObject:propertyAttribute];
        }
        free(properties);//立即释放properties指向的内存
        for (NSString * key in keys) {
            if ([dic valueForKey:key] == nil) continue;
            [self setValue:[dic objectForKey:key] forKey:key];
        }
    }
    return self;
}
-(id)initWithCoder:(NSCoder *)aDecoder{
    if (self = [super init]) {
        unsigned int outCount;
        Ivar * ivars = class_copyIvarList([self class], &outCount);
        for (int i = 0; i < outCount; i ++) {
            Ivar ivar = ivars[i];
            NSString * key = [NSString stringWithUTF8String:ivar_getName(ivar)];
            [self setValue:[aDecoder decodeObjectForKey:key] forKey:key];
        }
    }
    return self;
}
-(id)encodeWithCoder:(NSCoder *)aCoder{
    unsigned int outCount;
    Ivar * ivars = class_copyIvarList([self class], &outCount);
    for (int i = 0; i < outCount; i ++) {
        Ivar ivar = ivars[i];
        NSString * key = [NSString stringWithUTF8String:ivar_getName(ivar)];
        [aCoder encodeObject:[self valueForKey:key] forKey:key];
    }
    return self;
}
@end
