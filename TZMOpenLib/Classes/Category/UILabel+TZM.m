//
//  UILabel+TZM.m

#import "UILabel+TZM.h"
#import <YYCategories/YYCategories.h>

@implementation UILabel (TZM_IB)
-(void)setZ_titleColor:(NSString *)z_titleColor{
    self.textColor = [UIColor colorWithHexString:z_titleColor];
}
-(NSString *)z_titleColor{
    return nil;
}
@end
