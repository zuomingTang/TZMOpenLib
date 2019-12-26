//
//  UIViewController+TZM.h

#import <UIKit/UIKit.h>
#import "UINavigationController+TZM.h"

typedef void (^TZMViewControllerWillAppearInjectBlock)(UIViewController *viewController, BOOL animated);

#pragma mark-BackProtocol
@protocol UINavigationControllerBackButtonHandlerProtocol <NSObject>
@optional
/// 是否需要拦截系统返回按钮的事件，只有当这里返回YES的时候，才会询问方法：`canPopViewController`
- (BOOL)shouldHoldBackButtonEvent;
/// 是否可以`popViewController`，可以在这个返回里面做一些业务的判断，比如点击返回按钮的时候，如果输入框里面的文本没有满足条件的则可以弹alert并且返回NO
- (BOOL)canPopViewController;
/// 当自定义了`leftBarButtonItem`按钮之后，系统的手势返回就失效了。可以通过`forceEnableInteractivePopGestureRecognizer`来决定要不要把那个手势返回强制加回来。当 interactivePopGestureRecognizer.enabled = NO 或者当前`UINavigationController`堆栈的viewControllers小于2的时候此方法无效。
- (BOOL)forceEnableInteractivePopGestureRecognizer;
@end

#pragma mark-TZM
@interface UIViewController (TZM)<UINavigationControllerBackButtonHandlerProtocol>


//是否是第一次显示
@property (readonly) BOOL isFirstAppear;
//定制VC的返回按钮，可全局设置默认
@property (nonatomic) UIBarButtonItem *tzmBackBarButtonItem UI_APPEARANCE_SELECTOR;
//获取设置全局样式的对象
+ (instancetype)tzm_appearance;
// 获得当前可见的最上层的视图控制器
+ (UIViewController *)visibleTopViewController;
// 获得目标viewController的最上层的视图控制器
+ (UIViewController *)findTopViewController:(UIViewController *)viewController;
// 获得当前可见的最上层的导航视图控制器
+ (UINavigationController *)visibleTopNavigationController;


#pragma mark-NavigationBar
@property (nonatomic, copy) TZMViewControllerWillAppearInjectBlock tzm_willAppearInjectBlock;
@property (nonatomic, assign) BOOL tzm_interactivePopDisabled;
@property (nonatomic, assign) BOOL tzm_prefersNavigationBarHidden;
@property (nonatomic, strong) UIImage *tzm_navigationBackgroundImage;
@property (nonatomic, strong) UIImage *tzm_navigationShadowImage;
@property (nonatomic, strong) UIColor *tzm_navigationTitleTextColor;
@property (nonatomic, strong) UIColor *tzm_navigationTintColor;
@property (nonatomic, strong) UIColor *tzm_navigationBarTintColor;
+(void)tzm_exchangeImplementationsViewWillAppearBlock:(BOOL(^)(UIViewController *vc))block;
@end
