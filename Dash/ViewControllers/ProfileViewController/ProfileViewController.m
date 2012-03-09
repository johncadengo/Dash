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

// For scrolling the textfields up when keyboard is shown
#define kOFFSET_FOR_KEYBOARD 140.0f

@implementation ProfileViewController

@synthesize showingProfileView = _showingProfileView;
@synthesize introduction = _introduction;
@synthesize fbconnect = _fbconnect;
@synthesize start = _start;
@synthesize emailField = _emailField;
@synthesize passwordField = _passwordField;
@synthesize managedObjectContext = __managedObjectContext;
@synthesize api = _api;
@synthesize person = _person;
@synthesize stats = _stats;

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

#pragma mark - UITextField Delegate
-(void)textFieldDidBeginEditing:(UITextField *)sender
{
    BOOL eitherField = [sender isEqual:self.emailField] || [sender isEqual:self.passwordField];
    
    if (eitherField)
    {
        //move the main view, so that the keyboard does not hide it.
        if  (self.view.frame.origin.y >= 0)
        {
            [self setViewMovedUp:YES];
        }
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if ([textField isEqual:self.emailField]) {
        // If we are in the email field, we want it to go to the next field, password
        [self.passwordField becomeFirstResponder];
    }
    else {
        // Otherwise, dismiss the keyboard
        [textField resignFirstResponder];
        
        // Scroll our view back down
        [self setViewMovedUp:NO];
    }
    
    
    return NO;
}

//method to move the view up/down whenever the keyboard is shown/dismissed
-(void)setViewMovedUp:(BOOL)movedUp
{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.25f]; // if you want to slide up the view
    
    CGRect rect = self.view.frame;
    if (movedUp)
    {
        // 1. move the view's origin up so that the text field that will be hidden come above the keyboard 
        // 2. increase the size of the view so that the area behind the keyboard is covered up.
        rect.origin.y -= kOFFSET_FOR_KEYBOARD;
        rect.size.height += kOFFSET_FOR_KEYBOARD;
    }
    else
    {
        // revert back to the normal state.
        rect.origin.y += kOFFSET_FOR_KEYBOARD;
        rect.size.height -= kOFFSET_FOR_KEYBOARD;
    }
    self.view.frame = rect;
    
    [UIView commitAnimations];
}


- (void)keyboardWillShow:(NSNotification *)notif
{
    //keyboard will be shown now. depending for which textfield is active, move up or move down the view appropriately
    
    BOOL eitherField = [self.emailField isFirstResponder] || [self.passwordField isFirstResponder];
    
    if (eitherField && self.view.frame.origin.y >= 0)
    {
        [self setViewMovedUp:YES];
    }
    else if (!eitherField && self.view.frame.origin.y < 0)
    {
        [self setViewMovedUp:NO];
    }
}

#pragma mark - View lifecycle

- (void)loadLoginView
{
    // Create our self.view
    //CGRect frame = CGRectMake(0.0f, 0.0f, 320.0f, 480.0f);
    UIView *view = [[UIView alloc] init];// initWithFrame:[[UIScreen mainScreen] applicationFrame]];
    view.backgroundColor = [UIColor whiteColor];
    
    // Add the introduction
    CGRect introFrame = CGRectMake(20.0f, 5.0f, 280.0f, 40.0f);
    self.introduction = [[UILabel alloc] initWithFrame:introFrame];
    self.introduction.text = kSignUpText;
    self.introduction.lineBreakMode = UILineBreakModeWordWrap;
    self.introduction.numberOfLines = 0;
    self.introduction.font = [UIFont systemFontOfSize:12.0f];
    [view addSubview:self.introduction];
    
    // Fb Connect
    self.fbconnect = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [self.fbconnect addTarget:self 
                       action:@selector(loginWithConnect:) 
             forControlEvents:UIControlEventTouchUpInside];
    [self.fbconnect setTitle:@"Login with Facebook" forState:UIControlStateNormal];
    self.fbconnect.frame = CGRectMake(20.0f, 50.0f, 280.0f, 40.0f);
    [view addSubview:self.fbconnect];
    
    // Start Dashing button
    self.start = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [self.start addTarget:self 
                   action:@selector(startDashing:)
         forControlEvents:UIControlEventTouchUpInside];
    [self.start setTitle:@"Start Dashing" forState:UIControlStateNormal];
    self.start.frame = CGRectMake(20.0f, 280.0f, 280.0f, 40.0f);
    [view addSubview:self.start];
    
    // Email field
    self.emailField = [[UITextField alloc] initWithFrame:CGRectMake(20.0f, 180.0f, 280.0f, 40.0f)];
    self.emailField.borderStyle = UITextBorderStyleRoundedRect;
    self.emailField.font = [UIFont systemFontOfSize:15];
    self.emailField.placeholder = @"Email";
    self.emailField.autocorrectionType = UITextAutocorrectionTypeNo;
    self.emailField.keyboardType = UIKeyboardTypeDefault;
    self.emailField.returnKeyType = UIReturnKeyNext;
    self.emailField.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.emailField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;    
    self.emailField.delegate = self;
    [view addSubview:self.emailField];
    
    // Password field
    self.passwordField = [[UITextField alloc] initWithFrame:CGRectMake(20.0f, 230.0f, 280.0f, 40.0f)];
    self.passwordField.borderStyle = UITextBorderStyleRoundedRect;
    self.passwordField.font = [UIFont systemFontOfSize:15];
    self.passwordField.placeholder = @"Password";
    self.passwordField.autocorrectionType = UITextAutocorrectionTypeNo;
    self.passwordField.keyboardType = UIKeyboardTypeDefault;
    self.passwordField.returnKeyType = UIReturnKeyDone;
    self.passwordField.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.passwordField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;    
    self.passwordField.delegate = self;
    [view addSubview:self.passwordField];
    
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
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) 
                                                 name:UIKeyboardWillShowNotification object:self.view.window]; 


}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil]; 
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
        return kNumStatsTypes; 
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
            NSNumber *num;
            
            switch (indexPath.row) {
                case kSavesStat:
                    num = stats.saves;
                    break;
                case kRecommendsStat:
                    num = stats.recommends;
                    break;
                case kHightlightsStat:
                    num = stats.highlights;
                    break;
                default:
                    break;
            }
            
            cell.textLabel.text = [NSString stringWithFormat:@"%@", num];
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

- (void)startDashing:(id) sender
{
    NSLog(@"Start Dashing");
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
