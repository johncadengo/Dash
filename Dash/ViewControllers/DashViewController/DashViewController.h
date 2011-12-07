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

@interface DashViewController : UIViewController <RKObjectLoaderDelegate, CLLocationManagerDelegate, MBProgressHUDDelegate>

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

+ (NSInteger)pageForIndex:(NSInteger) index;

- (void)pop:(id) sender;
- (BOOL)canShowNextPage;
- (void)showNextPage;

@end
