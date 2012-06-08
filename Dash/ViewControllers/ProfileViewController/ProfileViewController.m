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
#import "TestFlight.h"
#import "TitleViewCell.h"

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
@synthesize hud = _hud;
@synthesize alertView = _alertView;

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
    
    // Put top bar back
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    
    // Set the bg color
    [self.view setBackgroundColor:UIColorFromRGB(kGreyBGColor)];
        
    // Add the settings button
    if (!self.person) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(265.0f, 10.0f, 49.0f, 34.0f);
        [button setImage:[UIImage imageNamed:@"SettingsButton.png"] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(showSettingsView:) forControlEvents:UIControlEventTouchUpInside];
        self.settingsButton = [[UIBarButtonItem alloc] initWithCustomView:button];
        [self.navigationItem setRightBarButtonItem:self.settingsButton];
    }
    
    // Make our progress hud
    self.hud = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:self.hud];
    [self.hud setDelegate:self];
    self.hud.removeFromSuperViewOnHide = NO;
}

// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
    // Connect to our API.
    self.api = [[DashAPI alloc] initWithManagedObjectContext:self.managedObjectContext delegate:self];
    
    // Default to NO
    self.showingProfileView = NO;
    
    // Login logic
    if (!DashAPI.loggedIn && !self.person) {
        // This means we skipped logging in earlier, and consequently are not logged in now.
        [self loadLoginView];
    }
    else {
        [self loadProfileView];
        [self requestProfile];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.recommends = [[NSMutableArray alloc] initWithCapacity:12];
    
    // FB
    self.facebook = [[Facebook alloc] initWithAppId:kFBAppID andDelegate:self];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if ([defaults objectForKey:@"FBAccessTokenKey"] 
        && [defaults objectForKey:@"FBExpirationDateKey"]) {
        self.facebook.accessToken = [defaults objectForKey:@"FBAccessTokenKey"];
        self.facebook.expirationDate = [defaults objectForKey:@"FBExpirationDateKey"];
    }

    // My profile or someone else's
    if ([self.facebook isSessionValid] && !self.person) {
        [DashAPI setLoggedIn:YES];
        [self.hud show:YES];
        [self.facebook requestWithGraphPath:@"me" andDelegate:self];
    }
    else if (self.person) {
        [self.hud show:YES];
        [self.facebook requestWithGraphPath:self.person.fb_uid andDelegate:self];
    }

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(newProfile:) name:@"fbDidLogin" object:nil];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    
    self.hud = nil;
    self.fbconnect = nil;
    self.backgroundView = nil;
    self.settingsSheet = nil;
    self.settingsButton = nil;
    self.alertView = nil;
    self.person = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    // Set the custom nav bar
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"TopBar.png"] forBarMetrics:UIBarMetricsDefault];
    
    if (DashAPI.shouldRefreshProfile) {
        [self requestProfile];
        [DashAPI setShouldRefreshProfile:NO];
    }
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
        case 1:
            height = [TitleViewCell height];
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
    return 3; //One for the header. One for the title. And one for the liked restaurants.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    if (section == 0) {
        // One header row
        return 1;
    }
    else if (section == 1) {
        // Title view cell section
        return 1;
    }
    else if (section == 2) {
        // Recommend cells.. If not recommends, then return 1 for the no likes message.
        return (self.recommends.count) ? self.recommends.count : 1; 
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
        case 1:
            cell = [self titleViewCellForTableView:tableView];
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

- (TitleViewCell *)titleViewCellForTableView:(UITableView *)tableView
{
    TitleViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kPlaceTitleCellIdentifier];
    
    if (cell == nil) {
        cell = [[TitleViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kPlaceTitleCellIdentifier];
    }
    
    [cell setTitle:@"Liked Restaurants"];
    
    return cell;
}

- (RecommendedPlaceViewCell *)recommendCellForTableView:(UITableView *)tableView row:(NSInteger)row
{
    id newCell;
    
    if (self.recommends.count) {
        RecommendedPlaceViewCell *cell = (RecommendedPlaceViewCell *)[tableView dequeueReusableCellWithIdentifier:kPlacesPlaceCellIdentifier];
        
        if (cell == nil) {
            cell = [[RecommendedPlaceViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kPlacesPlaceCellIdentifier type:[self recommendedPlaceViewCellTypeForRow:row]];
        }
        
        // Always update type
        [cell setType:[self recommendedPlaceViewCellTypeForRow:row]];
        [cell setWithPlace:[[self.recommends objectAtIndex:row] place] context:self.managedObjectContext];
        
        newCell = cell;
    }
    else {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kProfileNoLikesCellIdentifier];
        
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kProfileNoLikesCellIdentifier];
        }
        
        [cell setBackgroundView:[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"NoLikesMessage"]]];
        
        newCell = cell;
    }
    
    return newCell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 2 && self.recommends.count) {
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
    if (![self.facebook isSessionValid]) {
        [self.facebook authorize:nil];
    }
    else {
        [DashAPI setLoggedIn:YES];
    }
    
    // Reload view.
    [self loadView];
}

