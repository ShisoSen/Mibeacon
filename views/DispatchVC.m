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

float const formViewHeight = 150.0f;
float const maskViewBottomHeight = 80.0f;
@interface DispatchVC()
@property (nonatomic, assign) UIEdgeInsets insets;

@end

@implementation DispatchVC{
    UIView *maskViewTop;
    UIView *maskViewBottom;
    UIView *controlView;
    UIView *formView;
}

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.insets = UIEdgeInsetsMake(2, 1, 1, 1);
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
    
    [self makeLayout];
}

- (void)makeLayout{
    CGRect frame = self.view.frame;
    controlView = [[UIView alloc] initWithFrame:CGRectMake(self.insets.left, self.insets.top, frame.size.width-self.insets.left-self.insets.right, frame.size.height-69-formViewHeight-self.insets.top-self.insets.bottom)];
    controlView.backgroundColor = [UIColor colorWithRed:0.787 green:0.975 blue:1.000 alpha:1.000];
    [[controlView layer] setCornerRadius:10];
    [self.view addSubview:controlView];
    
    formView = [[UIView alloc] initWithFrame:CGRectMake(self.insets.left,frame.size.height-69-formViewHeight+self.insets.top, frame.size.width-self.insets.left-self.insets.right, formViewHeight-self.insets.top-self.insets.bottom)];
    formView.backgroundColor = [UIColor colorWithRed:0.517 green:0.380 blue:1.000 alpha:1.000];
    [[formView layer] setCornerRadius:10];
    [self.view addSubview:formView];
    
    maskViewTop = [[UIView alloc] initWithFrame:CGRectMake(self.insets.left, self.insets.top, controlView.frame.size.width, controlView.frame.size.height-maskViewBottomHeight)];
    maskViewTop.backgroundColor = [UIColor colorWithRed:0.828 green:1.000 blue:0.997 alpha:1.000];
    [self.view addSubview:maskViewTop];
    maskViewBottom = [[UIView alloc] initWithFrame:CGRectMake(self.insets.left, maskViewTop.frame.origin.y+maskViewTop.frame.size.height, maskViewTop.frame.size.width, maskViewBottomHeight)];
    maskViewBottom.backgroundColor = [UIColor grayColor];
    [self.view addSubview:maskViewBottom];
}
- (void)MoreAction:(id)sender{
    SenderVC *senderVC = [[SenderVC alloc] initWithNibName:nil bundle:nil];
    [self.navigationController pushViewController:senderVC foldStyle:MPFoldStyleUnfold];
}
@end
