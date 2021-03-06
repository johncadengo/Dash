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
#import "TestFlight.h"

@implementation DashViewController

@synthesize managedObjectContext = __managedObjectContext;
@synthesize api = _api;
@synthesize locationManager = _locationManager;
@synthesize places = _places;

@synthesize loading = _loading;
@synthesize dragging = _dragging;
@synthesize filterShowing = _filterShowing;
@synthesize didLoad = _didLoad;

@synthesize popsScrollView = _popsScrollView;
@synthesize quadrantImages = _quadrantImages;
@synthesize progressHUD = _progressHUD;
@synthesize alertView = _alertView;
@synthesize popBackground = _popBackground;
@synthesize popsScrollViewFrame = _popsScrollViewFrame;
@synthesize popBackgroundFrame = _popBackgroundFrame;
@synthesize popButtonFrame = _popButtonFrame;
@synthesize popButton = _popButton;
@synthesize dashButtonTip = _dashButtonTip;

@synthesize draggableFrame = _draggableFrame;
@synthesize flipGripFrame = _flipGripFrame;
@synthesize flipGrip = _flipGrip;

@synthesize filterViewFrame = _filterViewFrame;
@synthesize filterView = _filterView;
@synthesize filterViewController = _filterViewController;
@synthesize drag = _drag;
@synthesize swipeUp = _swipeUp;
@synthesize swipeDown = _swipeDown;

#pragma mark - UI Constants
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
    self.didLoad = NO;
    // The visible view at all times
    //self.view = [[UIView alloc] init];
    [super loadView];
    self.view.backgroundColor = [UIColor blackColor];
    
    // Set up the quadrantImages
    UIImage *firstImage = [UIImage imageNamed:@"DashGreenBox.png"]; 
    UIImage *secondImage = [UIImage imageNamed:@"DashOrangeBox.png"]; 
    UIImage *thirdImage = [UIImage imageNamed:@"DashRedBox.png"]; 
    UIImage *fourthImage = [UIImage imageNamed:@"DashTealBox.png"];
    self.quadrantImages = [[NSArray alloc] initWithObjects:
                           firstImage, secondImage, thirdImage, fourthImage, nil];
    
    // Add our pops scroll view
    CGFloat popsScrollViewWidth = PlaceSquareView.size.width * 2.0f;
    CGFloat popsScrollViewHeight = PlaceSquareView.size.height * 2.0f;
    self.popsScrollViewFrame = CGRectMake(0.0f, 0.0f, popsScrollViewWidth, popsScrollViewHeight);
    self.popsScrollView = [[PopsScrollView alloc] initWithFrame:self.popsScrollViewFrame delegate:self];
    [self.view addSubview:self.popsScrollView];
}

