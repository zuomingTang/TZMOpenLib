//
// Created by mayer on 15/3/22.
// Copyright (c) 2015 mayer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "UIView+TZMPageStatusViewEx.h"

// 给视图控制器增加一个状态视图
@interface UIViewController (TZMPageStatusViewEx)

- (TZMPageStatusView *)showPageStatus:(TZMPageStatus)status image:(UIImage*)image title:(NSString*)title desc:(NSString *)desc buttonText:(NSString *)text didClickButtonCallback:(TZMPageStatusViewBlock)callback;

//- (TZMPageStatusView *)showPageStatusLoading;

- (void)dismissPageStatusView;

@end
