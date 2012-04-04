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
#import "UIImage+ProportionalFill.h"
#import "PlaceHeaderViewCell.h"
#import "ActionViewCell.h"
#import "Badge.h"
#import "Place.h"
#import "Place+Helper.h"
#import "Highlight.h"
#import "Highlight+Helper.h"


@implementation PlaceViewController

@synthesize place = _place;
@synthesize managedObjectContext = _managedObjectContext;
@synthesize api = _api;
@synthesize badges = _badges;
@synthesize highlights = _highlights;
@synthesize footprints = _footprints;
@synthesize moreInfoCell = _moreInfoCell;
@synthesize themeColor = _themeColor;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
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

#pragma mark - Theme Color
- (void)setThemeColor:(PlaceThemeColor) newColor
{
    // Change the color of the background..
    self.view.backgroundColor = UIColorFromRGB(kPlaceOrangeBGColor);
    
    // And finally save the new theme color
    _themeColor = newColor;
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
    
    // Set default theme color
    self.themeColor = kPlaceThemeOrange;
    
    // Connect to our API.
    self.api = [[DashAPI alloc] initWithManagedObjectContext:self.managedObjectContext];
    
    // Get the highlights associated with the place
    self.badges = [[NSMutableArray alloc] initWithArray:[self.place.badges allObjects]];
    self.highlights = [[NSMutableArray alloc] initWithArray:[self.place.highlights allObjects]];
    
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
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
    
    // Make sure the top bar show
    [self.navigationController setNavigationBarHidden:NO animated:animated];
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
        case kPlaceBadgesSection:
            height = [self heightForHighlightSectionCellForRow:row];
            break;
        case kPlaceHighlightsSection:
            height = [self heightForHighlightSectionCellForRow:row];
            break;
        case kPlaceFootprintsSection:
            height = [self heightForFootprintSectionCellForRow:row];
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
            height = [PlaceHeaderViewCell heightForPlace:self.place withCellType:PlaceViewCellTypeHeader];
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

- (CGFloat)heightForHighlightSectionCellForRow:(NSInteger)row
{
    CGFloat height = 40.0f;
    
    // This is an if-else situation, not a switch situation,
    // since, the row value can be anything
    if (row == kPlaceHeaderRow) {
        
    }
    
    return height;
}

- (CGFloat)heightForFootprintSectionCellForRow:(NSInteger)row
{
    CGFloat height = 0.0f;
    
    // This is an if-else situation, not a switch situation,
    // since, the row value can be anything
    if (row == kPlaceHeaderRow) {
        
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
        case kPlaceBadgesSection:
            numRows = [self.badges count];
            break;
        case kPlaceHighlightsSection:
            // This is calculated by the header + up to 3 highlights + footer
            numRows = [self.highlights count];
            break;
        case kPlaceFootprintsSection:
            // This is calculated by the header + up to n footprints + footer
            
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
        case kPlaceBadgesSection:
            cell = [self badgesSectionCellForTableView:tableView forRow:row];
            break;
        case kPlaceHighlightsSection:
            cell = [self highlightsSectionCellForTableView:tableView forRow:row];
            break;
        case kPlaceFootprintsSection:
            cell = [self footprintsSectionCellForTableView:tableView forRow:row];
            break;
        default:
            NSAssert(NO, @"Asking for a cell in a section that doesn't exist %d", section);
            break;
    }
    
    return cell;
}

#pragma mark - Cells for rows in each section

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

- (UITableViewCell *)badgesSectionCellForTableView:(UITableView *)tableView forRow:(NSInteger)row
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    Badge *badge = [self.badges objectAtIndex:row];
    NSString *name = badge.name;
    cell.textLabel.text = [NSString stringWithFormat:@"%@", name];
    [cell.textLabel sizeToFit];
    
    return cell;
}

- (UITableViewCell *)highlightsSectionCellForTableView:(UITableView *)tableView forRow:(NSInteger)row
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    Highlight *highlight = [self.highlights objectAtIndex:row];
    NSString *name = highlight.text;
    cell.textLabel.text = [NSString stringWithFormat:@"%@", name];
    [cell.textLabel sizeToFit];
    
    return cell;
}

- (UITableViewCell *)footprintsSectionCellForTableView:(UITableView *)tableView forRow:(NSInteger)row
{
    id cell;
    
    if (row == kPlaceHeaderRow) {
        
    }
    else {
        
    }
    
    return cell;
}


#pragma mark - The actual cell

- (UITableViewCell *)headerRowForTableView:(UITableView *)tableView
{
    PlaceHeaderViewCell *cell = (PlaceHeaderViewCell *)[tableView dequeueReusableCellWithIdentifier:kPlaceHeaderCellIdentifier];
    
    if (cell == nil) {
        cell = [[PlaceHeaderViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kPlaceHeaderCellIdentifier cellType:PlaceViewCellTypeHeader];
    }
    
    [cell setWithPlace:self.place context:self.managedObjectContext];
    
    return cell;
}

- (UITableViewCell *)moreInfoRowForTableView:(UITableView *)tableView
{
    MoreInfoViewCell *cell = (MoreInfoViewCell *)[tableView dequeueReusableCellWithIdentifier:kPlaceMoreInfoCellIdentifier];
    
    if (cell == nil) {
        cell = [[MoreInfoViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kPlaceMoreInfoCellIdentifier];
    }
    
    // Connect us to the cell
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
    //([self.moreInfoCell.backView isHidden]) ? [self.moreInfoCell revealBackView] : [self.moreInfoCell hideBackView];
}


@end
