//
// Created by mayer on 15/3/22.
// Copyright (c) 2015 mayer. All rights reserved.
//

#import "UIViewController+TZMPageStatusViewEx.h"


@implementation UIViewController (TZMPageStatusViewEx)

- (TZMPageStatusView *)showPageStatus:(TZMPageStatus)status image:(UIImage*)image title:(NSString*)title desc:(NSString *)desc buttonText:(NSString *)text didClickButtonCallback:(TZMPageStatusViewBlock)callback{
    return [self.view showPageStatus:status image:image title:title desc:desc buttonText:text didClickButtonCallback:callback];
}

//- (TZMPageStatusView *)showPageStatusLoading {
//    return [self.view showPageStatusLoading];
//}

- (void)dismissPageStatusView {
    [self.view dismissPageStatusView];
}

@end
