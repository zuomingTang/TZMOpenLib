//
//  UIView+TZM.h

#import <UIKit/UIKit.h>
#import <YYCategories/YYCategories.h>
#import <ObjcAssociatedObjectHelpers/ObjcAssociatedObjectHelpers.h>

@interface UIView (TZM)
// 可以给视图加入一个菊花遮罩效果
- (UIActivityIndicatorView *)showActivityIndicator;
- (void)hideActivityIndicator;

// 获得当前 UIView 所在的 UIViewController
- (UIViewController *)viewController;

// 获得当前 UIView 所在的 UINavigationController
- (UINavigationController *)navigationController;

@end


@interface UIView (TZM_IB)
@property (nonatomic) IBInspectable CGFloat cornerRadius;
@property (nonatomic) IBInspectable CGFloat borderWidth;
@property (nonatomic) IBInspectable UIColor *borderColor;
@property (nonatomic) IBInspectable UIColor *shadowColor;
@property (nonatomic) IBInspectable CGFloat shadowOpacity;
@property (nonatomic) IBInspectable CGSize  shadowOffset;
@property (nonatomic) IBInspectable CGFloat shadowRadius;
//试图点击事件是否可以穿透视图
@property (nonatomic) IBInspectable BOOL passTouch;
//点击超出是自己范围的子视图部分也响应事件
@property (nonatomic) IBInspectable BOOL transmitTouch;

@property (nonatomic) IBInspectable NSString* z_backgroundColor;
@end
