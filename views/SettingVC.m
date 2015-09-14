//
//  SettingVC.m
//  MiBeacon
//
//  Created by Sicong Qian on 15/9/9.
//  Copyright (c) 2015年 silverup.co. All rights reserved.
//

#import "SettingVC.h"

@implementation SettingVC

- (void)viewDidLoad{
    [super viewDidLoad];
    [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithRed:0.241 green:0.474 blue:1.000 alpha:1.000]];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    self.navigationController.navigationBar.translucent = false;
    UIBarButtonItem *left = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStyleBordered target:self action:@selector(BackAction:)];
    left.tintColor = [UIColor whiteColor];
    self.navigationItem.leftBarButtonItem = left;
}

- (void)BackAction:(id)sender{
    [self dismissViewControllerAnimated:YES completion:^{
        NSLog(@"222");
    }];
}
@end
