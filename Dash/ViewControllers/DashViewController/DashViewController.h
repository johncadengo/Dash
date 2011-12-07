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

@class DashAPI;
@class MBProgressHUD;

@interface DashViewController : UIViewController <RKObjectLoaderDelegate, CLLocationManagerDelegate>

@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, strong) DashAPI *api;
@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic, strong) NSMutableArray *places;
@property (nonatomic) NSInteger currentPage;

@property (nonatomic, strong) MBProgressHUD *progressHUD;
@property (nonatomic, strong) UITextView *textView;
@property (nonatomic, strong) UIButton *popButton;

+ (NSInteger)pageForIndex:(NSInteger) index;

- (void)pop:(id) sender;
- (void)showNextPage;

@end
