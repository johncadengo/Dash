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

@implementation SearchViewController

@synthesize managedObjectContext = __managedObjectContext;
@synthesize api = _api;
@synthesize resultsForAutocompleteQuery = _resultsForAutocompleteQuery;
@synthesize resultsForSearchQuery = _resultsForSearchQuery;
@synthesize currentQuery = _currentQuery;
@synthesize currentSearchRequest = _currentSearchRequest;
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
    
    for (NSString *key in self.resultsForSearchQuery) {
        result = [self.resultsForSearchQuery objectForKey:key];
        [result removeAllObjects];
    }
    
    // Now clear the entire dictionary
    [self.resultsForAutocompleteQuery removeAllObjects];
    [self.resultsForSearchQuery removeAllObjects];
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
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    NSMutableArray *result;
    NSString *text;
    if (self.searchDisplayController.searchResultsTableView == tableView) {
        // Only display results if they exist
        result = [self.resultsForAutocompleteQuery objectForKey:self.currentQuery];
        if (result) {
            text = [result objectAtIndex:indexPath.row];
            if (text) {
                cell.textLabel.text = [NSString stringWithFormat:@"%@",text];
            }
        }
    }
    else {
        // Only display results if they exist
        result = [self.resultsForSearchQuery objectForKey:self.currentQuery];
        if (result) {
            Place *place = [result objectAtIndex:indexPath.row];
            if (place) {
                cell.textLabel.text = [NSString stringWithFormat:@"%@",place.name];
                cell.detailTextLabel.text = [NSString stringWithFormat:@"%@", place.address];
            }
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
        // Get our query
        NSMutableArray *results = [self.resultsForAutocompleteQuery objectForKey:self.currentQuery];
        NSString *query = [results objectAtIndex:indexPath.row];
        
        // Send a new request to the api to search and return places with details
        self. currentSearchRequest = [self.api search:query];
        
        // Hide the search display controller
        [self.searchDisplayController setActive:NO animated:YES];
        
        // Display it
        [self.tableView reloadData];
    }
    
    
}

@end
