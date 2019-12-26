//
//  UITableView+TZM.m
//
//  Created by mayer on 2018/6/6.
//  Copyright © 2018年 mayer. All rights reserved.
//

#import "UITableView+TZM.h"
#import <YYCategories/YYCategories.h>

@implementation UITableView (TZM_IB)

-(void)setZ_separatorColor:(NSString *)z_separatorColor{
    self.separatorColor = [UIColor colorWithHexString:z_separatorColor];
}

-(NSString *)z_separatorColor{
    return nil;
}

@end
