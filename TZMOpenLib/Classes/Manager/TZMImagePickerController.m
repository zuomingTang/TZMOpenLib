//
//  TZMImagePickerController.m
//  SmartHome
//
//  Created by gemdale on 2018/9/26.
//  Copyright © 2018年 gemdale. All rights reserved.
//

#import "TZMImagePickerController.h"

@interface TZMImagePickerController ()<UINavigationControllerDelegate, UIImagePickerControllerDelegate>
@end

@implementation TZMImagePickerController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.delegate = self;
}

-(void)dealloc{
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    [picker dismissViewControllerAnimated:YES completion:nil];
    if (self.block) {
        self.block(info);
    }
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [picker dismissViewControllerAnimated:YES completion:nil];
    if (self.block) {
        self.block(nil);
    }
}
@end
