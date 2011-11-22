//
//  PlacesViewController.m
//  Dash
//
//  Created by John Cadengo on 10/20/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "PlacesViewController.h"
#import "Place.h"
#import "DashAPI.h"
#import "Constants.h"

@implementation PlacesViewController

@synthesize managedObjectContext = __managedObjectContext;
@synthesize api = _api;
@synthesize refreshHeaderView = _refreshHeaderView;
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
    Place *place = [self.feedItems objectAtIndex:row];
    return [PlaceViewCell heightForPlace:place withCellType:PlaceViewCellTypeList];
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
    PlaceViewCell *cell = (PlaceViewCell *)[tableView dequeueReusableCellWithIdentifier:kPlacesPlaceCellIdentifier];
    
    if (cell == nil) {
        cell = [[PlaceViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kPlacesPlaceCellIdentifier cellType:PlaceViewCellTypeList];
    }
    
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
}

#pragma mark - Place view cell delegate

- (void)cellBackButtonWasTapped:(PlaceViewCell *)cell
{
    
}

@end
