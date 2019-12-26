//
//  UITextField+TZM.h

#import <UIKit/UIKit.h>

@interface UITextField (TZM_IB)
//默认文字颜色
@property (nonatomic) IBInspectable NSString *z_placeholderColor;
//清空按钮
@property (nonatomic) IBInspectable UIImage *z_clearImage;
//可输入最大长度
@property (nonatomic,assign) IBInspectable NSInteger tzm_maxLen;
//可输入最大字节长度（一个汉字算2个字节）
@property (nonatomic,assign) IBInspectable NSInteger tzm_maxByteLen;
//是否以123 1234 1234 显示文字
@property (nonatomic,assign) BOOL tzm_isPhoneNumber;
@end
