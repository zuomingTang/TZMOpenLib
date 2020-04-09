//
// Created by mayer on 15/3/13.
// Copyright (c) 2015 mayer. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (TZM_Notification)
+ (void)postNotification:(NSString *)name object:(id)object;
- (void)postNotification:(NSString *)name object:(id)object;
- (void)observerNotifications;
- (void)observerNotification:(NSString *)name;
- (void)handleNotifications:(NSNotification *)notification;
- (void)removeNotifications;
@end

@interface NSObject (TZM_Appearance)
@property (assign, nonatomic) BOOL tzm_isAppearance;
//获取设置全局样式的对象
+ (instancetype)tzm_appearance;
@end
