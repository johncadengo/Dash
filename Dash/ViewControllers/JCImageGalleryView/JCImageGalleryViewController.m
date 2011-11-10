//
//  JCImageGalleryViewController.m
//  Dash
//
//  Created by John Cadengo on 11/8/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "JCImageGalleryViewController.h"
#import "AppDelegate.h"

@implementation JCImageGalleryViewController

@synthesize superview = _mySuperview;
@synthesize view = _myView;
@synthesize tap = _tap;
@synthesize images = _images;
@synthesize toolbar = _toolbar;
@synthesize done = _done;
@synthesize state = _state;

- (id)initWithSuperview:(UIView *)superview
{
    return [self initWithSuperview:superview frame:superview.frame];
}

- (id)initWithSuperview:(UIView *)superview frame:(CGRect)frame
{
    self = [super init];
    
    if (self) {
        self.images = [[NSMutableArray alloc] initWithCapacity:4];
        
        self.view = [[UIScrollView alloc] initWithFrame:frame];
        [self.view setBackgroundColor: [UIColor grayColor]];


        self.tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleGesture:)];
        [self.view addGestureRecognizer:self.tap];
        
        self.superview = superview;
        [self.superview addSubview:self.view];
        
        // We always begin in the pinhole state 
        // because we are initializing inside of a superview
        self.state = JCImageGalleryViewStatePinhole;
    }
    
    return self;    
}

- (void)showToolbar:(id)sender
{
    if (self.toolbar == nil) {
        self.toolbar = [[UIToolbar alloc] init];
        self.toolbar.barStyle = UIBarStyleBlack;
        self.toolbar.translucent = YES;
        
        self.done = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(handleDone:)];
        [self.done setEnabled:YES];
        
        self.toolbarItems = [NSArray arrayWithObject:self.done];
        [self.toolbar setItems:self.toolbarItems animated:YES];
        [self.toolbar sizeToFit];
    }
    
    [self.view addSubview:self.toolbar];
}

- (void)handleDone:(id)sender
{
    [self.toolbar removeFromSuperview];
    [self.view addGestureRecognizer:self.tap];
    
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)handleGesture:(UIGestureRecognizer *)gestureRecognizer
{
    if (self.state == JCImageGalleryViewStatePinhole) {
        CGRect newframe = [[UIScreen mainScreen] applicationFrame];

        UIView *souper = self.view.superview;
        CGRect frame = souper.frame;
        [[[[UIApplication sharedApplication] delegate] window] addSubview:self.view];    
        self.view.frame = frame;

        [UIView animateWithDuration:1.0
                              delay: 0.0
                            options: UIViewAnimationOptionCurveEaseIn
                         animations:^{
                             self.view.frame = newframe;
                         }
                         completion:^(BOOL finished){
                             // Wait one second and then fade in the view
                             [UIView animateWithDuration:1.0
                                                   delay: 1.0
                                                 options:UIViewAnimationOptionCurveEaseOut
                                              animations:^{
                                                  //self.rowView.alpha = 0.7;
                                              }
                                              completion:nil];
                         }];
        
        [self setState:JCImageGalleryViewStateGallery];
    }
    else {
        [self.view removeGestureRecognizer:gestureRecognizer];
        [self showToolbar:self];
    }
}

#pragma mark - View lifecycle

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

@end
