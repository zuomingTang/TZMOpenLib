//
// Created by mayer on 14-6-27.
//


#import "TZMLoadMoreRefreshControl.h"

#define kLoadMoreRefreshControlHeight (50)
#define kLoadMoreRefreshControlMaxOffsetY (-0)

@interface TZMLoadMoreRefreshControl()
@property (weak, nonatomic) UIScrollView * scrollView;
@property (nonatomic, readwrite) BOOL refreshing;
@end
@implementation TZMLoadMoreRefreshControl

- (id)init {
    self = [super init];
    if ( self ){

        //self.backgroundColor = [UIColor redColor];
        self.enabled = YES;
        self.hidden = YES;
        self.refreshing = NO;

        self.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, kLoadMoreRefreshControlHeight);

        [self addSubview:self.activityIndicatorView];

    }
    return self;
}

- (UIView *)activityIndicatorView {
    if ( _activityIndicatorView == nil){
        _activityIndicatorView = [UIActivityIndicatorView new];
        [_activityIndicatorView sizeToFit];
    }
    return _activityIndicatorView;
}

- (void)removeFromSuperview{
    [self removeObserverFromScrollView];
    [super removeFromSuperview];
}

- (void)willMoveToSuperview:(UIView *)newSuperview {
    [super willMoveToSuperview:newSuperview];
    if ([newSuperview isKindOfClass:UIScrollView.class]){
        self.scrollView = (UIScrollView *) newSuperview;
        [self addObserverFromScrollView];
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.activityIndicatorView.frame = self.bounds;
}

#pragma mark -

- (void)addObserverFromScrollView {
    [self.scrollView addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew context:nil];
    [self.scrollView addObserver:self forKeyPath:@"contentInset" options:NSKeyValueObservingOptionNew context:nil];
}

- (void)removeObserverFromScrollView {
    [self.scrollView removeObserver:self forKeyPath:@"contentOffset"];
    [self.scrollView removeObserver:self forKeyPath:@"contentInset"];
}

#pragma mark -

- (void)beginRefreshing {
    __weak typeof(self) weakSelf = self;
    void (^block)(void) = ^{
        if ( !weakSelf.refreshing ){
            weakSelf.refreshing = YES;
            [weakSelf removeObserverFromScrollView];
            weakSelf.hidden = NO;

            CGPoint offset = weakSelf.scrollView.contentOffset;
            UIEdgeInsets inset = weakSelf.scrollView.contentInset;
            CGSize contentSize = weakSelf.scrollView.contentSize;
            inset.bottom += kLoadMoreRefreshControlHeight;
            weakSelf.scrollView.contentInset = inset;
            weakSelf.scrollView.contentOffset = offset;

            weakSelf.frame = CGRectMake(0, contentSize.height, contentSize.width, kLoadMoreRefreshControlHeight);
            [weakSelf sendActionsForControlEvents:UIControlEventValueChanged];
        }
    };
    if ([NSThread isMainThread]){
        block();
    } else {
        dispatch_sync(dispatch_get_main_queue(), block);
    }
}

- (void)endRefreshing {
    __weak typeof(self) weakSelf = self;
    void (^block)(void) = ^{
        if ( weakSelf.refreshing ) {
            [weakSelf addObserverFromScrollView];
            weakSelf.hidden = YES;
            CGPoint offset = weakSelf.scrollView.contentOffset;
            UIEdgeInsets inset = weakSelf.scrollView.contentInset;
            inset.bottom -= kLoadMoreRefreshControlHeight;
            weakSelf.scrollView.contentInset = inset;
            weakSelf.scrollView.contentOffset = offset;
            weakSelf.refreshing = NO;
        }
    };
    if ([NSThread isMainThread]){
        block();
    } else {
        dispatch_sync(dispatch_get_main_queue(), block);
    }
}

- (void)free {
    [self removeFromSuperview];
}

#pragma mark - KVO

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if ( !self.enabled || self.refreshing) {
        return;
    }

    if ([keyPath isEqualToString:@"contentOffset"]) {

        UIScrollView *scrollView = (UIScrollView *)object;
        CGFloat boundsHeight = scrollView.bounds.size.height;
        CGFloat contentHeight = scrollView.contentSize.height;
        if ( contentHeight < boundsHeight) {
            return;
        }

        CGFloat offset = scrollView.contentOffset.y;
        CGFloat insetBottom = scrollView.contentInset.bottom;

        if((offset + boundsHeight + insetBottom - contentHeight) > kLoadMoreRefreshControlMaxOffsetY) {
            [self beginRefreshing];
        }
    }
}

@end
