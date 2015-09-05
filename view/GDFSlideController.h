//
//  GDFSlideController.h
//  GDFamily
//
//  Created by Sicong Qian on 15/6/19.
//  Copyright © 2015年 silverup.co. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSUInteger, GDFDrawerControllerState)
{
    GDFDrawerControllerStateClosed = 0,
    GDFDrawerControllerStateOpening,
    GDFDrawerControllerStateOpen,
    GDFDrawerControllerStateClosing
};

@class GDFSlideController;
@protocol GDFSlideControllerChild <NSObject>
@property (nonatomic,weak) GDFSlideController *sliderController;

@end
@protocol GDFSlideControllerStatus <NSObject>
/**
 Tells the child controller that the slide controller is about to open.
 
 @param slideController The slide object that is about to open.
 */
- (void)slideControllerWillOpen:(GDFSlideController *)slideController;
/**
 Tells the child controller that the slide controller has completed the opening phase and is now open.
 
 @param slideController The slide object that is now open.
 */
- (void)slideControllerDidOpen:(GDFSlideController *)slideController;
/**
 Tells the child controller that the slide controller is about to close.
 
 @param slideController The slide object that is about to close.
 */
- (void)slideControllerWillClose:(GDFSlideController *)slideController;
/**
 Tells the child controller that the slide controller has completed the closing phase and is now closed.
 
 @param slideController The slide object that is now closed.
 */
- (void)slideControllerDidClose:(GDFSlideController *)slideController;

- (void)slideControllerTapClose:(GDFSlideController *)slideController;
@end

@interface GDFSlideController : UIViewController

@property(nonatomic, strong, readwrite) UIViewController<GDFSlideControllerChild,GDFSlideControllerStatus> *leftViewController;
@property(nonatomic, strong, readwrite) UIViewController<GDFSlideControllerChild,GDFSlideControllerStatus> *centerViewController;

@property(nonatomic, assign) GDFDrawerControllerState drawerState;
@property(nonatomic, assign) CGFloat LeftViewInitialOffset;
@property(nonatomic, assign, readonly) CGFloat ControllerDrawerDepth;
@property(nonatomic, assign) BOOL enablePanGesture;

- (id)initWithLeftViewController:(UIViewController<GDFSlideControllerChild,GDFSlideControllerStatus> *)leftViewController_
            centerViewController:(UIViewController<GDFSlideControllerChild,GDFSlideControllerStatus> *)centerViewController_;

- (void)open;

- (void)close;

- (void)reloadCenterViewControllerUsingBlock:(void (^)(void))reloadBlock;

- (void)replaceCenterViewControllerWithViewController:(UIViewController<GDFSlideControllerChild,GDFSlideControllerStatus> *)viewController;

- (void)replaceLeftViewControllerWithViewController:(UIViewController<GDFSlideControllerChild,GDFSlideControllerStatus> *)viewController;

@end
