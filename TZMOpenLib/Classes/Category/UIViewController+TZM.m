
//  UIViewController+TZM.m

#import "UIViewController+TZM.h"
#import <ObjcAssociatedObjectHelpers/ObjcAssociatedObjectHelpers.h>
#import <YYCategories/YYCategories.h>

#pragma mark-TZM
@implementation UIViewController (TZM)
SYNTHESIZE_ASC_PRIMITIVE(tzm_appearCount, setTzm_appearCount, NSInteger);
SYNTHESIZE_ASC_PRIMITIVE(tzm_isAppearance, setTzm_isAppearance, BOOL); //当前对象是否可以设置全局样式
SYNTHESIZE_ASC_PRIMITIVE(tzm_interactivePopDisabled, setTzm_interactivePopDisabled, BOOL);
SYNTHESIZE_ASC_PRIMITIVE(tzm_prefersNavigationBarHidden, setTzm_prefersNavigationBarHidden, BOOL);
SYNTHESIZE_ASC_OBJ(tzm_navigationBackgroundImage, setTzm_navigationBackgroundImage);
SYNTHESIZE_ASC_OBJ(tzm_navigationShadowImage, setTzm_navigationShadowImage);
SYNTHESIZE_ASC_OBJ(tzm_navigationTitleTextColor, setTzm_navigationTitleTextColor);
SYNTHESIZE_ASC_OBJ(tzm_navigationTintColor, setTzm_navigationTintColor);
SYNTHESIZE_ASC_OBJ(tzm_navigationBarTintColor, setTzm_navigationBarTintColor);

+ (void)load {
    [self swizzleInstanceMethod:@selector(viewDidAppear:) with:@selector(tzm_viewDidApper:)];
    [self swizzleInstanceMethod:@selector(viewWillAppear:) with:@selector(tzm_viewWillAppear:)];
    [self swizzleInstanceMethod:@selector(viewDidLoad) with:@selector(tzm_viewDidLoad)];
}

- (void)tzm_viewDidLoad{
    //在调viewDidload之前先加载全局样式
    if (tzm_backBarButtonItem) {
        self.navigationItem.backBarButtonItem = tzm_backBarButtonItem;
    }
    [self tzm_viewDidLoad];
}

- (void)tzm_viewWillAppear:(BOOL)animated{
    // Forward to primary implementation.
    [self tzm_viewWillAppear:animated];
    if (!tzm_viewWillAppearBlock) {
        return;
    }
    if (!tzm_viewWillAppearBlock(self)) {
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

- (void)tzm_viewDidApper:(BOOL)animated {
    self.tzm_appearCount = self.tzm_appearCount + 1;
    [self tzm_viewDidApper:animated];
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleDefault;
}

+ (UINavigationController *)visibleTopNavigationController {
    UIViewController *viewController = [[UIApplication sharedApplication] delegate].window.rootViewController;
    return (UINavigationController *) [self findTopNavigationController:viewController];
}

+ (UIViewController *)findTopNavigationController:(UIViewController *)viewController {
    if ([viewController isKindOfClass:[UITabBarController class]]) {
        return [self findTopNavigationController:[(UITabBarController *) viewController selectedViewController]];
    }else if ([viewController isKindOfClass:[UINavigationController class]]) {
        return viewController;
    }else {
        return nil;
    }
}

+ (UIViewController *)visibleTopViewController {
    UIViewController *viewController = [[UIApplication sharedApplication] delegate].window.rootViewController;
    return [self findTopViewController:viewController];
}

+ (UIViewController *)findTopViewController:(UIViewController *)viewController {
    if ([viewController isKindOfClass:[UITabBarController class]]) {
        return [self findTopViewController:[(UITabBarController *) viewController selectedViewController]];
    }else if ([viewController isKindOfClass:[UINavigationController class]]) {
        return [self findTopViewController:[(UINavigationController *)viewController visibleViewController]];
    }else if ([viewController isKindOfClass:[UIViewController class]]) {
        if (viewController.presentedViewController) {
            return [self findTopViewController:viewController.presentedViewController];
        } else {
            return viewController;
        }
    }else {
        return nil;
    }
}

+ (instancetype)tzm_appearance{
    UIViewController *vc = [UIViewController new];
    vc.tzm_isAppearance = YES;
    return vc;
}

- (BOOL)isFirstAppear {
    return (self.tzm_appearCount < 1);
}

static UIBarButtonItem *tzm_backBarButtonItem = nil;
- (void)setTzmBackBarButtonItem:(UIBarButtonItem *)tzmBackBarButtonItem{
    if (self.tzm_isAppearance) {
        tzm_backBarButtonItem = tzmBackBarButtonItem;
    }else{
        self.navigationItem.backBarButtonItem = tzmBackBarButtonItem;
    }
}

- (UIBarButtonItem*)tzmBackBarButtonItem{
    if (self.navigationItem.backBarButtonItem) {
        return self.navigationItem.backBarButtonItem;
    }else{
        return tzm_backBarButtonItem;
    }
}

static BOOL(^tzm_viewWillAppearBlock)(UIViewController *vc);
+(void)tzm_exchangeImplementationsViewWillAppearBlock:(BOOL(^)(UIViewController *vc))block{
    tzm_viewWillAppearBlock = block;
}

- (TZMViewControllerWillAppearInjectBlock)tzm_willAppearInjectBlock{
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setTzm_willAppearInjectBlock:(TZMViewControllerWillAppearInjectBlock)block{
    objc_setAssociatedObject(self, @selector(tzm_willAppearInjectBlock), block, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

@end


