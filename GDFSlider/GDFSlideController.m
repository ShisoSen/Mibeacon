//
//  GDFSlideController.m
//  GDFamily
//
//  Created by Sicong Qian on 15/6/19.
//  Copyright © 2015年 silverup.co. All rights reserved.
//

#import "GDFSlideController.h"

static const NSTimeInterval kGDFDrawerControllerAnimationDuration = 0.5;
static const CGFloat kGDFDrawerControllerOpeningAnimationSpringDamping = 0.7f;
static const CGFloat kGDFDrawerControllerOpeningAnimationSpringInitialVelocity = 0.1f;
static const CGFloat kGDFDrawerControllerClosingAnimationSpringDamping = 1.0f;
static const CGFloat kGDFDrawerControllerClosingAnimationSpringInitialVelocity = 0.5f;


@interface GDFSlideController () <UIGestureRecognizerDelegate>

@end

@implementation GDFSlideController{
    UIView *leftView;
    UIView *centerView;
    
    UITapGestureRecognizer *tapGestureRecognizer;
    UIPanGestureRecognizer *panGestureRecognizer;
    CGPoint panGestureStartLocation;
    
    
}
@synthesize leftViewController,centerViewController,LeftViewInitialOffset,ControllerDrawerDepth,enablePanGesture;

- (id)initWithLeftViewController:(UIViewController<GDFSlideControllerChild,GDFSlideControllerStatus> *)leftViewController_
            centerViewController:(UIViewController<GDFSlideControllerChild,GDFSlideControllerStatus> *)centerViewController_{
    if (!leftViewController_||!centerViewController_) {
        NSLog(@"do not accept nil params.");
        return nil;
    }
    self = [super init];
    if (self) {
        leftViewController = leftViewController_;
        centerViewController = centerViewController_;
        
        //initial offset
        LeftViewInitialOffset = -60.0f;
        ControllerDrawerDepth = [UIScreen mainScreen].bounds.size.width + LeftViewInitialOffset;
        enablePanGesture = YES;
        
        if ([leftViewController respondsToSelector:@selector(setSliderController:)]) {
            leftViewController.sliderController = self;
        }
        if ([centerViewController respondsToSelector:@selector(setSliderController:)]) {
            centerViewController.sliderController = self;
        }
    }
    return self;
}
-(void)setLeftViewInitialOffset:(CGFloat)LeftViewInitialOffset_{
    LeftViewInitialOffset = LeftViewInitialOffset_;
    ControllerDrawerDepth = [UIScreen mainScreen].bounds.size.width + LeftViewInitialOffset;
}
#pragma mark - Reloading/Replacing the center view controller

- (void)reloadCenterViewControllerUsingBlock:(void (^)(void))reloadBlock
{
    NSParameterAssert(self.drawerState == GDFDrawerControllerStateOpen);
    NSParameterAssert(centerViewController);
    
    [self willClose];
    
    CGRect f = centerView.frame;
    f.origin.x = self.view.bounds.size.width;
    
    [UIView animateWithDuration: kGDFDrawerControllerAnimationDuration / 2
                     animations:^{
                         centerView.frame = f;
                     }
                     completion:^(BOOL finished) {
                         // The center view controller is now out of sight
                         if (reloadBlock) {
                             reloadBlock();
                         }
                         // Finally, close the drawer
                         [self animateClosing];
                     }];
}

