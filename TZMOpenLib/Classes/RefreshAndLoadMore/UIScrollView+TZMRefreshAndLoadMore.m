//
// UIScrollView+TZMRefreshAndLoadMore.m

#import "UIScrollView+TZMRefreshAndLoadMore.h"

//#pragma clang diagnostic push
//#pragma ide diagnostic ignored "InfiniteRecursion"


@interface UIScrollView (_TZMRefreshAndLoadMore)
@property (readwrite, nonatomic, strong) TZMPullToRefresh *tzm_refreshControl;
@property (readwrite, nonatomic, strong) TZMLoadMoreRefreshControl *tzm_loadMoreControl;
@end

@implementation UIScrollView (TZMRefreshAndLoadMore)

SYNTHESIZE_ASC_PRIMITIVE(simultaneouslyGesture, setSimultaneouslyGesture, BOOL);
SYNTHESIZE_ASC_PRIMITIVE(closeBounceTop, setCloseBounceTop, BOOL);
SYNTHESIZE_ASC_PRIMITIVE(closeBounceBottom, setCloseBounceBottom, BOOL);
SYNTHESIZE_ASC_PRIMITIVE(lockFrame, setLockFrame, BOOL);

+ (void)load {
    [self swizzleInstanceMethod:@selector(removeFromSuperview) with:@selector(tzm_removeFromSuperview)];
    [self swizzleInstanceMethod:@selector(setContentOffset:) with:@selector(tzm_setContentOffset:)];
}

- (void)tzm_removeFromSuperview {
    [self freeDropDownRefreshControl];
    [self freeLoadMoreRefreshControl];
    [self tzm_removeFromSuperview];
}

-(void)tzm_setContentOffset:(CGPoint)contentOffset{
    if (self.lockFrame) {
        [self tzm_setContentOffset:self.contentOffset];
        return;
    }
    if (self.closeBounceTop) {
        if (contentOffset.y < 0) {
            contentOffset.y = 0;
        }
    }
    if (self.closeBounceBottom) {
        CGFloat maxY = self.contentSize.height - self.frame.size.height;
        maxY = maxY > 0 ? maxY : 0;
        if (contentOffset.y > maxY) {
            contentOffset.y = maxY;
        }
    }
    [self tzm_setContentOffset:contentOffset];
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer{
    return self.simultaneouslyGesture;
}

-(TZMPullToRefresh *)tzm_refreshControl{
    return objc_getAssociatedObject(self, @selector(tzm_refreshControl));
}

- (void)setTzm_refreshControl:(TZMPullToRefresh *)tzm_refreshControl{
    objc_setAssociatedObject(self, @selector(tzm_refreshControl), tzm_refreshControl, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

-(TZMLoadMoreRefreshControl *)tzm_loadMoreControl{
    return objc_getAssociatedObject(self, @selector(tzm_loadMoreControl));
}

-(void)setTzm_loadMoreControl:(TZMLoadMoreRefreshControl *)tzm_loadMoreControl{
    objc_setAssociatedObject(self, @selector(tzm_loadMoreControl), tzm_loadMoreControl, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)freeDropDownRefreshControl {
    if ( self.tzm_refreshControl) {
        [self.tzm_refreshControl removeFromSuperview];
        self.tzm_refreshControl = nil;
    }
}

- (void)freeLoadMoreRefreshControl {
    if ( self.tzm_loadMoreControl) {
        [self.tzm_loadMoreControl endRefreshing];
        [self.tzm_loadMoreControl removeTarget:self action:@selector(handleRefreshControlEvent:) forControlEvents:UIControlEventValueChanged];
        [self.tzm_loadMoreControl removeFromSuperview];
        self.tzm_loadMoreControl = nil;
    }
}

-(void)setTzm_enabledRefreshControl:(BOOL)tzm_enabledRefreshControl{
    if (tzm_enabledRefreshControl){
        // free
        [self freeDropDownRefreshControl];
        // new
        
        __weak typeof(self)weakSelf = self;
        self.tzm_refreshControl = [self addPullToRefreshPosition:TZMPullToRefreshPositionTop actionHandler:^(TZMPullToRefresh *v) {
            [weakSelf handleRefreshControlEvent:v];
        }];
    } else {
        [self freeDropDownRefreshControl];
    }
}

- (BOOL)tzm_enabledRefreshControl {
    return self.tzm_refreshControl != nil;
}

-(void)setTzm_enabledLoadMoreControl:(BOOL)tzm_enabledLoadMoreControl{
    if (tzm_enabledLoadMoreControl){
        // free
        [self freeLoadMoreRefreshControl];
        // new
        self.tzm_loadMoreControl = [TZMLoadMoreRefreshControl new];
        [self.tzm_loadMoreControl addTarget:self action:@selector(handleRefreshControlEvent:) forControlEvents:UIControlEventValueChanged];
        [self addSubview:self.tzm_loadMoreControl];
    } else {
        [self freeLoadMoreRefreshControl];
    }
}

-(BOOL)tzm_enabledLoadMoreControl{
    return self.tzm_loadMoreControl != nil;
}

- (void)handleRefreshControlEvent:(id)sender {
    if ( sender == self.tzm_refreshControl ) {
        self.tzm_loadMoreControl.hidden = YES;
        if ( self.delegate && [self.delegate respondsToSelector:@selector(tzm_scrollViewRefresh:refreshControl:)]){
            [self.delegate performSelector:@selector(tzm_scrollViewRefresh:refreshControl:) withObject:self withObject:self.tzm_refreshControl];
        }
    } else if ( sender == self.tzm_loadMoreControl ) {
        if ( self.delegate && [self.delegate respondsToSelector:@selector(tzm_scrollViewLoadMore:LoadMoreControl:)]){
            [self.delegate performSelector:@selector(tzm_scrollViewLoadMore:LoadMoreControl:) withObject:self withObject:self.tzm_loadMoreControl];
        }
    }
}

@end
#pragma clang diagnostic pop
