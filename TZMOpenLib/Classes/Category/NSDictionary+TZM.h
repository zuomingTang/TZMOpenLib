//
//  NSDictionary+TZM.h

#import <Foundation/Foundation.h>
#import <YYCategories/YYCategories.h>

@interface NSDictionary (TZM)
// 把字典里的东西拼接成URL查询字符串
- (NSString *)URLQueryString;
//获取签名相关信息
+ (NSDictionary *)mobileProvisionDictionary;
//获取一个url参数信息
- (NSDictionary *)queryParamsWithURL:(NSURL*)url;
//字符串转字典
+ (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString;
@end
