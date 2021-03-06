//
//  NSString+TZM.m
//
//  Created by mayer on 2018/6/6.
//  Copyright © 2018年 mayer. All rights reserved.
//

#import "NSString+TZM.h"

@implementation NSString (TZM)

- (BOOL)tzm_checkMobileNumber {
    NSString *pattern = @"^((13[0-9])|(14[5,7,9])|(15[0-3,5-9])|(166)|(17[0-3,5-8])|(18[0-9])|(19[8,9])|(147))\\d{8}$";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",pattern];
    return [pred evaluateWithObject:self];
}

- (BOOL)tzm_checkStringIsEmpty {
    if (!self) {
        return true;
    } else {
        //A character set containing only the whitespace characters space (U+0020) and tab (U+0009) and the newline and nextline characters (U+000A–U+000D, U+0085).
        NSCharacterSet *set = [NSCharacterSet whitespaceAndNewlineCharacterSet];
        //Returns a new string made by removing from both ends of the receiver characters contained in a given character set.
        NSString *trimedString = [self stringByTrimmingCharactersInSet:set];
        
        if ([trimedString length] == 0) {
            return true;
        } else {
            return false;
        }
    }
}

- (CGFloat)tzm_getStrWidthWithFontSize:(CGFloat)fontSize {
    CGSize size = [self sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:fontSize], NSFontAttributeName, nil]];
    return size.width;
}

- (CGFloat)tzm_getStrHeightWithFontSize:(CGFloat)fontSize labelWidth:(CGFloat)labelWidth {
    CGSize size = [self boundingRectWithSize:CGSizeMake(labelWidth, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:fontSize]} context:nil].size;
    return size.height;
}

-(NSUInteger)tzm_textLength{
    NSUInteger asciiLength = 0;
    for (NSUInteger i = 0; i < self.length; i++) {
        unichar uc = [self characterAtIndex: i];
        asciiLength += isascii(uc) ? 1 : 2;
    }
    NSUInteger unicodeLength = asciiLength;
    return unicodeLength;
}

-(NSString*)tzm_substringToMaxByte:(NSInteger)maxByte{
    NSUInteger asciiLength = 0;
    NSInteger le = 0;
    for (NSUInteger i = 0; i < self.length; i++) {
        unichar uc = [self characterAtIndex: i];
        asciiLength += isascii(uc) ? 1 : 2;
        if (asciiLength > maxByte) {
            break;
        }
        le = i + 1;
    }
    return [self substringToIndex:le];
}

//判断是否含有非法字符 yes 有  no没有
-(BOOL)tzm_judgeTheillegalCharacter{
    //提示 标签不能输入特殊字符
    NSString *str =@"^[A-Za-z0-9\\u4e00-\u9fa5]+$";
    NSPredicate* emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", str];
    if (![emailTest evaluateWithObject:self]) {
        return YES;
    }
    return NO;
}

@end
