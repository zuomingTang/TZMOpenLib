//
//  TZMPushManager.m

#import "TZMPushManager.h"

NSString *const TZMRemoteNotification = @"TZMRemoteNotification";

typedef void(^returnBlock)(NSString *deviceToken,NSError *error);

@interface TZMPushManager()
@property (nonatomic, copy, readwrite) NSString *deviceToken;
@property (nonatomic, strong) NSError *error;
@property (nonatomic, assign) BOOL isRegisters;
@property (nonatomic, strong) NSLock *lock;
@property (nonatomic, strong) NSMutableArray<returnBlock> *blocks;

@end

@implementation TZMPushManager{
}

+ (instancetype)shared {
    static TZMPushManager *_pushManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _pushManager = [TZMPushManager new];
        _pushManager.isRegisters = NO;
        _pushManager.blocks = [NSMutableArray array];
        _pushManager.lock = [NSLock new];
    });
    return _pushManager;
}

- (void)getDeviceTokenWithBlock:(void(^)(NSString *deviceToken,NSError *error))block{
    if (self.deviceToken.length > 0) {
        block(self.deviceToken,nil);
    }else{
        [self.lock lock];
        [self.blocks addObject:block];
        if(!self.isRegisters){
            self.isRegisters = YES;
            [self registerPush];
        }
        [self.lock unlock];
    }
}

- (void)registerPush{
#ifdef __IPHONE_8_0
    UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeAlert|UIUserNotificationTypeBadge|UIUserNotificationTypeSound) categories:nil];
    [[UIApplication sharedApplication] registerForRemoteNotifications];
    [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
#else
    UIRemoteNotificationType apn_type = (UIRemoteNotificationType)(UIRemoteNotificationTypeAlert|UIRemoteNotificationTypeSound|UIRemoteNotificationTypeBadge);
    [[UIApplication sharedApplication] registerForRemoteNotificationTypes:apn_type];
#endif
    
}

#pragma mark - AppDelegate回调

// 如果获取deviceToken失败 那么调这个方法
- (void)didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    self.error = error;
    [self runBlock];
    if ( error ) NSLog(@"didFailToRegisterForRemoteNotificationsWithError: %@", error);
}

// 成功获取deviceToken  系统自动回调
- (void)didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    self.deviceToken =[[[[deviceToken description] stringByReplacingOccurrencesOfString:@"<" withString:@""] stringByReplacingOccurrencesOfString:@">" withString:@""] stringByReplacingOccurrencesOfString:@" " withString:@""];
    [self runBlock];
    if (self.deviceToken.length > 0) NSLog(@"deviceToken: %@", self.deviceToken);
}

- (void)runBlock{
    [self.lock lock];
    for (returnBlock block in self.blocks) {
        block(self.deviceToken,self.error);
    }
    [self.blocks removeAllObjects];
    self.isRegisters = NO;
    [self.lock unlock];
}


@end
