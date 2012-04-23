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
#import "Constants.h"
#import "PlaceViewController.h"
#import "JCLocationManagerSingleton.h"
#import "FilterViewController.h"

@implementation DashViewController

@synthesize managedObjectContext = __managedObjectContext;
@synthesize api = _api;
@synthesize locationManager = _locationManager;
@synthesize places = _places;

@synthesize loading = _loading;
@synthesize dragging = _dragging;
@synthesize filterShowing = _filterShowing;
@synthesize currentPage = _currentPage;

@synthesize popsScrollView = _popsScrollView;
@synthesize progressHUD = _progressHUD;
@synthesize popBackground = _popBackground;
@synthesize popsScrollViewFrame = _popsScrollViewFrame;
@synthesize popBackgroundFrame = _popBackgroundFrame;
@synthesize popButtonFrame = _popButtonFrame;
@synthesize popButton = _popButton;

@synthesize draggableFrame = _draggableFrame;
@synthesize flipGripFrame = _flipGripFrame;
@synthesize flipGrip = _flipGrip;

@synthesize filterViewFrame = _filterViewFrame;
@synthesize filterView = _filterView;
@synthesize filterViewController = _filterViewController;
@synthesize drag = _drag;

@synthesize quadrantCells = _quadrantCells;
@synthesize quadrantFrames = _quadrantFrames;
@synthesize quadrantImages = _quadrantImages;

#pragma mark - UI Constants
enum {
    kPrePopPage = -1,
    kPlacesPerPage = 4
};

static double const kRightHalfXOffset = 0.5f;
static double const kBottomHalfYOffset = 0.5f;
static double const kPopButtonYOffset = 15.0f;

#pragma mark - Function to help with tracking views

CGRect CGRectMatchCGPointY(CGRect rect, CGPoint origin);
CGRect CGRectMatchCGPointY(CGRect rect, CGPoint origin) {
    return CGRectMake(rect.origin.x, origin.y, rect.size.width, rect.size.height);
}

CGRect CGRectMatchCGPointYWithOffset(CGRect rect, CGPoint origin, CGFloat offset);
CGRect CGRectMatchCGPointYWithOffset(CGRect rect, CGPoint origin, CGFloat offset) {
    return CGRectMake(rect.origin.x, origin.y + offset, rect.size.width, rect.size.height);
}

#pragma mark - Class methods for determining layout

/** There are four places per page.
 */
+ (NSInteger)pageForIndex:(NSInteger) index
{
    NSInteger page;
    
    // Calculate page if it is greater than or equal to zero
    // But otherwise, we are at the PrePopPage
    page = (index >= 0) ? (index / kPlacesPerPage) : kPrePopPage;
    
    return page;
}

+ (NSInteger)firstIndexForPage:(NSInteger) page
{
    NSInteger index;
    
    //
    index = (page >= 0) ? (page * kPlacesPerPage) : kPrePopPage;
    
    return index;
}

