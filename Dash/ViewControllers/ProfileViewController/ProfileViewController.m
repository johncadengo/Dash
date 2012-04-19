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

@implementation ProfileViewController

@synthesize showingProfileView = _showingProfileView;
@synthesize fbconnect = _fbconnect;
@synthesize managedObjectContext = __managedObjectContext;
@synthesize api = _api;
@synthesize person = _person;
@synthesize recommends = _recommends;

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
    view.backgroundColor = [UIColor whiteColor];
    
    // Fb Connect
    self.fbconnect = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.fbconnect setBackgroundImage:[UIImage imageNamed:@"FacebookSignIn.png"] forState:UIControlStateNormal];
    [self.fbconnect addTarget:self 
                       action:@selector(loginWithConnect:) 
             forControlEvents:UIControlEventTouchUpInside];
    self.fbconnect.frame = CGRectMake(0.0f, 298.0f, 320.0f, 51.0f);
    [view addSubview:self.fbconnect];
    
    // Finally, set our self.view
    // NOTE: Do not get self.view in loadView
    self.showingProfileView = NO;
    self.view = view;
}

- (void)loadProfileView
{
    // When we are in profile view self.view is self.tableview
    self.tableView = [[UITableView alloc] initWithFrame:[[UIScreen mainScreen] applicationFrame] style:UITableViewStylePlain];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    // Set our self.view
    self.showingProfileView = YES;
    self.view = self.tableView;
    
    // And finally, every time we show the profile view, 
    // we need to make a call to our Dash API to request the profile.
    [self requestProfile];
}

// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
    // Gotta do this before creating our views
    
    // Connect to our API.
    self.api = [[DashAPI alloc] initWithManagedObjectContext:self.managedObjectContext delegate:self];
    
    // Default to NO
    self.showingProfileView = NO;
    
    // TODO: Fix this
    [DashAPI setLoggedIn:YES];
    
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
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    // Configure the cell...
    if (self.person) {
        if (indexPath.section == 0) {
            // This is a header cell
            cell.textLabel.text = [NSString stringWithFormat:@"%@", self.person.name];
        }
        else if (indexPath.section == 1) {
            // This is a stat cell
            Stats *stats = self.person.stats;
            NSString *statDescription = [stats descriptionForType:[NSNumber numberWithInt:indexPath.row]];
            
            cell.textLabel.text = [NSString stringWithFormat:@"%@", statDescription];
        }
    }
    
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

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

#pragma mark - API

- (void)requestProfile
{
    [self.api myProfile];
}

#pragma mark - RKObjectLoaderDelegate methods

- (void)objectLoader:(RKObjectLoader *)objectLoader didLoadObjects:(NSArray *)objects 
{
    // We are done loading, so stop the progress hud
    //[self.progressHUD hide:YES]; 
    
    // Get the objects we've just loaded and fill our places array with them
    self.person = [objects lastObject];
    
    NSLog(@"Profile: %@ %@", objects, self.person.name);
    
    //[self.stats addObjectsFromArray:self.person.stats];
    
    
    // Display it
    [self.tableView reloadData];
    
}

- (void)objectLoader:(RKObjectLoader *)objectLoader didFailWithError:(NSError *)error 
{
    NSLog(@"Encountered an error: %@", error);
}




@end
