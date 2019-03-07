//
//  TZMPushManager.h

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

extern NSString * const TZMRemoteNotification;

// APPLE PUSH
@interface TZMPushManager : NSObject

@property (nonatomic, readonly) NSString *deviceToken;

+ (instancetype)shared;
- (void)getDeviceTokenWithBlock:(void(^)(NSString *deviceToken,NSError *error))block;

//一下两个方法需要在AppDelegate调用
// 如果获取deviceToken失败 那么调这个方法
- (void)didFailToRegisterForRemoteNotificationsWithError:(NSError *)error;
// 成功获取deviceToken  系统自动回调
- (void)didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken;
@end
