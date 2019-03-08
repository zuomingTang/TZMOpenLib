//
//  UITextView+TZM.h
//
//  Created by mayer on 2018/10/18.
//  Copyright © 2018 mayer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <YYCategories/YYCategories.h>
#import "NSObject+TZM.h"
#import <ObjcAssociatedObjectHelpers/ObjcAssociatedObjectHelpers.h>
#import <SVProgressHUD/SVProgressHUD.h>

@interface UITextView (TZM_IB)
@property (nonatomic,assign) IBInspectable NSInteger tzm_maxLen; //输入最大长度
@property (nonatomic,copy) IBInspectable NSString *tzm_placeholder;
@property (nonatomic,strong,readonly) UILabel *tzm_placeholderLabel;
@end
