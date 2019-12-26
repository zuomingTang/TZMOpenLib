//
//  UITextView+TZM.h
//
//  Created by mayer on 2018/10/18.
//  Copyright © 2018 mayer. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITextView (TZM_IB)
//输入最大长度
@property (nonatomic,assign) IBInspectable NSInteger tzm_maxLen;
//默认提示文字
@property (nonatomic,copy) IBInspectable NSString *tzm_placeholder;
//默认提示文字lable
@property (nonatomic,strong,readonly) UILabel *tzm_placeholderLabel;
@end
