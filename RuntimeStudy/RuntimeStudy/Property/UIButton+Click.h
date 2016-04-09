//
//  UIButton+Click.h
//  RuntimeStudy
//
//  Created by  on 16/4/8.
//  Copyright © 2016年 xingbida. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface UIButton (Click)
@property (nonatomic, copy) void(^clickAction)(void);
@property (nonatomic,strong) NSString * indentifier;
@end
