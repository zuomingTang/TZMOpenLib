//
// Created by mayer on 15/3/22.
// Copyright (c) 2015 mayer. All rights reserved.
//

#import "TZMPageStatusView.h"

@interface TZMPageStatusView()
@end

@implementation TZMPageStatusView

+ (instancetype)pageStatusView {
    NSBundle *bundle = [NSBundle bundleForClass:[TZMPageStatusView class]];
    bundle = [NSBundle bundleWithURL:[bundle URLForResource:@"StatusView" withExtension:@"bundle"]];
    NSArray *objs = [bundle loadNibNamed:@"TZMPageStatusView" owner:nil options:nil];
    for ( id obj in objs ) {
        if ([obj isKindOfClass:TZMPageStatusView.class])
            return obj;
    }
    return nil;
}

+ (instancetype)pageStatusViewInView:(UIView *)view {
    TZMPageStatusView * result = nil;
    NSArray *subviews = ([view isKindOfClass:UIScrollView.class] ? view.superview.subviews : view.subviews);
    for (UIView *subView in subviews){
        if ( [subView isKindOfClass:TZMPageStatusView.class] ){
            result = (TZMPageStatusView *) subView;
            break;
        }
    }
    return result;
}

- (BOOL)canBecomeFirstResponder {
    return YES;
}

- (void)showInView:(UIView *)view {
        self.translatesAutoresizingMaskIntoConstraints = NO;
        // 如果是 UIScrollView 则复制它的约束并将 TZMPageStatusView 与 UIScrollView 同级
        if ([view isKindOfClass:UIScrollView.class]) {
            UIScrollView *scrollView = (UIScrollView *)view;
            UIView *superview = scrollView.superview;
            [superview insertSubview:self aboveSubview:scrollView];

            NSArray *superViewConstraints = superview.constraints;
            NSMutableArray *scrollViewConstraints = [NSMutableArray array];
            for (NSLayoutConstraint *con in superViewConstraints){
                if ( con.firstItem == scrollView || con.secondItem == scrollView ){
                    [scrollViewConstraints addObject:con];
                }
            }

            for (NSLayoutConstraint *con in scrollViewConstraints){
                if ( con.firstItem == scrollView )
                    [superview addConstraint:[NSLayoutConstraint constraintWithItem:self attribute:con.firstAttribute relatedBy:con.relation toItem:con.secondItem attribute:con.secondAttribute multiplier:con.multiplier constant:con.constant]];
                else {
                    [superview addConstraint:[NSLayoutConstraint constraintWithItem:con.firstItem attribute:con.firstAttribute relatedBy:con.relation toItem:self attribute:con.secondAttribute multiplier:con.multiplier constant:con.constant]];
                }
            }

            [superview layoutIfNeeded];

        }
        // 普通的 UIView 则占满整个
        else {
            [view addSubview:self];
            [self mas_makeConstraints:^(MASConstraintMaker *make) {
                make.edges.equalTo(view);
            }];
            [view layoutIfNeeded];
        }
}

- (void)dismiss {
    self.didClickButtonCallback = nil;
    [self removeFromSuperview];
}

- (IBAction)handleButtonEvent:(id)sender {
    if ( sender == self.buttonView ) {
        if (self.didClickButtonCallback){
            self.didClickButtonCallback(self.pageStatus);
        }
    }
}

- (void)dealloc {

}

@end
