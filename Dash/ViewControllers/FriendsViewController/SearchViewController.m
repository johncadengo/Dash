//
//  FriendsViewController.m
//  Dash
//
//  Created by John Cadengo on 10/20/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "SearchViewController.h"
#import "DashAPI.h"
#import "Place.h"
#import "Place+Helper.h"
#import "Constants.h"
#import "PlaceViewController.h"

@implementation SearchViewController

@synthesize managedObjectContext = __managedObjectContext;
@synthesize api = _api;
@synthesize resultsForAutocompleteQuery = _resultsForAutocompleteQuery;
@synthesize resultsForSearchQuery = _resultsForSearchQuery;
@synthesize currentQuery = _currentQuery;
@synthesize hud = _hud;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        
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

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    // Connect to our API.
    self.api = [[DashAPI alloc] initWithManagedObjectContext:self.managedObjectContext delegate:self];
    
    // Prepare our array of results
    self.resultsForAutocompleteQuery = [[NSMutableDictionary alloc] init];
    self.resultsForSearchQuery = [[NSMutableDictionary alloc] init];
    
    // Tableview
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    self.view.backgroundColor = UIColorFromRGB(kPlaceOrangeBGColor);
    
    // Search bar
    [self.searchDisplayController.searchBar setTintColor:[UIColor blackColor]];
    [self clearSearchBarBackground];
    
    // Search text field
    UITextField *searchField;
    for(int i = 0; i < [self.searchDisplayController.searchBar.subviews count]; i++) {
        if([[self.searchDisplayController.searchBar.subviews objectAtIndex:i] isKindOfClass:[UITextField class]]) {
            searchField = [self.searchDisplayController.searchBar.subviews objectAtIndex:i];
            break;
        }
    }
    
    // Adjust some things
    searchField.borderStyle = UITextBorderStyleRoundedRect;
    searchField.backgroundColor = UIColorFromRGB(kSearchTextFieldBGColor);
    
    // Make our progress hud
    self.hud = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:self.hud];
    [self.hud setDelegate:self];
    self.hud.removeFromSuperViewOnHide = NO;
}

