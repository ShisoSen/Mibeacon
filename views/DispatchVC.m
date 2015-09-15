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

static float circleHeight = 100.0f;
@interface MaskViewTop : UIView

@end
@implementation MaskViewTop
- (void)drawRect:(CGRect)rect{
    CGContextRef context=UIGraphicsGetCurrentContext();
    CGRect bounds = self.bounds;
    CGRect upRect = CGRectMake(0, 0, bounds.size.width, bounds.size.height-circleHeight/2);
    CGRect downRect = CGRectMake(0, bounds.size.height-circleHeight/2, bounds.size.width, circleHeight/2);
    
    CGContextAddRect(context, upRect);
    [[UIColor colorWithRed:0.524 green:1.000 blue:0.626 alpha:1.000] set];
    CGContextDrawPath(context, kCGPathFillStroke);
    CGContextAddRect(context, downRect);
    [[UIColor colorWithRed:0.787 green:0.975 blue:1.000 alpha:1.000] set];
    CGContextDrawPath(context, kCGPathFillStroke);
    
}

@end

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
    float spacing = 2.0f;
    UIButton *startBt = [[UIButton alloc] initWithFrame:CGRectMake(self.insets.left, self.insets.top, formView.frame.size.width, formViewHeight/2-self.insets.top-spacing/2)];
    startBt.tintColor = [UIColor whiteColor];
    startBt.backgroundColor = [UIColor colorWithRed:1.000 green:0.617 blue:0.218 alpha:1.000];
    [startBt.layer setCornerRadius:10];
    [startBt setTitle:@"click me" forState:UIControlStateNormal];
    [startBt addTarget:self action:@selector(startBtAction:) forControlEvents:UIControlEventTouchUpInside];
    [formView addSubview:startBt];
    
    maskViewTop = [[MaskViewTop alloc] initWithFrame:CGRectMake(self.insets.left, self.insets.top, controlView.frame.size.width, controlView.frame.size.height-maskViewBottomHeight)];
    maskViewTop.backgroundColor = [UIColor colorWithRed:0.828 green:1.000 blue:0.997 alpha:1.000];
    [self.view addSubview:maskViewTop];
    CALayer *circle = [[CALayer alloc] init];
    circle.bounds = CGRectMake(0, 0, circleHeight, circleHeight);
    circle.position = CGPointMake(maskViewTop.bounds.size.width/2, maskViewTop.bounds.size.height-circleHeight/2);
    circle.backgroundColor = [UIColor colorWithRed:0.298 green:1.000 blue:0.671 alpha:1.000].CGColor;
    circle.cornerRadius = circleHeight/2;
    circle.masksToBounds = YES;
    circle.borderColor = [UIColor whiteColor].CGColor;
    circle.borderWidth = 2;
    circle.delegate = self;
    [maskViewTop.layer addSublayer:circle];
    [circle setNeedsDisplay];
    
    maskViewBottom = [[UIView alloc] initWithFrame:CGRectMake(self.insets.left, maskViewTop.frame.origin.y+maskViewTop.frame.size.height, maskViewTop.frame.size.width, maskViewBottomHeight)];
    maskViewBottom.backgroundColor = [UIColor colorWithRed:0.787 green:0.975 blue:1.000 alpha:1.000];
    [self.view addSubview:maskViewBottom];
    
}
- (void)drawLayer:(CALayer *)layer inContext:(CGContextRef)ctx{
    CGContextSaveGState(ctx);
    
    //图形上下文形变，解决图片倒立的问题
    CGContextScaleCTM(ctx, 1, -1);
    CGContextTranslateCTM(ctx, 0, -circleHeight);
    
    UIImage *image=[UIImage imageNamed:@"10.jpg"];
    
//    CIFilter *blurFilter =
//    [CIFilter filterWithName:@"CIGaussianBlur"];
//    [blurFilter setValue:[CIImage imageWithCGImage:image.CGImage] forKey:@"inputImage"];
//    [blurFilter setDefaults];
//    [blurFilter setValue:[NSNumber numberWithFloat:5.0f] forKey:@"inputRadius"];
//    CIImage *outputImage= [blurFilter outputImage];//取得输出图像
//    CIContext *_context=[CIContext contextWithOptions:nil];
//    CGImageRef temp=[_context createCGImage:outputImage fromRect:[outputImage extent]];
    
    //注意这个位置是相对于图层而言的不是屏幕
    CGContextDrawImage(ctx, CGRectMake(0, 0, circleHeight, circleHeight), image.CGImage);
    
    //    CGContextFillRect(ctx, CGRectMake(0, 0, 100, 100));
    //    CGContextDrawPath(ctx, kCGPathFillStroke);
    
    CGContextRestoreGState(ctx);
}
- (void)MoreAction:(id)sender{
    SenderVC *senderVC = [[SenderVC alloc] initWithNibName:nil bundle:nil];
    [self.navigationController pushViewController:senderVC foldStyle:MPFoldStyleUnfold];
}
- (void)startBtAction:(id)sender{
    NSLog(@"startBtAction");
    if (maskViewTop.center.y<0) {
        [UIView animateWithDuration:0.2 animations:^{
            maskViewTop.frame = CGRectMake(self.insets.left, self.insets.top, controlView.frame.size.width, controlView.frame.size.height-maskViewBottomHeight);
        }];
    }else{
        [UIView animateWithDuration:0.2 animations:^{
            maskViewTop.center = CGPointMake(maskViewTop.center.x, circleHeight/2-maskViewTop.frame.size.height/2);
        }];
    }
}
@end
