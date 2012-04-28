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
#import "Badge.h"
#import "Place.h"
#import "Place+Helper.h"
#import "Highlight.h"
#import "Highlight+Helper.h"
#import "TitleViewCell.h"
#import "BadgesViewCell.h"
#import "HighlightViewCell.h"
#import "CreateHighlightViewController.h"

@implementation PlaceViewController

@synthesize place = _place;
@synthesize managedObjectContext = _managedObjectContext;
@synthesize api = _api;
@synthesize badges = _badges;
@synthesize highlights = _highlights;
@synthesize footprints = _footprints;
@synthesize themeColor = _themeColor;
@synthesize highlightTitle = _highlightTitle;
@synthesize moreInfoCell = _moreInfoCell;
@synthesize moreInfoOpen = _moreInfoOpen;
@synthesize toolbar = _toolbar;
@synthesize createHighlightButton = _createHighlightButton;
@synthesize thumbsUpButton = _thumbsUpButton;
@synthesize thumbsDownButton = _thumbsDownButton;
@synthesize upLabel = _upLabel;
@synthesize downLabel = _downLabel;
@synthesize alertView = _alertView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // By default more info is closed
        self.moreInfoOpen = NO;
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
    self.api = [[DashAPI alloc] initWithManagedObjectContext:self.managedObjectContext delegate:self];
    
    // Get the highlights associated with the place
    self.badges = [[NSMutableArray alloc] initWithArray:[self.place.badges allObjects]];
    self.highlights = [[NSMutableArray alloc] initWithArray:[self.place.highlights allObjects]];
    
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    
    // Adjust tableview's frame to account for the toolbar
    //CGRect frame = self.tableView.frame;
    //self.tableView.frame = CGRectMake(frame.origin.x, frame.origin.y, 320.0f, frame.size.height - 49.0f);
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
    
    // Make the toolbar
    self.toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0.0f, 480.0f - 49.0f, 320.0f, 49.0f)];
    [self.toolbar insertSubview:[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"BottomBarBackground.png"]] atIndex:1];
    [self.navigationController.view addSubview:self.toolbar];
    
    // Create its items
    CGRect frame = CGRectMake(0.0f, 0.0f, 100.0f, 40.0f);
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = frame;
    [button setImage:[UIImage imageNamed:@"CreateHighlightButton.png"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(createHighlight:) forControlEvents:UIControlEventTouchUpInside];
    self.createHighlightButton = [[UIBarButtonItem alloc] initWithCustomView:button];
    
    button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = frame;
    [button setImage:[UIImage imageNamed:@"ThumbsUpButton"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(thumbsUp:) forControlEvents:UIControlEventTouchUpInside];
    self.thumbsUpButton = [[UIBarButtonItem alloc] initWithCustomView:button];
    
    self.upLabel = [[UILabel alloc] initWithFrame:CGRectMake(180.0f, 0.0f, 40.0f, 49.0f)];
    [self.upLabel setFont:[UIFont fontWithName:kHelveticaNeueBold size:15.0f]];
    [self.upLabel setTextColor:UIColorFromRGB(kPlaceToolbarTextColor)];
    [self.upLabel setText:[NSString stringWithFormat:@"%@", self.place.thumbsupcount]];
    [self.upLabel setBackgroundColor:[UIColor clearColor]];
    
    button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = frame;
    [button setImage:[UIImage imageNamed:@"ThumbsDownButton"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(thumbsDown:) forControlEvents:UIControlEventTouchUpInside];
    self.thumbsDownButton = [[UIBarButtonItem alloc] initWithCustomView:button];
    
    self.downLabel = [[UILabel alloc] initWithFrame:CGRectMake(280.0f, 0.0f, 40.0f, 49.0f)];
    [self.downLabel setFont:[UIFont fontWithName:kHelveticaNeueBold size:15.0f]];
    [self.downLabel setTextColor:UIColorFromRGB(kPlaceToolbarTextColor)];
    [self.downLabel setText:[NSString stringWithFormat:@"%@", self.place.thumbsdowncount]];
    [self.downLabel setBackgroundColor:[UIColor clearColor]];
    
    // Adjust padding
    UIBarButtonItem *outerNegative = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    outerNegative.width = -7.0f; // 12 - 7 = 5.0f
    
    UIBarButtonItem *innerNegative = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    innerNegative.width = -5.0f; // 10 - 5 = 5.0f
    
    // Add them. Sidenote: 320 - (3 * 100) = 20. 20 / 4 = 5.0f
    self.toolbar.items = [NSArray arrayWithObjects:outerNegative, self.createHighlightButton, 
                          innerNegative, self.thumbsUpButton, innerNegative, self.thumbsDownButton, nil];
    [self.toolbar addSubview:self.upLabel];
    [self.toolbar addSubview:self.downLabel];
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
            height = [self heightForMoreInforSection];
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
    if (row == [self.highlights count]) {
        return 50.0f;
    }
    
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
    CGFloat height = 60.0f; // TODO: For now, this will just make it so toolbar doesn't cover last cell
    
    return height;    
}

- (CGFloat)heightForMoreInforSection
{
    return (self.moreInfoOpen) ? [MoreInfoViewCell height] : 40.0f;
}

- (HighlightViewCellType)highlightViewCellTypeForRow:(NSInteger)row
{
    // Figure out which type
    HighlightViewCellType type;
    NSInteger firstHighlightRow = 0;
    NSInteger lastHighlightRow = [self.highlights count] - 1;
    
    if (row == firstHighlightRow)
        type = HighlightViewCellTypeFirst;
    /*
     else if (row == lastHighlightRow)
        type = HighlightViewCellTypeLast;
     */
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
            numRows = ([self.badges count] == 0) ? 0 : 2; // One for the title, the other for the badges scroll view
            break;
        case kPlaceMoreInfoSection:
            numRows = 1;
            break;
        case kPlaceHighlightsSection:
            numRows = [self.highlights count] + 1; // +1 for create highlight cell
            break;
        case kPlaceFootprintsSection:
            numRows = 1; // TODO: Just a filler cell to accomdate for toolbar
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
    UITableViewCell *cell;
    if (self.moreInfoOpen) {
        cell = [tableView dequeueReusableCellWithIdentifier:kPlaceMoreInfoOpenCellIdentifier];
    }
    else {
        cell = [tableView dequeueReusableCellWithIdentifier:kPlaceMoreInfoCellIdentifier];        
    }
    
    if (cell == nil) {
        if (self.moreInfoOpen) {
            cell = [[MoreInfoViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kPlaceMoreInfoOpenCellIdentifier];
            
            // Connect us to the cell
            [self setMoreInfoCell:(MoreInfoViewCell *)cell];
            [self.moreInfoCell setWithPlace:self.place];
        }
        else {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kPlaceMoreInfoCellIdentifier];
            cell.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"MoreInformationButton.png"]];
        }
    }
    
    return cell;
}

