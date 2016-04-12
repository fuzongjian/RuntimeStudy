//
//  NSObject+swizzling.h
//  RuntimeStudy
//
//  Created by 陈舒澳 on 16/4/11.
//  Copyright © 2016年 xingbida. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (swizzling)
+ (void)swizzleSelector:(SEL)originalSelector withSwizzledSelector:(SEL)swizzledSeletor;
@end
