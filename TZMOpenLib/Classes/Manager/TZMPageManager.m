//
// TZMPageManager.m

#import "TZMPageManager.h"


@implementation TZMPageManager {

}

+ (NSCache *)storyboardCache
{
    static NSCache *cache;

    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        cache = [NSCache new];
    });

    return cache;
}

+ (id)viewControllerWithSB:(NSString *)storyboardName andID:(NSString *)vcID {
    @try {
        UIStoryboard *storyboard = [[self storyboardCache] objectForKey:storyboardName];
        if (!storyboard) {
            storyboard = [UIStoryboard storyboardWithName:storyboardName bundle:[NSBundle mainBundle]];
            if (storyboard) {
                [[self storyboardCache] setObject:storyboard forKey:storyboardName];
            }
        }

        if (storyboard) {
            id vc = [storyboard instantiateViewControllerWithIdentifier:vcID];
            if (vc) {
                return vc;
            }
        }
        return nil;
    } @catch (NSException *exception) {
        NSLog(@"ERROR: %@",exception);
        return nil;
    }
}

+ (id)viewControllerWithClass:(Class)clazz nibName:(NSString *)nibName {
    return [(UIViewController *) [clazz alloc] initWithNibName:nibName bundle:nil];
}
@end
