//
// Created by mayer on 15/3/13.
// Copyright (c) 2015 mayer. All rights reserved.
//

#import "NSObject+TZM.h"
#import <ObjcAssociatedObjectHelpers/ObjcAssociatedObjectHelpers.h>


@implementation NSObject (TZM_Notification)

+ (void)postNotification:(NSString *)name object:(id)object {
    NSNotification *notification = [NSNotification notificationWithName:name object:object];
    if ([NSThread isMainThread]) return [[NSNotificationCenter defaultCenter] postNotification:notification];
    [[NSNotificationCenter defaultCenter] performSelectorOnMainThread:@selector(postNotification:) withObject:notification waitUntilDone:NO];
}

- (void)postNotification:(NSString *)name object:(id)object {
    [self.class postNotification:name object:object];
}

- (void)observerNotifications {

}

- (void)observerNotification:(NSString *)name {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(_handleNotifications:) name:name object:nil];
}

- (void)_handleNotifications:(NSNotification *)notification {
    if ([NSThread isMainThread]) return [self handleNotifications:notification];
    [[self class] performSelectorOnMainThread:@selector(handleNotifications:) withObject:notification waitUntilDone:NO];
}

- (void)handleNotifications:(NSNotification *)notification {

}

- (void)removeNotifications {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


@end

@implementation NSObject (TZM_Appearance)
SYNTHESIZE_ASC_PRIMITIVE(tzm_isAppearance, setTzm_isAppearance, BOOL);
+ (instancetype)tzm_appearance{
    NSObject *obj = [self new];
    obj.tzm_isAppearance = YES;
    return obj;
}
@end
