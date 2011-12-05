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

@interface DashViewController : UIViewController <RKObjectLoaderDelegate, CLLocationManagerDelegate>

@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, strong) DashAPI *api;
@property (nonatomic, strong) CLLocationManager *locationManager;

// UI Elements
@property (nonatomic, strong) UITextView *textView;
@property (nonatomic, strong) UIButton *popButton;

- (void)pop:(id) sender;

@end
