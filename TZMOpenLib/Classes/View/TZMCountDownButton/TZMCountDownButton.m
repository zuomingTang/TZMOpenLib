//
//  TZMCountDownButton.m

#import "TZMCountDownButton.h"

@implementation TZMCountDownButton

/**
 *  获取短信验证码倒计时
 *
 *  @param duration 倒计时时间
 */

- (void)startTimeWithDuration:(NSInteger)duration {
    __block NSInteger timeout = duration;
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    self.timer_t = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    dispatch_source_set_timer(self.timer_t,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
    __weak typeof(self)weakSelf = self;
    __weak typeof(self.timer_t) weakTimer = self.timer_t;
    dispatch_source_set_event_handler(self.timer_t, ^{
        if(timeout <= 0) { //倒计时结束，关闭
            dispatch_source_cancel(weakTimer);
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置按钮为最初的状态
                weakSelf.titleLabel.text = @"重新发送";
                [weakSelf setTitle:@"重新发送" forState:UIControlStateNormal];
                weakSelf.layer.borderColor = [UIColor colorWithRed:64.0 / 256.0 green:144.0 / 256.0 blue:247.0 / 256.0 alpha:1].CGColor;
                [weakSelf setTitleColor:[UIColor colorWithRed:64.0 / 256.0 green:144.0 / 256.0 blue:247.0 / 256.0 alpha:1] forState:UIControlStateNormal];
                if (!weakSelf.enabled) {
                    weakSelf.enabled = YES;
                }
            });
        } else {
            dispatch_async(dispatch_get_main_queue(), ^{//根据自己需求设置倒计时显示
                NSInteger seconds = timeout % duration;
                if(seconds == 0) {
                    seconds = duration;
                }
                NSString *strTime = [NSString stringWithFormat:@"%.2ld", (long)seconds];
                weakSelf.titleLabel.text = [NSString stringWithFormat:@"%@s重试",strTime];
                [weakSelf setTitle:[NSString stringWithFormat:@"%@s重试",strTime] forState:UIControlStateNormal];
                weakSelf.layer.borderColor = [UIColor colorWithRed:222.0 / 256.0 green:222.0 / 256.0 blue:222.0 / 256.0 alpha:1].CGColor;
                [weakSelf setTitleColor:[UIColor colorWithRed:153.0 / 256.0 green:153.0 / 256.0 blue:153.0 / 256.0 alpha:1] forState:UIControlStateNormal];
                if (weakSelf.enabled) {
                    weakSelf.enabled = NO;
                }
                timeout--;
            });
        }
    });
    dispatch_resume(self.timer_t);
    
}

- (void)dealloc {
    //    NSLog(@"title : %@",self.titleLabel.text);
}

@end
