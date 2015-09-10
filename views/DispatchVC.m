//
//  DispatchVC.m
//  MiBeacon
//
//  Created by Sicong Qian on 15/9/10.
//  Copyright (c) 2015年 silverup.co. All rights reserved.
//

#import "DispatchVC.h"
#import "MPFoldTransition.h"
#import "SenderVC.h"

@implementation DispatchVC

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
    self.navigationItem.title = @"Dispatch";
    UIBarButtonItem *moreItem = [[UIBarButtonItem alloc] initWithTitle:@"More" style:UIBarButtonItemStyleBordered target:self action:@selector(MoreAction:)];
    moreItem.tintColor = [UIColor whiteColor];
    self.navigationItem.rightBarButtonItem = moreItem;
}

- (void)MoreAction:(id)sender{
    SenderVC *senderVC = [[SenderVC alloc] initWithNibName:nil bundle:nil];
    [self.navigationController pushViewController:senderVC foldStyle:MPFoldStyleUnfold];
}
@end
