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
#import "MapViewController.h"
#import "TestFlight.h"
#import "MoreInfoViewCell.h"
#import "NewsItemViewCell.h"
#import "NewsItem.h"
#import "ProfileViewController.h"

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
@synthesize toolbar = _toolbar;
@synthesize createHighlightButton = _createHighlightButton;
@synthesize thumbsUpButton = _thumbsUpButton;
@synthesize thumbsDownButton = _thumbsDownButton;
@synthesize upButton = _upButton;
@synthesize downButton = _downButton;
@synthesize upLabel = _upLabel;
@synthesize downLabel = _downLabel;
@synthesize alertView = _alertView;

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
    self.api = [[DashAPI alloc] initWithManagedObjectContext:self.managedObjectContext delegate:self];
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self refresh];
    
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
    
    self.upButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.upButton.frame = frame;
    [self.upButton setImage:[UIImage imageNamed:@"ThumbsUpButton.png"] forState:UIControlStateNormal];
    [self.upButton setImage:[UIImage imageNamed:@"ThumbsUpButtonSelected.png"] forState:UIControlStateSelected];
    [self.upButton addTarget:self action:@selector(thumbsUp:) forControlEvents:UIControlEventTouchUpInside];
    self.thumbsUpButton = [[UIBarButtonItem alloc] initWithCustomView:self.upButton];
    
    self.upLabel = [[UILabel alloc] initWithFrame:CGRectMake(180.0f, 0.0f, 40.0f, 49.0f)];
    [self.upLabel setFont:[UIFont fontWithName:kHelveticaNeueBold size:15.0f]];
    [self.upLabel setTextColor:UIColorFromRGB(kPlaceToolbarTextColor)];
    [self.upLabel setBackgroundColor:[UIColor clearColor]];
    
    self.downButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.downButton.frame = frame;
    [self.downButton setImage:[UIImage imageNamed:@"ThumbsDownButton"] forState:UIControlStateNormal];
    [self.downButton setImage:[UIImage imageNamed:@"ThumbsDownButtonSelected.png"] forState:UIControlStateSelected];
    [self.downButton addTarget:self action:@selector(thumbsDown:) forControlEvents:UIControlEventTouchUpInside];
    self.thumbsDownButton = [[UIBarButtonItem alloc] initWithCustomView:self.downButton];
    
    self.downLabel = [[UILabel alloc] initWithFrame:CGRectMake(280.0f, 0.0f, 40.0f, 49.0f)];
    [self.downLabel setFont:[UIFont fontWithName:kHelveticaNeueBold size:15.0f]];
    [self.downLabel setTextColor:UIColorFromRGB(kPlaceToolbarTextColor)];
    [self.downLabel setBackgroundColor:[UIColor clearColor]];
    
    // Adjust padding
    UIBarButtonItem *outerNegative = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    outerNegative.width = -7.0f; // 12 - 7 = 5.0f
    
    UIBarButtonItem *innerNegative = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    innerNegative.width = -5.0f; // 10 - 5 = 5.0f
    
    // Initial values
    [self.upButton setSelected:[self.place recommendedByMe]];
    [self.downButton setSelected:[self.place savedByMe]];
    [self.downLabel setText:[NSString stringWithFormat:@"%d", ([self.place.thumbsdowncount integerValue])]];
    [self.upLabel setText:[NSString stringWithFormat:@"%d", ([self.place.thumbsupcount integerValue])]];
    
    // Add them. Sidenote: 320 - (3 * 100) = 20. 20 / 4 = 5.0f
    self.toolbar.items = [NSArray arrayWithObjects:outerNegative, self.createHighlightButton, 
                          innerNegative, self.thumbsUpButton, innerNegative, self.thumbsDownButton, nil];
    [self.toolbar addSubview:self.upLabel];
    [self.toolbar addSubview:self.downLabel];
}


- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    
    self.highlightTitle = nil;
    self.toolbar = nil;
    self.createHighlightButton = nil;
    self.thumbsUpButton = nil;
    self.thumbsDownButton = nil;
    self.upButton = nil;
    self.downButton = nil;
    self.upLabel = nil;
    self.downLabel = nil;
    self.alertView = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    // Make sure the top bar and bottom bar show
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    
    
    // Make this smarter, but for now
    if ([DashAPI shouldRefreshFavorites] || [DashAPI shouldRefreshProfile]) {
        [self.api placeByID:self.place.uid];
    }
    
    // Add the toolbar to our view
    [self.toolbar setHidden:NO];
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
    /*if (animated)
        [UIView animateWithDuration:2.75f
                         animations:^{
                             self.toolbar.frame = CGRectMake(320.0f, 480.0f - 49.0f, 320.0f, 49.0f);
                         }
                         completion:^(BOOL finished){ [self.toolbar setHidden:YES]; }];
    else
        [self.toolbar setHidden:YES];
     */
    [self.toolbar setHidden:YES];
    
    
    [self.api cancelRequests];
    
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
            height = [self heightForMoreInforSectionForRow:row];
            break;
        case kPlaceHighlightsSection:
            height = [self heightForHighlightSectionCellForRow:row];
            break;
        case kPlaceFootprintsSection:
            height = [self heightForFootprintSectionCellForRow:row];
            break;
        case kPlaceFeedbackSection:
            height = [self heightForFeedBackSectionForRow:row];
            break;
        case kPlaceFooterSection:
            height = 60.0f;
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
    CGFloat height;
    
    if (row == 0) {
        height = TitleViewCell.height;
    }
    else {
        NewsItem *item = [self.footprints objectAtIndex:row - 1];
        //NSLog(@"%@",item);
        height = [FootprintCell heightForType:[self footprintCellTypeForRow:row]];   
    }
    
    return height;    
}

- (CGFloat)heightForMoreInforSectionForRow:(NSInteger)row
{
    if (row == 0) {
        return TitleViewCell.height;
    }
    
    return MoreInfoViewCell.height;
}

