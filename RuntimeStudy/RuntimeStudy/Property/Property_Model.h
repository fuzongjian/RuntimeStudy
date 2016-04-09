//
//  Property_Model.h
//  RuntimeStudy
//
//  Created by 陈舒澳 on 16/4/8.
//  Copyright © 2016年 xingbida. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Property_Model : NSObject
{
    NSArray * _array;
}
@property (nonatomic, copy) NSDictionary * dic;
@property (nonatomic,strong) NSString * name;
@property (nonatomic,assign) float  number;
-(void)modelPlay;
@end
