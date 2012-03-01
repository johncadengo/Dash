//
//  LoginViewController.m
//  Dash
//
//  Created by John Cadengo on 3/1/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "LoginViewController.h"
#import "DashViewController.h"
#import "Constants.h"

@implementation LoginViewController

@synthesize managedObjectContext = _managedObjectContext;
@synthesize welcome = _welcome;
@synthesize introduction = _introduction;
@synthesize skip = _skip;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
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
    UIView *view = [[UIView alloc] init];//WithFrame:frame];
    view.backgroundColor = [UIColor whiteColor];
    
    // Add welcome text
    CGRect welcomeFrame = CGRectMake(0.0f, 0.0f, 320.0f, 50.0f);
    self.welcome = [[UILabel alloc] initWithFrame:welcomeFrame];
    self.welcome.text = @"Welcome to Dash";
    [view addSubview:self.welcome];
    
    // Finally, set our self.view
    // NOTE: Do not get self.view in loadView
    self.view = view;
}



// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];

    // TODO: Some logic in here to check whether we are logged in or not
    // For now, segue immediately to dash view controller
    //[self showDash];
}


- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Show dash

- (void)showDash
{
    [self performSegueWithIdentifier:kShowDashViewControllerSegueIdentifier sender:nil];
}


#pragma mark - Storyboard Segue

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:kShowDashViewControllerSegueIdentifier]) {
        DashViewController *dashViewController = (DashViewController *)[segue destinationViewController];
        
        // Make sure it has a managed object context
        [dashViewController setManagedObjectContext:self.managedObjectContext];
    }
}

@end