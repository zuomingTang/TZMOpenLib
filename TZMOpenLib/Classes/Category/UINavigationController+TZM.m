//
//  UINavigationController+TZM.m
//
//  Created by mayer on 2018/5/18.
//  Copyright © 2018年 mayer. All rights reserved.
//

#import "UINavigationController+TZM.h"

@interface _TZMFullScreenPopGestureRecognizerDelegate : NSObject <UIGestureRecognizerDelegate>

@property (nonatomic, weak) UINavigationController *navigationController;

@end

@implementation _TZMFullScreenPopGestureRecognizerDelegate

- (BOOL)gestureRecognizerShouldBegin:(UIPanGestureRecognizer *)gestureRecognizer{
    // Ignore when no view controller is pushed into the navigation stack.
    if (self.navigationController.viewControllers.count <= 1) {
        return NO;
    }
    
    // Disable when the active view controller doesn't allow interactive pop.
    UIViewController *topViewController = self.navigationController.viewControllers.lastObject;
    if (topViewController.tzm_interactivePopDisabled) {
        return NO;
    }

    // Ignore pan gesture when the navigation controller is currently in transition.
    if ([[self.navigationController valueForKey:@"_isTransitioning"] boolValue]) {
        return NO;
    }
    
    // Prevent calling the handler when the gesture begins in an opposite direction.
    CGPoint translation = [gestureRecognizer translationInView:gestureRecognizer.view];
    if (translation.x <= 0) {
        return NO;
    }
    return YES;
}

@end

typedef void (^_TZMViewControllerWillAppearInjectBlock)(UIViewController *viewController, BOOL animated);

@interface UIViewController (_TZM_NavigationBar)

@property (nonatomic, copy) _TZMViewControllerWillAppearInjectBlock tzm_willAppearInjectBlock;

@end

@implementation UIViewController (_TZM_NavigationBar)

+ (void)load{
    Method originalMethod = class_getInstanceMethod(self, @selector(viewWillAppear:));
    Method swizzledMethod = class_getInstanceMethod(self, @selector(tzm_viewWillAppear:));
    method_exchangeImplementations(originalMethod, swizzledMethod);
}

- (void)tzm_viewWillAppear:(BOOL)animated
{
    // Forward to primary implementation.
    [self tzm_viewWillAppear:animated];
    if ([self.className rangeOfString:@"GSH"].location == NSNotFound) {
        //如果是系统的照相界面则不做处理
        return;
    }
    if (self.tzm_prefersNavigationBarHidden == self.navigationController.navigationBarHidden) {
        return ;
    }
    if (self.tzm_willAppearInjectBlock) {
        self.tzm_willAppearInjectBlock(self, animated);
    }
    __weak typeof(self)weakSelf = self;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(CGFLOAT_MIN * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (weakSelf.tzm_prefersNavigationBarHidden) {
            [weakSelf.navigationController setNavigationBarHidden:YES];
        } else {
            [weakSelf.navigationController setNavigationBarHidden:NO];
        }
    });
}