#pragma mark - Initialization

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom tab bar icon
//        UIImage *tabBarIcon = [UIImage imageNamed:@"DashFourColorIcon.png"];
//        UITabBarItem *tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Dash" image:tabBarIcon tag:0];
//        self.tabBarItem = tabBarItem;
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
- (void)loadView
{
    // The visible view at all times
    //self.view = [[UIView alloc] init];
    [super loadView];
    self.view.backgroundColor = [UIColor blackColor];
    
    // Add our pops scroll view
    CGFloat popsScrollViewWidth = PlaceSquareView.size.width * 2.0f;
    CGFloat popsScrollViewHeight = PlaceSquareView.size.height * 2.0f;
    self.popsScrollViewFrame = CGRectMake(0.0f, 0.0f, popsScrollViewWidth, popsScrollViewHeight);
    self.popsScrollView = [[UIScrollView alloc] initWithFrame:self.popsScrollViewFrame];
    [self.popsScrollView setScrollEnabled:YES];
    [self.popsScrollView setPagingEnabled:YES];
    [self.view addSubview:self.popsScrollView];
    
    // Set up the quadrantFrames
    CGFloat squareWidth = PlaceSquareView.size.width;
    CGFloat squareHeight = PlaceSquareView.size.height;
    
    CGRect firstFrame = CGRectMake(squareWidth + kRightHalfXOffset, 0.0f, squareWidth, squareHeight);
    CGRect secondFrame = CGRectMake(0.0f, 0.0f, squareWidth, squareHeight);
    CGRect thirdFrame = CGRectMake(0.0f, squareHeight + kBottomHalfYOffset, squareWidth, squareHeight);
    CGRect fourthFrame = CGRectMake(squareWidth + kRightHalfXOffset, squareHeight + kBottomHalfYOffset, squareWidth, squareHeight);
    
    self.quadrantFrames = [[NSMutableArray alloc] initWithObjects:
                           [NSValue valueWithCGRect:firstFrame],
                           [NSValue valueWithCGRect:secondFrame],
                           [NSValue valueWithCGRect:thirdFrame],
                           [NSValue valueWithCGRect:fourthFrame], nil];
    
    // Set up the quadrantImages
    UIImage *firstImage = [UIImage imageNamed:@"DashGreenBox.png"]; 
    UIImage *secondImage = [UIImage imageNamed:@"DashOrangeBox.png"]; 
    UIImage *thirdImage = [UIImage imageNamed:@"DashRedBox.png"]; 
    UIImage *fourthImage = [UIImage imageNamed:@"DashTealBox.png"];
    
    self.quadrantImages = [[NSMutableArray alloc] initWithObjects:
                           firstImage, secondImage, thirdImage, fourthImage, nil];

    // Set up the array to contain our cells
    self.quadrantCells = [[NSMutableArray alloc] initWithCapacity:kPlacesPerPage * 16];

    // Set up our initial four blank cells
    UIImageView *imageView;
    UIImage *image;
    CGRect frame;
    
    for (int i = 0; i < kPlacesPerPage; ++i) {
        image = [self.quadrantImages objectAtIndex:i];
        frame = [[self.quadrantFrames objectAtIndex:i] CGRectValue];
        imageView = [[UIImageView alloc] initWithImage: image];
        imageView.frame = frame;
        [self.popsScrollView addSubview:imageView];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];  
    
    // Initialize some things
    self.loading = NO;
    self.dragging = NO;
    self.filterShowing = NO;
    self.currentPage = kPrePopPage; // -1
    self.places = [[NSMutableArray alloc] initWithCapacity:12];
    
    // Connect to our API.
    self.api = [[DashAPI alloc] initWithManagedObjectContext:self.managedObjectContext delegate:self];
    
    // Add our Dash button background
    self.popBackground = [[UIImageView alloc] initWithImage:
                          [UIImage imageNamed:@"BlackGradientBackground.png"]];
    CGFloat kPopBackgroundY = (2 * PlaceSquareView.size.height);
    self.popBackgroundFrame = CGRectMake(0.0f, kPopBackgroundY, 320.0f, 480.0f);
    self.popBackground.frame = self.popBackgroundFrame;
    [self.view addSubview:self.popBackground];
    
    // Draggable frame.. for when filter is showing
    self.draggableFrame = CGRectMake(0.0f, 0.0f, 320.0f, 120.0f);
    
    // Flip grip
    self.flipGrip = [[UIImageView alloc] initWithImage:
                     [UIImage imageNamed:@"FlipGrip.png"]];
    // -16.0f.... I'm not sure why right now haha
    self.flipGripFrame = CGRectMake(0.0f, kPopBackgroundY - 16.0f, 320.0f, 480.0f);
    self.flipGrip.frame = self.flipGripFrame;
    [self.view addSubview:self.flipGrip];
    
    // Dash button
    self.popButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [self.popButton addTarget:self 
                       action:@selector(pop:)
             forControlEvents:UIControlEventTouchUpInside];
    [self.popButton setTitle:@"dash" forState:UIControlStateNormal];
    [self.popButton.titleLabel setFont:[UIFont fontWithName:kPlutoBold size:42.5f]];
    [self.popButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.popButton setBackgroundImage:[UIImage imageNamed:@"DashOrangeButton"] forState:UIControlStateNormal];
    self.popButtonFrame = CGRectMake(10.0f, kPopBackgroundY + kPopButtonYOffset, 300.0f, 54.5f);
    self.popButton.frame = self.popButtonFrame;
    [self.view addSubview:self.popButton];

    // Figure out where we are
    self.locationManager = [JCLocationManagerSingleton sharedInstance];
    self.locationManager.delegate = self;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters;
    [self.locationManager startUpdatingLocation];
    
    // Add our progress hud
    self.progressHUD = [[MBProgressHUD alloc] initWithView:self.popsScrollView];
    [self.popsScrollView addSubview:self.progressHUD];
    self.progressHUD.delegate = self;
    self.progressHUD.removeFromSuperViewOnHide = NO;
    
    // Add our drag gesture recognizer
    self.drag = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handleDrag:)];
    [self.view addGestureRecognizer:self.drag];
    [self.drag setDelegate:self];
    
    // Hide our navigation bar
    [self.navigationController setNavigationBarHidden:YES];

    // Initial filter view frame
    self.filterViewFrame = CGRectMake(0.0f, 360.0f, 320.0f, 480.0f);
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    
    if (![DashAPI skipLogin] && ![DashAPI loggedIn]) {
        /*
        self.filterShowing = YES;
        [self performSegueWithIdentifier:kPresentFilterViewController sender:nil];
        [self showFilter];
        */
        
        [self showLogin];
    }
    else {
        [self pop:nil];
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    if (self.isFilterShowing) {
        [self performSegueWithIdentifier:kPresentFilterViewController sender:nil];
        [self showFilter];
    }
    else {
        self.filterView.frame = CGRectMake(0.0f, 400.0f, 320.0f, 320.0f);
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    // Make sure we turn off location services
    // TODO: Make sure we restart it when we need it...
    [self.locationManager stopUpdatingLocation];
    [self.locationManager stopMonitoringSignificantLocationChanges];
    
    [self.filterView removeFromSuperview];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    //NSLog(@"UNLOAD");
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
        //NSLog(@"latitude %+.6f, longitude %+.6f\n",
        //      newLocation.coordinate.latitude,
        //      newLocation.coordinate.longitude);
        [manager stopUpdatingLocation];
        [manager startMonitoringSignificantLocationChanges];
    }
    // else skip the event and process the next one.
}

