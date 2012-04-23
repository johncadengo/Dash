//
//  ProfileViewController.m
//  Dash
//
//  Created by John Cadengo on 10/20/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "ProfileViewController.h"
#import "Constants.h"
#import "DashAPI.h"
#import "ProfileHeaderCell.h"
#import "PlaceViewController.h"

@implementation ProfileViewController

@synthesize showingProfileView = _showingProfileView;
@synthesize facebook = _facebook;
@synthesize fbconnect = _fbconnect;
@synthesize backgroundView = _backgroundView;
@synthesize managedObjectContext = __managedObjectContext;
@synthesize api = _api;
@synthesize person = _person;
@synthesize recommends = _recommends;
@synthesize settingsButton = _settingsButton;
@synthesize settingsSheet = _settingsSheet;

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

- (void)loadLoginView
{
    // Create our self.view
    //CGRect frame = CGRectMake(0.0f, 0.0f, 320.0f, 480.0f);
    UIView *view = [[UIView alloc] init];// initWithFrame:[[UIScreen mainScreen] applicationFrame]];
    self.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"SignInScreen.png"]];
    self.backgroundView.frame = CGRectMake(0.0f, 0.0f, 320.0f, 415.0f);
    [view addSubview:self.backgroundView];
    
    // Fb Connect
    self.fbconnect = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.fbconnect setBackgroundImage:[UIImage imageNamed:@"FacebookSignIn.png"] forState:UIControlStateNormal];
    [self.fbconnect addTarget:self 
                       action:@selector(loginWithConnect:) 
             forControlEvents:UIControlEventTouchUpInside];
    self.fbconnect.frame = CGRectMake(0.0f, 320.0f, 320.0f, 51.0f);
    [view addSubview:self.fbconnect];
    
    // Finally, set our self.view
    // NOTE: Do not get self.view in loadView
    self.showingProfileView = NO;
    self.view = view;
    
    // Get rid of top bar
    [self.navigationController setNavigationBarHidden:YES animated:NO];
}

- (void)loadProfileView
{
    // When we are in profile view self.view is self.tableview
    self.tableView = [[UITableView alloc] initWithFrame:[[UIScreen mainScreen] applicationFrame] style:UITableViewStylePlain];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    
    // Set our self.view
    self.showingProfileView = YES;
    self.view = self.tableView;
    
    // And finally, every time we show the profile view, 
    // we need to make a call to our Dash API to request the profile.
    [self requestProfile];
    
    // Put top bar back
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    
    // Set the bg color
    [self.view setBackgroundColor:UIColorFromRGB(kPlaceOrangeBGColor)];
        
    // Add the settings button
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(265.0f, 10.0f, 49.0f, 34.0f);
    [button setImage:[UIImage imageNamed:@"SettingsButton.png"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(showSettingsView:) forControlEvents:UIControlEventTouchUpInside];
    self.settingsButton = [[UIBarButtonItem alloc] initWithCustomView:button];
    [self.navigationItem setRightBarButtonItem:self.settingsButton];
}

// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
    // Gotta do this before creating our views
    
    // Connect to our API.
    self.api = [[DashAPI alloc] initWithManagedObjectContext:self.managedObjectContext delegate:self];
    
    // Default to NO
    self.showingProfileView = NO;
    
    // Login logic
    if (![DashAPI loggedIn]) {
        // This means we skipped logging in earlier, and consequently are not logged in now.
        [self loadLoginView];
    }
    else {
        [self loadProfileView];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.recommends = [[NSMutableArray alloc] initWithCapacity:12];
    
    self.facebook = [[Facebook alloc] initWithAppId:kFBAppID andDelegate:self];
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

    // Set the custom nav bar
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"TopBar.png"] forBarMetrics:UIBarMetricsDefault];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    // Reset it
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"TopBarWithoutDash.png"] forBarMetrics:UIBarMetricsDefault];
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

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat height;
    
    switch (indexPath.section) {
        case 0:
            height = [ProfileHeaderCell height];
            break;
            
        default:
            height = [RecommendedPlaceViewCell heightForType:[self recommendedPlaceViewCellTypeForRow:indexPath.row]];
            break;
    }
    
    return height;
}

