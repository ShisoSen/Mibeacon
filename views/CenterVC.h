//
//  CenterVC.h
//  MiBeacon
//
//  Created by Sicong Qian on 15/9/7.
//  Copyright (c) 2015年 silverup.co. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GDFSlideController.h"

@interface CenterVC : UIViewController <GDFSlideControllerChild,GDFSlideControllerStatus>
@property (nonatomic,weak) GDFSlideController *sliderController;

@end
