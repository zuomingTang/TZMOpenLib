//
//  TZMRefreshView.h
//
//  Created by mayer on 2018/8/31.
//  Copyright © 2018年 mayer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XXNibBridge/XXNibBridge.h>

//带文件，leading，和重试的加载视图
@interface TZMRefreshView : UIView <XXNibBridge>
@property(nonatomic,copy)NSString *text;
@property(nonatomic,strong)UIImage *image;
@property(nonatomic,copy)void(^block)(void);
-(void)endRefrsh;
-(void)startRefrsh;
@end