#pragma mark - UIGestureRecognizer Delegate

/** Want certain events to pass right through
 */
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    CGPoint origin = [touch locationInView:self.view];
    BOOL insidePopButton = CGRectContainsPoint(self.popBackground.frame, origin);
    return (self.isFilterShowing && !insidePopButton) ? NO : YES;
}

/** Perceive a drag and respond accordingly
 
    TODO: Track drag from different locations depending if we are going from top down or bottom up.
    TODO: Don't highlight Dash when dragging.
    TODO: When Dash, animate the filter view down.
 */
- (void)handleDrag:(UIPanGestureRecognizer *)gestureRecognizer
{
    UIView *dragSuperView = self.view;
    
    if (self.isDragging && gestureRecognizer.state == UIGestureRecognizerStateEnded) {
        //NSLog(@"Dragging over. Should stick either up or down now.");
        // Reset isDragging
        self.dragging = NO;
        
        // If it is over, we check the velocity of the drag
        // to see if we want to finish dragging it up or down
        CGPoint origin = [gestureRecognizer velocityInView:dragSuperView];
        CGFloat velocity = origin.y;
        CGFloat vertical;
        NSTimeInterval duration;
        
        // If the y value is negative, we are moving up and so attach the view
        if (velocity < 0) {
            // Calculate how many points we have to go before we hit our destination
            vertical = self.filterView.frame.origin.y - dragSuperView.frame.origin.y;
            duration = MIN(ABS(vertical / velocity), 1.0f);
            
            //NSLog(@"%f %f %f", velocity, vertical, duration);
            
            [UIView animateWithDuration:duration
                                  delay:0.0
                                options:UIViewAnimationCurveLinear
                             animations:^{
                                 [self showFilter];
                             }
                             completion:^(BOOL finished){
                                 self.filterShowing = YES;
                             }];
        }
        else {
            // Otherwise, at a standstill or moving back, we want to retract the view
            vertical = self.filterView.frame.origin.y - self.popButton.frame.origin.y;
            duration = MIN(ABS(vertical / velocity), 1.0f);
            
            [UIView animateWithDuration:duration
                                  delay:0.0
                                options:UIViewAnimationCurveLinear
                             animations:^{
                                 [self hideFilter];
                             }
                             completion:^(BOOL finished){
                                 self.filterShowing = NO;
                             }];
        }
    }
    else if (self.isDragging) {
        // Keep track of where we are
        CGPoint origin = [gestureRecognizer locationInView:dragSuperView];
        
        // As long as we aren't going above the top of the view, have it follow the drag
        if (CGRectContainsPoint(dragSuperView.frame, origin)) {
            // Only allow dragging to a certain point. Don't let drag further down.
            if (origin.y - (2 * PlaceSquareView.size.height) < 0.0f) {
                // Track the drag
                [self offsetFrames:origin.y];
            }
            else {
                // Stick to the bottom
                [self hideFilter];
            }
        }
    }
    else if (gestureRecognizer.state == UIGestureRecognizerStateBegan) { //(!self.isFilterShowing && gestureRecognizer.state == UIGestureRecognizerStateBegan) {
        //NSLog(@"Pan begins");
        
        // Otherwise, we want to start dragging if the gesture begins in the pop button
        //CGPoint origin = [self.view convertPoint:[gestureRecognizer locationInView:self.view] 
        //                                  toView:self.popButton];
        CGPoint origin = [gestureRecognizer locationInView:dragSuperView];
        
        NSLog(@"origin %f %f", origin.x, origin.y);
        BOOL inBackgroundFrame = CGRectContainsPoint(self.popBackground.frame, origin);
        BOOL inDraggableFrame = CGRectContainsPoint(self.draggableFrame, origin);
        
        if ((self.isFilterShowing && inDraggableFrame) || (!self.isFilterShowing && inBackgroundFrame)) {
            // Now, we are dragging
            self.dragging = YES;
            
            [self performSegueWithIdentifier:kPresentFilterViewController sender:nil];
        }
    }
}

