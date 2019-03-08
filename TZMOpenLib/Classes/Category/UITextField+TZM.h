//
//  UITextField+TZM.h

#import <UIKit/UIKit.h>
#import <YYCategories/YYCategories.h>
#import "NSObject+TZM.h"
#import <ObjcAssociatedObjectHelpers/ObjcAssociatedObjectHelpers.h>

@interface UITextField (TZM_IB)
@property (nonatomic) IBInspectable NSString *z_placeholderColor;
@property (nonatomic) IBInspectable UIImage *z_clearImage;
@property (nonatomic,assign) IBInspectable NSInteger tzm_maxLen; //输入最大长度
@end
