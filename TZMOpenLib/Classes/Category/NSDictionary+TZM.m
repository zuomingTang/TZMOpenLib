//
//  NSDictionary+TZM.m

#import "NSDictionary+TZM.h"
#import <YYCategories/YYCategories.h>

@implementation NSDictionary (TZM)

- (NSString *)tzm_urlQueryString{
    NSMutableArray *parts = [NSMutableArray array];
    for (NSString *key in self) {
        id value = self[key];
        NSString *stringValue = [NSString stringWithFormat:@"%@", value];
        NSString *part = [NSString stringWithFormat:@"%@=%@", [key stringByURLEncode], [stringValue stringByURLEncode]];
        [parts addObject:part];
    }
    return [parts componentsJoinedByString:@"&"];
}

+ (NSDictionary *)tzm_mobileProvisionDictionary {
    NSDictionary *result = nil;
    NSString *path = [[NSBundle mainBundle] pathForResource:@"embedded" ofType:@"mobileprovision"];
    if (!path){
        return nil;
    }
    
    NSError *error = nil;
    // NSISOLatin1 keeps the binary wrapper from being parsed as unicode and dropped as invalid
    NSString *binaryString = [NSString stringWithContentsOfFile:path encoding:NSISOLatin1StringEncoding error:&error];
    if (!binaryString) {
        return nil;
    }
    
    NSScanner *scanner = [NSScanner scannerWithString:binaryString];
    BOOL ok = [scanner scanUpToString:@"<plist" intoString:nil];
    if (!ok) {
        NSLog(@"unable to find beginning of plist");
        return nil;
    }
    NSString *plistString;
    ok = [scanner scanUpToString:@"</plist>" intoString:&plistString];
    if (!ok) {
        NSLog(@"unable to find end of plist");
        return nil;
    }
    plistString = [NSString stringWithFormat:@"%@</plist>",plistString];
    // juggle latin1 back to utf-8!
    NSData *plistdata_latin1 = [plistString dataUsingEncoding:NSISOLatin1StringEncoding];
    // plistString = [NSString stringWithUTF8String:[plistdata_latin1 bytes]];
    // NSData *plistdata2_latin1 = [plistString dataUsingEncoding:NSISOLatin1StringEncoding];
    result = [NSPropertyListSerialization propertyListWithData:plistdata_latin1 options:NSPropertyListImmutable format:NULL error:&error];
    if (error) {
        NSLog(@"error parsing extracted plist — %@",error);
        return nil;
    }
    
    return result;
}

- (NSDictionary *)tzm_queryParamsWithURL:(NSURL*)url{
    NSMutableDictionary *result = [NSMutableDictionary dictionary];
    if ( !url.query.length ){
        return result;
    }
    NSArray *params = [url.query componentsSeparatedByString:@"&"];
    for(NSString *paramStr in params){
        NSArray *param = [paramStr componentsSeparatedByString:@"="];
        if ( param.count == 2){
            NSString *key = param[0];
            NSString *val = param[1];
            [result setValue:val forKey:key];
        }
    }
    return result;
}

+ (NSDictionary *)tzm_dictionaryWithJsonString:(NSString *)jsonString{
    if (jsonString == nil) {
        return nil;
    }
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                        options:NSJSONReadingMutableContainers
                                                          error:&err];
    if(err) {
        return nil;
    }
    return dic;
}
@end
