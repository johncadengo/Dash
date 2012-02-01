//
//  FriendsViewController.m
//  Dash
//
//  Created by John Cadengo on 10/20/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "SearchViewController.h"
#import "DashAPI.h"

@implementation SearchViewController

@synthesize managedObjectContext = __managedObjectContext;
@synthesize api = _api;
@synthesize resultsForQuery = _results;
@synthesize currentQuery = _currentQuery;

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
    self.resultsForQuery = [[NSMutableDictionary alloc] init];
    
    
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
    for (NSString *key in self.resultsForQuery) {
        result = [self.resultsForQuery objectForKey:key];
        [result removeAllObjects];
    }
    
    // Now clear the entire dictionary
    [self.resultsForQuery removeAllObjects];
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
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [[self.resultsForQuery objectForKey:self.currentQuery] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    cell.textLabel.text = [NSString stringWithFormat:@"%@",[[self.resultsForQuery objectForKey:self.currentQuery] objectAtIndex:indexPath.row]];
    
    return cell;
}

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
    // Save the current query
    self.currentQuery = [NSString stringWithString:searchString];
    
    // Check if its results are already cached 
    NSMutableArray *result = [self.resultsForQuery objectForKey:self.currentQuery];
    if (result && [result count]) {
        [self.searchDisplayController.searchResultsTableView reloadData];
    }
    else {
        // Send the request out to autocomplete
        [self.api autocomplete:searchString];
    }
    
    //[NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(search:) userInfo:searchString repeats:NO];
    return NO;
}

#pragma mark - RKRequestDelegate

- (void)request:(RKRequest*)request didLoadResponse:(RKResponse*)response {  
    if ([request isGET]) {
        if ([response isJSON]) {
            NSDictionary *dict = [response parsedBody:nil];
            self.currentQuery = [dict objectForKey:@"query"];
            
            // Grab the array corresponding with our query
            NSMutableArray *results = [self.resultsForQuery objectForKey:self.currentQuery];
            if (results) {
                // If it exists, clear it out
                [results removeAllObjects];   
            }
            else {
                // Otherwise, create it
                results = [[NSMutableArray alloc] init];
                [self.resultsForQuery setObject:results forKey:self.currentQuery];
            }
                
            // Fill it up
            for (NSString *result in [dict objectForKey:@"data"]) {
                [results addObject:[NSString stringWithString:result]];
            }
            
            // Display it
            [self.searchDisplayController.searchResultsTableView reloadData];
        }
    }
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
}

@end