- (void)replaceCenterViewControllerWithViewController:(UIViewController<GDFSlideControllerChild,GDFSlideControllerStatus> *)viewController{
    NSParameterAssert(self.drawerState == GDFDrawerControllerStateOpen);
    NSParameterAssert(viewController);
    NSParameterAssert(centerView);
    NSParameterAssert(centerViewController);
    
    [self willClose];
    
    CGRect f = centerView.frame;
    f.origin.x = self.view.bounds.size.width;
    
    [centerViewController willMoveToParentViewController:nil];
    [UIView animateWithDuration: kGDFDrawerControllerAnimationDuration / 2
                     animations:^{
                         centerView.frame = f;
                     }
                     completion:^(BOOL finished) {
                         // The center view controller is now out of sight
                         
                         // Remove the current center view controller from the container
                         if ([centerViewController respondsToSelector:@selector(setSliderController:)]) {
                             centerViewController.sliderController = nil;
                         }
                         [centerViewController.view removeFromSuperview];
                         [centerViewController removeFromParentViewController];
                         
                         // Set the new center view controller
                         centerViewController = viewController;
                         if ([centerViewController respondsToSelector:@selector(setSliderController:)]) {
                             centerViewController.sliderController = self;
                         }
                         
                         // Add the new center view controller to the container
                         [self addCenterViewController];
                         
                         // Finally, close the drawer
                         [self animateClosing];
                     }];
}
- (void)replaceLeftViewControllerWithViewController:(UIViewController<GDFSlideControllerChild,GDFSlideControllerStatus> *)viewController{
    NSParameterAssert(self.drawerState == GDFDrawerControllerStateClosed);
    NSParameterAssert(viewController);
    NSParameterAssert(leftView);
    NSParameterAssert(leftViewController);
    
    CGRect f = leftView.frame;
    f.origin.x = self.view.bounds.size.width;
    
    [leftViewController willMoveToParentViewController:nil];
    [UIView animateWithDuration: kGDFDrawerControllerAnimationDuration / 2
                     animations:^{
                         leftView.frame = f;
                     }
                     completion:^(BOOL finished) {
                         // The left view controller is now out of sight
                         
                         // Remove the current left view controller from the container
                         if ([leftViewController respondsToSelector:@selector(setSliderController:)]) {
                             leftViewController.sliderController = nil;
                         }
                         [leftViewController.view removeFromSuperview];
                         [leftViewController removeFromParentViewController];
                         
                         // Set the new left view controller
                         leftViewController = viewController;
                         if ([leftViewController respondsToSelector:@selector(setSliderController:)]) {
                             leftViewController.sliderController = self;
                         }
                         
                         [self willOpen];
                         
                         // Finally, open the drawer
                         [self animateOpening];
                     }];
}
#pragma mark - Opening the drawer

