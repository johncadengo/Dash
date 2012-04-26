//
//  CreateHighlightViewController.m
//  Dash
//
//  Created by John Cadengo on 4/25/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CreateHighlightViewController.h"
#import "Place.h"
#import "Place+Helper.h"

@interface CreateHighlightViewController ()

@end

@implementation CreateHighlightViewController

@synthesize place = _place;
@synthesize context = _context;
@synthesize toolbar = _toolbar;
@synthesize textField = _textField;
@synthesize cancelButton = _cancelButton;
@synthesize doneButton = _doneButton;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Set up the textfield
    self.textField = [[UITextField alloc] initWithFrame:CGRectMake(5.0f, 49.0f, 320.0f - 10.0f, 159.0f - 10.0f)];
    [self.view addSubview:self.textField];
    [self.textField becomeFirstResponder];
    
    // Add the cancel button
    self.cancelButton = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" 
                                                         style:UIBarButtonItemStyleBordered 
                                                        target:self 
                                                        action:@selector(dismissModalViewControllerAnimated:)];
    
    // Add the done button
    self.doneButton = [[UIBarButtonItem alloc] initWithTitle:@"Post" 
                                                       style:UIBarButtonItemStyleDone 
                                                      target:self 
                                                      action:@selector(createHighlight:)];
    //[self.navigationItem setRightBarButtonItem:self.doneButton];
 
    self.toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0.0, 0.0, 320.0f, 44.0f)];
    [self.toolbar setBackgroundImage:[UIImage imageNamed:@"TopBarWithoutDash.png"] forToolbarPosition:UIToolbarPositionAny barMetrics:UIBarMetricsDefault];
    [self.toolbar setItems:[NSArray arrayWithObjects:self.cancelButton, self.doneButton, nil]];
    [self.view addSubview:self.toolbar];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (void)viewWillAppear:(BOOL)animated
{
    
    
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - 

- (void)createHighlight:(id)sender
{
    NSLog(@"Done");
}

@end
