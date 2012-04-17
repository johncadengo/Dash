//
//  PlacesViewController.m
//  Dash
//
//  Created by John Cadengo on 10/20/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "RecommendedPlacesViewController.h"
#import "Place.h"
#import "DashAPI.h"
#import "Constants.h"
#import "PlaceViewController.h"
#import "PlaceAction.h"

@implementation RecommendedPlacesViewController

@synthesize managedObjectContext = __managedObjectContext;
@synthesize api = _api;
@synthesize refreshHeaderView = _refreshHeaderView;
@synthesize hud = _hud;
@synthesize feedItems = _feedItems;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
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
    
    // Connect to our API.
    self.api = [[DashAPI alloc] initWithManagedObjectContext:self.managedObjectContext delegate:self];
    
    // Prepare our arrays of place actions
    self.feedItems = [[NSMutableArray alloc] init];
    
    [self.tableView setSeparatorStyle: UITableViewCellSeparatorStyleNone];
    
    // Make our refresh header view
    if (_refreshHeaderView == nil) {
		EGORefreshTableHeaderView *view = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0.0f, 0.0f - self.tableView.bounds.size.height, self.view.frame.size.width, self.tableView.bounds.size.height)];
		view.delegate = self;
		[self.tableView addSubview:view];
		_refreshHeaderView = view;
	}
	
	//  update the last update date
	[_refreshHeaderView refreshLastUpdatedDate];
    
    // Change the color of the background..
    self.view.backgroundColor = UIColorFromRGB(kPlaceOrangeBGColor);
    
    // Make a call to the api
    [self refreshFeed]; 
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
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
    // TODO: Return the date the data source was last changed. This is fake for now.
	return [NSDate date];
	
}

#pragma mark - Table view delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [RecommendedPlaceViewCell heightForType:[self recommendedPlaceViewCellTypeForRow:[indexPath row]]];
}

- (RecommendedPlaceViewCellType)recommendedPlaceViewCellTypeForRow:(NSInteger)row
{
    RecommendedPlaceViewCellType type;
    NSInteger last = [self.feedItems count] - 1;
    
    if (row == 0) {
        type = RecommendedPlaceViewCellTypeFirst;
    }
    else if (row == last) {
        type = RecommendedPlaceViewCellTypeLast;
    }
    else {
        type = RecommendedPlaceViewCellTypeMiddle;
    }
    
    return type;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [self.feedItems count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    RecommendedPlaceViewCell *cell = (RecommendedPlaceViewCell *)[tableView dequeueReusableCellWithIdentifier:kPlacesPlaceCellIdentifier];
    
    NSInteger row = [indexPath row];
    
    if (cell == nil) {
        cell = [[RecommendedPlaceViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kPlacesPlaceCellIdentifier type:[self recommendedPlaceViewCellTypeForRow:row]];
    }
    
    // Always update type
    [cell setType:[self recommendedPlaceViewCellTypeForRow:row]];
    [cell setWithPlace:[[self.feedItems objectAtIndex:row] place] context:self.managedObjectContext];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSUInteger row = [indexPath row];
    
    PlaceAction *placeAction = [self.feedItems objectAtIndex:row];
    Place *place = [placeAction place];
    [self performSegueWithIdentifier:kShowPlaceActionDetailsSegueIdentifier sender:place];
}

#pragma mark - Storyboard Segue

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:kShowPlaceActionDetailsSegueIdentifier]) {
        Place *place = (Place *)sender;
        PlaceViewController *placeViewController = (PlaceViewController *)[segue destinationViewController];
        [placeViewController setPlace:place];
        
        // Make sure it has a managed object context
        [placeViewController setManagedObjectContext:self.managedObjectContext];
        
        
        // Make sure the tabbar hides so we can replace it with a toolbar
        placeViewController.hidesBottomBarWhenPushed = YES;
    }
}

#pragma mark - RKObjectLoaderDelegate methods

- (void)objectLoader:(RKObjectLoader *)objectLoader didLoadObjects:(NSArray *)objects 
{
    // We currently have two types of place actions coming in: saves, recommends
    // Figure out which kind it is based on the userData passed.
    NSNumber *requestType = objectLoader.userData;
    
    NSLog(@"%@", objects);
    
    self.feedItems = [NSMutableArray arrayWithArray:objects];
     
    // If we are switching from a different mode, need to hide the back views so that swipe will reset and work.
    [self.tableView reloadData];
    
    // TODO: Gotta do this asynchronously 
    [_refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:self.tableView];
}

- (void)objectLoader:(RKObjectLoader *)objectLoader didFailWithError:(NSError *)error 
{
    NSLog(@"Encountered an error: %@", error);
}

#pragma mark - ListModeCellDelegate

- (void)refreshFeed
{
    // Make a call to the api to request the feed
    //self.requests = [NSDictionary dictionaryWithDictionary:[self.api placeActionsForPerson:nil]];
    [self.api placeActionsForPerson:nil];
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
