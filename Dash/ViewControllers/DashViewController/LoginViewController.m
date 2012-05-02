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
#import "Person.h"
#import "Person+Helper.h"

@implementation LoginViewController

@synthesize skip = _skip;
@synthesize fbconnect = _fbconnect;
@synthesize dashViewController = _dashViewController;
@synthesize facebook = _facebook;

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
    
    // Fb Connect
    self.fbconnect = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.fbconnect setBackgroundImage:[UIImage imageNamed:@"FacebookSignIn.png"] forState:UIControlStateNormal];
    [self.fbconnect addTarget:self 
                       action:@selector(loginWithConnect:) 
             forControlEvents:UIControlEventTouchUpInside];
    self.fbconnect.frame = CGRectMake(0.0f, 298.0f, 320.0f, 51.0f);
    [view addSubview:self.fbconnect];
    
    // Skip now button
    self.skip = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.skip setBackgroundImage:[UIImage imageNamed:@"DashItNow.png"] forState:UIControlStateNormal];
    [self.skip addTarget:self 
               action:@selector(showDash:)
     forControlEvents:UIControlEventTouchUpInside];
    self.skip.frame = CGRectMake(0.0f, 398.0f, 320.0f, 50.0f);
    [view addSubview:self.skip];
    
    // Finally, set our self.view
    self.view = view;
}



// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.facebook = [[Facebook alloc] initWithAppId:kFBAppID andDelegate:self];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(fbDidLogin) name:@"fbDidLogin" object:nil];
}


- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Login logic
- (void)loginWithConnect:(id) sender
{
    if (![self.facebook isSessionValid]) {
        [self.facebook authorize:nil];
    }
    else {
        [DashAPI setLoggedIn:YES];
        [self dismissModalViewControllerAnimated:YES];
    }
}

- (void)fbDidLogin 
{
    [self.dashViewController pop:self];
    [self dismissModalViewControllerAnimated:YES];
}

- (void)fbDidNotLogin:(BOOL)cancelled
{
    NSLog(@"Uh oh");
}

- (void)fbDidExtendToken:(NSString*)accessToken
               expiresAt:(NSDate*)expiresAt
{
    [self fbDidLogin];
}


#pragma mark - Show dash

- (void)showDash:(id) sender
{
    // Login logic
    [DashAPI setSkipLogin:YES];
    
    // Pop it
    [self.dashViewController pop:self];
    
    // Goodbye!
    [self dismissModalViewControllerAnimated:YES];
}


@end
