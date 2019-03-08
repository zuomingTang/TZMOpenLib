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
