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
    UIView *view = [[UIView alloc] init];// initWithFrame:[[UIScreen mainScreen] applicationFrame]];
    view.backgroundColor = [UIColor whiteColor];
    
    // Add the welcoming
    CGRect welcomeFrame = CGRectMake(20.0f, 10.0f, 280.0f, 20.0f);
    self.welcome = [[UILabel alloc] initWithFrame:welcomeFrame];
    self.welcome.text = kWelcomeText;
    [view addSubview:self.welcome];
    
    // Add the introduction
    CGRect introFrame = CGRectMake(20.0f, 30.0f, 280.0f, 100.0f);
    self.introduction = [[UILabel alloc] initWithFrame:introFrame];
    self.introduction.text = kIntroText;
    self.introduction.lineBreakMode = UILineBreakModeWordWrap;
    self.introduction.numberOfLines = 0;
    self.introduction.font = [UIFont systemFontOfSize:12.0f];
    [view addSubview:self.introduction];
    
    // Skip now button
    self.skip = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [self.skip addTarget:self 
               action:@selector(showDash:)
     forControlEvents:UIControlEventTouchUpInside];
    [self.skip setTitle:@"Skip this for now" forState:UIControlStateNormal];
    self.skip.frame = CGRectMake(20.0f, 300.0f, 280.0f, 40.0f);
    [view addSubview:self.skip];
    
    // Finally, set our self.view
    // NOTE: Do not get self.view in loadView
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

#pragma mark - Show dash

- (void)showDash:(id) sender
{
    [self dismissModalViewControllerAnimated:YES];
}

@end
