//
//  UINavigationController+TZM.h
//
//  Created by mayer on 2018/5/18.
//  Copyright © 2018年 mayer. All rights reserved.
//


#import <UIKit/UIKit.h>
#import <objc/runtime.h>
#import <YYCategories/YYCategories.h>
#import <Foundation/Foundation.h>

@interface UINavigationController (TZM)
//pop手势
@property (nonatomic, strong, readonly) UIPanGestureRecognizer *tzm_fullScreenPopGestureRecognizer;
//是否开启
@property (nonatomic, assign) BOOL tzm_viewControllerBasedNavigationBarAppearanceEnabled;
@end


@interface UIViewController (TZM_NavigationBar)

@property (nonatomic, assign) BOOL tzm_interactivePopDisabled;

@property (nonatomic, assign) BOOL tzm_prefersNavigationBarHidden;

@property (nonatomic, strong) UIImage *tzm_navigationBackgroundImage;
@property (nonatomic, strong) UIImage *tzm_navigationShadowImage;
@property (nonatomic, strong) UIColor *tzm_navigationTitleTextColor;
@property (nonatomic, strong) UIColor *tzm_navigationTintColor;
@property (nonatomic, strong) UIColor *tzm_navigationBarTintColor;

+(void)tzm_exchangeImplementationsViewWillAppearBlock:(BOOL(^)(UIViewController *vc))block;
@end


/**
 *  拦截系统默认返回按钮事件，有时候需要在点击系统返回按钮，或者手势返回的时候想要拦截事件，比如要判断当前界面编辑的的内容是否要保存，或者返回的时候需要做一些额外的逻辑处理等等。
 *
 */
@protocol UINavigationControllerBackButtonHandlerProtocol <NSObject>

@optional

/// 是否需要拦截系统返回按钮的事件，只有当这里返回YES的时候，才会询问方法：`canPopViewController`
- (BOOL)shouldHoldBackButtonEvent;

/// 是否可以`popViewController`，可以在这个返回里面做一些业务的判断，比如点击返回按钮的时候，如果输入框里面的文本没有满足条件的则可以弹alert并且返回NO
- (BOOL)canPopViewController;

/// 当自定义了`leftBarButtonItem`按钮之后，系统的手势返回就失效了。可以通过`forceEnableInteractivePopGestureRecognizer`来决定要不要把那个手势返回强制加回来。当 interactivePopGestureRecognizer.enabled = NO 或者当前`UINavigationController`堆栈的viewControllers小于2的时候此方法无效。
- (BOOL)forceEnableInteractivePopGestureRecognizer;

@end

/**
 *  @see UINavigationControllerBackButtonHandlerProtocol
 */
@interface UIViewController (TZM_Back) <UINavigationControllerBackButtonHandlerProtocol>
@end
