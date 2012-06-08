//
//  FeedViewController.m
//  Dash
//
//  Created by John Cadengo on 10/20/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "FeedViewController.h"
#import "Constants.h"
#import "DashAPI.h"
#import "PlaceViewController.h"
#import "CustomSegmentView.h"
#import "NewsItem.h"
#import "NewsItem+Helper.h"
#import "JCLocationManagerSingleton.h"
#import "TestFlight.h"
#import "ProfileViewController.h"

@implementation FeedViewController

@synthesize managedObjectContext = __managedObjectContext;
@synthesize locationManager = _locationManager;
@synthesize api = _api;
@synthesize feedItems = _feedItems;
@synthesize refreshHeaderView = _refreshHeaderView;
@synthesize hud = _hud;
@synthesize searching = _searching;
@synthesize backgroundBubble = _backgroundBubble;
@synthesize customSegmentView = _customSegmentView;
@synthesize alertView = _alertView;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom stuff
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
    
    // Connect to our API.
    self.api = [[DashAPI alloc] initWithManagedObjectContext:self.managedObjectContext delegate:self];
    
    [self.tableView setSeparatorStyle: UITableViewCellSeparatorStyleNone];

    if (_refreshHeaderView == nil) {
		EGORefreshTableHeaderView *view = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0.0f, 0.0f - self.tableView.bounds.size.height, self.view.frame.size.width, self.tableView.bounds.size.height)];
		view.delegate = self;
		[self.tableView addSubview:view];
		_refreshHeaderView = view;
	}
	
	//  update the last update date
	[_refreshHeaderView refreshLastUpdatedDate];
    
    // Set up the fake background view
    self.backgroundBubble = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"BackgroundBubble.png"]];
    self.tableView.backgroundView = self.backgroundBubble;
    self.tableView.backgroundColor = UIColorFromRGB(kGreyBGColor);
    
    // Make our progress hud
    self.hud = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:self.hud];
    [self.hud setDelegate:self];
    self.hud.removeFromSuperViewOnHide = NO;
    
    // Figure out where we are
    self.locationManager = [JCLocationManagerSingleton sharedInstance];
    
    // Make the call
    [self.hud show:YES];
    self.searching = YES;
    [self refreshFeed];
    
    // Segmented control
    //self.customSegmentView = [[CustomSegmentView alloc] initWithFrame:
    //                          CGRectMake(70.25, 7.25f, 359.0f / 2.0f, 59.0f / 2.0f)];
    
    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    
    self.refreshHeaderView = nil;
    self.hud = nil;
    self.customSegmentView = nil;
    self.backgroundBubble = nil;
    self.alertView = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.hud.delegate = self;
    
    [self.navigationController.navigationBar addSubview:self.customSegmentView];
    
    // Set the custom nav bar
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"TopBar.png"] forBarMetrics:UIBarMetricsDefault];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    self.hud.delegate = nil;
    
    [self.customSegmentView removeFromSuperview];
    
    // Reset it
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"TopBarWithoutDash.png"] forBarMetrics:UIBarMetricsDefault];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark -
#pragma mark EGORefreshTableHeaderDelegate Methods

- (void)egoRefreshTableHeaderDidTriggerRefresh:(EGORefreshTableHeaderView*)view
{	
    // Causes the table view to reload our data source
    [self.refreshHeaderView performSelector:@selector(egoRefreshScrollViewDataSourceDidFinishedLoading:) withObject:self.tableView afterDelay:2.0];
    [self refreshFeed];
}

- (BOOL)egoRefreshTableHeaderDataSourceIsLoading:(EGORefreshTableHeaderView*)view
{
    // The data source is reloading? 
    // TODO: Figure out how to actually check
	return (self.feedItems == nil) ? YES : NO;
	
}

- (NSDate*)egoRefreshTableHeaderDataSourceLastUpdated:(EGORefreshTableHeaderView*)view
{	
     // TODO: Return the date the data source was last changed. THis is fake for now.
	return [NSDate date];
	
}

