//
//  ScanVC.m
//  MiBeacon
//
//  Created by Sicong Qian on 15/9/14.
//  Copyright (c) 2015年 silverup.co. All rights reserved.
//

#import "ScanVC.h"

@interface DrawView : UIView

@end
@implementation DrawView

- (void)drawRect:(CGRect)rect{
    UIBezierPath* p = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(0,0,100,100)];
    
    [[UIColor blueColor] setFill];
    
    [p fill];
}

@end

@implementation ScanVC

- (void)viewDidLoad{
    [super viewDidLoad];
    DrawView *drawView = [[DrawView alloc] initWithFrame:self.view.bounds];
    self.view = drawView;
}
@end
