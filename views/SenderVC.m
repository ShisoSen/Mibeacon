//
//  SenderVC.m
//  MiBeacon
//
//  Created by Sicong Qian on 15/9/10.
//  Copyright (c) 2015年 silverup.co. All rights reserved.
//

#import "SenderVC.h"

@implementation SenderVC

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithRed:0.241 green:0.474 blue:1.000 alpha:1.000]];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    self.navigationController.navigationBar.translucent = false;
    self.navigationItem.title = @"SenderVC";
    
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(BackAction:)];
    backItem.tintColor = [UIColor whiteColor];
    self.navigationItem.leftBarButtonItem = backItem;
}

- (void)BackAction:(id)sender{
    [self dismissViewControllerAnimated:YES completion:^{
        NSLog(@"222");
    }];
}
@end
