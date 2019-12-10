//
//  NSString+TZM.h
//
//  Created by mayer on 2018/6/6.
//  Copyright © 2018年 mayer. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (TZM)
// 手机号码校验
- (BOOL)checkMobileNumber;
// 判断字符串是否全是空格
- (BOOL)checkStringIsEmpty;
// 验证密码输入是否符合规则
- (BOOL)checkPsd;
//计算文字长度
- (CGFloat)getStrWidthWithFontSize:(CGFloat)fontSize;
//计算文字高度
- (CGFloat)getStrHeightWithFontSize:(CGFloat)fontSize labelWidth:(CGFloat)labelWidth;
//文字字节数
-(NSUInteger)textLength;
//是否包含特殊字符
-(BOOL)judgeTheillegalCharacter;

-(NSString*)substringToMaxByte:(NSInteger)maxByte;
@end
