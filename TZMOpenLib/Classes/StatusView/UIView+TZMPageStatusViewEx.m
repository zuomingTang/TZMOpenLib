//
// Created by mayer on 15/8/3.
// Copyright (c) 2015 mayer. All rights reserved.
//

#import "UIView+TZMPageStatusViewEx.h"


@implementation UIView (TZMPageStatusViewEx)

- (TZMPageStatusView *)showPageStatus:(TZMPageStatus)status image:(UIImage*)image title:(NSString*)title desc:(NSString *)desc buttonText:(NSString *)text didClickButtonCallback:(TZMPageStatusViewBlock)callback{
    TZMPageStatusView *statusView = [TZMPageStatusView pageStatusViewInView:self];
    if (!statusView){
        statusView = [TZMPageStatusView pageStatusView];
        [statusView showInView:self];
    }
    
    if (image) {
        statusView.imageView.hidden = NO;
    }else{
        statusView.imageView.hidden = YES;
    }
    statusView.imageView.image = image;
    
    if (title) {
        statusView.viewBigLabel.hidden = NO;
    }else{
        statusView.viewBigLabel.hidden = YES;
    }
    statusView.labelViewBig.text = title;
    
    if (desc) {
        statusView.viewLabel.hidden = NO;
    }else{
        statusView.viewLabel.hidden = YES;
    }
    statusView.labelView.text = desc;
    
    if (text) {
        statusView.vieButton.hidden = NO;
    }else{
        statusView.vieButton.hidden = YES;
    }
    [statusView.buttonView setTitle:text forState:UIControlStateNormal];
    statusView.didClickButtonCallback = callback;
    return statusView;
}

- (TZMPageStatusView *)showPageStatusLoading {
    TZMPageStatusView *statusView = [TZMPageStatusView pageStatusViewInView:self];
    if (!statusView){
        statusView = [TZMPageStatusView pageStatusView];
        [statusView showInView:self];
    }
    return statusView;
}

- (void)dismissPageStatusView {
    [[TZMPageStatusView pageStatusViewInView:self] dismiss];
}

@end
