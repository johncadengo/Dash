//
//  DashViewController.m
//  Dash
//
//  Created by John Cadengo on 10/20/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "DashViewController.h"
#import "DashAPI.h"
#import "Place.h"
#import "MBProgressHUD.h"

@implementation DashViewController

@synthesize managedObjectContext = __managedObjectContext;
@synthesize api = _api;
@synthesize locationManager = _locationManager;
@synthesize places = _places;
@synthesize currentPage = _currentPage;

@synthesize progressHUD = _progressHUD;
@synthesize textView = _textView;
@synthesize popButton = _popButton;

#pragma mark - UI Constants
static int kPlacesPerPage = 4;

#pragma mark - Class methods for determining layout

/** There are four places per page.
 */
+ (NSInteger)pageForIndex:(NSInteger) index
{
    return (index % kPlacesPerPage);
}

#pragma mark - Initialization

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}


#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Set page
    
    
    // Connect to our API.
    self.api = [[DashAPI alloc] initWithManagedObjectContext:self.managedObjectContext delegate:self];
    
    // Add our text view
    self.textView = [[UITextView alloc] init];
    self.textView.frame = CGRectMake(0.0f, 0.0f, 320.0f, 480.f - 50.0f);
    self.textView.text = @"Tap Dash!";
    self.textView.font = [UIFont systemFontOfSize:12];
    [self.textView setEditable:NO];
    [self.view addSubview:self.textView];
    
    // Add our Dash button
    UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [button addTarget:self 
               action:@selector(pop:)
     forControlEvents:UIControlEventTouchUpInside];
    [button setTitle:@"Dash" forState:UIControlStateNormal];
    button.frame = CGRectMake(0.0f, 480.f - 44.0f - 64.0f - 100.0f, 320.0f, 100.0f);
    [self.view addSubview:button];

    // Figure out where we are
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters;
    [self.locationManager startUpdatingLocation];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - CLLocationManagerDelegate
- (void)locationManager:(CLLocationManager *)manager
    didUpdateToLocation:(CLLocation *)newLocation
           fromLocation:(CLLocation *)oldLocation
{
    // If it's a relatively recent event, turn off updates to save power
    NSDate* eventDate = newLocation.timestamp;
    NSTimeInterval howRecent = [eventDate timeIntervalSinceNow];
    if (abs(howRecent) < 15.0)
    {
        NSLog(@"latitude %+.6f, longitude %+.6f\n",
              newLocation.coordinate.latitude,
              newLocation.coordinate.longitude);
        [manager stopUpdatingLocation];
    }
    // else skip the event and process the next one.
}

#pragma mark -

- (void)pop:(id) sender
{
    self.textView.text = @"Loading...";
    [self.view setNeedsDisplay];
    
    // Find out where we are
    CLLocation *loc = [self.locationManager location];
    [self.api pop:loc];
}

#pragma mark -

- (void)showNextPage
{
    
}

#pragma mark - RKObjectLoaderDelegate methods

- (void)objectLoader:(RKObjectLoader *)objectLoader didLoadObjects:(NSArray *)objects 
{
    // Create the text
    NSMutableString *text = [[NSMutableString alloc] init];
    for (Place *place in objects) {
        [text appendFormat:@"%@ - %@\n", place.name, place.address];
    }
    
    // Display it in a textview
    self.textView.text = [NSString stringWithString:text];
    [self.view setNeedsDisplay];
    //NSLog(@"text %@", text);
}

- (void)objectLoader:(RKObjectLoader *)objectLoader didFailWithError:(NSError *)error 
{
    //NSLog(@"Encountered an error: %@", error);
}

@end
