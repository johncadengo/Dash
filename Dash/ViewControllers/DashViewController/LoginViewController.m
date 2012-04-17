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
#import "DashAPI.h"

@implementation LoginViewController

@synthesize skip = _skip;
@synthesize fbconnect = _fbconnect;

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
    UIView *view = [[UIView alloc] init];// initWithFrame:[[UIScreen mainScreen] applicationFrame]];
    
    // Set the background
    UIImageView *backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"SplashPagePlain.png"]];
    [view addSubview:backgroundView];
    
    UIFont *buttonFont = [UIFont fontWithName:kPlutoBold size:16.0f];
    
    // Fb Connect
    self.fbconnect = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.fbconnect setBackgroundImage:[UIImage imageNamed:@"FacebookSignIn.png"] forState:UIControlStateNormal];
    [self.fbconnect addTarget:self 
                       action:@selector(loginWithConnect:) 
             forControlEvents:UIControlEventTouchUpInside];
    [self.fbconnect setTitle:@"sign in with facebook" forState:UIControlStateNormal];
    [self.fbconnect.titleLabel setFont:buttonFont];
    self.fbconnect.frame = CGRectMake(0.0f, 298.0f, 320.0f, 50.0f);
    [view addSubview:self.fbconnect];
    
    // Skip now button
    self.skip = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.skip setBackgroundImage:[UIImage imageNamed:@"DashItNow.png"] forState:UIControlStateNormal];
    [self.skip addTarget:self 
               action:@selector(showDash:)
     forControlEvents:UIControlEventTouchUpInside];
    [self.skip setTitle:@"dash it now" forState:UIControlStateNormal];
    [self.skip.titleLabel setFont:buttonFont];
    self.skip.frame = CGRectMake(0.0f, 398.0f, 320.0f, 50.0f);
    [view addSubview:self.skip];
    
    // Finally, set our self.view
    self.view = view;
}



// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
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

#pragma mark - Login logic
- (void)loginWithConnect:(id) sender
{
    // Login logic
    [DashAPI setLoggedIn:YES];
    
    // TODO: AND SOME MAGIC

    // See ya!
    [self dismissModalViewControllerAnimated:YES];
}

#pragma mark - Show dash

- (void)showDash:(id) sender
{
    // Login logic
    [DashAPI setSkipLogin:YES];
    
    // Goodbye!
    [self dismissModalViewControllerAnimated:YES];
}


@end
