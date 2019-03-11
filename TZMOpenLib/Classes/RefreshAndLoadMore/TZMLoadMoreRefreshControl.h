//
// Created by mayer on 14-6-27.
//

#import <UIKit/UIKit.h>

@interface TZMLoadMoreRefreshControl : UIControl{
    UIView *_activityIndicatorView;
}

@property (nonatomic, readonly, getter=isRefreshing) BOOL refreshing;

- (UIView *)activityIndicatorView;

- (void)beginRefreshing;
- (void)endRefreshing;

- (void)free;

@end