- (void)viewDidLoad
{
    [super viewDidLoad];  
    
    // Initialize some things
    self.loading = NO;
    self.dragging = NO;
    self.filterShowing = NO;
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
    self.popButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.popButton addTarget:self 
                       action:@selector(popScroll:)
             forControlEvents:UIControlEventTouchUpInside];
    //[self.popButton setTitle:@"dash" forState:UIControlStateNormal];
    //[self.popButton.titleLabel setFont:[UIFont fontWithName:kPlutoBold size:42.5f]];
    //[self.popButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.popButton setBackgroundImage:[UIImage imageNamed:@"DashOrangeButton"] forState:UIControlStateNormal];
    [self.popButton setBackgroundImage:[UIImage imageNamed:@"DashOrangeButtonPressed"] forState:UIControlStateHighlighted];
    self.popButtonFrame = CGRectMake(10.0f, kPopBackgroundY + kPopButtonYOffset, 300.0f, 54.5f);
    self.popButton.frame = self.popButtonFrame;
    [self.view addSubview:self.popButton];

    // Figure out where we are
    self.locationManager = [JCLocationManagerSingleton sharedInstance];
    
    // Add our progress hud
    self.progressHUD = [[MBProgressHUD alloc] initWithView:self.view];
    self.progressHUD.yOffset = -44.0f;
    [self.view addSubview:self.progressHUD];
    self.progressHUD.delegate = self;
    self.progressHUD.removeFromSuperViewOnHide = NO;
    
    // Add our draga gesture recognizer
    self.drag = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handleDrag:)];
    [self.view addGestureRecognizer:self.drag];
    [self.drag setDelegate:self];
    [self.drag setCancelsTouchesInView:NO];
    
    // And our swipe gestures
    self.swipeUp = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipe:)];
    [self.swipeUp setDirection:UISwipeGestureRecognizerDirectionUp];
    [self.swipeUp setDelegate:self];
    
    self.swipeDown = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipe:)];
    [self.swipeDown setDirection:UISwipeGestureRecognizerDirectionDown];
    [self.swipeDown setDelegate:self];
    
    [self.view addGestureRecognizer:self.swipeDown];
    [self.view addGestureRecognizer:self.swipeUp];
    
    // Hide our navigation bar
    [self.navigationController setNavigationBarHidden:YES];

    // Initial filter view frame
    self.filterViewFrame = CGRectMake(0.0f, 360.0f, 320.0f, 480.0f);
    
    self.didLoad = YES;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.progressHUD.delegate = self;
    
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    
    if (![DashAPI skipLogin]) {
        [self showLogin];
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
    
    // Tip logic
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSNumber *timesDashShown = [defaults objectForKey:@"TimesDashShown"];
    
    // Show the filter swipe tip on the 2nd try
    if (timesDashShown && [timesDashShown compare:[NSNumber numberWithInt:1]] == NSOrderedSame) {
        // Increment times dash shown in our defaults
        [defaults setObject:[NSNumber numberWithInt:timesDashShown.intValue+1] forKey:@"TimesDashShown"];
        
        // Show filter swipe tip
        self.dashButtonTip = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"DashFilterTip"]];
        [self.view addSubview:self.dashButtonTip];
    }
    else if (!timesDashShown){
        // Add times dash shown to our defaults
        [defaults setObject:[NSNumber numberWithInt:1] forKey:@"TimesDashShown"];
        
        // Show dash button tip
        self.dashButtonTip = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"DashButtonTip"]];
        [self.view addSubview:self.dashButtonTip];
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    // Figure out where we are
    
    [self.filterView removeFromSuperview];
    
    self.progressHUD.delegate = nil;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    self.popsScrollView = nil;
    self.popBackground = nil;
    self.popButton = nil;
    self.flipGrip = nil;
    self.filterViewController = nil;
    self.filterView = nil;
    self.alertView = nil;
    self.dashButtonTip = nil;
    self.progressHUD = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - UIGestureRecognizer Delegate

/** Want certain events to pass right through
 */
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    if (gestureRecognizer == self.drag) {
        CGPoint origin = [touch locationInView:self.view];
        BOOL insideScrollView = CGRectContainsPoint(self.popsScrollView.frame, origin);
        BOOL insideFilterView = CGRectContainsPoint(self.filterView.frame, origin);
        return (insideScrollView || insideFilterView) ? NO : YES;
    }
    else {
        return YES;
    }
}

/** Perceive a drag and respond accordingly
 */
- (void)handleDrag:(UIPanGestureRecognizer *)gestureRecognizer
{
    // If the tip is showing, dismiss it
    if ([self.dashButtonTip superview]) {
        [self.dashButtonTip removeFromSuperview];
    }
    
    UIView *dragSuperView = self.view;
    if (self.isDragging && gestureRecognizer.state == UIGestureRecognizerStateEnded) {
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
        [self performSegueWithIdentifier:kPresentFilterViewController sender:nil];
        // Keep track of where we are
        CGPoint origin = [gestureRecognizer locationInView:dragSuperView];
        
        // As long as we aren't going above the top of the view, have it follow the drag
        if (CGRectContainsPoint(dragSuperView.frame, origin)) {
            // Only allow dragging to a certain point. Don't let drag further down.
            CGPoint translatedPoint = [gestureRecognizer translationInView:dragSuperView];
            
            // Our offset is different depending on if the filter is showing or not
            CGFloat offset = (self.isFilterShowing) ? (PlaceSquareView.size.height * 2) : 0.0f;
            
            if (translatedPoint.y < offset) {
                // Track the drag
                [self offsetFrames:translatedPoint.y - offset];
            }
            else {
                // Stick to the bottom
                [self hideFilter];
            }
        }
    }
    else if (gestureRecognizer.state == UIGestureRecognizerStateBegan) {
        // Now, we are dragging
        self.dragging = YES;
    }
}

