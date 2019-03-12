//
// Created by mayer on 16/1/3.
// Copyright (c) 2016 mayer. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, TZMButtonImageDirection) {
    TZMButtonImageDirectionLeft   = 0,
    TZMButtonImageDirectionTop    = 1,
    TZMButtonImageDirectionRight  = 2,
    TZMButtonImageDirectionBottom = 3,
};

@interface TZMButton : UIButton

@property (nonatomic) IBInspectable NSUInteger/*TZMButtonImageDirection*/ imageDirection;

@end
