//
//  TZMActionViewManager.m
//  SmartHome
//
//  Created by gemdale on 2018/5/14.
//  Copyright © 2018年 gemdale. All rights reserved.
//

#import "TZMAlertManager.h"

@implementation TZMAlertManager
+ (id)showAlertToVC:(UIViewController*)vc block:(void (^)(NSInteger buttonIndex, id alert))block andTitle:(NSString *)title andMessage:(NSString *)message preferredStyle:(TZMAlertManagerStyle)style destructiveButtonTitle:(NSString *)destructiveButtonTitle otherButtonTitles:(NSString *)otherButtonTitles,...{
   
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:(UIAlertControllerStyle)style];
    NSInteger buttonIndex = 1;
    __weak UIAlertController *weakAlert = alert;
    if( otherButtonTitles != nil ){
        [alert addAction:[UIAlertAction actionWithTitle:otherButtonTitles style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            if (block) block(buttonIndex,weakAlert);
        }]];
        va_list args;
        va_start( args, otherButtonTitles );
        for ( ;; ){
            buttonIndex++;
            NSString * otherButtonTitle = va_arg( args, NSString * );
            if ( nil == otherButtonTitle) break;
            [alert addAction:[UIAlertAction actionWithTitle:otherButtonTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                if (block) block(buttonIndex,weakAlert);
            }]];
        }
        va_end( args );
    }
    if (destructiveButtonTitle.length > 0) {
        [alert addAction:[UIAlertAction actionWithTitle:destructiveButtonTitle style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
            if (block) block(0,weakAlert);
        }]];
    }
    [vc presentViewController:alert animated:YES completion:nil];
    return alert;
}

@end