- (void)handleSwipe:(UISwipeGestureRecognizer *)gestureRecognizer
{
    // If the tip is showing, dismiss it
    if ([self.dashButtonTip superview]) {
        [self.dashButtonTip removeFromSuperview];
    }
    
    if (self.swipeUp == gestureRecognizer && !self.filterShowing) {
        // If the filter isn't showing, and we swipe up, then show it
        [UIView animateWithDuration:1.0f
                              delay:0.0
                            options:UIViewAnimationCurveLinear
                         animations:^{
                             [self showFilter];
                         }
                         completion:^(BOOL finished){
                             self.filterShowing = YES;
                         }];
    }
    else if (self.swipeDown == gestureRecognizer && self.filterShowing) {
        // If the filter is showing, and we swipe down, then hide it
        [UIView animateWithDuration:1.0f
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

- (void)hideFilter
{
    [self offsetFrames:0.0f];
}

- (void)showFilter
{
    [self performSegueWithIdentifier:kPresentFilterViewController sender:nil];
    [self offsetFrames:-(PlaceSquareView.size.height * 2)];
    
    [TestFlight passCheckpoint:@"Found Filter View"];
}

- (void)offsetFrames:(CGFloat)offset
{
    // Grab the popsscrollview and drag it
    self.popsScrollView.frame = CGRectOffset(self.popsScrollViewFrame, 0.0f, offset);
    
    // Grab the popbutton and its background and drag em too
    self.popBackground.frame = CGRectOffset(self.popBackgroundFrame, 0.0f, offset);
    self.popButton.frame = CGRectOffset(self.popButtonFrame, 0.0f, offset);
    
    self.flipGrip.frame = CGRectOffset(self.flipGripFrame, 0.0f, offset);
    
    // Grab the filter view and drag it up
    // 54.5f is the popbutton's height...
    self.filterView.frame = CGRectOffset(self.filterViewFrame, 0.0f, offset + 51.0f);
}

#pragma mark -

- (void)popScroll:(id)sender
{
    // If filter is showing.. Animate down and pop
    if (self.filterShowing) {
        self.popsScrollView.currentPage = self.popsScrollView.maxPage;
        [self.popsScrollView updateVisibleCells];
        [UIView animateWithDuration:1.0f
                              delay:0.0f
                            options:UIViewAnimationCurveLinear
                         animations:^{
                             [self hideFilter];
                         }
                         completion:^(BOOL finished){
                             self.filterShowing = NO;
                         }];
    }
    else {
        self.popsScrollView.currentPage++;
        [self.popsScrollView updateVisibleCells];
    }
}

- (void)pop:(id) sender
{
    // If we're loading, ignore a pop
    if (self.isLoading) {
        return;
    }
    
    // If the tip is showing, dismiss it
    if ([self.dashButtonTip superview]) {
        [self.dashButtonTip removeFromSuperview];
    }
    
    // Find out where we are
    CLLocation *loc = [self.locationManager location];
    
    // If we have enough places to show, show next page
    //if ([self canShowNextPage]) {
    //    [self showNextPage];
    //}
    //else if (INTERNET_REACHABLE) {
    if (INTERNET_REACHABLE) {
        // Otherwise, as long as we can reach the internet, indicate we are now loading
        self.loading = YES;
        self.popsScrollView.scrollEnabled = NO;
        [self.progressHUD show:YES];
        
        // Figure out the filters
        NSMutableString *prices = [[NSMutableString alloc] initWithCapacity:16];
        BOOL check;
        for (int i = 0; i < 4; i++) {
            check = [[self.filterViewController.filterView.pricesChecked objectAtIndex:i] boolValue];
            
            if (check) {
                for (int j = 0; j < i + 1; j++) {
                    [prices appendFormat:@"$"];
                }
                
                [prices appendFormat:@","];
            }
        }
        
        // Have to account for if the filterview hasn't been segued to yet
        NSString *distance = (self.filterViewController) ? [self.filterViewController stringForDistanceFilter:self.filterViewController.filterView.currentDistanceFilter] : @"";
        
        // And send request to API for more places
        NSString *locParam;
        if (self.filterViewController.customLocation) {
            locParam = self.filterViewController.customLocationGeocoded;
        }
        else {
            locParam = [NSString stringWithFormat:@"%f, %f", loc.coordinate.latitude,
                                  loc.coordinate.longitude];
        }
        
        NSMutableString *types = [[NSMutableString alloc] initWithCapacity:16];
        for (int i = 0; i < 4; i++) {
            check = [[self.filterViewController.filterView.typesChecked objectAtIndex:i] boolValue];
            if (check) {
                [types appendFormat:@"%d,", i];
            }
        }

        [self.api pop:locParam types:types prices:prices distance:distance];
    }
    else {
        // We can't reach the internet, so let the user know
        if (self.alertView == nil && self.didLoad) {
            self.alertView = [[UIAlertView alloc] initWithTitle:@"Oh no!" 
                                                        message:kNoInternetMessage 
                                                       delegate:nil
                                              cancelButtonTitle:@"Ok" 
                                              otherButtonTitles:nil];
        }
        else {
            [self.alertView setMessage:kNoInternetMessage];
        }
        
        [self.alertView show];
    }
}

#pragma mark - Paging logic

- (UIImage *)imageForCellAtIndexPath:(NSIndexPath *)indexPath
{
    UIImage *image = nil;
    NSInteger sectionParity = indexPath.section % 2;
    
    if (sectionParity == 0) {
        // This means we're on the left half of the screen, i.e. second or third image, i.e. index 1 and 2
        if (indexPath.row == 0) {
            image = [self.quadrantImages objectAtIndex:1];
        }
        else {
            image = [self.quadrantImages objectAtIndex:2];
        }
    }
    else {
        // Right half of screen
        if (indexPath.row == 0) {
            image = [self.quadrantImages objectAtIndex:0];
        }
        else {
            image = [self.quadrantImages objectAtIndex:3];
        }
    }
    
    return image;
}

- (NSInteger)indexForIndexPath:(NSIndexPath *)indexPath
{
    NSInteger index;
    
    index = (indexPath.section * 2) + indexPath.row;
    
    return index;
}

- (Place *)placeAtIndexPath:(NSIndexPath *)indexPath
{
    Place *place = nil;
    NSInteger index = [self indexForIndexPath:indexPath];
    
    if (index < self.places.count) {
        place = [self.places objectAtIndex:index];
    }
    else {
        // Get more
        [self pop:nil];
    }
    
    return place;
}

- (PlaceSquareView *)popsScrollView:(PopsScrollView *)popsScrollView cellAtIndexPath:(NSIndexPath *)indexPath
{
    PlaceSquareView *cell = [popsScrollView dequeueReuseableCellAtIndexPath:indexPath];
    
    if (cell == nil) {
        cell = [[PlaceSquareView alloc] initWithFrame:CGRectZero];
    }
    
    // Set stuff
    [cell setBackgroundImage:[self imageForCellAtIndexPath:indexPath]];
    
    Place *place = [self placeAtIndexPath:indexPath];
    if (place) {
        [cell setWithPlace:place context:self.managedObjectContext];
        cell.delegate = self;
        cell.index = [self indexForIndexPath:indexPath];
    }
    
    return cell;
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
    self.loading = NO;
    self.popsScrollView.scrollEnabled = YES;
    [self.progressHUD hide:YES]; 
    
    // Get the objects we've just loaded and fill our places array with them
    [self.places addObjectsFromArray:objects];
    
    // Now, show them
    if (objects.count) {
        self.popsScrollView.maxPage = (self.places.count / 4);
        NSLog(@"max page %d current page %d", self.popsScrollView.maxPage, self.popsScrollView.currentPage);
        [self.popsScrollView reloadData];
    }
    else {
        // Alert the user that we were unable to obtain results
        if (self.alertView == nil) {
            self.alertView = [[UIAlertView alloc] initWithTitle:@"Oh no!" 
                                                        message:@"We've run out of places in your area that fit the criteria you've specified!" 
                                                       delegate:nil
                                              cancelButtonTitle:@"Ok" 
                                              otherButtonTitles:nil];
        }
        else {
            [self.alertView setMessage:@"We were unable to retrive any results with the criteria you've specified! Please change your filter options."];
        }
        
        [self.alertView show];
    }
}

- (void)objectLoader:(RKObjectLoader *)objectLoader didFailWithError:(NSError *)error 
{
    //NSLog(@"Encountered an error: %@", error);
}

#pragma mark - MBProgressHUDDelegate methods

- (void)hudWasHidden:(MBProgressHUD *)hud {
    
}

@end
