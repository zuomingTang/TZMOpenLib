//
// Created by mayer on 15/3/22.
// Copyright (c) 2015 mayer. All rights reserved.
//


#import <UIKit/UIKit.h>
#import <Masonry/Masonry.h>

@class TZMPageStatusView;

typedef enum : NSInteger {
    TZMPageStatusNormal   = 0,  // 正常
    TZMPageStatusLoading  = 1,  // 正在加载中
} TZMPageStatus;

typedef void(^TZMPageStatusViewBlock)(TZMPageStatus status);

// 状态视图，不同状态展示不同
@interface TZMPageStatusView : UIView

@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@property (weak, nonatomic) IBOutlet UIView *viewBigLabel;
@property (weak, nonatomic) IBOutlet UILabel *labelViewBig;

@property (weak, nonatomic) IBOutlet UIView *viewLabel;
@property (weak, nonatomic) IBOutlet UILabel *labelView;

@property (weak, nonatomic) IBOutlet UIView *vieButton;
@property (weak, nonatomic) IBOutlet UIButton *buttonView;


@property (copy, nonatomic) TZMPageStatusViewBlock didClickButtonCallback;
@property (assign, nonatomic) TZMPageStatus pageStatus;

+ (instancetype)pageStatusView;
+ (instancetype)pageStatusViewInView:(UIView *)view;

// 显示到某个视图上
- (void)showInView:(UIView *)view;
// 从视图上移除
- (void)dismiss;

@end
