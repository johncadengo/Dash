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

@synthesize rowView = _rowView;
@synthesize images = _images;

- (id)initWithStyle:(UITableViewStyle)style
{
    CGSize size = CGSizeMake(320.0f, 70.0f);
    return [self initWithStyle:style withSize:size];
}

- (id)initWithStyle:(UITableViewStyle)style withSize:(CGSize)size
{
    self = [super initWithStyle:style];
    if (self) {
        CGRect frame = CGRectMake(0.0f, 0.0f, size.width, size.height);
        self.rowView = [[JCImageGalleryView alloc] initWithFrame:frame];
        [self.rowView setBackgroundColor: [UIColor grayColor]];
        
        self.images = [[NSMutableArray alloc] initWithCapacity:4];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleGesture:)];
        [self.rowView addGestureRecognizer:tap];
        
        
    }
    return self;
}

- (void)showToolbar:(id)sender
{
    UIToolbar *toolbar = [UIToolbar new];
    toolbar.barStyle = UIBarStyleDefault;
    [toolbar sizeToFit];
    toolbar.frame = CGRectMake(0, 410, 320, 50);
    
    NSArray* toolbarItems = [NSArray arrayWithObjects:
                             [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone 
                                                                           target:self
                                                                           action:@selector(done:)],
                             nil];
    
    
    [toolbar setItems:toolbarItems];
    [self.rowView addSubview:toolbar];
}

- (void)done:(id)sender
{
    NSLog(@"hey hey hey");
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)handleGesture:(UIGestureRecognizer *)gestureRecognizer
{
    CGRect oldframe = self.rowView.bounds;
    CGRect newframe = CGRectMake(oldframe.origin.x, 0.0f,
                                 oldframe.size.width, 960.0f);
    newframe = [[UIScreen mainScreen] applicationFrame];
    //CGRect zerobounds = CGRectMake(newbounds.origin.x, newbounds.origin.y, 320.0f, 1.0f);
    
    UIView *souper = self.rowView.superview;
    UIView *souperdooper = souper.superview;
    //souper.clipsToBounds = NO;
    //souperdooper.clipsToBounds = NO;
    
    CGRect frame = souper.frame;
    
    //[souper removeFromSuperview];
    //[souperdooper addSubview:self.rowView];
    [[[[UIApplication sharedApplication] delegate] window] addSubview:self.rowView];
    
    self.rowView.frame = frame;
    
    //self.rowView.clipsToBounds = NO;
    NSLog(@"hey %f %f %f %f", frame.origin.x, frame.origin.y, frame.size.width, frame.size.height);
    

//    [souperdooper removeFromSuperview];

    [UIView animateWithDuration:1.0
                          delay: 0.0
                        options: UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         //[self.rowView removeFromSuperview];
//                         
                         self.rowView.frame = newframe;
                         //souperdooper.bounds = zerobounds;
                     }
                     completion:^(BOOL finished){
                         // Wait one second and then fade in the view
                         [UIView animateWithDuration:1.0
                                               delay: 1.0
                                             options:UIViewAnimationOptionCurveEaseOut
                                          animations:^{
                                              //souperdooper.alpha = 0.0;
                                              //self.rowView.alpha = 0.7;
                                          }
                                          completion:nil];
                     }];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showToolbar:)];
    [self.rowView addGestureRecognizer:tap];
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
