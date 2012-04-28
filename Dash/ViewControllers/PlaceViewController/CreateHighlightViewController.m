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
#import "Constants.h"
#import "DashAPI.h"

@interface CreateHighlightViewController ()

@end

@implementation CreateHighlightViewController

@synthesize place = _place;
@synthesize api = _api;
@synthesize context = _context;
@synthesize toolbar = _toolbar;
@synthesize textView = _textView;
@synthesize cancelButton = _cancelButton;
@synthesize doneButton = _doneButton;
@synthesize toolbarTitle = _toolbarTitle;
@synthesize characterCountLabel = _characterCountLabel;

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
    self.textView = [[UITextView alloc] initWithFrame:CGRectMake(5.0f, 49.0f, 320.0f - 10.0f, 159.0f - 10.0f)];
    [self.textView setFont:[UIFont systemFontOfSize:15.0f]];
    [self.textView setDelegate:self];
    [self.textView becomeFirstResponder];
    [self.view addSubview:self.textView];
    
    // Add the cancel button
    self.cancelButton = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" 
                                                         style:UIBarButtonItemStyleBordered 
                                                        target:self 
                                                        action:@selector(dismissModalViewControllerAnimated:)];
    [self.cancelButton setTintColor:[UIColor blackColor]];
    
    // Add the space inbetween
    UIBarButtonItem *flexibleSpace = [[UIBarButtonItem alloc] 
                                  initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace 
                                                                               target:nil action:nil];
    
    // Add the title
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 190.0f, 23.0f)];
    [titleLabel setText:@"Create Highlight"];
    [titleLabel setFont:[UIFont boldSystemFontOfSize:20.0f]];
    [titleLabel setBackgroundColor:[UIColor clearColor]];
    [titleLabel setTextColor:[UIColor whiteColor]];
    [titleLabel setTextAlignment:UITextAlignmentCenter];
    self.toolbarTitle = [[UIBarButtonItem alloc] initWithCustomView:titleLabel];
    
    // Add the done button
    self.doneButton = [[UIBarButtonItem alloc] initWithTitle:@"Post" 
                                                       style:UIBarButtonItemStyleDone 
                                                      target:self 
                                                      action:@selector(createHighlight:)];
 
    // Add the toolbar
    self.toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0.0, 0.0, 320.0f, 44.0f)];
    [self.toolbar setBackgroundImage:[UIImage imageNamed:@"TopBarWithoutDash.png"] forToolbarPosition:UIToolbarPositionAny barMetrics:UIBarMetricsDefault];
    [self.toolbar setItems:[NSArray arrayWithObjects:self.cancelButton, flexibleSpace, self.toolbarTitle, flexibleSpace, self.doneButton, nil]];
    [self.view addSubview:self.toolbar];
    
    // Add the character count label
    self.characterCountLabel = [[UILabel alloc] initWithFrame:CGRectMake(285.0f, 210.0f, 20.0f, 25.0f)];
    [self.characterCountLabel setTextColor:[UIColor blackColor]];
    [self.characterCountLabel setBackgroundColor:[UIColor clearColor]];
    [self.characterCountLabel setText:[NSString stringWithFormat:@"%i", kHighlightCharacterLimit]];
    [self.view addSubview:self.characterCountLabel];
    
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

#pragma mark - Button actions

- (void)createHighlight:(id)sender
{
    [self.api createHighlight:self.textView.text atPlace:self.place];
    [self.api placeByID:self.place.uid];
    [self dismissModalViewControllerAnimated:YES];
}

#pragma mark - Text View Delegate

-(void)textViewDidChange:(UITextView *)textView 
{
    int len = textView.text.length;
    self.characterCountLabel.text=[NSString stringWithFormat:@"%i",kHighlightCharacterLimit-len];
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    BOOL flag = NO;
    if([text length] == 0)
    {
        if([textView.text length] != 0)
        {
            flag = YES;
            return YES;
        }
        else {
            return NO;
        }
    }
    else if([[textView text] length] > (kHighlightCharacterLimit - 1))
    {
        return NO;
    }
    return YES;
} 

@end