- (_TZMViewControllerWillAppearInjectBlock)tzm_willAppearInjectBlock{
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setTzm_willAppearInjectBlock:(_TZMViewControllerWillAppearInjectBlock)block{
    objc_setAssociatedObject(self, @selector(tzm_willAppearInjectBlock), block, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

@end

@implementation UINavigationController (TZM)

+ (void)load{
    // Inject "-pushViewController:animated:"
    Method originalMethod = class_getInstanceMethod(self, @selector(pushViewController:animated:));
    Method swizzledMethod = class_getInstanceMethod(self, @selector(tzm_pushViewController:animated:));
    method_exchangeImplementations(originalMethod, swizzledMethod);

    Method originalMethodSet = class_getInstanceMethod(self, @selector(setViewControllers:animated:));
    Method swizzledMethodSet = class_getInstanceMethod(self, @selector(tzm_setViewControllers:animated:));
    method_exchangeImplementations(originalMethodSet, swizzledMethodSet);
}

-(void)tzm_setViewControllers:(NSArray<UIViewController *> *)viewControllers animated:(BOOL)animated{
    if (![self.interactivePopGestureRecognizer.view.gestureRecognizers containsObject:self.tzm_fullScreenPopGestureRecognizer]){
        
        // Add our own gesture recognizer to where the onboard screen edge pan gesture recognizer is attached to.
        [self.interactivePopGestureRecognizer.view addGestureRecognizer:self.tzm_fullScreenPopGestureRecognizer];
        
        // Forward the gesture events to the private handler of the onboard gesture recognizer.
        NSArray *internalTargets = [self.interactivePopGestureRecognizer valueForKey:@"targets"];
        id internalTarget = [internalTargets.firstObject valueForKey:@"target"];
        SEL internalAction = NSSelectorFromString(@"handleNavigationTransition:");
        self.tzm_fullScreenPopGestureRecognizer.delegate = self.tzm_popGestureRecognizerDelegate;
        [self.tzm_fullScreenPopGestureRecognizer addTarget:internalTarget action:internalAction];
        
        // Disable the onboard gesture recognizer.
        self.interactivePopGestureRecognizer.enabled = NO;
    }
    
    if (self.tzm_viewControllerBasedNavigationBarAppearanceEnabled) {
        __weak typeof(self) weakSelf = self;
        _TZMViewControllerWillAppearInjectBlock block = ^(UIViewController *viewController, BOOL animated) {
            __strong typeof(weakSelf) strongSelf = weakSelf;
            if (strongSelf) {
                [strongSelf setNavigationBarHidden:viewController.tzm_prefersNavigationBarHidden animated:animated];
                
                if (viewController.tzm_navigationBackgroundImage) {
                    [strongSelf.navigationBar setBackgroundImage:viewController.tzm_navigationBackgroundImage forBarMetrics:UIBarMetricsDefault];
                }else{
                    [strongSelf.navigationBar setBackgroundImage:[[UINavigationBar appearance] backgroundImageForBarMetrics:UIBarMetricsDefault] forBarMetrics:UIBarMetricsDefault];
                }
                
                if (viewController.tzm_navigationShadowImage) {
                    [strongSelf.navigationBar setShadowImage:viewController.tzm_navigationShadowImage];
                }else{
                    [strongSelf.navigationBar setShadowImage:[UINavigationBar appearance].shadowImage];
                }
                
                if (viewController.tzm_navigationTintColor) {
                    [strongSelf.navigationBar setTintColor:viewController.tzm_navigationTintColor];
                }else{
                    [strongSelf.navigationBar setTintColor:[UINavigationBar appearance].tintColor];
                }
                
                if (viewController.tzm_navigationBarTintColor) {
                    strongSelf.navigationBar.barTintColor = viewController.tzm_navigationBarTintColor;
                }else{
                    strongSelf.navigationBar.barTintColor = [UINavigationBar appearance].barTintColor;
                }
                
                if (viewController.tzm_navigationTitleTextColor) {
                    [strongSelf.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:viewController.tzm_navigationTitleTextColor}];
                }else{
                    [strongSelf.navigationBar setTitleTextAttributes:[UINavigationBar appearance].titleTextAttributes];
                }
            }
        };
        
        for (UIViewController *VC in viewControllers) {
            if (VC && !VC.tzm_willAppearInjectBlock) {
                VC.tzm_willAppearInjectBlock = block;
            }
        }
    }
    
    // Forward to primary implementation.
    [self tzm_setViewControllers:viewControllers animated:animated];
}

- (void)tzm_pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if (![self.interactivePopGestureRecognizer.view.gestureRecognizers containsObject:self.tzm_fullScreenPopGestureRecognizer]) {
        
        // Add our own gesture recognizer to where the onboard screen edge pan gesture recognizer is attached to.
        [self.interactivePopGestureRecognizer.view addGestureRecognizer:self.tzm_fullScreenPopGestureRecognizer];

        // Forward the gesture events to the private handler of the onboard gesture recognizer.
        NSArray *internalTargets = [self.interactivePopGestureRecognizer valueForKey:@"targets"];
        id internalTarget = [internalTargets.firstObject valueForKey:@"target"];
        SEL internalAction = NSSelectorFromString(@"handleNavigationTransition:");
        self.tzm_fullScreenPopGestureRecognizer.delegate = self.tzm_popGestureRecognizerDelegate;
        [self.tzm_fullScreenPopGestureRecognizer addTarget:internalTarget action:internalAction];

        // Disable the onboard gesture recognizer.
        self.interactivePopGestureRecognizer.enabled = NO;
    }
    
    // Handle perferred navigation bar appearance.
    [self tzm_setupViewControllerBasedNavigationBarAppearanceIfNeeded:viewController];
    
    // Forward to primary implementation.
    [self tzm_pushViewController:viewController animated:animated];
}

- (void)tzm_setupViewControllerBasedNavigationBarAppearanceIfNeeded:(UIViewController *)appearingViewController
{
    if (!self.tzm_viewControllerBasedNavigationBarAppearanceEnabled) {
        return;
    }
    
    __weak typeof(self) weakSelf = self;
    _TZMViewControllerWillAppearInjectBlock block = ^(UIViewController *viewController, BOOL animated) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        if (strongSelf) {
            [strongSelf setNavigationBarHidden:viewController.tzm_prefersNavigationBarHidden animated:animated];
            
            if (viewController.tzm_navigationBackgroundImage) {
                [strongSelf.navigationBar setBackgroundImage:viewController.tzm_navigationBackgroundImage forBarMetrics:UIBarMetricsDefault];
            }else{
                [strongSelf.navigationBar setBackgroundImage:[[UINavigationBar appearance] backgroundImageForBarMetrics:UIBarMetricsDefault] forBarMetrics:UIBarMetricsDefault];
            }
            
            if (viewController.tzm_navigationShadowImage) {
                [strongSelf.navigationBar setShadowImage:viewController.tzm_navigationShadowImage];
            }else{
                [strongSelf.navigationBar setShadowImage:[UINavigationBar appearance].shadowImage];
            }
            
            if (viewController.tzm_navigationTintColor) {
                [strongSelf.navigationBar setTintColor:viewController.tzm_navigationTintColor];
            }else{
                [strongSelf.navigationBar setTintColor:[UINavigationBar appearance].tintColor];
            }
            
            if (viewController.tzm_navigationBarTintColor) {
                strongSelf.navigationBar.barTintColor = viewController.tzm_navigationBarTintColor;
            }else{
                strongSelf.navigationBar.barTintColor = [UINavigationBar appearance].barTintColor;
            }
            
            if (viewController.tzm_navigationTitleTextColor) {
                [strongSelf.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:viewController.tzm_navigationTitleTextColor}];
            }else{
                [strongSelf.navigationBar setTitleTextAttributes:[UINavigationBar appearance].titleTextAttributes];
            }
        }
    };
    
    // Setup will appear inject block to appearing view controller.
    // Setup disappearing view controller as well, because not every view controller is added into
    // stack by pushing, maybe by "-setViewControllers:".
    appearingViewController.tzm_willAppearInjectBlock = block;
    UIViewController *disappearingViewController = self.viewControllers.lastObject;
    if (disappearingViewController && !disappearingViewController.tzm_willAppearInjectBlock) {
        disappearingViewController.tzm_willAppearInjectBlock = block;
    }
}

