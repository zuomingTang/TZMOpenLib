//
// TZMPageManager.h

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


// 这个对象负责管理视图控制器
@interface TZMPageManager : NSObject

+ (id)viewControllerWithSB:(NSString *)storyboardName andID:(NSString *)vcID;

+ (id)viewControllerWithClass:(Class)clazz nibName:(NSString *)nibName;

@end