- (CGFloat)heightForFeedBackSectionForRow:(NSInteger)row
{
    if (row == 0) {
        return TitleViewCell.height;
    }
    
    return 50.0f;
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

- (FootprintCellType)footprintCellTypeForRow:(NSInteger)row
{
    FootprintCellType type;
    NSInteger firstRow = 1;
    NSInteger lastRow = self.footprints.count;

    if (firstRow == lastRow) {
        type = FootprintCellTypeOnly;
    }
    else if (row == firstRow)
        type = FootprintCellTypeFirst;
    else if (row == lastRow) {
        type = FootprintCellTypeLast;
    }
    else {
        type = FootprintCellTypeMiddle;
    }
    
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
            numRows = 2; // Title and the actual cell
            break;
        case kPlaceHighlightsSection:
            numRows = [self.highlights count] + 1; // +1 for create highlight cell
            break;
        case kPlaceFootprintsSection:
            numRows = (self.footprints.count == 0) ? 0 : self.footprints.count + 1;
            break;
        case kPlaceFeedbackSection:
            numRows = 2;
            break;
        case kPlaceFooterSection:
            numRows = 1;
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
            cell = [self moreInfoCellForTableView:tableView forRow:row];
            break;
        case kPlaceHighlightsSection:
            cell = [self highlightsSectionCellForTableView:tableView forRow:row];
            break;
        case kPlaceFootprintsSection:
            cell = [self footprintSectionCellForTableView:tableView forRow:row];
            break;
        case kPlaceFooterSection:
            cell = [self footerSectionCellForTableView:tableView forRow:row];
            break;
        case kPlaceFeedbackSection:
            cell = [self feedbackSectionCellForTableView:tableView forRow:row];
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

- (UITableViewCell *)moreInfoCellForTableView:(UITableView *)tableView forRow:(NSInteger)row
{
    if (row == 0) 
        return [self titleViewCellForTableView:tableView WithTitle:@"Information"];
        
    MoreInfoViewCell *cell;
    
    cell = [tableView dequeueReusableCellWithIdentifier:kPlaceMoreInfoCellIdentifier];        
    
    if (cell == nil) {
        cell = [[MoreInfoViewCell alloc] initWithStyle:UITableViewCellStyleDefault 
                                       reuseIdentifier:kPlaceMoreInfoCellIdentifier];
        
        // Connect us to the cell
        [self setMoreInfoCell:cell];
        [self.moreInfoCell setWithPlace:self.place];
        [self.moreInfoCell.mapButton addTarget:self action:@selector(map:) forControlEvents:UIControlEventTouchUpInside];
        [self.moreInfoCell.hoursButton addTarget:self action:@selector(showHours:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return cell;
}

- (UITableViewCell *)badgesSectionCellForTableView:(UITableView *)tableView forRow:(NSInteger)row
{
    if (row == 0)
        return [self titleViewCellForTableView:tableView WithTitle:@"Recognized By"];
    
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

- (UITableViewCell *)footprintSectionCellForTableView:(UITableView *)tableView forRow:(NSInteger)row
{
    UITableViewCell *newCell = nil;
    
    if (row==0) {
        newCell = [self titleViewCellForTableView:tableView WithTitle:@"Footprints"];
    }
    else {
        FootprintCell *cell = (FootprintCell *)[tableView dequeueReusableCellWithIdentifier:@"FootprintCell"];
        
        if (cell == nil) {
            cell = [[FootprintCell alloc] initWithStyle:UITableViewCellStyleDefault 
                                           reuseIdentifier:kFeedItemCellIdentifier
                                                   type:[self footprintCellTypeForRow:row]];
        }
        
        NewsItem *newsItem = [[self footprints] objectAtIndex:row-1];
        [cell setWithNewsItem:newsItem];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        
        // Make sure the image button connects
        [cell.icon addTarget:self action:@selector(showProfile:) forControlEvents:UIControlEventTouchUpInside];
        NSInteger footprintIndex = row-1;
        [cell.icon setTag:footprintIndex];
        
        newCell = cell;
    }
    
    return newCell;
}

- (UITableViewCell *)footerSectionCellForTableView:(UITableView *)tableView forRow:(NSInteger)row
{
    static NSString *identifier = @"FillerCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    
    cell.backgroundColor = [UIColor clearColor];
    
    return cell;
}

- (UITableViewCell *)feedbackSectionCellForTableView:(UITableView *)tableView forRow:(NSInteger)row
{
    if (row == 0) {
        return [self titleViewCellForTableView:tableView WithTitle:@"Feedback"];
    }
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kPlaceReportProblemCellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kPlaceReportProblemCellIdentifier];
    }
    
    cell.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ReportButton"]];
    
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
        //[self toggleMoreInfo];
    }
    if (indexPath.section == kPlaceHighlightsSection && indexPath.row == [self.highlights count]) {
        // This is the create highlights row
        [self createHighlight:self];
    }
    if (indexPath.section == kPlaceFeedbackSection && indexPath.row == 1) {
        [TestFlight openFeedbackView];
    }
}

#pragma mark - Buttons

- (void)map:(id)sender
{
    [self performSegueWithIdentifier:kShowMapViewControllerSegueIdentifier sender:self.place];
}


- (void)showHours:(id)sender
{
    NSMutableString *hoursString = [[NSMutableString alloc] initWithCapacity:64];
    
    for (Hours *hours in self.place.hours) {
        [hoursString appendFormat:@"%@\n", hours];
    }
    
    if ([hoursString isEqualToString:@""])
        [hoursString appendFormat:@"Aw, sorry, we don't have business hour information for this place."];
    
    NSString *title = [NSString stringWithFormat:@"Hours For %@", self.place.name];

    if (self.alertView == nil) {
        self.alertView = [[UIAlertView alloc] initWithTitle:title message:hoursString delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
    }
    
    [self.alertView setTitle:title];
    [self.alertView setMessage:hoursString];
    [self.alertView show];
}

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
        
        [self.alertView setTitle:kLoginAlertTitle];
        [self.alertView setMessage:kLoginAlertMessage];
        [self.alertView show];
    }
}

- (void)thumbsUp:(id)sender
{
    if ([DashAPI loggedIn]) {
        [self.api thumbsUpPlace:self.place];
    }
    else {
        // Otherwise, let them know they can't do that yet
        if (self.alertView == nil) {
            self.alertView = [[UIAlertView alloc] initWithTitle:kLoginAlertTitle message:kLoginAlertMessage delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        }
        
        [self.alertView setTitle:kLoginAlertTitle];
        [self.alertView setMessage:kLoginAlertMessage];
        [self.alertView show];
    }
}

- (void)thumbsDown:(id)sender
{
    if ([DashAPI loggedIn]) {        
        [self.api thumbsDownPlace:self.place];
    }
    else {
        // Otherwise, let them know they can't do that yet
        if (self.alertView == nil) {
            self.alertView = [[UIAlertView alloc] initWithTitle:kLoginAlertTitle message:kLoginAlertMessage delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        }
        
        [self.alertView setTitle:kLoginAlertTitle];
        [self.alertView setMessage:kLoginAlertMessage];
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
        [createHighlightViewController setDelegate:self];
    }
    else if ([[segue identifier] isEqualToString:kShowMapViewControllerSegueIdentifier]) {
        MapViewController *mapViewController = (MapViewController *)[segue destinationViewController];
        Place *place = (Place *)sender;
        
        [mapViewController setWithPlace:place];
    }
    else if ([segue.identifier isEqualToString:kShowFootprintProfile]) {
        Person *person = (Person *)sender;
        ProfileViewController *profileViewController = (ProfileViewController *)[segue destinationViewController];
        
        profileViewController.managedObjectContext = self.managedObjectContext;
        profileViewController.person = person;
        [profileViewController.recommends removeAllObjects];
        [profileViewController.highlights removeAllObjects];
        [profileViewController.likeHighlights removeAllObjects];
        
        [TestFlight passCheckpoint:@"Viewed footprint's profile"];       
    }
}

#pragma mark -

- (void)refresh
{
    // Table view cells
    self.badges = [[NSMutableArray alloc] initWithArray:[self.place.badges allObjects]];
    self.highlights = [[NSMutableArray alloc] initWithArray:[self.place.highlights allObjects]];
    self.footprints = [[NSMutableArray alloc] initWithArray:[self.place.newsItems allObjects]];
    
    // Connect the news items to us
    for (NewsItem *newsItem in self.footprints) {
        newsItem.place = self.place;
    }
    
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:nil ascending:NO selector:@selector(compare:)];
    [self.highlights sortUsingDescriptors:[NSArray arrayWithObject:sortDescriptor]];
    [self.tableView reloadData];
    
    // Tool bar stuff
    [self.upButton setSelected:[self.place recommendedByMe]];
    [self.downButton setSelected:[self.place savedByMe]];
    [self.downLabel setText:[NSString stringWithFormat:@"%d", ([self.place.thumbsdowncount integerValue])]];
    [self.upLabel setText:[NSString stringWithFormat:@"%d", ([self.place.thumbsupcount integerValue])]];
}

- (void)showProfile:(id)sender
{
    UIButton *button = (UIButton *)sender;
    NSInteger row = button.tag;
    
    NewsItem *newsItem = [self.footprints objectAtIndex:row];
    Person *author = newsItem.author;
    
   [self performSegueWithIdentifier:kShowFootprintProfile sender:author];
}

#pragma mark - RKObjectLoaderDelegate methods

- (void)objectLoader:(RKObjectLoader *)objectLoader didLoadObjects:(NSArray *)objects 
{
    self.place = [objects lastObject];
    [self refresh];
}

- (void)objectLoader:(RKObjectLoader *)objectLoader didFailWithError:(NSError *)error 
{
    NSLog(@"Encountered an error: %@", error);
}

#pragma mark - RKRequestDelegate methods

- (void)request:(RKRequest *)request didLoadResponse:(RKResponse *)response
{
    if ([request.userData isEqualToNumber:[NSNumber numberWithInt:kRecommends]] || [request.userData isEqualToNumber:[NSNumber numberWithInt:kSaves]]) {
        [self.api placeByID:self.place.uid];
    }
}

@end
