#import <UIKit/UIKit.h>

typedef void (^actionHandler)(void);
typedef NS_ENUM(NSUInteger, TZMPullToRefreshState) {
    TZMPullToRefreshStateNormal = 0,
    TZMPullToRefreshStateStopped,
    TZMPullToRefreshStateLoading,
};
typedef NS_ENUM(NSUInteger, TZMPullToRefreshPosition) {
    TZMPullToRefreshPositionTop,
    TZMPullToRefreshPositionBottom,
    TZMPullToRefreshPositionLeft,
    TZMPullToRefreshPositionRight,
};

typedef NS_ENUM(NSUInteger, TZMPullToRefreshDropDownType) {
    TZMPullToRefreshDropDownTypeText,
    TZMPullToRefreshDropDownTypeImage,
};

@interface TZMPullToRefresh : UIView

@property (nonatomic, assign) CGFloat originalInsetTop;
@property (nonatomic, assign) CGFloat originalInsetBottom;
@property (nonatomic, assign, readonly) TZMPullToRefreshPosition position;
@property (nonatomic, weak) UIScrollView *scrollView;
@property (nonatomic, copy) void (^pullToRefreshHandler)(TZMPullToRefresh *v);
@property (nonatomic, assign) BOOL isObserving;

// user customizable.
@property (nonatomic, assign) BOOL showPullToRefresh;
@property (nonatomic, assign) CGFloat threshold;

@property (nonatomic, assign) TZMPullToRefreshDropDownType dropDownType;    //下拉样式，默认为文字

@property (nonatomic, strong) UIColor *textColor;

//dropDownType = TZMPullToRefreshDropDownTypeImage 设置一下三个属性
@property (nonatomic, strong) UIImage *imageIcon;
@property (nonatomic, strong) UIColor *borderColor;
@property (nonatomic, assign) CGFloat borderWidth;

@property (nonatomic, strong) UIActivityIndicatorView *activityIndicatorView;

- (id)initWithImage:(UIImage *)image position:(TZMPullToRefreshPosition)position;
- (void)stopIndicatorAnimation;
- (void)manuallyTriggered;
- (void)setSize:(CGSize)size;

@end

@interface UIScrollView (TZMPullToRefresh)
- (TZMPullToRefresh *)addPullToRefreshPosition:(TZMPullToRefreshPosition)position actionHandler:(void (^)(TZMPullToRefresh *v))handler;
@end