- (void)open
{
    NSParameterAssert(self.drawerState == GDFDrawerControllerStateClosed);
    
    [self willOpen];
    
    [self animateOpening];
}
#pragma mark -GestureRecognizers
- (void)addCenterViewController{
    [self addChildViewController:self.centerViewController];
    self.centerViewController.view.frame = self.view.bounds;
    [centerView addSubview:self.centerViewController.view];
    [centerViewController didMoveToParentViewController:self];
}
- (void)setupGestureRecognizers{
    tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGestureRecognized:)];
    if (enablePanGesture) {
        panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGestureRecognized:)];
        panGestureRecognizer.maximumNumberOfTouches = 1;
        panGestureRecognizer.delegate = self;
        
        [centerView addGestureRecognizer:panGestureRecognizer];
    }
}
- (void)tapGestureRecognized:(UITapGestureRecognizer *)tapGestureRecognizer_{
    if (tapGestureRecognizer_.state == UIGestureRecognizerStateEnded) {
        if ([centerViewController respondsToSelector:@selector(slideControllerTapClose:)]) {
            [centerViewController slideControllerTapClose:self];
        }
        if ([leftViewController respondsToSelector:@selector(slideControllerTapClose:)]) {
            [leftViewController slideControllerTapClose:self];
        }
        [self close];
    }
}
- (void)removeClosingGestureRecognizers
{
    NSParameterAssert(centerView);
    if (enablePanGesture) {
        NSParameterAssert(panGestureRecognizer);
    }
    if (tapGestureRecognizer) {
        [centerView removeGestureRecognizer:tapGestureRecognizer];
    }
}
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer{
    NSParameterAssert([gestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]]);
    NSParameterAssert([gestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]]);
    CGPoint velocity = [(UIPanGestureRecognizer *)gestureRecognizer velocityInView:self.view];
    
    if (self.drawerState == GDFDrawerControllerStateClosed && velocity.x > 0.0f) {
        return YES;
    }
    else if (self.drawerState == GDFDrawerControllerStateOpen && velocity.x < 0.0f) {
        return YES;
    }
    
    return NO;
}
- (void)panGestureRecognized:(UIPanGestureRecognizer *)panGestureRecognizer_{
    UIGestureRecognizerState state = panGestureRecognizer_.state;
    CGPoint location = [panGestureRecognizer_ locationInView:self.view];
    CGPoint velocity = [panGestureRecognizer_ velocityInView:self.view];
    
    switch (state) {
            
        case UIGestureRecognizerStateBegan:
            panGestureStartLocation = location;
            if (self.drawerState == GDFDrawerControllerStateClosed) {
                [self willOpen];
            }
            else {
                [self willClose];
            }
            break;
            
        case UIGestureRecognizerStateChanged:
        {
            CGFloat delta = 0.0f;
            if (self.drawerState == GDFDrawerControllerStateOpening) {
                delta = location.x - panGestureStartLocation.x;
            }
            else if (self.drawerState == GDFDrawerControllerStateClosing) {
                delta = ControllerDrawerDepth - (panGestureStartLocation.x - location.x);
            }
            
            CGRect l = leftView.frame;
            CGRect c = centerView.frame;
            if (delta > ControllerDrawerDepth) {
                l.origin.x = 0.0f;
                c.origin.x = ControllerDrawerDepth;
            }
            else if (delta < 0.0f) {
                l.origin.x = LeftViewInitialOffset;
                c.origin.x = 0.0f;
            }
            else {
                // While the centerView can move up to kGDFDrawerControllerDrawerDepth points, to achieve a parallax effect
                // the leftView has move no more than LeftViewInitialOffset points
                l.origin.x = LeftViewInitialOffset
                - (delta * LeftViewInitialOffset) / ControllerDrawerDepth;
                
                c.origin.x = delta;
            }
            
            leftView.frame = l;
            centerView.frame = c;
            
            break;
        }
            
        case UIGestureRecognizerStateEnded:
            
            if (self.drawerState == GDFDrawerControllerStateOpening) {
                CGFloat centerViewLocation = centerView.frame.origin.x;
                if (centerViewLocation == ControllerDrawerDepth) {
                    // Open the drawer without animation, as it has already being dragged in its final position
                    [self setNeedsStatusBarAppearanceUpdate];
                    [self didOpen];
                }
                else if (centerViewLocation > self.view.bounds.size.width / 3
                         && velocity.x > 0.0f) {
                    // Animate the drawer opening
                    [self animateOpening];
                }
                else {
                    // Animate the drawer closing, as the opening gesture hasn't been completed or it has
                    // been reverted by the user
                    [self didOpen];
                    [self willClose];
                    [self animateClosing];
                }
                
            } else if (self.drawerState == GDFDrawerControllerStateClosing) {
                CGFloat centerViewLocation = centerView.frame.origin.x;
                if (centerViewLocation == 0.0f) {
                    // Close the drawer without animation, as it has already being dragged in its final position
                    [self setNeedsStatusBarAppearanceUpdate];
                    [self didClose];
                }
                else if (centerViewLocation < (2 * self.view.bounds.size.width) / 3
                         && velocity.x < 0.0f) {
                    // Animate the drawer closing
                    [self animateClosing];
                }
                else {
                    // Animate the drawer opening, as the opening gesture hasn't been completed or it has
                    // been reverted by the user
                    [self didClose];
                    
                    // Here we save the current position for the leftView since
                    // we want the opening animation to start from the current position
                    // and not the one that is set in 'willOpen'
                    CGRect l = leftView.frame;
                    [self willOpen];
                    leftView.frame = l;
                    
                    [self animateOpening];
                }
            }
            break;
            
        default:
            break;
    }
}
- (void)addClosingGestureRecognizers
{
    NSParameterAssert(centerView);
    if (enablePanGesture) {
        NSParameterAssert(panGestureRecognizer);
    }
    if (tapGestureRecognizer) {
        [centerView addGestureRecognizer:tapGestureRecognizer];
    }
}
#pragma mark -SlideControllerStatus
- (void)willOpen
{
    NSParameterAssert(self.drawerState == GDFDrawerControllerStateClosed);
    NSParameterAssert(leftView);
    NSParameterAssert(centerView);
    NSParameterAssert(leftViewController);
    NSParameterAssert(centerViewController);
    
    // Keep track that the drawer is opening
    self.drawerState = GDFDrawerControllerStateOpening;
    
    // Position the left view
    CGRect f = self.view.bounds;
    f.origin.x = LeftViewInitialOffset;
    NSParameterAssert(f.origin.x < 0.0f);
    leftView.frame = f;
    
    // Start adding the left view controller to the container
    [self addChildViewController:leftViewController];
    leftViewController.view.frame = leftView.bounds;
    [leftView addSubview:leftViewController.view];
    
    // Add the left view to the view hierarchy
    [self.view insertSubview:leftView belowSubview:centerView];
    
    // Notify the child view controllers that the drawer is about to open
    if ([leftViewController respondsToSelector:@selector(slideControllerWillOpen:)]) {
        [leftViewController slideControllerWillOpen:self];
    }
    if ([centerViewController respondsToSelector:@selector(slideControllerWillOpen:)]) {
        [centerViewController slideControllerWillOpen:self];
    }
}
- (void)didOpen
{
    NSParameterAssert(self.drawerState == GDFDrawerControllerStateOpening);
    NSParameterAssert(leftViewController);
    NSParameterAssert(centerViewController);
    
    // Complete adding the left controller to the container
    [self.leftViewController didMoveToParentViewController:self];
    
    [self addClosingGestureRecognizers];
    
    // Keep track that the drawer is open
    self.drawerState = GDFDrawerControllerStateOpen;
    
    // Notify the child view controllers that the drawer is open
    if ([leftViewController respondsToSelector:@selector(slideControllerDidOpen:)]) {
        [leftViewController slideControllerDidOpen:self];
    }
    if ([centerViewController respondsToSelector:@selector(slideControllerDidOpen:)]) {
        [centerViewController slideControllerDidOpen:self];
    }
}
- (void)willClose
{
    NSParameterAssert(self.drawerState == GDFDrawerControllerStateOpen);
    NSParameterAssert(leftViewController);
    NSParameterAssert(centerViewController);
    
    // Start removing the left controller from the container
    [self.leftViewController willMoveToParentViewController:nil];
    
    // Keep track that the drawer is closing
    self.drawerState = GDFDrawerControllerStateClosing;
    
    // Notify the child view controllers that the drawer is about to close
    if ([leftViewController respondsToSelector:@selector(slideControllerWillClose:)]) {
        [leftViewController slideControllerWillClose:self];
    }
    if ([centerViewController respondsToSelector:@selector(slideControllerWillClose:)]) {
        [centerViewController slideControllerWillClose:self];
    }
}
- (void)close
{
    NSParameterAssert(self.drawerState == GDFDrawerControllerStateOpen);
    
    [self willClose];
    
    [self animateClosing];
}
- (void)didClose
{
    NSParameterAssert(self.drawerState == GDFDrawerControllerStateClosing);
    NSParameterAssert(leftView);
    NSParameterAssert(centerView);
    NSParameterAssert(leftViewController);
    NSParameterAssert(centerViewController);
    
    // Complete removing the left view controller from the container
    [self.leftViewController.view removeFromSuperview];
    [self.leftViewController removeFromParentViewController];
    
    // Remove the left view from the view hierarchy
    [leftView removeFromSuperview];
    
    [self removeClosingGestureRecognizers];
    
    // Keep track that the drawer is closed
    self.drawerState = GDFDrawerControllerStateClosed;
    
    // Notify the child view controllers that the drawer is closed
    if ([leftViewController respondsToSelector:@selector(slideControllerDidClose:)]) {
        [leftViewController slideControllerDidClose:self];
    }
    if ([centerViewController respondsToSelector:@selector(slideControllerDidClose:)]) {
        [centerViewController slideControllerDidClose:self];
    }
}
#pragma mark - Animations
- (void)animateOpening
{
    NSParameterAssert(self.drawerState == GDFDrawerControllerStateOpening);
    NSParameterAssert(leftView);
    NSParameterAssert(centerView);
    
    // Calculate the final frames for the container views
    CGRect leftViewFinalFrame = self.view.bounds;
    CGRect centerViewFinalFrame = self.view.bounds;
    centerViewFinalFrame.origin.x = ControllerDrawerDepth;
    
    [UIView animateWithDuration:kGDFDrawerControllerAnimationDuration
                          delay:0
         usingSpringWithDamping:kGDFDrawerControllerOpeningAnimationSpringDamping
          initialSpringVelocity:kGDFDrawerControllerOpeningAnimationSpringInitialVelocity
                        options:UIViewAnimationOptionCurveLinear
                     animations:^{
                         centerView.frame = centerViewFinalFrame;
                         leftView.frame = leftViewFinalFrame;
                         
                         [self setNeedsStatusBarAppearanceUpdate];
                     }
                     completion:^(BOOL finished) {
                         [self didOpen];
                     }];
}
- (void)animateClosing
{
    NSParameterAssert(self.drawerState == GDFDrawerControllerStateClosing);
    NSParameterAssert(leftView);
    NSParameterAssert(centerView);
    
    // Calculate final frames for the container views
    CGRect leftViewFinalFrame = leftView.frame;
    leftViewFinalFrame.origin.x = LeftViewInitialOffset;
    CGRect centerViewFinalFrame = self.view.bounds;
    
    [UIView animateWithDuration:kGDFDrawerControllerAnimationDuration
                          delay:0
         usingSpringWithDamping:kGDFDrawerControllerClosingAnimationSpringDamping
          initialSpringVelocity:kGDFDrawerControllerClosingAnimationSpringInitialVelocity
                        options:UIViewAnimationOptionCurveLinear
                     animations:^{
                         centerView.frame = centerViewFinalFrame;
                         leftView.frame = leftViewFinalFrame;
                         
                         [self setNeedsStatusBarAppearanceUpdate];
                     }
                     completion:^(BOOL finished) {
                         [self didClose];
                     }];
}
#pragma mark - uiviewcontroller method
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
    // Initialize left and center view containers
    leftView = [[UIView alloc] initWithFrame:self.view.bounds];
    centerView = [[UIView alloc] initWithFrame:self.view.bounds];
    leftView.autoresizingMask = self.view.autoresizingMask;
    centerView.autoresizingMask = self.view.autoresizingMask;
    
    // Add the center view container
    [self.view addSubview:centerView];
    
    // Add the center view controller to the container
    [self addCenterViewController];
    
    [self setupGestureRecognizers];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