- (UITableViewCell *)badgesSectionCellForTableView:(UITableView *)tableView forRow:(NSInteger)row
{
    if (row == 0)
        return [self titleViewCellForTableView:tableView WithTitle:@"Notables"];
    
    BadgesViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kPlaceBadgesCellIdentifier];
    if (cell == nil) {
        cell = [[BadgesViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kPlaceBadgesCellIdentifier];
    }
    
    [cell setBadges:self.badges];
    
    return cell;
}

- (UITableViewCell *)highlightsSectionCellForTableView:(UITableView *)tableView forRow:(NSInteger)row
{
    if (row == [self.highlights count]) {
        return [self createHighlightViewCellForTableView:tableView];
    }
    
    HighlightViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kPlaceHighlightCellIdentifier];
    if (cell == nil) {
        cell = [[HighlightViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kPlaceHighlightCellIdentifier type:[self highlightViewCellTypeForRow:row]];
    }
    
    // Set the type always, not just when creating a new cell
    cell.type = [self highlightViewCellTypeForRow:row];
    
    Highlight *highlight = [self.highlights objectAtIndex:row];
    [cell setWithHighlight:highlight];
    [cell.heart setTag:row];
    [cell.heart addTarget:self action:@selector(heartTapped:) forControlEvents:UIControlEventTouchUpInside];
    
    return cell;
}

- (UITableViewCell *)footprintsSectionCellForTableView:(UITableView *)tableView forRow:(NSInteger)row
{
    static NSString *identifier = @"FillerCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    
    cell.backgroundColor = [UIColor clearColor];
    
    return cell;
}

