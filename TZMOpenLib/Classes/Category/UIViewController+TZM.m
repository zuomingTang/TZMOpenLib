
//  UIViewController+TZM.m

#import "UIViewController+TZM.h"

@implementation UIViewController (TZM)

SYNTHESIZE_ASC_PRIMITIVE(tzm_appearCount, setTzm_appearCount, NSInteger);
SYNTHESIZE_ASC_PRIMITIVE(tzm_isAppearance, setTzm_isAppearance, BOOL); //当前对象是否可以设置全局样式

+ (void)load {
    [self swizzleInstanceMethod:@selector(viewDidAppear:) with:@selector(tzm_viewDidApper:)];
    [self swizzleInstanceMethod:@selector(viewDidLoad) with:@selector(tzm_viewDidLoad)];
    
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleDefault;
}

+ (UIViewController *)visibleTopViewController {
    UIViewController *viewController = [[UIApplication sharedApplication] delegate].window.rootViewController;
    return [self findTopViewController:viewController];
}

+ (UIViewController *)findTopViewController:(UIViewController *)viewController {
    if ([viewController isKindOfClass:[UITabBarController class]]) {
        return [self findTopViewController:[(UITabBarController *) viewController selectedViewController]];
    }
    else if ([viewController isKindOfClass:[UINavigationController class]]) {
        return [self findTopViewController:[(UINavigationController *)viewController visibleViewController]];
    }
    else if ([viewController isKindOfClass:[UIViewController class]]) {
        if (viewController.presentedViewController) {
            return [self findTopViewController:viewController.presentedViewController];
        } else {
            return viewController;
        }
    }
    else {
        return nil;
    }
}

+ (instancetype)tzm_appearance{
    UIViewController *vc = [UIViewController new];
    vc.tzm_isAppearance = YES;
    return vc;
}

+ (instancetype)tzm_instantiateFromNib {
    NSString *nibName = NSStringFromClass(self.class);
    return [[self alloc] initWithNibName:nibName bundle:nil];
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

- (void)tzm_viewDidLoad{
    //在调viewDidload之前先加载全局样式
    if (tzm_backBarButtonItem) {
        self.navigationItem.backBarButtonItem = tzm_backBarButtonItem;
    }
    [self tzm_viewDidLoad];
}

- (void)tzm_viewDidApper:(BOOL)animated {
    self.tzm_appearCount = self.tzm_appearCount + 1;
    [self tzm_viewDidApper:animated];
}

- (BOOL)isFirstAppear {
    return (self.tzm_appearCount < 1);
}

+ (UINavigationController *)visibleTopNavigationController {
    UIViewController *viewController = [[UIApplication sharedApplication] delegate].window.rootViewController;
    return (UINavigationController *) [self findTopNavigationController:viewController];
}

+ (UIViewController *)findTopNavigationController:(UIViewController *)viewController {
    if ([viewController isKindOfClass:[UITabBarController class]]) {
        return [self findTopNavigationController:[(UITabBarController *) viewController selectedViewController]];
    }
    else if ([viewController isKindOfClass:[UINavigationController class]]) {
        return viewController;
    }
    else {
        return nil;
    }
}

@end
