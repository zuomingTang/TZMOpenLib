//
//  NSError+TZM.m
//  SmartHome
//
//  Created by gemdale on 2018/9/3.
//  Copyright © 2018年 gemdale. All rights reserved.
//

#import "NSError+TZM.h"
#import <YYCategories/YYCategories.h>

@implementation NSError (TZM)

+ (void)load {
    [self swizzleInstanceMethod:@selector(localizedDescription) with:@selector(tzm_localizedDescription)];
}

-(NSString *)tzm_localizedDescription{
    NSString *string = [self tzm_localizedDescription];
    if (string.length > 0) {
        return string;
    }else{
        if ([self.domain isEqualToString:NSURLErrorDomain] && self.code == -1009) {
            return @"网络不给力，请检查网络设置";
        }
        return string;
    }
}
@end
