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
@class PlaceSquareViewCell;

@interface DashViewController : UIViewController <RKObjectLoaderDelegate, CLLocationManagerDelegate, MBProgressHUDDelegate, UIGestureRecognizerDelegate>

// Model elements
@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, strong) DashAPI *api;
@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic, strong) NSMutableArray *places;

// State
@property (nonatomic, getter=isLoading) BOOL loading;
@property (nonatomic) NSInteger currentPage;

// UI Elements
@property (nonatomic, strong) UIScrollView *popsScrollView;
@property (nonatomic, strong) MBProgressHUD *progressHUD;
@property (nonatomic, strong) UILabel *label;
@property (nonatomic, strong) UIButton *popButton;

// Gesture recognizers
@property (nonatomic, strong) UITapGestureRecognizer *singleTap;

/** The four quadrants are divided up in to a Cartesian system,
    each bounded by two half-axes: I, II, III, and IV.
    and ordered by the axes (x,y): (+,+), (-,+), (-,-), and (+,-).
    That is, we start in the upper right, and progress counter-clockwise.
 */
@property (nonatomic, strong) NSMutableArray *quadrants;
@property (nonatomic, strong) NSMutableArray *quadrantFrames;

+ (NSInteger)pageForIndex:(NSInteger) index;
+ (NSInteger)firstIndexForPage:(NSInteger) page;

- (void)pop:(id) sender;
- (BOOL)canShowNextPage;
- (void)showNextPage;

/** Receive touch events and respond accordingly.
 */
- (void)handleSingleTap:(UIGestureRecognizer *)gestureRecognizer;

@end