- (void)clearSearchBarBackground
{
    for (UIImageView *view in self.searchDisplayController.searchBar.subviews)
    {
        if ([view isKindOfClass:NSClassFromString
             (@"UISearchBarBackground")])
        {
            [view setImage:nil];
            break;
        }
    }
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
    
    // Clear cached results
    NSMutableArray *result;
    for (NSString *key in self.resultsForAutocompleteQuery) {
        result = [self.resultsForAutocompleteQuery objectForKey:key];
        [result removeAllObjects];
    }
    
    // Now clear the entire dictionary
    [self.resultsForAutocompleteQuery removeAllObjects];
    //[self.resultsForSearchQuery removeAllObjects];
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

- (RecommendedPlaceViewCellType)recommendedPlaceViewCellTypeForRow:(NSInteger)row
{
    RecommendedPlaceViewCellType type;
    NSInteger last = [[self.resultsForSearchQuery objectForKey:self.currentQuery] count] - 1;
    
    if (last == 0) {
        type = RecommendedPlaceViewCellTypeOnly;
    }
    else if (row == 0) {
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

#pragma mark - Table view delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat height;
    
    if (self.searchDisplayController.searchResultsTableView == tableView) {
        height = self.tableView.rowHeight;
    }
    else {
        height = [RecommendedPlaceViewCell heightForType:[self recommendedPlaceViewCellTypeForRow:[indexPath row]]];
    }
    
    return height;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    if (self.searchDisplayController.searchResultsTableView == tableView) {
        return 1;
    }
    else {
        return 1;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    NSMutableDictionary *resultsDict;
    
    if (self.searchDisplayController.searchResultsTableView == tableView) {
        resultsDict = self.resultsForAutocompleteQuery;
    }
    else {
        resultsDict = self.resultsForSearchQuery;
    }
    
    return [[resultsDict objectForKey:self.currentQuery] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    
    if (self.searchDisplayController.searchResultsTableView == tableView) {
        cell = [self tableView:tableView cellForAutocompleteRow:indexPath.row];
        cell.backgroundView.backgroundColor = [UIColor clearColor];
    }
    else {
        cell = [self tableView:tableView cellForSearchQueryRow:indexPath.row];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
        
    return cell;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForSearchQueryRow:(NSInteger)row
{
    RecommendedPlaceViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kPlacesPlaceCellIdentifier];
    if (cell == nil) {
        cell = [[RecommendedPlaceViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:kPlacesPlaceCellIdentifier type:[self recommendedPlaceViewCellTypeForRow:row]];
    }
    
    // Always set the type
    [cell setType:[self recommendedPlaceViewCellTypeForRow:row]];
    
    // Only display results if they exist
    NSMutableArray *result = [self.resultsForSearchQuery objectForKey:self.currentQuery];
    if (result) {
        Place *place = [result objectAtIndex:row];
        if (place) {
            [cell setWithPlace:place context:self.managedObjectContext];
        }
    }
    
    return cell;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForAutocompleteRow:(NSInteger)row
{
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kSearchAutocompleteCellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kSearchAutocompleteCellIdentifier];
    }
    
    // Only display results if they exist
    NSMutableArray *result = [self.resultsForAutocompleteQuery objectForKey:self.currentQuery];
    if (result) {
        NSString *text = [result objectAtIndex:row];
        if (text) {
            cell.textLabel.text = [NSString stringWithFormat:@"%@",text];
        }
    }
    
    return cell;
}

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
    // Save the current query
    self.currentQuery = [NSString stringWithString:searchString];
    
    // Check if its results are already cached 
    NSMutableArray *result = [self.resultsForAutocompleteQuery objectForKey:self.currentQuery];
    if (result && [result count]) {
        [self.searchDisplayController.searchResultsTableView reloadData];
    }
    else {
        // Send the request out to autocomplete
        [self.api autocomplete:searchString];
    }
    
    return NO;
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar 
{
    // Let them know we're working on it
    [self.hud show:YES];
    
    // When search is clicked, perform a search with the search string
    NSString *searchString = searchBar.text;
    
    // Send the request
    [self.api search:searchString];
    
    // Dismiss the search display controller
    [self.searchDisplayController setActive:NO animated:YES];
}

- (void)searchDisplayControllerWillBeginSearch:(UISearchDisplayController *)controller
{
    // Change the background
    [controller.searchBar setBackgroundImage:[UIImage imageNamed:@"TopBarWithoutDash.png"]];
}

- (void)searchDisplayControllerWillEndSearch:(UISearchDisplayController *)controller
{
    // Clear the background
    [self clearSearchBarBackground];
}

#pragma mark - RKRequestDelegate

- (void)request:(RKRequest*)request didLoadResponse:(RKResponse*)response 
{
    if ([request isGET] && [response isJSON]) {
        // Grab the query either way
        NSDictionary *dict = [response parsedBody:nil];
        self.currentQuery = [dict objectForKey:@"query"];
        
        // Prepare pointers to reference appropriate data structures and tableviews
        UITableView *tableView = self.searchDisplayController.searchResultsTableView;
        NSMutableDictionary *resultsDict = self.resultsForAutocompleteQuery;
        
        // Grab the array corresponding with our query
        NSMutableArray *results = [resultsDict objectForKey:self.currentQuery];
        if (results) {
            // If it exists, clear it out
            [results removeAllObjects];   
        }
        else {
            // Otherwise, create it
            results = [[NSMutableArray alloc] init];
            [resultsDict setObject:results forKey:self.currentQuery];
        }
        
        // Fill it up
        for (NSString *result in [dict objectForKey:@"data"]) {
            [results addObject:[NSString stringWithString:result]];
        }
        
        // Display it
        [tableView reloadData];
    }
}

#pragma mark - RKObjectLoaderDelegate methods

- (void)objectLoader:(RKObjectLoader *)objectLoader didLoadObjects:(NSArray *)objects 
{
    // And we're done
    [self.hud hide:YES];
    
    UITableView *tableView = self.tableView;
    NSMutableDictionary *resultsDict = self.resultsForSearchQuery;
    
    // Grab the array corresponding with our query
    NSMutableArray *results = [resultsDict objectForKey:self.currentQuery];
    if (results) {
        // If it exists, clear it out
        [results removeAllObjects];   
    }
    else {
        // Otherwise, create it
        results = [[NSMutableArray alloc] init];
        [resultsDict setObject:results forKey:self.currentQuery];
    }
    
    // Fill it up
    [results addObjectsFromArray:objects];
    
    NSLog(@"%@", objects);
    
    // Display it
    [tableView reloadData];
}

- (void)objectLoader:(RKObjectLoader *)objectLoader didFailWithError:(NSError *)error 
{
    //NSLog(@"Encountered an error: %@", error);
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Check which table view is being selected
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        // A row selected in autocomplete means we will send a request to search for a query
        
        // Get our query
        NSMutableArray *results = [self.resultsForAutocompleteQuery objectForKey:self.currentQuery];
        NSString *query = [results objectAtIndex:indexPath.row];
        
        // Send a new request to the api to search and return places with details
        [self.api search:query];
        
        // Display it
        [self.tableView reloadData];
        
        // Hide the search display controller
        [self.searchDisplayController setActive:NO animated:YES];
    }
    else {
        // A row selected in search means we will segue to the place view controller
        NSArray *results = [self.resultsForSearchQuery objectForKey:self.currentQuery];
        Place *place = [results objectAtIndex:indexPath.row];
        
        [self performSegueWithIdentifier:kShowSearchResultDetailView sender:place];
    }
    
}


#pragma mark - Storyboard Segue

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:kShowSearchResultDetailView]) {
        Place *place = (Place *)sender;
        PlaceViewController *placeViewController = (PlaceViewController *)[segue destinationViewController];
        [placeViewController setPlace:place];
        
        // Make sure it has a managed object context
        [placeViewController setManagedObjectContext:self.managedObjectContext];
        
        // Make sure the tabbar hides so we can replace it with a toolbar
        placeViewController.hidesBottomBarWhenPushed = YES;
    }
}


@end
