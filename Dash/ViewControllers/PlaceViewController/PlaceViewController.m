//
//  PlaceViewController.m
//  Dash
//
//  Created by John Cadengo on 11/22/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "PlaceViewController.h"
#import "DashAPI.h"
#import "Constants.h"
#import "JCImageGalleryViewController.h"
#import "UIImage+ProportionalFill.h"
#import "PlaceViewCell.h"

@implementation PlaceViewController

@synthesize place = _place;
@synthesize managedObjectContext = _managedObjectContext;
@synthesize api = _api;
@synthesize highlights = _highlights;
@synthesize footprints = _footprints;
@synthesize imageGalleryViewController = _imageGalleryViewController;
@synthesize moreInfoCell = _moreInfoCell;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
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

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
}
*/

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Connect to our API.
    self.api = [[DashAPI alloc] initWithManagedObjectContext:self.managedObjectContext];
    
    // Get the highlights associated with the place
    self.highlights = [self.api highlightsForPlace:self.place];
    
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
}


- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
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
    
    CGFloat height = 0.0f;
    
    switch (section) {
        case kPlaceHeaderSection:
            height = [self heightForHeaderSectionCellForRow:row];
            break;
        case kPlaceHighlightsSection:
            
            break;
        case kPlaceFootprintsSection:
            
            break;
        default:
            NSAssert(NO, @"Asking for the height of a row in a section that doesn't exist: %d", section);
            break;
    }
    
    return height;
}

- (CGFloat)heightForHeaderSectionCellForRow:(NSInteger)row 
{
    CGFloat height = 0.0f;
    
    switch (row) {
        case kPlaceHeaderRow:
            height = [PlaceViewCell heightForPlace:self.place withCellType:PlaceViewCellTypeHeader];
            break;
        case kPlaceMoreInfoRow:
            height = [MoreInfoViewCell height];
            break;
        default:
            NSAssert(NO, @"Asking for the height of a row in the header section that doesn't exist %d", row);
            break;
    }
    
    return height;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return kPlaceNumSections;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger numRows = 0;
    
    switch (section) {
        case kPlaceHeaderSection:
            numRows = kPlaceNumRowsForHeaderSection;
            break;
        case kPlaceHighlightsSection:
            
            break;
        case kPlaceFootprintsSection:
            
            break;
        default:
            NSAssert(NO, @"Asking for number of rows in a section that doesn't exist %d", section);
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
        case kPlaceHeaderSection:
            cell = [self headerSectionCellForTableView:tableView forRow:row];
            break;
        case kPlaceHighlightsSection:
            
            break;
        case kPlaceFootprintsSection:
            
            break;
        default:
            NSAssert(NO, @"Asking for a cell in a section that doesn't exist %d", section);
            break;
    }
    
    return cell;
}

- (UITableViewCell *)headerSectionCellForTableView:(UITableView *)tableView forRow:(NSInteger)row
{
    id cell;
    
    switch (row) {
        case kPlaceHeaderRow:
            cell = [self headerRowForTableView:tableView];
            break;
        case kPlaceMoreInfoRow:
            cell = [self moreInfoRowForTableView:tableView];
            break;
        default:
            NSAssert(NO, @"Asking for a cell in a row of the header section that doesn't exist %d", row);
            break;
    }
    
    return cell;
}

- (UITableViewCell *)headerRowForTableView:(UITableView *)tableView
{
    PlaceViewCell *cell = (PlaceViewCell *)[tableView dequeueReusableCellWithIdentifier:kPlaceHeaderCellIdentifier];
    
    if (cell == nil) {
        cell = [[PlaceViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kPlaceHeaderCellIdentifier cellType:PlaceViewCellTypeHeader];
    }
    
    [cell setWithPlace:self.place];
    
    return cell;
}

- (UITableViewCell *)moreInfoRowForTableView:(UITableView *)tableView
{
    MoreInfoViewCell *cell = (MoreInfoViewCell *)[tableView dequeueReusableCellWithIdentifier:kPlaceMoreInfoCellIdentifier];
    
    if (cell == nil) {
        cell = [[MoreInfoViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kPlaceMoreInfoCellIdentifier];
    }
    
    // Connect us to the cell
    [cell setDelegate:self];
    [self setMoreInfoCell:cell];
    
    return cell;
}

#pragma mark - table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger section = [indexPath section];
    NSInteger row = [indexPath row];
    
    if (section == kPlaceHeaderSection && row == kPlaceMoreInfoRow) {
        [self toggleMoreInfo];
    }
}



#pragma mark - More info cell delegate

- (void)toggleMoreInfo
{
    ([self.moreInfoCell.backView isHidden]) ? [self.moreInfoCell revealBackView] : [self.moreInfoCell hideBackView];
}

- (void)cellBackButtonWasTapped:(MoreInfoViewCell *)cell
{
    
}


@end