#pragma mark - Table view delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat height = 0.0f; 
    if (self.feedItems.count) {
        NewsItem *item = [self.feedItems objectAtIndex:indexPath.row];
        height = [NewsItemViewCell heightForNewsItem:item];    
    }
    else {
        height = 150.0f; // No results height
    }
    return height;
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger numRows = (self.feedItems.count) ? self.feedItems.count : 1; // 1 for no one nearby message
    
    return numRows;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    id newCell;
    
    if (self.feedItems.count) {
        NewsItemViewCell *cell = (NewsItemViewCell *)[tableView dequeueReusableCellWithIdentifier:kFeedItemCellIdentifier];
        
        if (cell == nil) {
            cell = [[NewsItemViewCell alloc] initWithStyle:UITableViewCellStyleDefault 
                                         reuseIdentifier:kFeedItemCellIdentifier];
        }
        
        NewsItem *newsItem = [[self feedItems] objectAtIndex:indexPath.row];
        [cell setWithNewsItem:newsItem];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        
        // Make sure the image button connects
        [cell.icon addTarget:self action:@selector(showProfile:) forControlEvents:UIControlEventTouchUpInside];
        [cell.icon setTag:indexPath.row];
        
        newCell = cell;
    }
    else {
        // No one nearby message
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kSearchNoResultsCellIdentifier];
        
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kSearchNoResultsCellIdentifier];
        }
        
        if (!self.isSearching) {
            [cell setBackgroundView:[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"NoOneNearbyMessage"]]];
        }
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        
        newCell = cell;
    }
    
    return newCell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.feedItems.count) {
        NewsItem *newsItem = [self.feedItems objectAtIndex:indexPath.row];
        [self performSegueWithIdentifier:kShowFeedItemDetailsSegueIdentifier sender:newsItem];
    }
}

#pragma mark - Storyboard Segue

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:kShowFeedItemDetailsSegueIdentifier]) {
        NewsItem *newsItem = (NewsItem *)sender;
        Place *place = newsItem.place;
        
        PlaceViewController *placeViewController = (PlaceViewController *)[segue destinationViewController];
        [placeViewController setPlace:place];
        
        // Make sure it has a managed object context
        [placeViewController setManagedObjectContext:self.managedObjectContext];
        
        // Make sure the tabbar hides so we can replace it with a toolbar
        placeViewController.hidesBottomBarWhenPushed = YES;
    }
    if ([[segue identifier] isEqualToString:kShowProfileViewControllerIdentifier]) {
        Person *person = (Person *)sender;
        ProfileViewController *profileViewController = (ProfileViewController *)[segue destinationViewController];
        
        profileViewController.managedObjectContext = self.managedObjectContext;
        profileViewController.person = person;
        [profileViewController.recommends removeAllObjects];
        [profileViewController.highlights removeAllObjects];
        [profileViewController.likeHighlights removeAllObjects];
        
        [TestFlight passCheckpoint:@"Viewed friend's profile"];
    }
}

#pragma mark -

- (void) refreshFeed
{
    CLLocation *loc = [self.locationManager location];
    
    if (INTERNET_REACHABLE) {
        [self.api feedForPerson:[DashAPI me] near:loc];
    }
    else {
        // We can't reach the internet, so let the user know
        [self.hud hide:YES];
        
        if (self.alertView == nil) {
            self.alertView = [[UIAlertView alloc] initWithTitle:@"Oh no!" 
                                                        message:kNoInternetMessage 
                                                       delegate:nil
                                              cancelButtonTitle:@"Ok" 
                                              otherButtonTitles:nil];
        }
        
        [self.alertView show];
    }
}

- (void)showProfile:(id)sender;
{
    UIButton *button = (UIButton *)sender;
    NSInteger row = button.tag;
    
    NewsItem *newsItem = [self.feedItems objectAtIndex:row];
    Person *person = newsItem.author;
    [self performSegueWithIdentifier:kShowProfileViewControllerIdentifier sender:person];
}

#pragma mark - RKObjectLoaderDelegate methods

- (void)objectLoader:(RKObjectLoader *)objectLoader didLoadObjects:(NSArray *)objects 
{
    // Let them know we're done
    [self.hud hide:YES];
    
    self.feedItems = [[NSMutableArray alloc] initWithArray:objects];
    
    // If we are switching from a different mode, need to hide the back views so that swipe will reset and work.
    [self.tableView reloadData];
    
    [_refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:self.tableView];
}

- (void)objectLoader:(RKObjectLoader *)objectLoader didFailWithError:(NSError *)error 
{
    TFLog(@"Encountered an error: %@", error);
    
    [self.hud hide:YES];
}

#pragma mark - HUD delegate

- (void)hudWasHidden:(MBProgressHUD *)hud
{
    self.searching = NO;
    [self.tableView reloadData];
}

#pragma mark -
#pragma mark UIScrollViewDelegate Methods

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{	
    // For our EGO pull refresh header
	[_refreshHeaderView egoRefreshScrollViewDidScroll:scrollView];
    
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{	
	[_refreshHeaderView egoRefreshScrollViewDidEndDragging:scrollView];
	
}

@end