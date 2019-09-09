//
//  TZMBlanketVC.h
//
//  Created by mayer on 16/5/12.
//
//

#import <UIKit/UIKit.h>

// 用子类继承该类，可以获得独立显示在一个 Window 的能力
// 所有继承自该类的 VC 调用 show 都将共用一个队列用来显示自己，后调用的会显示在屏幕上
// 调用 close 方法后会将自己从队列中移除，同时会将队列中最后一个 VC 显示出来
@interface TZMBlanketVC : UIViewController
@property (assign, nonatomic) BOOL enableAroundClose; //开启点击周围关闭该视图的功能,默认 YES
@property (nonatomic, copy) void(^didCallShowCallback)(TZMBlanketVC *vc); //显示方法被调用
@property (nonatomic, copy) void(^didCallCloseCallback)(TZMBlanketVC *vc); //关闭方法被掉用
- (void)show;
- (IBAction)close;

@property (strong,nonatomic) UIButton *closeBtn;
@end
