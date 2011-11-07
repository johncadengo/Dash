//
//  FeedViewController.m
//  Dash
//
//  Created by John Cadengo on 10/20/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "FeedViewController.h"
#import "ListModeCell.h"
#import "Constants.h"
#import "DashAPI.h"
#import "Action.h"
#import "Action+Helper.h"
#import "Highlight.h"
#import "Highlight+Helper.h"
#import "HighlightViewController.h"

@implementation FeedViewController

@synthesize managedObjectContext = __managedObjectContext;
@synthesize api = _api;
@synthesize feedItems = _feedItems;
@synthesize listMode = _listMode;
@synthesize refreshHeaderView = _refreshHeaderView;

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
    self.api = [[DashAPI alloc] initWithManagedObjectContext:self.managedObjectContext];
    
    // Initialize our tableview's array which will represent its model.
    [self setListMode:kFriendsListMode];
    
    [self.tableView setSeparatorStyle: UITableViewCellSeparatorStyleNone];

    if (_refreshHeaderView == nil) {
		
		EGORefreshTableHeaderView *view = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0.0f, 0.0f - self.tableView.bounds.size.height, self.view.frame.size.width, self.tableView.bounds.size.height)];
		view.delegate = self;
		[self.tableView addSubview:view];
		_refreshHeaderView = view;
	}
	
	//  update the last update date
	[_refreshHeaderView refreshLastUpdatedDate];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
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
    
    // 
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
    [self setListMode:self.listMode];
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
     // TODO: Return the date the data source was last changed. THis is fake for now.
	return [NSDate date];
	
}

#pragma mark - Table view delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger section = [indexPath section];
    NSInteger row = [indexPath row];
    
    CGFloat height = 0.0;
    
    switch (section) {
        case kFeedListModeSection:
            // TODO: Make this a constant and figure out where to put it.
            height = 40.0;
            break;
        case kFeedFeedItemsSection:
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
    Action *action = [self.feedItems objectAtIndex:row];
    return [ActionViewCell heightForAction:action withCellType:ActionViewCellTypeFeedItem];
}

#pragma mark - Table view data source

/** Two sections:
    1) Segmented control for list mode
    2) Items in the news feed
 */
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return kFeedNumSections;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger numRows = 0;
    
    switch (section) {
        case kFeedListModeSection:
            numRows = kNumRowsForListModeSection;
            break;
        case kFeedFeedItemsSection:
            numRows = [self.feedItems count];
            break;
        default:
            // Should never happen
            NSAssert(NO, @"Asking for number of rows in a section that doesn't exist: %d", section);
            break;
    }
    
    return numRows;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger section = [indexPath section];
    NSInteger row = [indexPath row];
    id cell = nil;

    switch (section) {
        case kFeedListModeSection:
            cell = [self listModeCellForTableView:tableView];
            break;
        case kFeedFeedItemsSection:
            cell = [self feedCellForTableView:tableView forRow:row];
            break;
        default:
            // Should never happen
            NSAssert(NO, @"Asking for cell in a section that doesn't exist: %d", section);
            break;
    }
    
    return cell;
}


- (ListModeCell *)listModeCellForTableView:(UITableView *)tableView
{
    ListModeCell *cell = (ListModeCell*)[tableView dequeueReusableCellWithIdentifier:kListModeCellIdentifier];
    
    if (cell == nil) {
        cell = [[ListModeCell alloc] initWithStyle:UITableViewCellStyleDefault 
                                   reuseIdentifier:kListModeCellIdentifier 
                              selectedSegmentIndex:self.listMode];
    }
    
    [cell setDelegate:self];
    
    return cell;
}

- (ActionViewCell *)feedCellForTableView:(UITableView *)tableView forRow:(NSInteger)row
{
    ActionViewCell *cell = (ActionViewCell *)[tableView dequeueReusableCellWithIdentifier:kFeedItemCellIdentifier];
    
    if (cell == nil) {
        cell = [[ActionViewCell alloc] initWithStyle:UITableViewCellStyleDefault 
                                     reuseIdentifier:kFeedItemCellIdentifier
                                  cellType:ActionViewCellTypeFeedItem];
    }
   
    [cell setDelegate:self];
    Action *action = [[self feedItems] objectAtIndex:row];
    [cell setWithAction:action];
    
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

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
    
    NSInteger section = [indexPath section];
    NSInteger row = [indexPath row];
    
    // Only perform segue on a row in the feed item section being tapped, not on the very first section.
    if (section != kFeedListModeSection) {
        Highlight *highlight = [self.feedItems objectAtIndex:row];
        [self performSegueWithIdentifier:@"ShowFeedItemDetails" sender:highlight];
    }
}

#pragma mark - Storyboard Segue

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"ShowFeedItemDetails"]) {
        Highlight *highlight = (Highlight *) sender;
        HighlightViewController *highlightViewController = (HighlightViewController *)[segue destinationViewController];
        [highlightViewController setHighlight:highlight];
        
        // Make sure it has a managed object context
        [highlightViewController setManagedObjectContext:self.managedObjectContext];
    }
}

#pragma mark - TISwipeableTableView stuff


- (void)tableView:(UITableView *)tableView didSwipeCellAtIndexPath:(NSIndexPath *)indexPath 
{	
    NSLog(@"SWIPE");
	[super tableView:tableView didSwipeCellAtIndexPath:indexPath];
	

}

#pragma mark - ListModeCellDelegate
/** Overriding synthesized method to make sure that when this value is changed we call reloadData
    Shouldn't be a problem since ListMode is just an int.
 */
- (void)setListMode:(ListMode)newListMode
{
    _listMode = newListMode;
    NSMutableArray *newFeed;
    
    switch (self.listMode) {
        case kFriendsListMode:
            newFeed = [self.api feedForLocation:nil];
            break;
        case kNearbyListMode:
            newFeed = [self.api feedForPerson:nil];
            break;
        default:
            NSAssert(NO, @"Tried to change to a ListMode that does not exist: %d", newListMode);
            break; 
    }
    
    self.feedItems = newFeed;
    
    // If we are switching from a different mode, need to hide the back views so that swipe will reset and work.
    [self hideVisibleBackView:NO];
    [self.tableView reloadData];
    
    // TODO: Gotta do this asynchronously 
    [_refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:self.tableView];
}

#pragma mark - FeedItemCellDelegate

- (void)cellBackButtonWasTapped:(ActionViewCell *)cell {
	
	UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"BackView Button" 
														 message:@"WHOA! YOU TAPPED A BACKVIEW BUTTON!" 
														delegate:nil cancelButtonTitle:@"Sorry" 
											   otherButtonTitles:nil];
	[alertView show];
	
	[self hideVisibleBackView:YES];
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
