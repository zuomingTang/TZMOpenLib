//
//  UIView+TZM.m

#import "UIView+TZM.h"
#import <YYCategories/YYCategories.h>
#import <ObjcAssociatedObjectHelpers/ObjcAssociatedObjectHelpers.h>

//创建这个类是为了区分view的子视图中原生UIActivityIndicatorView
@interface TZM_UIActivityIndicatorView : UIActivityIndicatorView
@end

@implementation TZM_UIActivityIndicatorView
@end

@implementation UIView (TZM)
- (TZM_UIActivityIndicatorView *)TZM_UIActivityIndicatorView {
    for (UIView *view in self.subviews){
        if([view isKindOfClass:TZM_UIActivityIndicatorView.class]){
            return (TZM_UIActivityIndicatorView *) view;
        }
    }
    TZM_UIActivityIndicatorView *indicatorView = [[TZM_UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    indicatorView.color = [UIColor lightGrayColor];
    indicatorView.backgroundColor = [UIColor whiteColor];
    [self addSubview:indicatorView];
    
    indicatorView.translatesAutoresizingMaskIntoConstraints = NO;
    NSLayoutConstraint *top = [NSLayoutConstraint constraintWithItem:indicatorView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTop multiplier:1 constant:0];
    NSLayoutConstraint *bottom = [NSLayoutConstraint constraintWithItem:indicatorView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeBottom multiplier:1 constant:0];
    NSLayoutConstraint *right = [NSLayoutConstraint constraintWithItem:indicatorView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeRight multiplier:1 constant:0];
    NSLayoutConstraint *left = [NSLayoutConstraint constraintWithItem:indicatorView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeLeft multiplier:1 constant:0];
    [self addConstraints:@[top, bottom, right, left]];
    
    return indicatorView;
}

- (UIActivityIndicatorView *)tzm_showActivityIndicator {
    TZM_UIActivityIndicatorView *indicatorView = [self TZM_UIActivityIndicatorView];
    [indicatorView startAnimating];
    
    indicatorView.alpha = 0;
    [UIView animateWithDuration:0.2 animations:^{
        indicatorView.alpha = 0.618;
    }];
    return indicatorView;
}

- (void)tzm_hideActivityIndicator {
    TZM_UIActivityIndicatorView *indicatorView = [self TZM_UIActivityIndicatorView];
    [UIView animateWithDuration:0.2 animations:^{
        indicatorView.alpha = 0;
    } completion:^(BOOL finished) {
        [indicatorView removeFromSuperview];
    }];
}

- (UIViewController *)tzm_viewController {
    for (UIView *view = self; view; view = view.superview) {
        UIResponder *nextResponder = [view nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController class]]) {
            return (UIViewController *)nextResponder;
        }
    }
    return nil;
}

- (UINavigationController *)tzm_navigationController {
    UIViewController *viewController = [self viewController];
    if ([viewController isKindOfClass:UINavigationController.class]) {
        return (UINavigationController *) viewController;
    } else {
        if ( viewController.navigationController ) {
            return viewController.navigationController;
        } else {
            return nil;
        }
    }
}
@end


@implementation UIView (TZM_IB)

+ (void)load {
    [self swizzleInstanceMethod:@selector(hitTest:withEvent:) with:@selector(tzm_hitTest:withEvent:)];
}

SYNTHESIZE_ASC_PRIMITIVE(passTouch, setPassTouch, BOOL);
SYNTHESIZE_ASC_PRIMITIVE(transmitTouch, setTransmitTouch, BOOL);

-(UIView*)tzm_hitTest:(CGPoint)point withEvent:(UIEvent *)event{
    if (self.passTouch) {
        if (self.transmitTouch) {
            //如果需要穿透点击，也需要超出范围点击，那么首先判断是不是自身响应事件，如果是就直接返回nil穿透，再判断点击事件是否在自己范围内，如果不在就寻找子视图响应
            UIView *hitView = [self tzm_hitTest:point withEvent:event];
            if (hitView == self){
                return nil;
            }else{
                if (hitView == nil) {
                    for (UIView *subView in self.subviews) {
                        CGPoint myPoint = [subView convertPoint:point fromView:self];
                        if (CGRectContainsPoint(subView.bounds, myPoint)) {
                            return subView;
                        }
                    }
                }
            }
            return hitView;
        }else{
            //如果需要穿透点击，也不需要超出范围点击，那么在响应视图是自己的时候返回为空，自己不响应事件
            UIView *hitView = [self tzm_hitTest:point withEvent:event];
            if (hitView == self){
                return nil;
            }else{
                return hitView;
            }
        }
    }else{
        if(self.transmitTouch){
            //如果不需要穿透点击，需要超出范围点击，在点击到父视图以外的时候，检测是否落在子视图上，如果有返回子视图。
            UIView *hitView = [self tzm_hitTest:point withEvent:event];
            if (hitView == nil) {
                for (UIView *subView in self.subviews) {
                    CGPoint myPoint = [subView convertPoint:point fromView:self];
                    if (CGRectContainsPoint(subView.bounds, myPoint)) {
                        return subView;
                    }
                }
            }
            return hitView;
        }else{
            //如果不需要穿透点击，也不需要超出范围点击，那么直接返回
            return [self tzm_hitTest:point withEvent:event];
        }
    }
}

- (CGFloat)cornerRadius {
    return self.layer.cornerRadius;
}

- (void)setCornerRadius:(CGFloat)cornerRadius {
    self.layer.masksToBounds = YES;
    self.layer.cornerRadius = cornerRadius;
}

- (CGFloat)borderWidth {
    return self.layer.borderWidth;
}

- (void)setBorderWidth:(CGFloat)borderWidth {
    self.layer.borderWidth = borderWidth;
}

- (UIColor *)borderColor {
    return (UIColor *)self.layer.borderColor;
}

- (void)setBorderColor:(UIColor *)borderColor {
    self.layer.borderColor = borderColor.CGColor;
}

- (UIColor *)shadowColor {
    return (UIColor *)self.layer.shadowColor;
}

- (void)setShadowColor:(UIColor *)shadowColor {
    self.layer.shadowColor = shadowColor.CGColor;
}

- (CGFloat)shadowOpacity {
    return self.layer.shadowOpacity;
}

- (void)setShadowOpacity:(CGFloat)shadowOpacity {
    self.layer.shadowOpacity = shadowOpacity;
}

- (CGSize)shadowOffset {
    return self.layer.shadowOffset;
}

- (void)setShadowOffset:(CGSize)shadowOffset {
    self.layer.shadowOffset = shadowOffset;
}

- (CGFloat)shadowRadius {
    return self.layer.shadowRadius;
}

- (void)setShadowRadius:(CGFloat)shadowRadius {
    self.layer.shadowRadius = shadowRadius;
}

-(void)setZ_backgroundColor:(NSString *)z_backgroundColor{
    self.backgroundColor = [UIColor colorWithHexString:z_backgroundColor];
}
-(NSString *)z_backgroundColor{
    return nil;
}

@end
