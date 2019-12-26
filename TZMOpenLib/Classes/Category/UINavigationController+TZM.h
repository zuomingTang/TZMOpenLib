//
//  UINavigationController+TZM.h
//
//  Created by mayer on 2018/5/18.
//  Copyright © 2018年 mayer. All rights reserved.
//


#import <UIKit/UIKit.h>

@interface UINavigationController (TZM)
//pop手势
@property (nonatomic, strong, readonly) UIPanGestureRecognizer *tzm_fullScreenPopGestureRecognizer;
//是否开启每个VC自己控制nav
@property (nonatomic, assign) BOOL tzm_viewControllerBasedNavigationBarAppearanceEnabled;
@end