- (void)showSettingsView:(id)sender
{
    if (self.settingsSheet == nil) {
        self.settingsSheet = [[UIActionSheet alloc] initWithTitle:@"Settings" 
                                                         delegate:self 
                                                cancelButtonTitle:@"Cancel" 
                                           destructiveButtonTitle:@"Log out" 
                                                otherButtonTitles:@"Submit Feedback", nil];
    }
    
    [self.settingsSheet showFromTabBar:self.tabBarController.tabBar];
    
    [TestFlight passCheckpoint:@"Showing settings sheet"];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
        case kLogoutButtonIndex:
            [self logout];
            break;
        case kFeedbackButtonIndex:
            [TestFlight passCheckpoint:@"Showing submit feedback"];
            [TestFlight openFeedbackView];
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
    if (self.person) {
        [self.api recommendsForPerson:self.person];
    }
    else if (DashAPI.me) {
        [self.api myProfile];
        [self.api recommendsForPerson:DashAPI.me];
    }
}

#pragma mark - FB Connect

- (void)logout
{
    [DashAPI setMe:nil];
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

- (void)fbDidLogin 
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if ([defaults objectForKey:@"FBAccessTokenKey"] 
        && [defaults objectForKey:@"FBExpirationDateKey"]) {
        self.facebook.accessToken = [defaults objectForKey:@"FBAccessTokenKey"];
        self.facebook.expirationDate = [defaults objectForKey:@"FBExpirationDateKey"];
    }
    
    [self loadView];
}

- (void)newProfile:(NSNotification *)sender;
{
    self.person = [sender.userInfo objectForKey:@"newMe"];
    [self fbDidLogin];
}

- (void)request:(FBRequest *)request didLoad:(id)result
{
    self.person = [Person personWithFBResult:result context:self.managedObjectContext];
    [self.api createPerson:self.person];
    [DashAPI setMe:self.person];
    [self.tableView reloadData];
}

- (void)request:(FBRequest *)request didFailWithError:(NSError *)error
{
    TFLog(@"Request %@ Error %@", request, error);
    
    [self.hud hide:YES];
}

#pragma mark - RKObjectLoaderDelegate methods

- (void)objectLoader:(RKObjectLoader *)objectLoader didLoadObjects:(NSArray *)objects 
{
    // We are done loading, so stop the progress hud
    [self.hud hide:YES];
    
    if ([objectLoader.userData isEqualToNumber:[NSNumber numberWithInt:kRecommends]]) {
        [self.recommends removeAllObjects];
        [self.recommends addObjectsFromArray:objects];
    }
    else {
        // Get the objects we've just loaded and fill our places array with them
        //self.person = [objects lastObject];
        
        //NSLog(@"Profile: %@ %@", objects, self.person.actions);    
    }
    
    // Display it
    [self.tableView reloadData];
    
}

- (void)objectLoader:(RKObjectLoader *)objectLoader didFailWithError:(NSError *)error 
{
    TFLog(@"Encountered an error: %@", error);
    
    [self.hud hide:YES];

    // We can't reach the internet, so let the user know
    if (self.alertView == nil) {
        self.alertView = [[UIAlertView alloc] initWithTitle:@"Oh no!" 
                                                    message:kNoInternetMessage 
                                                   delegate:nil
                                          cancelButtonTitle:@"Ok" 
                                          otherButtonTitles:nil];
    }
    else {
        [self.alertView setMessage:kNoInternetMessage];
    }
    
    [self.alertView show];
}


@end
