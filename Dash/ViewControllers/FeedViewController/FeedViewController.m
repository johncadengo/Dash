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
#import "Action.h"
#import "Action+Helper.h"
#import "Highlight.h"
#import "Highlight+Helper.h"
#import "Like.h"
#import "Like+Helper.h"
#import "PlaceViewController.h"
#import "CustomSegmentView.h"

@implementation FeedViewController

@synthesize managedObjectContext = __managedObjectContext;
@synthesize api = _api;
@synthesize feedItems = _feedItems;
@synthesize refreshHeaderView = _refreshHeaderView;
@synthesize hud = _hud;
@synthesize backgroundBubble = _backgroundBubble;
@synthesize customSegmentView = _customSegmentView;

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
    self.tableView.backgroundColor = UIColorFromRGB(kPlaceOrangeBGColor);
    
    // Make our progress hud
    self.hud = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:self.hud];
    [self.hud setDelegate:self];
    self.hud.removeFromSuperViewOnHide = NO;
    
    // Make the call
    [self.hud show:YES];
    [self refreshFeed];
    
    // Segmented control
    self.customSegmentView = [[CustomSegmentView alloc] initWithFrame:
                              CGRectMake(70.25, 7.25f, 359.0f / 2.0f, 59.0f / 2.0f)];
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
    
    [self.navigationController.navigationBar addSubview:self.customSegmentView];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [self.customSegmentView removeFromSuperview];
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
    // Get the blurb we are using for that row
    Action *action = [self.feedItems objectAtIndex:indexPath.row];
    return [ActionViewCell heightForAction:action];
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger numRows = [self.feedItems count];
    
    return numRows;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ActionViewCell *cell = (ActionViewCell *)[tableView dequeueReusableCellWithIdentifier:kFeedItemCellIdentifier];
    
    if (cell == nil) {
        cell = [[ActionViewCell alloc] initWithStyle:UITableViewCellStyleDefault 
                                     reuseIdentifier:kFeedItemCellIdentifier];
    }
    
    Action *action = [[self feedItems] objectAtIndex:indexPath.row];
    [cell setWithAction:action];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    PlaceAction *placeAction = [self.feedItems objectAtIndex:indexPath.row];
    [self performSegueWithIdentifier:kShowFeedItemDetailsSegueIdentifier sender:placeAction];
}

#pragma mark - Storyboard Segue

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:kShowFeedItemDetailsSegueIdentifier]) {
        Like *like = (Like *) sender;
        Highlight *highlight = like.highlight;
        Place *place = highlight.place;
        
        PlaceViewController *placeViewController = (PlaceViewController *)[segue destinationViewController];
        [placeViewController setPlace:place];
        
        // Make sure it has a managed object context
        [placeViewController setManagedObjectContext:self.managedObjectContext];
        
        // Make sure the tabbar hides so we can replace it with a toolbar
        placeViewController.hidesBottomBarWhenPushed = YES;
    }
}

#pragma mark -

- (void) refreshFeed
{
    [self.api feedForPerson:nil];
}

#pragma mark - RKObjectLoaderDelegate methods

- (void)objectLoader:(RKObjectLoader *)objectLoader didLoadObjects:(NSArray *)objects 
{
    // Let them know we're done
    [self.hud hide:YES];
    
    NSLog(@"Feed items: %@", objects);
    self.feedItems = [[NSMutableArray alloc] initWithArray:objects];
    
    // TODO: These are fakes
    [self.feedItems addObjectsFromArray:objects];
    [self.feedItems addObjectsFromArray:objects];
    [self.feedItems addObjectsFromArray:objects];
    [self.feedItems addObjectsFromArray:objects];
    [self.feedItems addObjectsFromArray:objects];
    [self.feedItems addObjectsFromArray:objects];
    
    // If we are switching from a different mode, need to hide the back views so that swipe will reset and work.
    [self.tableView reloadData];
    
    [_refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:self.tableView];
}

- (void)objectLoader:(RKObjectLoader *)objectLoader didFailWithError:(NSError *)error 
{
    NSLog(@"Encountered an error: %@", error);
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
