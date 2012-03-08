//
//  ProfileViewController.m
//  Dash
//
//  Created by John Cadengo on 10/20/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "ProfileViewController.h"
#import "Constants.h"

// For scrolling the textfields up when keyboard is shown
#define kOFFSET_FOR_KEYBOARD 60.0

@implementation ProfileViewController

@synthesize managedObjectContext = __managedObjectContext;
@synthesize introduction = _introduction;
@synthesize fbconnect = _fbconnect;
@synthesize start = _start;
@synthesize emailField = _emailField;
@synthesize passwordField = _passwordField;

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

// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
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
    self.emailField.returnKeyType = UIReturnKeyDone;
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
    self.view = view;
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

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    // Configure the cell...
    
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
    NSLog(@"Login with FB");
}

- (void)startDashing:(id) sender
{
    NSLog(@"Start Dashing");
}

@end
