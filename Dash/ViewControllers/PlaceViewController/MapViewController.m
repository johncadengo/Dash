//
//  MapViewController.m
//  Dash
//
//  Created by John Cadengo on 4/30/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MapViewController.h"
#import "Place.h"
#import "Place+Helper.h"
#import "PlaceLocation.h"
#import "DashMapAnnotation.h"

@interface MapViewController ()

@end

@implementation MapViewController

@synthesize map = _map;
@synthesize annotations = _annotations;
@synthesize toolbar = _toolbar;
@synthesize cancelButton = _cancelButton;
@synthesize doneButton = _doneButton;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.map = [[MKMapView alloc] initWithFrame:CGRectMake(0.0f, 44.0f, 320.0f, 480.0f - 64.0f)];
    [self.map setDelegate:self];
    [self.map addAnnotations:self.annotations];
    [self.view addSubview:self.map];
    
    DashMapAnnotation *annotation = [self.annotations lastObject];
    MKCoordinateRegion region = self.map.region;
    region.center = annotation.coordinate;
    region.span.longitudeDelta /= 8192.0f; // Bigger the value, closer the map view
    region.span.latitudeDelta /= 8192.0f;
    [self.map setRegion:region animated:YES];
    
    
    // Add the cancel button
    self.cancelButton = [[UIBarButtonItem alloc] initWithTitle:@"Done" 
                                                         style:UIBarButtonItemStyleBordered 
                                                        target:self 
                                                        action:@selector(dismissModalViewControllerAnimated:)];
    [self.cancelButton setTintColor:[UIColor blackColor]];
    
    // Add the space inbetween
    UIBarButtonItem *flexibleSpace = [[UIBarButtonItem alloc] 
                                       initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace 
                                       target:nil action:nil];
    
    // Add the done button
    if (self.annotations.count == 1) {
        self.doneButton = [[UIBarButtonItem alloc] initWithTitle:@"Map" 
                                                           style:UIBarButtonItemStyleDone 
                                                          target:self 
                                                          action:@selector(googleMap:)];
    }
    
    // Add the toolbar
    self.toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0.0, 0.0, 320.0f, 44.0f)];
    [self.toolbar setBackgroundImage:[UIImage imageNamed:@"TopBar.png"] forToolbarPosition:UIToolbarPositionAny barMetrics:UIBarMetricsDefault];
    [self.toolbar setItems:[NSArray arrayWithObjects:self.cancelButton, flexibleSpace, self.doneButton, nil]];
    [self.view addSubview:self.toolbar];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    
    self.map = nil;
    self.toolbar = nil;
    self.cancelButton = nil;
    self.doneButton = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark -

- (void)setWithPlace:(Place *)place
{
    [self setWithPlaces:[NSArray arrayWithObject:place]];
}

- (void)setWithPlaces:(NSArray *)places
{
    if (self.annotations == nil) {
        self.annotations = [[NSMutableArray alloc] initWithCapacity:32];    
    }
    
    [self.annotations removeAllObjects];
    
    // Create annotations for all the places
    DashMapAnnotation *annotation;
    for (Place *place in places) {
        annotation = [[DashMapAnnotation alloc] init];
        
        CLLocationDegrees lat = place.location.latitude.doubleValue;
        CLLocationDegrees lng = place.location.longitude.doubleValue;
        annotation.coordinate = CLLocationCoordinate2DMake(lat, lng);
        annotation.title = [NSString stringWithFormat:@"%@", place.name];
        annotation.subtitle = [NSString stringWithFormat:@"%@", [place.address capitalizedString]];
        
        [self.annotations addObject:annotation];
    }
}

- (NSString *) URLEncodeString:(NSString *) str
{
    NSMutableString *tempStr = [NSMutableString stringWithString:str];
    [tempStr replaceOccurrencesOfString:@" " withString:@"+" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [tempStr length])];
    
    return [[NSString stringWithFormat:@"%@",tempStr] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
}

- (void)googleMap:(id)sender
{
    DashMapAnnotation *annotation = [self.annotations lastObject];
    
   [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[self URLEncodeString:[NSString stringWithFormat:@"http://maps.google.com/maps?q=%f,%f", annotation.coordinate.latitude, annotation.coordinate.longitude]]]];
}

@end
