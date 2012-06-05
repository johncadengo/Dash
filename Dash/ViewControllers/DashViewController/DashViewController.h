//
//  DashViewController.h
//  Dash
//
//  Created by John Cadengo on 10/20/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <RestKit/RestKit.h>
#import <CoreLocation/CoreLocation.h>
#import "MBProgressHUD.h"
#import "PlaceSquareView.h"
#import "PopsScrollView.h"

@class DashAPI;
@class Place;
@class FilterViewController;

@interface DashViewController : UIViewController <RKObjectLoaderDelegate, MBProgressHUDDelegate, UIGestureRecognizerDelegate, PlaceSquareViewDelegate, PopsScrollViewDelegate>

// Model elements
@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, strong) DashAPI *api;
@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic, strong) NSMutableArray *places;

// State
@property (nonatomic, getter=isLoading) BOOL loading;
@property (nonatomic, getter=isDragging) BOOL dragging;
@property (nonatomic, getter=isFilterShowing) BOOL filterShowing;

// UI Elements, and views
// PopsScroll, PopBG, and PopButton
@property (nonatomic) CGRect popsScrollViewFrame;
@property (nonatomic) CGRect popBackgroundFrame;
@property (nonatomic) CGRect popButtonFrame;
@property (nonatomic, strong) PopsScrollView *popsScrollView;
@property (nonatomic, strong) NSArray *quadrantImages;
@property (nonatomic, strong) UIImageView *popBackground;
@property (nonatomic, strong) UIButton *popButton;

@property (nonatomic) CGRect draggableFrame;
@property (nonatomic) CGRect flipGripFrame;
@property (nonatomic, strong) UIImageView *flipGrip;

@property (nonatomic) CGRect filterViewFrame;
@property (nonatomic, strong) FilterViewController *filterViewController;
@property (nonatomic, strong) UIView *filterView;
@property (nonatomic, strong) MBProgressHUD *progressHUD;
@property (nonatomic, strong) UIAlertView *alertView;
@property (nonatomic, strong) UIImageView *dashButtonTip;

// Gesture recognizers
@property (nonatomic, strong) UIPanGestureRecognizer *drag;
@property (nonatomic, strong) UISwipeGestureRecognizer *swipeUp;
@property (nonatomic, strong) UISwipeGestureRecognizer *swipeDown;

- (void)pop:(id) sender;

// PopsScrollView
- (UIImage *)imageForCellAtIndexPath:(NSIndexPath *)indexPath;
- (PopsScrollView *)popsScrollView:(PopsScrollView *)popsScrollView cellAtIndexPath:(NSIndexPath *)indexPath;

// For dragging
- (void)hideFilter;
- (void)showFilter;
- (void)offsetFrames:(CGFloat)offset;

- (void)handleDrag:(UIPanGestureRecognizer *)gestureRecognizer;
- (void)handleSwipe:(UISwipeGestureRecognizer *)gestureRecognizer;

- (void)showLogin;
- (void)pushPlaceAtIndex:(NSInteger)index;

@end
