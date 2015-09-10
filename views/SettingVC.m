//
//  SettingVC.m
//  MiBeacon
//
//  Created by Sicong Qian on 15/9/9.
//  Copyright (c) 2015年 silverup.co. All rights reserved.
//

#import "SettingVC.h"

@implementation SettingVC

- (QuickDialogController *)initWithRoot:(QRootElement *)rootElement{
    self = [super initWithRoot:rootElement];
    if (self) {
        
    }
    return self;
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    NSLog(@"%s",__func__);
    UIBarButtonItem *left = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStyleBordered target:self action:@selector(BackAction:)];
    self.navigationItem.leftBarButtonItem = left;
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    NSLog(@"%s",__func__);
}

- (void)BackAction:(id)sender{
    [self dismissViewControllerAnimated:YES completion:^{
        NSLog(@"222");
    }];
}
@end
