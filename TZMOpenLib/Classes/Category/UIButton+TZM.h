//
//  UIButton+TZM_IB.h

#import <UIKit/UIKit.h>
#import <YYCategories/YYCategories.h>
#import <objc/runtime.h>

@interface UIButton (TZM_IB)
@property (nonatomic) IBInspectable NSString* z_normalStateTitleColor;
@property (nonatomic) IBInspectable NSString* z_highlightedStateTitleColor;
@property (nonatomic) IBInspectable NSString* z_disabledStateTitleColor;
@property (nonatomic) IBInspectable NSString* z_selectedStateTitleColor;
//扩大点击区域
@property (nonatomic) UIEdgeInsets z_touchHitEdgeInsets;
@end
