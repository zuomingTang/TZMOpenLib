//
// Created by mayer on 15/8/3.
// Copyright (c) 2015 mayer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "TZMPageStatusView.h"


@interface UIView (TZMPageStatusViewEx)

- (TZMPageStatusView *)showPageStatus:(TZMPageStatus)status image:(UIImage*)image title:(NSString*)title desc:(NSString *)desc buttonText:(NSString *)text didClickButtonCallback:(TZMPageStatusViewBlock)callback;

//- (TZMPageStatusView *)showPageStatusLoading;
- (void)dismissPageStatusView;
@end
