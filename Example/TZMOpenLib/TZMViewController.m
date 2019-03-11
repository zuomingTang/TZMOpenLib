//
//  TZMViewController.m
//  TZMOpenLib
//
//  Created by zuomingTang on 03/06/2019.
//  Copyright (c) 2019 zuomingTang. All rights reserved.
//

#import "TZMViewController.h"
#import "UIViewController+TZMPageStatusViewEx.h"

@interface TZMViewController ()

@end

@implementation TZMViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self showPageStatus:TZMPageStatusNormal image:nil title:@"title" desc:@"desc" buttonText:@"button" didClickButtonCallback:^(TZMPageStatus status) {

    }];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
