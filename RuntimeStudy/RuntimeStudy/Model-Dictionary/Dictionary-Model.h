//
//  Dictionary-Model.h
//  RuntimeStudy
//
//  Created by 陈舒澳 on 16/4/12.
//  Copyright © 2016年 xingbida. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <objc/runtime.h>
#import <objc/message.h>
@interface Dictionary_Model : NSObject
@property (nonatomic, copy) NSString * name;
@property (nonatomic, copy) NSString * title;
@property (nonatomic,strong) NSNumber * count;
@property (nonatomic,assign) int  commentCount;
@property (nonatomic,strong) NSArray * summaries;
@property (nonatomic,strong) NSDictionary * parameters;
@property (nonatomic,strong) NSSet * result;
@property (nonatomic,strong) Dictionary_Model * model;
@property (nonatomic,assign,readonly) NSString  * classVersion;
//字典转模型
- (instancetype)initWithDictionary:(NSDictionary *)dictionary;
- (NSDictionary *)toDictionary;
+ (void)test;
@end
