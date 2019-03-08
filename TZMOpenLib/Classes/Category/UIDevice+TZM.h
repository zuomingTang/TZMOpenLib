//
//  UIDevice+TZM.h
//
//  Created by mayer on 2018/5/18.
//  Copyright © 2018年 mayer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <sys/utsname.h>

@interface UIDevice (TZM)
+ (NSString*)getUUID;
+ (NSString*)getIPhoneType;
@end
