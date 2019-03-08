//
//  UIViewController+TZM.h

#import <UIKit/UIKit.h>
#import <ObjcAssociatedObjectHelpers/ObjcAssociatedObjectHelpers.h>
#import <YYCategories/YYCategories.h>

@interface UIViewController (TZM)

@property (nonatomic) UIBarButtonItem *tzmBackBarButtonItem UI_APPEARANCE_SELECTOR; //定制VC的返回按钮，可全局设置默认

@property (readonly) BOOL isFirstAppear; //是否是第一次显示

+ (instancetype)tzm_appearance; //获取设置全局样式的对象

// 获得当前可见的最上层的视图控制器
+ (UIViewController *)visibleTopViewController;
// 获得目标viewController的最上层的视图控制器
+ (UIViewController *)findTopViewController:(UIViewController *)viewController;

+ (instancetype)tzm_instantiateFromNib;

// 获得当前可见的最上层的导航视图控制器
+ (UINavigationController *)visibleTopNavigationController;

@end
