//
//  PlacesViewController.m
//  Dash
//
//  Created by John Cadengo on 10/20/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "PlaceActionsViewController.h"
#import "Place.h"
#import "DashAPI.h"
#import "Constants.h"
#import "PlaceViewController.h"
#import "PlaceAction.h"

@implementation PlaceActionsViewController

@synthesize managedObjectContext = __managedObjectContext;
@synthesize api = _api;
@synthesize refreshHeaderView = _refreshHeaderView;
@synthesize hud = _hud;
@synthesize requests = _requests;
@synthesize feedItems = _feedItems;
@synthesize recommended = _recommended;
@synthesize saved = _saved;

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
    self.recommended = [[NSMutableArray alloc] init];
    self.saved = [[NSMutableArray alloc] init];
    
    // Ask for our initial results
    self.requests = [self.api placeActionsForPerson:nil]; 
    
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
	//[self performSelector:@selector(doneLoadingTableViewData) withObject:nil afterDelay:3.0];
	
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
    NSInteger section = [indexPath section];
    NSInteger row = [indexPath row];
    
    CGFloat height = 0.0;
    
    switch (section) {
        case kPlaceListSection:
            height = [self heightForFeedCellForRow:row];
            break;
        default:
            // Should never happen
            NSAssert(NO, @"Asking for the height of a row in a section that doesn't exist: %d", section);
            break;
    }
    
    return height;
}

- (CGFloat)heightForFeedCellForRow:(NSInteger)row
{
    // Get the blurb we are using for that row
    PlaceAction *placeAction = [self.feedItems objectAtIndex:row];
    return [PlaceActionViewCell heightForPlaceAction:placeAction withCellType:PlaceActionViewCellTypeList];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return kNumSections;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [self.feedItems count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PlaceActionViewCell *cell = (PlaceActionViewCell *)[tableView dequeueReusableCellWithIdentifier:kPlacesPlaceCellIdentifier];
    
    if (cell == nil) {
        cell = [[PlaceActionViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kPlacesPlaceCellIdentifier cellType:PlaceActionViewCellTypeList];
    }
    
    NSInteger row = [indexPath row];
    [cell setWithPlaceAction:[self.feedItems objectAtIndex:row]];
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
    
    [super tableView:tableView didSelectRowAtIndexPath:indexPath];
    
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
    }
}

#pragma mark - RKObjectLoaderDelegate methods

- (void)objectLoader:(RKObjectLoader *)objectLoader didLoadObjects:(NSArray *)objects 
{
    // We currently have two types of place actions coming in: saves, recommends
    // Figure out which kind it is based on the userData passed.
    NSNumber *requestType = objectLoader.userData;
    
    NSLog(@"%@", objects);
    
    if ([requestType isEqualToNumber:[NSNumber numberWithInt:kSaves]]) {
        // For now, we are only loading saved places
        [self.saved addObjectsFromArray:objects];
        [self.feedItems addObjectsFromArray:self.saved];
        
    }
    else if ([requestType isEqualToNumber:[NSNumber numberWithInt:kRecommends]]) {
        // For now, we are only loading saved places
        [self.saved addObjectsFromArray:objects];
        [self.feedItems addObjectsFromArray:self.saved];
    }
    
    // If we are switching from a different mode, need to hide the back views so that swipe will reset and work.
    [self hideVisibleBackView:NO];
    [self.tableView reloadData];
    
    // TODO: Gotta do this asynchronously 
    [_refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:self.tableView];
}

- (void)objectLoader:(RKObjectLoader *)objectLoader didFailWithError:(NSError *)error 
{
    NSLog(@"Encountered an error: %@", error);
}

#pragma mark - Place view cell delegate

- (void)cellBackButtonWasTapped:(PlaceActionViewCell *)cell
{
    
}

#pragma mark - TISwipeableTableView stuff


- (void)tableView:(UITableView *)tableView didSwipeCellAtIndexPath:(NSIndexPath *)indexPath 
{	
    NSLog(@"SWIPE");
	[super tableView:tableView didSwipeCellAtIndexPath:indexPath];
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
    // For TISwipeableTableViewCells
	[super scrollViewDidScroll:scrollView];
    
    // For our EGO pull refresh header
	[_refreshHeaderView egoRefreshScrollViewDidScroll:scrollView];
    
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{	
	[_refreshHeaderView egoRefreshScrollViewDidEndDragging:scrollView];
	
}

@end
