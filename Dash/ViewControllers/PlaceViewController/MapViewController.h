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

@interface MapViewController : UIViewController <MKMapViewDelegate, MKAnnotation>

@property (nonatomic, strong) MKMapView *map;
@property (nonatomic) CLLocationCoordinate2D coordinate;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *subtitle;
@property (nonatomic, strong) UIToolbar *toolbar;
@property (nonatomic, strong) UIBarButtonItem *cancelButton;
@property (nonatomic, strong) UIBarButtonItem *doneButton;

- (void)setWithPlace:(Place *)place;
- (NSString *) URLEncodeString:(NSString *) str;
- (void)googleMap:(id)sender;

@end