- (_TZMFullScreenPopGestureRecognizerDelegate *)tzm_popGestureRecognizerDelegate
{
    _TZMFullScreenPopGestureRecognizerDelegate *delegate = objc_getAssociatedObject(self, _cmd);

    if (!delegate) {
        delegate = [[_TZMFullScreenPopGestureRecognizerDelegate alloc] init];
        delegate.navigationController = self;
        
        objc_setAssociatedObject(self, _cmd, delegate, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return delegate;
}

- (UIPanGestureRecognizer *)tzm_fullScreenPopGestureRecognizer{
    UIPanGestureRecognizer *panGestureRecognizer = objc_getAssociatedObject(self, _cmd);

    if (!panGestureRecognizer) {
        panGestureRecognizer = [[UIPanGestureRecognizer alloc] init];
        panGestureRecognizer.maximumNumberOfTouches = 1;
        
        objc_setAssociatedObject(self, _cmd, panGestureRecognizer, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return panGestureRecognizer;
}

- (BOOL)tzm_viewControllerBasedNavigationBarAppearanceEnabled
{
    NSNumber *number = objc_getAssociatedObject(self, _cmd);
    if (number) {
        return number.boolValue;
    }
    self.tzm_viewControllerBasedNavigationBarAppearanceEnabled = YES;
    return YES;
}

- (void)setTzm_viewControllerBasedNavigationBarAppearanceEnabled:(BOOL)enabled
{
    SEL key = @selector(tzm_viewControllerBasedNavigationBarAppearanceEnabled);
    objc_setAssociatedObject(self, key, @(enabled), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end

@implementation UIViewController (TZM_NavigationBar)

- (BOOL)tzm_interactivePopDisabled
{
    return [objc_getAssociatedObject(self, _cmd) boolValue];
}

- (void)setTzm_interactivePopDisabled:(BOOL)disabled
{
    objc_setAssociatedObject(self, @selector(tzm_interactivePopDisabled), @(disabled), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BOOL)tzm_prefersNavigationBarHidden
{
    return [objc_getAssociatedObject(self, _cmd) boolValue];
}

- (void)setTzm_prefersNavigationBarHidden:(BOOL)hidden
{
    objc_setAssociatedObject(self, @selector(tzm_prefersNavigationBarHidden), @(hidden), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIImage*)tzm_navigationBackgroundImage
{
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setTzm_navigationBackgroundImage:(UIImage*)tzm_navigationBackgroundImage
{
    objc_setAssociatedObject(self, @selector(tzm_navigationBackgroundImage), tzm_navigationBackgroundImage, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIImage*)tzm_navigationShadowImage
{
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setTzm_navigationShadowImage:(UIImage*)tzm_navigationShadowImage
{
    objc_setAssociatedObject(self, @selector(tzm_navigationShadowImage), tzm_navigationShadowImage, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIColor*)tzm_navigationTitleTextColor
{
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setTzm_navigationTitleTextColor:(UIColor*)tzm_navigationTitleTextColor
{
    objc_setAssociatedObject(self, @selector(tzm_navigationTitleTextColor), tzm_navigationTitleTextColor, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIColor*)tzm_navigationTintColor
{
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setTzm_navigationTintColor:(UIColor*)tzm_navigationTintColor
{
    objc_setAssociatedObject(self, @selector(tzm_navigationTintColor), tzm_navigationTintColor, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIColor*)tzm_navigationBarTintColor
{
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setTzm_navigationBarTintColor:(UIColor*)tzm_navigationBarTintColor
{
    objc_setAssociatedObject(self, @selector(tzm_navigationBarTintColor), tzm_navigationBarTintColor, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end


@interface UINavigationController (TZM_Back)

// `UINavigationControllerBackButtonHandlerProtocol`的`canPopViewController`功能里面，当 A canPop = NO，B canPop = YES，那么从 B 手势返回到 A，也会触发需求 A 的 `canPopViewController` 方法，这是因为手势返回会去询问`gestureRecognizerShouldBegin:`和`qmui_navigationBar:shouldPopItem:`，而这两个方法里面的 self.topViewController 是不同的对象，所以导致这个问题。所以通过 tmp_topViewController 来记录 self.topViewController 从而保证两个地方的值是相等的。

- (nullable UIViewController *)tmp_topViewController;

@end

@implementation UINavigationController (TZM_Back)

- (UIViewController *)tmp_topViewController {
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setTmp_topViewController:(UIViewController *)viewController {
    objc_setAssociatedObject(self, @selector(tmp_topViewController), viewController, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [self swizzleInstanceMethod:@selector(viewDidLoad) with:@selector(tzm_viewDidLoad)];
        [self swizzleInstanceMethod:@selector(navigationBar:shouldPopItem:) with:@selector(tzm_navigationBar:shouldPopItem:)];
    });
}

static char originGestureDelegateKey;
- (void)tzm_viewDidLoad {
    [self tzm_viewDidLoad];
    objc_setAssociatedObject(self, &originGestureDelegateKey, self.interactivePopGestureRecognizer.delegate, OBJC_ASSOCIATION_ASSIGN);
    self.interactivePopGestureRecognizer.delegate = (id<UIGestureRecognizerDelegate>)self;
}

- (BOOL)canPopViewController:(UIViewController *)viewController {
    BOOL canPopViewController = YES;
    
    if ([viewController respondsToSelector:@selector(shouldHoldBackButtonEvent)] &&
        [viewController shouldHoldBackButtonEvent] &&
        [viewController respondsToSelector:@selector(canPopViewController)] &&
        ![viewController canPopViewController]) {
        canPopViewController = NO;
    }
    
    return canPopViewController;
}

- (BOOL)tzm_navigationBar:(UINavigationBar *)navigationBar shouldPopItem:(UINavigationItem *)item {
    
    // 如果nav的vc栈中有两个vc，第一个是root，第二个是second。这是second页面如果点击系统的返回按钮，topViewController获取的栈顶vc是second，而如果是直接代码写的pop操作，则获取的栈顶vc是root。也就是说只要代码写了pop操作，则系统会直接将顶层vc也就是second出栈，然后才回调的，所以这时我们获取到的顶层vc就是root了。然而不管哪种方式，参数中的item都是second的item。
    BOOL isPopedByCoding = item != [self topViewController].navigationItem;
    
    // !isPopedByCoding 要放在前面，这样当 !isPopedByCoding 不满足的时候就不会去询问 canPopViewController 了，可以避免额外调用 canPopViewController 里面的逻辑导致
    BOOL canPopViewController = !isPopedByCoding && [self canPopViewController:self.tmp_topViewController ?: [self topViewController]];
    
    if (canPopViewController || isPopedByCoding) {
        self.tmp_topViewController = nil;
        return [self tzm_navigationBar:navigationBar shouldPopItem:item];
    } else {
        [self resetSubviewsInNavBar:navigationBar];
        self.tmp_topViewController = nil;
    }
    
    return NO;
}

- (void)resetSubviewsInNavBar:(UINavigationBar *)navBar {
    // Workaround for >= iOS7.1. Thanks to @boliva - http://stackoverflow.com/posts/comments/34452906
    for(UIView *subview in [navBar subviews]) {
        if(subview.alpha < 1.0) {
            [UIView animateWithDuration:.25 animations:^{
                subview.alpha = 1.0;
            }];
        }
    }
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    if (gestureRecognizer == self.interactivePopGestureRecognizer) {
        self.tmp_topViewController = self.topViewController;
        BOOL canPopViewController = [self canPopViewController:self.tmp_topViewController];
        if (canPopViewController) {
            id<UIGestureRecognizerDelegate>originGestureDelegate = objc_getAssociatedObject(self, &originGestureDelegateKey);
            if ([originGestureDelegate respondsToSelector:@selector(gestureRecognizerShouldBegin:)]) {
                return [originGestureDelegate gestureRecognizerShouldBegin:gestureRecognizer];
            } else {
                return NO;
            }
        } else {
            return NO;
        }
    }
    return YES;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    if (gestureRecognizer == self.interactivePopGestureRecognizer) {
        id<UIGestureRecognizerDelegate>originGestureDelegate = objc_getAssociatedObject(self, &originGestureDelegateKey);
        if ([originGestureDelegate respondsToSelector:@selector(gestureRecognizer:shouldReceiveTouch:)]) {
            // 先判断要不要强制开启手势返回
            UIViewController *viewController = [self topViewController];
            if (self.viewControllers.count > 1 &&
                self.interactivePopGestureRecognizer.enabled &&
                [viewController respondsToSelector:@selector(forceEnableInteractivePopGestureRecognizer)] &&
                [viewController forceEnableInteractivePopGestureRecognizer]) {
                return YES;
            }
            // 调用默认的实现
            return [originGestureDelegate gestureRecognizer:gestureRecognizer shouldReceiveTouch:touch];
        }
    }
    return YES;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    if (gestureRecognizer == self.interactivePopGestureRecognizer) {
        id<UIGestureRecognizerDelegate>originGestureDelegate = objc_getAssociatedObject(self, &originGestureDelegateKey);
        if ([originGestureDelegate respondsToSelector:@selector(gestureRecognizer:shouldRecognizeSimultaneouslyWithGestureRecognizer:)]) {
            return [originGestureDelegate gestureRecognizer:gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:otherGestureRecognizer];
        }
    }
    return NO;
}

// 是否要gestureRecognizer检测失败了，才去检测otherGestureRecognizer
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldBeRequiredToFailByGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    if (gestureRecognizer == self.interactivePopGestureRecognizer) {
        // 如果只是实现了上面几个手势的delegate，那么返回的手势和当前界面上的scrollview或者其他存在的手势会冲突，所以如果判断是返回手势，则优先响应返回手势再响应其他手势。
        // 不知道为什么，系统竟然没有实现这个delegate，那么它是怎么处理返回手势和其他手势的优先级的
        return YES;
    }
    return NO;
}

@end

@implementation UIViewController (TZM_Back)

@end
