//
//  UITextField+TZM.m

#import "UITextField+TZM.h"

@implementation UITextField (TZM_IB)

SYNTHESIZE_ASC_PRIMITIVE(tzm_maxLen, setTzm_maxLen, NSInteger);
SYNTHESIZE_ASC_PRIMITIVE(tzm_isPhoneNumber, setTzm_isPhoneNumber, BOOL);

+ (void)load {
    [self swizzleInstanceMethod:@selector(awakeFromNib) with:@selector(tzm_awakeFromNib)];
    [self swizzleInstanceMethod:@selector(init) with:@selector(tzm_init)];
}

-(void)tzm_awakeFromNib{
    [self tzm_awakeFromNib];
    [self observerNotifications];
}

- (instancetype)tzm_init {
    UITextField *textField = [self tzm_init];
    if (textField) {
        [self observerNotifications];
    }
    return textField;
}

-(void)setZ_placeholderColor:(NSString *)z_placeholderColor{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setValue:[UIColor colorWithHexString:z_placeholderColor] forKey:NSForegroundColorAttributeName];
    [dic setValue:self.font forKey:NSFontAttributeName];
    self.attributedPlaceholder = [[NSAttributedString alloc] initWithString:self.placeholder ? self.placeholder : @"" attributes:dic];
}

-(UIColor *)z_placeholderColor{
    return nil;
}

-(void)setZ_clearImage:(UIImage *)z_clearImage{
    if (z_clearImage) {
        UIButton *clearBut = [UIButton buttonWithType:UIButtonTypeCustom];
        clearBut.frame = CGRectMake(self.frame.size.width - 20, (self.frame.size.height - 20) / 2, 20, 20);
        [clearBut setImage:z_clearImage forState:UIControlStateNormal];
        [clearBut addTarget:self action:@selector(xImageViewClick:) forControlEvents:UIControlEventTouchUpInside];
        self.rightView = clearBut;
        self.rightViewMode = UITextFieldViewModeWhileEditing;
    }
}

-(UIImage *)z_clearImage{
    return nil;
}

- (void)xImageViewClick:(UITextField*)textField{
    if(self.editing){
        [self setText:@""];
    }
}

-(void)observerNotifications{
    [self observerNotification:UITextFieldTextDidChangeNotification];
}

-(void)handleNotifications:(NSNotification *)notification{
    if ([notification.name isEqualToString:UITextFieldTextDidChangeNotification]) {
        if (notification.object == self){
            UITextField *textField = (UITextField *)notification.object;
            NSString *toBeString = textField.text;
            if (self.tzm_maxLen > 0) {
                UITextRange *selectedRange = [textField markedTextRange];
                // 没有高亮选择的字，则对已输入的文字进行字数统计和限制
                if (!selectedRange || [selectedRange isEmpty]){
                    if (toBeString.length > self.tzm_maxLen) {
                        toBeString = [toBeString substringToIndex:self.tzm_maxLen];
                    }
                }
            }
            if (self.tzm_isPhoneNumber) {
                toBeString = [toBeString stringByReplacingOccurrencesOfString:@" " withString:@""];
                if (toBeString.length > 11) {
                    toBeString = [toBeString substringToIndex:11];
                }
                if (toBeString.length > 3 && toBeString.length < 8) {
                    toBeString = [NSString stringWithFormat:@"%@ %@",[toBeString substringToIndex:3],[toBeString substringFromIndex:3]];
                }else if (toBeString.length > 7) {
                     toBeString = [NSString stringWithFormat:@"%@ %@ %@",[toBeString substringToIndex:3],[toBeString substringWithRange:NSMakeRange(3, 4)],[toBeString substringFromIndex:7]];
                }
            }
            textField.text = toBeString;
        }
    }
}

-(void)dealloc{
    [self removeNotifications];
}

@end
