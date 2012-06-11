//
//  MapViewController.h
//  Dash
//
//  Created by John Cadengo on 4/30/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>

@class Place;

@interface MapViewController : UIViewController <MKMapViewDelegate>

@property (nonatomic, strong) MKMapView *map;
@property (nonatomic, strong) NSMutableArray *annotations;
@property (nonatomic, strong) UIToolbar *toolbar;
@property (nonatomic, strong) UIBarButtonItem *cancelButton;
@property (nonatomic, strong) UIBarButtonItem *doneButton;

- (void)setWithPlace:(Place *)place;
- (void)setWithPlaces:(NSArray *)places;
- (NSString *) URLEncodeString:(NSString *) str;
- (void)googleMap:(id)sender;

@end
