//
//  UIDevice+TZM.m
//
//  Created by mayer on 2018/5/18.
//  Copyright © 2018年 mayer. All rights reserved.
//

#import "UIDevice+TZM.h"
#import <sys/utsname.h>

@implementation UIDevice (TZM)

static NSString *_iphoneType;
+ (NSString*)tzm_getIPhoneType{
    if (_iphoneType.length > 0) {
        return _iphoneType;
    }
    struct utsname systemInfo;
    uname(&systemInfo);
    _iphoneType = [NSString stringWithCString:systemInfo.machine encoding:NSASCIIStringEncoding];
    return _iphoneType;
}

static NSString *_UUID;
+ (NSString*)tzm_getUUID{
    if (_UUID.length > 0) {
        return _UUID;
    }
    NSString *uuidString = nil;
    
    NSString *service = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleIdentifier"];
    NSDictionary *query = @{(__bridge id)kSecAttrAccessible:(__bridge id)kSecAttrAccessibleAfterFirstUnlock,
                            (__bridge id)kSecClass:(__bridge id)kSecClassGenericPassword,
                            (__bridge id)kSecAttrService:service,
                            (__bridge id)kSecAttrAccount:service
                            };
    
    //查询钥匙串是否已经有UUID啦
    NSMutableDictionary *loadQuery = [query mutableCopy];
    [loadQuery setObject:(__bridge id)kCFBooleanTrue forKey:(__bridge id)kSecReturnData];
    [loadQuery setObject:(__bridge id)kSecMatchLimitOne forKey:(__bridge id)kSecMatchLimit];
    CFDataRef keyData = NULL;
    if (SecItemCopyMatching((CFDictionaryRef)loadQuery, (CFTypeRef *)&keyData) == noErr) {
        @try{
            id ret = [NSKeyedUnarchiver unarchiveObjectWithData:(__bridge NSData *)keyData];
            if ([ret isKindOfClass:NSString.class]) {
                uuidString = ret;
            }
        }@catch(NSException *e){
            NSLog(@"Unarchive of %@ failed: %@", service, e);
        }@finally {
        }
    }
    if (keyData) CFRelease(keyData);
    
    if (uuidString.length > 0) {
        //如果有直接用
    }else{
        //如果没有就生成一个存入钥匙串
        uuidString = [UIDevice currentDevice].identifierForVendor.UUIDString;
        
        SecItemDelete((CFDictionaryRef)query);
        
        NSMutableDictionary *saveQuery = [query mutableCopy];
        [saveQuery setObject:[NSKeyedArchiver archivedDataWithRootObject:uuidString] forKey:(id)kSecValueData];
        SecItemAdd((CFDictionaryRef)saveQuery, NULL);
    }
    _UUID = uuidString;
    return _UUID;
}
@end
