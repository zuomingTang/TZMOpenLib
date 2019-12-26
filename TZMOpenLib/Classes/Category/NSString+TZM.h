//
//  NSString+TZM.h
//
//  Created by mayer on 2018/6/6.
//  Copyright © 2018年 mayer. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (TZM)
// 手机号码校验
- (BOOL)tzm_checkMobileNumber;
// 判断字符串是否全是空格
- (BOOL)tzm_checkStringIsEmpty;
// 计算文字长度
- (CGFloat)tzm_getStrWidthWithFontSize:(CGFloat)fontSize;
// 计算文字高度
- (CGFloat)tzm_getStrHeightWithFontSize:(CGFloat)fontSize labelWidth:(CGFloat)labelWidth;
// 文字字节数(一个汉字为2个字节)
- (NSUInteger)tzm_textLength;
// 是否包含特殊字符
- (BOOL)tzm_judgeTheillegalCharacter;
// 截取最大字节数
- (NSString*)tzm_substringToMaxByte:(NSInteger)maxByte;
@end
