//
//  TZMActionViewManager.h
//  SmartHome
//
//  Created by gemdale on 2018/5/14.
//  Copyright © 2018年 gemdale. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, TZMAlertManagerStyle) {
    TZMAlertManagerStyleActionSheet = 0,
    TZMAlertManagerStyleAlert
};

@interface TZMAlertManager : NSObject
//destructiveButtonTitle 警示操作按钮文字
+ (id)showAlertToVC:(UIViewController*)vc block:(void (^)(NSInteger buttonIndex, id alert))block andTitle:(NSString *)title andMessage:(NSString *)message preferredStyle:(TZMAlertManagerStyle)style destructiveButtonTitle:(NSString *)destructiveButtonTitle otherButtonTitles:(NSString *)otherButtonTitles,...;
@end