- (RecommendedPlaceViewCellType)recommendedPlaceViewCellTypeForRow:(NSInteger)row
{
    RecommendedPlaceViewCellType type;
    NSInteger last = [self.recommends count] - 1;
    
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

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    if (section == 0) {
        // One header row
        return 1;
    }
    else if (section == 1) {
        // A row for each kind of stats
        return [self.recommends count]; 
    }
    else {
        // Should never happen
        return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    
    switch (indexPath.section) {
        case 0:
            cell = [self headerCellForTableView:tableView];
            break;
        default:
            cell = [self recommendCellForTableView:tableView row:indexPath.row];
            break;
    }
    
    // None should have a selection style
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    return cell;
}

- (ProfileHeaderCell *)headerCellForTableView:(UITableView *)tableView
{
    ProfileHeaderCell *cell = [tableView dequeueReusableCellWithIdentifier:kProfileHeaderCellIdentifier];
    
    if (cell == nil) {
        cell = [[ProfileHeaderCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kProfileHeaderCellIdentifier];
    }
    
    [cell setWithPerson:self.person];
    
    return cell;
}

- (RecommendedPlaceViewCell *)recommendCellForTableView:(UITableView *)tableView row:(NSInteger)row
{
    RecommendedPlaceViewCell *cell = (RecommendedPlaceViewCell *)[tableView dequeueReusableCellWithIdentifier:kPlacesPlaceCellIdentifier];
    
    if (cell == nil) {
        cell = [[RecommendedPlaceViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kPlacesPlaceCellIdentifier type:[self recommendedPlaceViewCellTypeForRow:row]];
    }
    
    // Always update type
    [cell setType:[self recommendedPlaceViewCellTypeForRow:row]];
    [cell setWithPlace:[[self.recommends objectAtIndex:row] place] context:self.managedObjectContext];
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1) {
        Place *place = [[self.recommends objectAtIndex:indexPath.row] place];
        [self performSegueWithIdentifier:kShowProfileViewDetailsIdentifier sender:place];
    }
}

#pragma mark - Storyboard Segue

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:kShowProfileViewDetailsIdentifier]) {
        Place *place = (Place *)sender;
        PlaceViewController *placeViewController = (PlaceViewController *)[segue destinationViewController];
        [placeViewController setPlace:place];
        
        // Make sure it has a managed object context
        [placeViewController setManagedObjectContext:self.managedObjectContext];
        
        
        // Make sure the tabbar hides so we can replace it with a toolbar
        placeViewController.hidesBottomBarWhenPushed = YES;
    }
}
#pragma mark - Button Actions

- (void)loginWithConnect:(id) sender
{
    // Assume we are logging in as John
    [DashAPI setLoggedIn:YES];
    
    // TODO: SOME MAGIC HERE
    
    // Reload view. 
    // TODO: Probably some memory leak here right?
    [self loadView];
}

- (void)showSettingsView:(id)sender
{
    if (self.settingsSheet == nil) {
        self.settingsSheet = [[UIActionSheet alloc] initWithTitle:@"Settings" 
                                                         delegate:self 
                                                cancelButtonTitle:@"Cancel" 
                                           destructiveButtonTitle:nil 
                                                otherButtonTitles:@"Log out", nil];
    }
    
    [self.settingsSheet showFromTabBar:self.tabBarController.tabBar];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
        case kLogoutButtonIndex:
            [self logout];
            break;
        case kCancelButtonIndex:
            NSLog(@"Cancel");
            break;
        default:
            break;
    }
}

#pragma mark - API

- (void)requestProfile
{
    [self.api myProfile];
    [self.api recommendsForPerson:nil];
}

#pragma mark - FB Connect

- (void)logout
{
    [self.facebook logout];
}

- (void)fbDidLogout 
{
    // Remove saved authorization information if it exists
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if ([defaults objectForKey:@"FBAccessTokenKey"]) {
        [defaults removeObjectForKey:@"FBAccessTokenKey"];
        [defaults removeObjectForKey:@"FBExpirationDateKey"];
        [defaults synchronize];
    }
    
    [DashAPI setLoggedIn:NO];
    [self loadView];
}

#pragma mark - RKObjectLoaderDelegate methods

- (void)objectLoader:(RKObjectLoader *)objectLoader didLoadObjects:(NSArray *)objects 
{
    // We are done loading, so stop the progress hud
    //[self.progressHUD hide:YES]; 
    
    if ([objectLoader.userData isEqualToNumber:[NSNumber numberWithInt:kRecommends]]) {
        [self.recommends addObjectsFromArray:objects];
    }
    else {
        // Get the objects we've just loaded and fill our places array with them
        self.person = [objects lastObject];
        
        NSLog(@"Profile: %@ %@", objects, self.person.actions);    
    }
    
    // Display it
    [self.tableView reloadData];
    
}

- (void)objectLoader:(RKObjectLoader *)objectLoader didFailWithError:(NSError *)error 
{
    NSLog(@"Encountered an error: %@", error);
}




@end
