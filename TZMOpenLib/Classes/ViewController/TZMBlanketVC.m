//
//  TZMBlanketVC.m
//
//  Created by mayer on 16/5/12.
//
//

#import "TZMBlanketVC.h"

@interface TZMBlanketVC ()
@end

// 遮罩管理器
@interface TZMBlanketVCManger : NSObject
@property (nonatomic, strong) NSMutableArray<UIWindow *> *showWindowQueue; //需要显示的Window 的队列
@property (atomic, strong) UIWindow *currentShowWindow; //当前正在显示的Window
+ (instancetype)shared;
- (void)showBlanketVC:(TZMBlanketVC *)blanketVC;
- (void)closeBlanketVC:(TZMBlanketVC *)blanketVC;
@end
@implementation TZMBlanketVCManger
+ (instancetype)shared {
    static id _shared = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _shared = [self.class new];
    });
    return _shared;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        self.showWindowQueue = [NSMutableArray array];
    }
    return self;
}

- (UIWindow *)makeWindowByVC:(TZMBlanketVC *)blanketVC {
    UIWindow *window;

    for(UIWindow *win in self.showWindowQueue){
        if(win.rootViewController == blanketVC){
            window = win;
            break;
        }
    }

    if (!window) {
        window = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
        window.windowLevel = UIWindowLevelStatusBar + 1;
        window.backgroundColor = [UIColor clearColor];
        window.rootViewController = blanketVC;
    }

    return window;
}

- (void)showBlanketVC:(TZMBlanketVC *)blanketVC {
    __weak typeof(self) wself = self;
    UIWindow *window = [self makeWindowByVC:blanketVC];

    // 当前已经在显示,不处理
    if(self.currentShowWindow != window) {
        // 先移除队列
        [self.showWindowQueue removeObject:window];

        // 如果当前有在显示的则继续排队
        if(self.currentShowWindow != nil) {
            [self.showWindowQueue addObject:window];
        }
        // 否则显示出来
        else {
            wself.currentShowWindow = window;
            window.alpha = 0;
            window.userInteractionEnabled = NO;
            [window makeKeyAndVisible];
            [UIView animateWithDuration:0.2f animations:^{
                window.alpha = 1;
            } completion:^(BOOL finished) {
                window.userInteractionEnabled = YES;
            }];

        }
    }

}
- (void)closeBlanketVC:(TZMBlanketVC *)blanketVC {
    __weak typeof(self) wself = self;
    UIWindow *window;
    for(UIWindow *win in self.showWindowQueue){
        if(win.rootViewController == blanketVC){
            window = win;
            break;
        }
    }

    if( self.currentShowWindow.rootViewController == blanketVC){
        window = self.currentShowWindow;
    }

    if( window ) {

        window.userInteractionEnabled = NO;

        // 如果是当前在显示的则做动画消失,否则直接移除
        if(self.currentShowWindow){
            [UIView animateWithDuration:0.2f animations:^{
                window.alpha = 0;
            } completion:^(BOOL finished) {
                // 移除
                window.rootViewController = nil;
                wself.currentShowWindow = nil;
                [wself.showWindowQueue removeObject:window];

                // 判断是否还有排队的
                if(wself.showWindowQueue.count > 0){
                    // 有则显示出来
                    TZMBlanketVC *lastBlanketVC = (TZMBlanketVC *) [wself.showWindowQueue.lastObject rootViewController];
                    [wself showBlanketVC:lastBlanketVC];
                }
            }];
        } else {
            // 移除
            window.rootViewController = nil;
            [wself.showWindowQueue removeObject:window];
        }

    }
}


@end

@implementation TZMBlanketVC

-(instancetype)init{
    self = [super init];
    if (self) {
        [self initSelf];
    }
    return self;
}

-(instancetype)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self initSelf];
    }
    return self;
}

-(instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [self initSelf];
    }
    return self;
}

-(void)initSelf{
    self.closeBtn = [UIButton new];
    self.enableAroundClose = YES;
}

- (void)setEnableAroundClose:(BOOL)enableAroundClose {
    _enableAroundClose = enableAroundClose;
    self.closeBtn.userInteractionEnabled = enableAroundClose;
}

- (void)show{
    [[TZMBlanketVCManger shared] showBlanketVC:self];
    if(self.didCallShowCallback)self.didCallShowCallback(self);
}

- (IBAction)close{
    [[TZMBlanketVCManger shared] closeBlanketVC:self];
    if(self.didCallCloseCallback)self.didCallCloseCallback(self);
}

- (UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.closeBtn addTarget:self action:@selector(close) forControlEvents:UIControlEventTouchUpInside];
    [self.view insertSubview:self.closeBtn atIndex:0];
    __weak typeof(self) wself = self;
    [self.closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(wself.view);
    }];
}

-(void)dealloc{
    
}

@end
