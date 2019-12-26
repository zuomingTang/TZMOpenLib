//
//  NSDictionary+TZM.h

#import <Foundation/Foundation.h>

@interface NSDictionary (TZM)
// 把字典里的东西拼接成URL查询字符串
- (NSString *)tzm_urlQueryString;
//获取签名相关信息
+ (NSDictionary *)tzm_mobileProvisionDictionary;
//获取一个url参数信息
- (NSDictionary *)tzm_queryParamsWithURL:(NSURL*)url;
//字符串转字典
+ (NSDictionary *)tzm_dictionaryWithJsonString:(NSString *)jsonString;
@end
