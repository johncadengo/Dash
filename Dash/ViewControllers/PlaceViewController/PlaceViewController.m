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
#import "TitleViewCell.h"
#import "BadgesViewCell.h"
#import "HighlightViewCell.h"

@implementation PlaceViewController

@synthesize place = _place;
@synthesize managedObjectContext = _managedObjectContext;
@synthesize api = _api;
@synthesize badges = _badges;
@synthesize highlights = _highlights;
@synthesize footprints = _footprints;
@synthesize moreInfoCell = _moreInfoCell;
@synthesize themeColor = _themeColor;
@synthesize toolbar = _toolbar;
@synthesize highlightTitle = _highlightTitle;

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
    
    // Make the toolbar
    //self.toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0.0f, 480.0f - 49.0f, 320.0f, 49.0f)];
    //[self.toolbar insertSubview:[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"BottomBarBackground.png"]] atIndex:1];
    
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
    
    // Make sure the top bar and bottom bar show
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    //[self.navigationController.view addSubview:self.toolbar];
}

- (void)viewDidAppear:(BOOL)animated
{
    // Set the custom nav bar
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"TopBar.png"] forBarMetrics:UIBarMetricsDefault];
}

- (void)viewWillDisappear:(BOOL)animated
{
    // Reset it
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"TopBarWithoutDash.png"] forBarMetrics:UIBarMetricsDefault];
    
    // Duration must match the popping pushing animation.. It appears to be the perfect #
    if (animated)
        [UIView animateWithDuration:2.75f
                         animations:^{
                             self.toolbar.frame = CGRectMake(320.0f, 480.0f - 49.0f, 320.0f, 49.0f);
                         }
                         completion:^(BOOL finished){ [self.toolbar removeFromSuperview]; }];
    else
        [self.toolbar removeFromSuperview];
    
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
            height = [PlaceHeaderViewCell heightForPlace:self.place withCellType:PlaceViewCellTypeHeader];
            break;
        case kPlaceBadgesSection:
            height = [self heightForBadgeSectionCellForRow:row];
            break;
        case kPlaceMoreInfoSection:
            height = [MoreInfoViewCell height];
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

- (CGFloat)heightForHighlightSectionCellForRow:(NSInteger)row
{
    CGFloat height = [HighlightViewCell heightForType:[self highlightViewCellTypeForRow:row]];
    
    return height;
}

- (CGFloat)heightForBadgeSectionCellForRow:(NSInteger)row
{
    if (row == 0) {
        return [TitleViewCell height];
    }
    
    CGFloat height = [BadgesViewCell height];
    
    return height;
}

- (CGFloat)heightForFootprintSectionCellForRow:(NSInteger)row
{
    CGFloat height = 0.0f;
    
    return height;    
}

- (HighlightViewCellType)highlightViewCellTypeForRow:(NSInteger)row
{
    // Figure out which type
    HighlightViewCellType type;
    NSInteger firstHighlightRow = 0;
    NSInteger lastHighlightRow = [self.highlights count] - 1;
    
    if (row == firstHighlightRow)
        type = HighlightViewCellTypeFirst;
    else if (row == lastHighlightRow)
        type = HighlightViewCellTypeLast;
    else 
        type = HighlightViewCellTypeMiddle;
    
    return type;
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
            numRows = 1;
            break;
        case kPlaceBadgesSection:
            numRows = 2; // One for the title, the other for the badges scroll view
            break;
        case kPlaceMoreInfoSection:
            numRows = 1;
            break;
        case kPlaceHighlightsSection:
            numRows = [self.highlights count];
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
    UITableViewCell *cell = nil;
    
    switch (section) {
        case kPlaceHeaderSection:
            cell = [self headerSectionCellForTableView:tableView forRow:row];
            break;
        case kPlaceBadgesSection:
            cell = [self badgesSectionCellForTableView:tableView forRow:row];
            break;
        case kPlaceMoreInfoSection:
            cell = [self moreInfoCellForTableView:tableView];
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
    
    // None of our cells should be able to be selected
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

#pragma mark - Cells for rows in each section

- (UITableViewCell *)headerSectionCellForTableView:(UITableView *)tableView forRow:(NSInteger)row
{
    PlaceHeaderViewCell *cell = (PlaceHeaderViewCell *)[tableView dequeueReusableCellWithIdentifier:kPlaceHeaderCellIdentifier];
    
    if (cell == nil) {
        cell = [[PlaceHeaderViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kPlaceHeaderCellIdentifier cellType:PlaceViewCellTypeHeader];
    }
    
    [cell setWithPlace:self.place context:self.managedObjectContext];
    
    return cell;
}

- (UITableViewCell *)moreInfoCellForTableView:(UITableView *)tableView
{
    MoreInfoViewCell *cell = (MoreInfoViewCell *)[tableView dequeueReusableCellWithIdentifier:kPlaceMoreInfoCellIdentifier];
    
    if (cell == nil) {
        cell = [[MoreInfoViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kPlaceMoreInfoCellIdentifier];
    }
    
    // Connect us to the cell
    [self setMoreInfoCell:cell];
    
    return cell;
}

- (UITableViewCell *)badgesSectionCellForTableView:(UITableView *)tableView forRow:(NSInteger)row
{
    if (row == 0)
        return [self titleViewCellForTableView:tableView WithTitle:@"Notables"];
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[BadgesViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    return cell;
}

- (UITableViewCell *)highlightsSectionCellForTableView:(UITableView *)tableView forRow:(NSInteger)row
{
    static NSString *CellIdentifier = @"Cell";
    
    HighlightViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[HighlightViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier type:[self highlightViewCellTypeForRow:row]];
    }
    
    Highlight *highlight = [self.highlights objectAtIndex:row];
    [cell setWithHighlight:highlight];
    
    return cell;
}

- (UITableViewCell *)footprintsSectionCellForTableView:(UITableView *)tableView forRow:(NSInteger)row
{
    id cell;

    
    return cell;
}

- (UITableViewCell *)titleViewCellForTableView:(UITableView *)tableView WithTitle:(NSString *)title
{
    static NSString *CellIdentifier = @"Cell";
    
    TitleViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[TitleViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    cell.title = title;
    
    return cell;
}

#pragma mark - table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger section = [indexPath section];
    NSInteger row = [indexPath row];
    
    if (section == kPlaceMoreInfoSection) {
        [self toggleMoreInfo];
    }
}



#pragma mark - More info cell delegate

- (void)toggleMoreInfo
{
    //([self.moreInfoCell.backView isHidden]) ? [self.moreInfoCell revealBackView] : [self.moreInfoCell hideBackView];
}


@end