- (void)hideFilter
{
    [self offsetFrames:(PlaceSquareView.size.height * 2)];    
}

- (void)showFilter
{
    [self offsetFrames:0.0f];
}

- (void)offsetFrames:(CGFloat)offset
{
    CGFloat trackingOrigin = (2 * PlaceSquareView.size.height);
    
    // Grab the popsscrollview and drag it
    self.popsScrollView.frame = CGRectOffset(self.popsScrollViewFrame, 0.0f, offset - trackingOrigin);
    
    // Grab the popbutton and its background and drag em too
    self.popBackground.frame = CGRectOffset(self.popBackgroundFrame, 0.0f, offset - trackingOrigin);
    self.popButton.frame = CGRectOffset(self.popButtonFrame, 0.0f, offset - trackingOrigin);
    
    self.flipGrip.frame = CGRectOffset(self.flipGripFrame, 0.0f, offset - trackingOrigin);
    
    // Grab the filter view and drag it up
    // 54.5f is the popbutton's height...
    self.filterView.frame = CGRectOffset(self.filterViewFrame, 0.0f, offset - trackingOrigin + 51.0f);
}

#pragma mark -

- (void)pop:(id) sender
{
    // If filter is showing.. Animate down and pop
    if (self.filterShowing) {
        [UIView animateWithDuration:1.0f
                              delay:0.0f
                            options:UIViewAnimationCurveLinear
                         animations:^{
                             [self offsetFrames:(2 * PlaceSquareView.size.height)];
                         }
                         completion:^(BOOL finished){
                             self.filterShowing = NO;
                         }];
    }
    
    // Find out where we are
    CLLocation *loc = [self.locationManager location];
    
    // If we have enough places to show, show next page
    if ([self canShowNextPage]) {
        [self showNextPage];
    }
    else {
        // Otherwise, indicate we are now loading
        [self.progressHUD show:YES];
        
        // And send request to API for more places
        [self.api pop:loc];
    }
}

#pragma mark - Paging logic

- (Place *)placeForQuadrant:(QuadrantIndex)quadrant
{
    NSInteger firstIndex = [[self class] firstIndexForPage:self.currentPage];
    Place *place = [self.places objectAtIndex:firstIndex + quadrant];
    
    return place;
}


- (void)adjustScrollViewContentSize
{
    // Our content size is determined by what page we are currently on.
    CGFloat popsScrollViewWidth = PlaceSquareView.size.width * 2.0f;
    CGFloat popsScrollViewHeight = PlaceSquareView.size.height * 2.0f;
    self.popsScrollView.contentSize = CGSizeMake(popsScrollViewWidth * (self.currentPage + 1), popsScrollViewHeight);    
}

