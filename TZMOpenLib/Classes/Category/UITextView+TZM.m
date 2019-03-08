//
//  UITextView+TZM.m
//
//  Created by mayer on 2018/10/18.
//  Copyright © 2018 mayer. All rights reserved.
//

#import "UITextView+TZM.h"

@implementation UITextView (TZM_IB)

SYNTHESIZE_ASC_PRIMITIVE(tzm_maxLen, setTzm_maxLen, NSInteger);
SYNTHESIZE_ASC_OBJ(tzm_m_placeholder, setTzm_m_placeholder);
SYNTHESIZE_ASC_OBJ(tzm_placeholderLabel, setTzm_placeholderLabel);

+ (void)load {
    [self swizzleInstanceMethod:@selector(awakeFromNib) with:@selector(tzm_awakeFromNib)];
}

-(void)tzm_awakeFromNib{
    [self tzm_awakeFromNib];
    
    self.tzm_placeholderLabel = [UILabel new];
    self.tzm_placeholderLabel.font = self.font;
    self.tzm_placeholderLabel.textColor = self.textColor;
    self.tzm_placeholderLabel.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    self.tzm_placeholderLabel.userInteractionEnabled = NO;
    self.tzm_placeholderLabel.numberOfLines = 0;
    [self addSubview:self.tzm_placeholderLabel];
    
    self.tzm_placeholder = self.tzm_placeholder;
    self.tzm_placeholderLabel.hidden = self.text.length > 0;
    
    [self observerNotification:UITextViewTextDidChangeNotification];
}

-(void)setTzm_placeholder:(NSString *)tzm_placeholder{
    [self setTzm_m_placeholder:tzm_placeholder];
    CGSize size = CGSizeZero;
    if (self.tzm_placeholderLabel.font) {
        size = [tzm_placeholder boundingRectWithSize:CGSizeMake(self.frame.size.width, 10000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : self.tzm_placeholderLabel.font} context:nil].size;
    }
    self.tzm_placeholderLabel.frame = CGRectMake(4, 7, self.frame.size.width, size.height);
    self.tzm_placeholderLabel.text = tzm_placeholder;
}

-(NSString *)tzm_placeholder{
    id placeholder = [self tzm_m_placeholder];
    if ([placeholder isKindOfClass:NSString.class]) {
        return placeholder;
    }else{
        return nil;
    }
}

-(void)handleNotifications:(NSNotification *)notification{
    if ([notification.name isEqualToString:UITextViewTextDidChangeNotification]) {
        if (notification.object == self){
            UITextView *textView = (UITextView *)notification.object;
            self.tzm_placeholderLabel.hidden = textView.text.length > 0;
            [self wordLimitWithTextField:textView wordMaxNumber:self.tzm_maxLen];
        }
    }
}

-(void)dealloc{
    [self removeNotifications];
}

-(void)wordLimitWithTextField:(UITextView*)textView wordMaxNumber:(NSInteger)maxNumber{
    NSString *toBeString = textView.text;
    UITextRange *selectedRange = [textView markedTextRange];
    // 没有高亮选择的字，则对已输入的文字进行字数统计和限制
    if (!selectedRange || [selectedRange isEmpty]){
        if (toBeString.length > maxNumber) {
            [SVProgressHUD showErrorWithStatus:[[NSString alloc]initWithFormat:@"输入不得超过%d个字",(int)maxNumber]];
            textView.text = [toBeString substringToIndex:maxNumber];
        }
    }
}

@end
