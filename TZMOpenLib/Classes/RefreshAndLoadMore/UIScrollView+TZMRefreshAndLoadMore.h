//
// UIScrollView+TZMRefreshAndLoadMore.h

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <ObjcAssociatedObjectHelpers/ObjcAssociatedObjectHelpers.h>
#import <YYCategories/YYCategories.h>
#import "TZMPullToRefresh.h"
#import "TZMLoadMoreRefreshControl.h"

@protocol TZMScrollViewRefreshAndLoadMoreDelegate <UIScrollViewDelegate>
@optional
- (void)tzm_scrollViewRefresh:(UIScrollView *)scrollView refreshControl:(TZMPullToRefresh *)refreshControl; //下拉刷新事件变化
- (void)tzm_scrollViewLoadMore:(UIScrollView *)scrollView LoadMoreControl:(TZMLoadMoreRefreshControl *)loadMoreControl; //加载更多事件变化
@end

@interface UIScrollView (TZMRefreshAndLoadMore)<UIGestureRecognizerDelegate>
@property (nonatomic, assign) id delegate;

@property (assign, nonatomic) IBInspectable BOOL tzm_enabledRefreshControl; //是否启用下拉刷新控件
@property (readonly, nonatomic) TZMPullToRefresh *tzm_refreshControl; //下拉刷新控件

@property (assign, nonatomic) IBInspectable BOOL tzm_enabledLoadMoreControl; //是否启用加载更多控件
@property (readonly, nonatomic) TZMLoadMoreRefreshControl *tzm_loadMoreControl; // 加载更多控件

@property (assign, nonatomic) IBInspectable BOOL simultaneouslyGesture; //接收多个手势

@property (assign, nonatomic) IBInspectable BOOL closeBounceTop; //上方是否支持弹回
@property (assign, nonatomic) IBInspectable BOOL closeBounceBottom; //上方是否支持弹回

@property (assign, nonatomic) IBInspectable BOOL lockFrame; //是否禁止改变fram
@end
