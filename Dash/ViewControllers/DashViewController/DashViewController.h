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

@class DashAPI;
@class Place;
@class FilterView;

// For mapping the quadrant to array indices
typedef enum {
    kQuadUndef = -1,
    kQuadI = 0,
    kQuadII = 1,
    kQuadIII = 2,
    kQuadIV = 3
}QuadrantIndex;

@interface DashViewController : UIViewController <RKObjectLoaderDelegate, CLLocationManagerDelegate, MBProgressHUDDelegate, UIGestureRecognizerDelegate>

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

// UI Elements
@property (nonatomic, strong) UIScrollView *popsScrollView;
@property (nonatomic, strong) MBProgressHUD *progressHUD;
@property (nonatomic, strong) UILabel *label;
@property (nonatomic, strong) UIButton *popButton;
@property (nonatomic, strong) FilterView *filterView;

// Gesture recognizers
@property (nonatomic, strong) UITapGestureRecognizer *singleTap;
@property (nonatomic, strong) UIPanGestureRecognizer *drag;

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
- (BOOL)canShowNextPage;
- (void)showNextPage;

/** Receive touch events and respond accordingly.
 */
- (void)handleSingleTap:(UITapGestureRecognizer *)gestureRecognizer;
- (void)handleDrag:(UIPanGestureRecognizer *)gestureRecognizer;

/**
 */
- (void)showLogin;

@end
