//
//  TZMImagePickerController.h
//  SmartHome
//
//  Created by gemdale on 2018/9/26.
//  Copyright © 2018年 gemdale. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TZMImagePickerController : UIImagePickerController
@property(nonatomic,copy)void(^block)(NSDictionary<NSString *,id> *info);
@end
