//
//  DashViewController.m
//  Dash
//
//  Created by John Cadengo on 10/20/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "DashViewController.h"
#import "DashAPI.h"
#import "Place.h"

@implementation DashViewController

@synthesize managedObjectContext = __managedObjectContext;
@synthesize api = _api;
@synthesize textView = _textView;
@synthesize popButton = _popButton;

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

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Connect to our API.
    self.api = [[DashAPI alloc] initWithManagedObjectContext:self.managedObjectContext delegate:self];
    
    // Add our text view
    self.textView = [[UITextView alloc] init];
    self.textView.frame = CGRectMake(0.0f, 0.0f, 320.0f, 480.f - 49.0f - 50.0f);
    self.textView.text = @"Tap Dash!";
    self.textView.font = [UIFont systemFontOfSize:12];
    [self.view addSubview:self.textView];
    
    // Add our Dash button
    UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [button addTarget:self 
               action:@selector(pop:)
     forControlEvents:UIControlEventTouchDown];
    [button setTitle:@"Dash" forState:UIControlStateNormal];
    button.frame = CGRectMake(0.0f, 480.f - 44.0f - 64.0f - 50.0f, 320.0f, 50.0f);
    [self.view addSubview:button];

    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
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

# pragma mark -

- (void)pop:(id) sender
{
    [self.api pop:nil];
}

#pragma mark - RKObjectLoaderDelegate methods

- (void)objectLoader:(RKObjectLoader *)objectLoader didLoadObjects:(NSArray *)objects 
{
    // Create the text
    NSMutableString *text = [[NSMutableString alloc] init];
    for (Place *place in objects) {
        [text appendFormat:@"%@ - %@\n", place.name, place.address];
    }
    
    // Display it in a textview
    self.textView.text = [NSString stringWithString:text];    
    [self.textView sizeToFit];
    [self.view setNeedsDisplay];
    //NSLog(@"text %@", text);
}

- (void)objectLoader:(RKObjectLoader *)objectLoader didFailWithError:(NSError *)error 
{
    //NSLog(@"Encountered an error: %@", error);
}

@end
