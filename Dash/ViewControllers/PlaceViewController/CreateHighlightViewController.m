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
@synthesize textField = _textField;

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
    
    // Make sure the top bar and bottom bar show
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    
    
    self.textField = [[UITextField alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 320.0f, 208.0f)];
    [self.view addSubview:self.textField];
    [self.textField becomeFirstResponder];
    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
