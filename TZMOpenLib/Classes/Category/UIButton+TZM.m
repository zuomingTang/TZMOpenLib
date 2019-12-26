//
//  UIButton+TZM_IB.m

#import "UIButton+TZM.h"
#import <YYCategories/YYCategories.h>
#import <objc/runtime.h>

@implementation UIButton (TZM_IB)

+ (void)load {
    [self swizzleInstanceMethod:@selector(pointInside:withEvent:) with:@selector(tzm_pointInside:withEvent:)];
}

static const NSString *KEY_HIT_TEST_EDGE_INSETS = @"tzm_HitTestEdgeInsets";

- (BOOL)tzm_pointInside:(CGPoint)point withEvent:(UIEvent *)event {
    if(UIEdgeInsetsEqualToEdgeInsets(self.z_touchHitEdgeInsets, UIEdgeInsetsZero) || !self.enabled || self.hidden) {
        return [self tzm_pointInside:point withEvent:event];
    }
    
    CGRect relativeFrame = self.bounds;
    CGRect hitFrame = UIEdgeInsetsInsetRect(relativeFrame, self.z_touchHitEdgeInsets);
    
    return CGRectContainsPoint(hitFrame, point);
}

-(void)setZ_touchHitEdgeInsets:(UIEdgeInsets)hitTestEdgeInsets {
    NSValue *value = [NSValue value:&hitTestEdgeInsets withObjCType:@encode(UIEdgeInsets)];
    objc_setAssociatedObject(self, &KEY_HIT_TEST_EDGE_INSETS, value, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

-(UIEdgeInsets)z_touchHitEdgeInsets {
    NSValue *value = objc_getAssociatedObject(self, &KEY_HIT_TEST_EDGE_INSETS);
    if(value) {
        UIEdgeInsets edgeInsets; [value getValue:&edgeInsets]; return edgeInsets;
    }else {
        return UIEdgeInsetsZero;
    }
}

//-------------------------------------------------------
-(void)setZ_normalStateTitleColor:(NSString *)z_normalStateTitleColor{
    [self setTitleColor:[UIColor colorWithHexString:z_normalStateTitleColor] forState:UIControlStateNormal];
}
-(NSString *)z_normalStateTitleColor{
    return nil;
}

-(void)setZ_disabledStateTitleColor:(NSString *)z_disabledStateTitleColor{
    [self setTitleColor:[UIColor colorWithHexString:z_disabledStateTitleColor] forState:UIControlStateDisabled];
}
-(NSString *)z_disabledStateTitleColor{
    return nil;
}

-(void)setZ_selectedStateTitleColor:(NSString *)z_selectedStateTitleColor{
    [self setTitleColor:[UIColor colorWithHexString:z_selectedStateTitleColor] forState:UIControlStateSelected];
}
-(NSString *)z_selectedStateTitleColor{
    return nil;
}

-(void)setZ_highlightedStateTitleColor:(NSString *)z_highlightedStateTitleColor{
    [self setTitleColor:[UIColor colorWithHexString:z_highlightedStateTitleColor] forState:UIControlStateHighlighted];
}
-(NSString *)z_highlightedStateTitleColor{
    return nil;
}
@end
