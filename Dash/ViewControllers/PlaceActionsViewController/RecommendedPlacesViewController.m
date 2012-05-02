//
//  PlacesViewController.m
//  Dash
//
//  Created by John Cadengo on 10/20/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "RecommendedPlacesViewController.h"
#import "Place.h"
#import "DashAPI.h"
#import "Constants.h"
#import "PlaceViewController.h"
#import "PlaceAction.h"

@implementation RecommendedPlacesViewController

@synthesize showingFavoritesView = _showingFavoritesView;
@synthesize facebook = _facebook;
@synthesize fbconnect = _fbconnect;
@synthesize backgroundView = _backgroundView;

@synthesize managedObjectContext = __managedObjectContext;
@synthesize api = _api;
@synthesize hud = _hud;
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
    self.showingFavoritesView = NO;
    self.view = view;
    
    // Get rid of top bar
    [self.navigationController setNavigationBarHidden:YES animated:NO];
}

- (void)loadFavoritesView
{
    // When we are in profile view self.view is self.tableview
    self.tableView = [[UITableView alloc] initWithFrame:[[UIScreen mainScreen] applicationFrame] style:UITableViewStylePlain];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    
    // Set our self.view
    self.showingFavoritesView = YES;
    self.view = self.tableView;
    
    // Put top bar back
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    
    // Set the bg color
    [self.view setBackgroundColor:UIColorFromRGB(kPlaceOrangeBGColor)];
    
    // Make our progress hud
    self.hud = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:self.hud];
    [self.hud setDelegate:self];
    self.hud.removeFromSuperViewOnHide = NO;
    
    // Make our call
    [self.hud show:YES];
    [self refreshFeed];
}

- (void)loadView
{
    // Connect to our API.
    self.api = [[DashAPI alloc] initWithManagedObjectContext:self.managedObjectContext delegate:self];
    
    // Default to NO
    self.showingFavoritesView = NO;
    
    // Login logic
    if (![DashAPI loggedIn]) {
        // This means we skipped logging in earlier, and consequently are not logged in now.
        [self loadLoginView];
    }
    else {
        [self loadFavoritesView];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
 
    // Prepare our arrays of places
    self.feedItems = [[NSMutableArray alloc] initWithCapacity:12];
    
    // FB
    self.facebook = [[Facebook alloc] initWithAppId:kFBAppID andDelegate:self];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if ([defaults objectForKey:@"FBAccessTokenKey"] 
        && [defaults objectForKey:@"FBExpirationDateKey"]) {
        self.facebook.accessToken = [defaults objectForKey:@"FBAccessTokenKey"];
        self.facebook.expirationDate = [defaults objectForKey:@"FBExpirationDateKey"];
    }
    
    if ([self.facebook isSessionValid]) {
        [DashAPI setLoggedIn:YES];
        [self.hud show:YES];
        [self refreshFeed];
    }

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(fbDidLogin) name:@"fbDidLogin" object:nil];
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
    
    if (DashAPI.shouldRefreshFavorites) {
        [self refreshFeed];
        [DashAPI setShouldRefreshFavorites:NO];
    }
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
    return [RecommendedPlaceViewCell heightForType:[self recommendedPlaceViewCellTypeForRow:[indexPath row]]];
}

- (RecommendedPlaceViewCellType)recommendedPlaceViewCellTypeForRow:(NSInteger)row
{
    RecommendedPlaceViewCellType type;
    NSInteger last = [self.feedItems count] - 1;
    
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
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [self.feedItems count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    RecommendedPlaceViewCell *cell = (RecommendedPlaceViewCell *)[tableView dequeueReusableCellWithIdentifier:kPlacesPlaceCellIdentifier];
    
    NSInteger row = [indexPath row];
    
    if (cell == nil) {
        cell = [[RecommendedPlaceViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kPlacesPlaceCellIdentifier type:[self recommendedPlaceViewCellTypeForRow:row]];
    }
    
    // Always update type
    [cell setType:[self recommendedPlaceViewCellTypeForRow:row]];
    [cell setWithPlace:[[self.feedItems objectAtIndex:row] place] context:self.managedObjectContext];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSUInteger row = [indexPath row];
    
    PlaceAction *placeAction = [self.feedItems objectAtIndex:row];
    Place *place = [placeAction place];
    [self performSegueWithIdentifier:kShowPlaceActionDetailsSegueIdentifier sender:place];
}

#pragma mark - Storyboard Segue

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:kShowPlaceActionDetailsSegueIdentifier]) {
        Place *place = (Place *)sender;
        PlaceViewController *placeViewController = (PlaceViewController *)[segue destinationViewController];
        [placeViewController setPlace:place];
        
        // Make sure it has a managed object context
        [placeViewController setManagedObjectContext:self.managedObjectContext];
        
        
        // Make sure the tabbar hides so we can replace it with a toolbar
        placeViewController.hidesBottomBarWhenPushed = YES;
    }
}

#pragma mark - RKObjectLoaderDelegate methods

- (void)objectLoader:(RKObjectLoader *)objectLoader didLoadObjects:(NSArray *)objects 
{
    // Let them know we're done
    [self.hud hide:YES];
    
    //[self.feedItems addObjectsFromArray:objects];
    self.feedItems = [NSMutableArray arrayWithArray:objects];
     
    // If we are switching from a different mode, need to hide the back views so that swipe will reset and work.
    [self.tableView reloadData];
}

- (void)objectLoader:(RKObjectLoader *)objectLoader didFailWithError:(NSError *)error 
{
    NSLog(@"Encountered an error: %@", error);
    
    // Let them know we're done
    [self.hud hide:YES];
}

#pragma mark - ListModeCellDelegate

- (void)refreshFeed
{
    // Let them know we're working on it
    [self.hud show:YES];
    
    // Make a call to the api to request the feed
    //self.requests = [NSDictionary dictionaryWithDictionary:[self.api placeActionsForPerson:nil]];
    [self.api recommendsForPerson:DashAPI.me];
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



@end
