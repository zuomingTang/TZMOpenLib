//
//  TZMTabBar.h

#import <UIKit/UIKit.h>

@interface TZMTabBar : UITabBar
@property(nonatomic, weak) UITabBarController *tabBarController;
@property(nonatomic,assign) NSUInteger selectedIndex;
@property(nonatomic,strong) UIButton *centreBut;         //centreBut是tabbar中央自定义按钮,若传空则没有按钮
@end
