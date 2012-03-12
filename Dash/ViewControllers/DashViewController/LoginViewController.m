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

// For scrolling the textfields up when keyboard is shown
#define kOFFSET_FOR_KEYBOARD 140.0f

@implementation LoginViewController

@synthesize welcome = _welcome;
@synthesize introduction = _introduction;
@synthesize skip = _skip;
@synthesize fbconnect = _fbconnect;
@synthesize emailField = _emailField;
@synthesize passwordField = _passwordField;
@synthesize create = _create;
@synthesize tap = _tap;

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
        [self dismissKeyboard:textField];
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
    
    // Fb Connect
    self.fbconnect = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [self.fbconnect addTarget:self 
                       action:@selector(loginWithConnect:) 
             forControlEvents:UIControlEventTouchUpInside];
    [self.fbconnect setTitle:@"Login with Facebook" forState:UIControlStateNormal];
    self.fbconnect.frame = CGRectMake(20.0f, 340.0f, 280.0f, 40.0f);
    [view addSubview:self.fbconnect];
    
    // Skip now button
    self.skip = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [self.skip addTarget:self 
               action:@selector(showDash:)
     forControlEvents:UIControlEventTouchUpInside];
    [self.skip setTitle:@"Skip this for now" forState:UIControlStateNormal];
    self.skip.frame = CGRectMake(20.0f, 390.0f, 280.0f, 40.0f);
    [view addSubview:self.skip];
    
    // Create account button
    self.create = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [self.create addTarget:self 
                    action:@selector(loginWithConnect:)
          forControlEvents:UIControlEventTouchUpInside];
    [self.create setTitle:@"Create Account" forState:UIControlStateNormal];
    self.create.frame = CGRectMake(20.0f, 240.0f, 280.0f, 40.0f);
    [view addSubview:self.create];
    
    // Email field
    self.emailField = [[UITextField alloc] initWithFrame:CGRectMake(20.0f, 140.0f, 280.0f, 40.0f)];
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
    self.passwordField = [[UITextField alloc] initWithFrame:CGRectMake(20.0f, 190.0f, 280.0f, 40.0f)];
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



// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];

    self.tap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                       action:@selector(dismissKeyboard:)];
    [self.tap setCancelsTouchesInView:NO];
    [self.view addGestureRecognizer:self.tap];
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


- (void)dismissKeyboard:(id) sender
{
    // Only dismiss keyboard if it is showing. Otherwise, tap will pass through
    if ([self.emailField isFirstResponder] || [self.passwordField isFirstResponder]) {
        // Should find out who is first responder first, but for now just call both text fields
        [self.emailField resignFirstResponder];
        [self.passwordField resignFirstResponder];
        
        // Scroll our view back down
        [self setViewMovedUp:NO];
    }
}

@end
