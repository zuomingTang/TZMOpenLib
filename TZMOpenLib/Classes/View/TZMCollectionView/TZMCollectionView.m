//
//  TZMCollectionView.m
//
//  Created by mayer on 2018/8/31.
//  Copyright © 2018年 mayer. All rights reserved.
//

#import "TZMCollectionView.h"
#import <UIScrollView+TZMRefreshAndLoadMore.h>

@interface TZMCollectionView()
@property(nonatomic,strong)UILongPressGestureRecognizer *longPress;
@property(nonatomic,assign)BOOL tzmLoadMoreControlEnabled;
@property(nonatomic,assign)BOOL movementing;
@end

@implementation TZMCollectionView
-(instancetype)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if (self) {
        self.longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(lonePressMoving:)];
        [self addGestureRecognizer:self.longPress];
    }
    return self;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer{
    if (self.movementing) {
        return NO;
    }
    return self.simultaneouslyGesture;
}

- (void)lonePressMoving:(UILongPressGestureRecognizer *)longPress{
    if (@available(iOS 9.0, *)){
        switch (self.longPress.state) {
            case UIGestureRecognizerStateBegan: {
                NSIndexPath *indexPath = [self indexPathForItemAtPoint:[longPress locationInView:self]];
                if (indexPath == nil) {
                    break;
                }
                self.movementing = YES;
                [self beginInteractiveMovementForItemAtIndexPath:indexPath];
                break;
            }
            case UIGestureRecognizerStateChanged: {
                [self updateInteractiveMovementTargetPosition:[longPress locationInView:self]];
                break;
            }
            case UIGestureRecognizerStateEnded: {
                [self updateInteractiveMovementTargetPosition:[longPress locationInView:self]];
                self.movementing = NO;
                [self endInteractiveMovement];
                break;
            }
            default:
                [self cancelInteractiveMovement];
                self.movementing = NO;
                break;
        }
    }
}
@end
