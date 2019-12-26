//
//  UIDevice+TZM.h
//
//  Created by mayer on 2018/5/18.
//  Copyright © 2018年 mayer. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIDevice (TZM)
//获取一个uuid 在APP被删除后重新装uuid不变
+ (NSString*)tzm_getUUID;
//获取设备的型号
+ (NSString*)tzm_getIPhoneType;
@end