- (UITableViewCell *)titleViewCellForTableView:(UITableView *)tableView WithTitle:(NSString *)title
{
    TitleViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kPlaceTitleCellIdentifier];
    
    if (cell == nil) {
        cell = [[TitleViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kPlaceTitleCellIdentifier];
    }
    
    cell.title = title;
    
    return cell;
}

- (UITableViewCell *)createHighlightViewCellForTableView:(UITableView *)tableView
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kPlaceCreateHighlightCellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kPlaceCreateHighlightCellIdentifier];
    }
    
    cell.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"HighlightCreate.png"]];
    
    return cell;
}

#pragma mark - table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == kPlaceMoreInfoSection) {
        [self toggleMoreInfo];
    }
    if (indexPath.section == kPlaceHighlightsSection && indexPath.row == [self.highlights count]) {
        // This is the create highlights row
        [self createHighlight:self];
    }
}



#pragma mark - More info cell delegate

- (void)toggleMoreInfo
{
    self.moreInfoOpen = !self.moreInfoOpen;
    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:kPlaceMoreInfoSection] 
                  withRowAnimation:UITableViewRowAnimationAutomatic];
}

#pragma mark - Buttons

- (void)heartTapped:(id)sender
{
    UIButton *button = (UIButton *)sender;
    button.selected = !button.selected;
    [self.api likeHighlight:[self.highlights objectAtIndex:button.tag]];
}

- (void)createHighlight:(id)sender
{
    if ([DashAPI loggedIn]) {
        // Check if we're logged in
        [self performSegueWithIdentifier:kShowCreateHighlightSegueIdentifier sender:self.place];   
    }
    else {
        // Otherwise, let them know they can't do that yet
        if (self.alertView == nil) {
            self.alertView = [[UIAlertView alloc] initWithTitle:kLoginAlertTitle message:kLoginAlertMessage delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        }
        [self.alertView show];
    }
}

- (void)thumbsUp:(id)sender
{
    if ([DashAPI loggedIn]) {
        // Check if we're logged in
        [self.api thumbsUpPlace:self.place];
        [self.upLabel setText:[NSString stringWithFormat:@"%d", ([self.place.thumbsupcount integerValue] + 1)]];
    }
    else {
        // Otherwise, let them know they can't do that yet
        if (self.alertView == nil) {
            self.alertView = [[UIAlertView alloc] initWithTitle:kLoginAlertTitle message:kLoginAlertMessage delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        }
        [self.alertView show];
    }
}

- (void)thumbsDown:(id)sender
{
    if ([DashAPI loggedIn]) {
        // Check if we're logged in
        [self.api thumbsDownPlace:self.place];
        [self.downLabel setText:[NSString stringWithFormat:@"%d", ([self.place.thumbsdowncount integerValue] + 1)]];
    }
    else {
        // Otherwise, let them know they can't do that yet
        if (self.alertView == nil) {
            self.alertView = [[UIAlertView alloc] initWithTitle:kLoginAlertTitle message:kLoginAlertMessage delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        }
        [self.alertView show];
    }
}


#pragma mark - Storyboard Segue

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:kShowCreateHighlightSegueIdentifier]) {
        CreateHighlightViewController *createHighlightViewController = (CreateHighlightViewController *)[segue destinationViewController];
        Place *place = (Place *)sender;
        
        [createHighlightViewController setPlace:place];
        [createHighlightViewController setContext:self.managedObjectContext];
        [createHighlightViewController setApi:self.api];
    }
}



#pragma mark - RKObjectLoaderDelegate methods

- (void)objectLoader:(RKObjectLoader *)objectLoader didLoadObjects:(NSArray *)objects 
{
    self.place = [objects lastObject];
    
    [self.tableView reloadData];
}

- (void)objectLoader:(RKObjectLoader *)objectLoader didFailWithError:(NSError *)error 
{
    //NSLog(@"Encountered an error: %@", error);
}

#pragma mark - RKRequestDelegate methods

- (void)request:(RKRequest *)request didLoadResponse:(RKResponse *)response
{
    NSLog(@"Request response %@", [response bodyAsString]);
}

@end
