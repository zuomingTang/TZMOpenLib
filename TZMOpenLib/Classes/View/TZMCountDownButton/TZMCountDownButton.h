//
//  TZMCountDownButton.h
//
//  Created by mayer on 2018/5/10.
//  Copyright © 2018年 mayer. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TZMCountDownButton : UIButton

@property (nonatomic , strong) dispatch_source_t timer_t;

/**
 *  获取短信验证码倒计时
 *
 *  @param duration 倒计时时间
 */
- (void)startTimeWithDuration:(NSInteger)duration;

@end
