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

@interface MapViewController ()

@end

@implementation MapViewController

@synthesize map = _map;
@synthesize coordinate = _coordinate;
@synthesize subtitle = _subtitle;
@synthesize toolbar = _toolbar;
@synthesize cancelButton = _cancelButton;
@synthesize doneButton = _doneButton;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.map = [[MKMapView alloc] initWithFrame:CGRectMake(0.0f, 44.0f, 320.0f, 480.0f - 64.0f)];
    [self.map setDelegate:self];
    [self.view addSubview:self.map];
    MKCoordinateRegion region = MKCoordinateRegionMake(self.coordinate, MKCoordinateSpanMake(0.02, 0.02));
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
    self.doneButton = [[UIBarButtonItem alloc] initWithTitle:@"Map" 
                                                       style:UIBarButtonItemStyleDone 
                                                      target:self 
                                                      action:@selector(googleMap:)];
    
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
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark -

- (void)setWithPlace:(Place *)place
{
    CLLocationDegrees lat = place.location.latitude.doubleValue;
    CLLocationDegrees lng = place.location.longitude.doubleValue;
    self.coordinate = CLLocationCoordinate2DMake(lat, lng);
    
    self.title = [NSString stringWithFormat:@"%@", place.name];
    self.subtitle = [NSString stringWithFormat:@"%@", [place.address capitalizedString]];
}

- (NSString *) URLEncodeString:(NSString *) str
{
    NSMutableString *tempStr = [NSMutableString stringWithString:str];
    [tempStr replaceOccurrencesOfString:@" " withString:@"+" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [tempStr length])];
    
    
    return [[NSString stringWithFormat:@"%@",tempStr] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
}

- (void)googleMap:(id)sender
{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[self URLEncodeString:[NSString stringWithFormat:@"http://maps.google.com/maps?q=%f,%f", self.coordinate.latitude, self.coordinate.longitude]]]];
}

#pragma mark -

- (MKAnnotationView *) mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>) annotation{
    MKPinAnnotationView *annView=[[MKPinAnnotationView alloc] initWithAnnotation:self reuseIdentifier:@"currentloc"];
    annView.pinColor = MKPinAnnotationColorRed;
    annView.animatesDrop=TRUE;
    annView.canShowCallout = YES;
    annView.calloutOffset = CGPointMake(-5, 5);
    return annView;
}

@end
