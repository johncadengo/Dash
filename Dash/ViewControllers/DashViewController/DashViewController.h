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

// For mapping the quadrant to array indices
typedef enum {
    kQuadUndef = -1,
    kQuadI = 0,
    kQuadII = 1,
    kQuadIII = 2,
    kQuadIV = 3
}QuadrantIndex;

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
@property (nonatomic) NSInteger currentPage;

// UI Elements, and views
// PopsScroll, PopBG, and PopButton
@property (nonatomic) CGRect popsScrollViewFrame;
@property (nonatomic) CGRect popBackgroundFrame;
@property (nonatomic) CGRect popButtonFrame;
@property (nonatomic, strong) PopsScrollView *popsScrollView;
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

/** The four quadrants are divided up in to a Cartesian system,
    each bounded by two half-axes: I, II, III, and IV.
    and ordered by the axes (x,y): (+,+), (-,+), (-,-), and (+,-).
    That is, we start in the upper right, and progress counter-clockwise.
 */
@property (nonatomic, strong) NSMutableArray *quadrantCells;
@property (nonatomic, strong) NSMutableArray *quadrantFrames;

+ (NSInteger)pageForIndex:(NSInteger) index;
+ (NSInteger)firstIndexForPage:(NSInteger) page;

- (void)pop:(id) sender;

/** Assumes quadrant is located on self.currentPage
 */
- (Place *)placeForQuadrant:(QuadrantIndex) quadrant;
- (void)adjustScrollViewContentSize;
- (void)addFourMoreQuadrantCells;
- (BOOL)canShowNextPage;
- (void)showNextPage;

// For dragging
- (void)hideFilter;
- (void)showFilter;
- (void)offsetFrames:(CGFloat)offset;

- (void)handleDrag:(UIPanGestureRecognizer *)gestureRecognizer;
- (void)handleSwipe:(UISwipeGestureRecognizer *)gestureRecognizer;

- (void)showLogin;
- (void)pushPlaceAtIndex:(NSInteger)index;

@end