- (void)addFourMoreQuadrantCells
{
    // Set up the quadrants
    PlaceSquareView *cell;
    NSValue *value;
    CGRect cellFrame;
    UIImage *image;
    NSInteger index;
    NSInteger start = [self.quadrantCells count];
    CGFloat popsScrollViewWidth = PlaceSquareView.size.width * 2.0f;
    
    for (int i = start; i < start + kPlacesPerPage; ++i) {
        // Get the frames and images
        index = i % kPlacesPerPage;
        value = [self.quadrantFrames objectAtIndex:index];
        cellFrame = CGRectOffset([value CGRectValue], popsScrollViewWidth * self.currentPage, 0.0);
        image = [self.quadrantImages objectAtIndex:index];
        
        // Create the cells
        cell = [[PlaceSquareView alloc] initWithFrame:cellFrame backgroundImage:image];
        cell.delegate = self;
        cell.index = i;
        
        [self.quadrantCells addObject:cell];
        [self.popsScrollView addSubview:cell];       
    }
}

/** Figures out if we have enough places in our array to show the next page
 */ 
- (BOOL)canShowNextPage
{
    NSInteger maxIndexAvailable = self.places.count - 1;
    NSInteger lastPageWeCanShow = [[self class] pageForIndex:maxIndexAvailable];
    
    return (lastPageWeCanShow == self.currentPage) ? NO : YES;
}

/** Assumes that we have enough places to display. 
    Should not call if there's nothing to show.
 */
- (void)showNextPage
{
    // Should never happen
    NSAssert([self canShowNextPage], @"Tried to showNextPage when canShowNextPage fails");
    
    // If this is our first time showing a page, clear out the initial imageviews
    if (self.currentPage < 0) {
        for (UIView *subView in self.popsScrollView.subviews) {
            [subView removeFromSuperview];
        }
    }
    
    ++self.currentPage;
    NSInteger firstIndex = [[self class] firstIndexForPage:self.currentPage];
    NSInteger lastIndex = firstIndex + kPlacesPerPage;
    Place *place;
    PlaceSquareView *squareCell;
    
    // Adjust the content size of the scroll view to accommodate the new places we've just added
    [self adjustScrollViewContentSize];
    
    // Now add more cells to fill up the new content
    [self addFourMoreQuadrantCells];
    
    for (int i = firstIndex; i < lastIndex; ++i) {
        place = [self.places objectAtIndex:i];
        squareCell = [self.quadrantCells objectAtIndex:i];
        [squareCell setWithPlace:place context:self.managedObjectContext];
    }
    
    // Now scroll to the newest pops
    CGFloat popsScrollViewWidth = PlaceSquareView.size.width * 2.0f;
    [self.popsScrollView setContentOffset:CGPointMake(self.currentPage * popsScrollViewWidth, 0.0f) animated:NO];
}

#pragma mark - Storyboard Segue

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:kShowDashViewDetailsSegueIdentifier]) {
        Place *place = (Place *)sender;
        PlaceViewController *placeViewController = (PlaceViewController *)[segue destinationViewController];
        [placeViewController setPlace:place];
        
        // Make sure it has a managed object context
        [placeViewController setManagedObjectContext:self.managedObjectContext];
        
        // Make sure the tabbar hides so we can replace it with a toolbar
        placeViewController.hidesBottomBarWhenPushed = YES;
    }
    else if ([[segue identifier] isEqualToString:kPresentFilterViewController]) {
        //NSLog(@"Presenting filter view controller");
    }
    else if ([[segue identifier] isEqualToString:kShowLoginViewControllerSegueIdentifier]) {
        //NSLog(@"Show login view controller");
    }
}

- (void)showLogin 
{
    [self performSegueWithIdentifier:kShowLoginViewControllerSegueIdentifier sender:nil];
}

#pragma mark - PlaceSquareViewDelegate

- (void)pushPlaceAtIndex:(NSInteger)index
{
    // Perform segue to place view controller
    Place *place = [self.places objectAtIndex:index];
    [self performSegueWithIdentifier:kShowDashViewDetailsSegueIdentifier sender:place];
}

#pragma mark - RKObjectLoaderDelegate methods

- (void)objectLoader:(RKObjectLoader *)objectLoader didLoadObjects:(NSArray *)objects 
{
    // We are done loading, so stop the progress hud
    [self.progressHUD hide:YES]; 
    
    // Get the objects we've just loaded and fill our places array with them
    [self.places addObjectsFromArray:objects];
    
    // Now, show them
    [self showNextPage];
}

- (void)objectLoader:(RKObjectLoader *)objectLoader didFailWithError:(NSError *)error 
{
    //NSLog(@"Encountered an error: %@", error);
}

#pragma mark - MBProgressHUDDelegate methods

- (void)hudWasHidden:(MBProgressHUD *)hud {
    
}

@end
