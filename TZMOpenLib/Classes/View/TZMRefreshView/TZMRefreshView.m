//
//  TZMRefreshView.m
//
//  Created by mayer on 2018/8/31.
//  Copyright © 2018年 mayer. All rights reserved.
//

#import "TZMRefreshView.h"

@interface TZMRefreshView()
@property (weak, nonatomic) IBOutlet UILabel *lblText;
@property (weak, nonatomic) IBOutlet UIButton *btnRefresh;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *aiView;
@end

@implementation TZMRefreshView
-(void)setText:(NSString *)text{
    _text = text;
    self.lblText.text = text;
}

- (IBAction)touchRefresh:(id)sender {
    [self startRefrsh];
    if (self.block) {
        self.block();
    }
}

-(void)endRefrsh{
    self.btnRefresh.hidden = NO;
    self.lblText.hidden = NO;
    self.aiView.hidden = YES;
    [self.aiView stopAnimating];
}

-(void)startRefrsh{
    self.btnRefresh.hidden = YES;
    self.lblText.hidden = YES;
    self.aiView.hidden = NO;
    [self.aiView startAnimating];
}

+ (id)xx_instantiateFromNibInBundle:(NSBundle *)bundle owner:(id)owner {
    bundle = [NSBundle bundleForClass:[TZMRefreshView class]];
    bundle = [NSBundle bundleWithURL:[bundle URLForResource:@"View" withExtension:@"bundle"]];
    NSArray *views = [bundle loadNibNamed:@"TZMRefreshView" owner:nil options:nil];
    for (UIView *view in views) {
        if ([view isMemberOfClass:self.class]) {
            return view;
        }
    }
    NSAssert(NO, @"Expect file: %@", [NSString stringWithFormat:@"%@.xib", self.nibid]);
    return nil;
}

@end