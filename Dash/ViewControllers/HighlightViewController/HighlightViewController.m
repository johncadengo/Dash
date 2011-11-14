//
//  ActionViewController.m
//  Dash
//
//  Created by John Cadengo on 11/4/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "HighlightViewController.h"
#import "TISwipeableTableView.h"
#import "DashAPI.h"
#import "Constants.h"
#import "FeedbackActivityCell.h"
#import "UIImage+ProportionalFill.h"
#import "JCImageGalleryViewController.h"


@implementation HighlightViewController

@synthesize managedObjectContext = __managedObjectContext;
@synthesize highlight = _highlight;
@synthesize api = _api;
@synthesize comments = _comments;
@synthesize imageGalleryViewController = _imageGalleryViewController;


- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {

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
    self.api = [[DashAPI alloc] initWithManagedObjectContext:self.managedObjectContext];
    
    self.comments = [self.api commentsForHighlight:self.highlight];
    
    [self.tableView setSeparatorStyle: UITableViewCellSeparatorStyleNone];

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


#pragma mark - Table view delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger section = [indexPath section];
    NSInteger row = [indexPath row];
    
    CGFloat height = 0.0f;
    
    switch (section) {
        case kHighlightHeaderSection:
            height = [self heightForHeaderSectionCellForRow:row];
            break;
        case kHighlightCommentsSection:
            height = [self heightForActionCellForRow:row];
            break;
        case kHighlightPhotosSection:
            // TODO: Figure out this height.
            height = 80.0f;
            break;
        default:
            // Should never happen
            NSAssert(NO, @"Asking for the height of a row in a section that doesn't exist: %d", section);
            break;
    }
    
    return height;
}

- (CGFloat)heightForHeaderSectionCellForRow:(NSInteger)row
{
    CGFloat height;
    
    switch (row) {
        case kHighlightHeaderRow:
            height = [ActionViewCell heightForAction:self.highlight 
                                        withCellType:ActionViewCellTypeHeader];
            break;
        case kHighlightFeedbackActivityRow:
            height = [FeedbackActivityCell heightForAction:self.highlight];
            break;
        default:
            NSAssert(NO, @"Asking for height of a row in the header section that doesn't exist: %d", row);
            break;
    }
    
    return height;
}

- (CGFloat)heightForActionCellForRow:(NSInteger)row
{
    // Get the blurb we are using for that row
    Action *action = [self.comments objectAtIndex:row];
    return [ActionViewCell heightForAction:action withCellType:ActionViewCellTypeFeedItem];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return kHighlightNumSections;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger numRows = 0;
    
    switch (section) {
        case kHighlightHeaderSection:
            numRows = kHighlightNumRowsForHeaderSection;
            break;
        case kHighlightCommentsSection:
            numRows = [self.comments count];
            break;
        case kHighlightPhotosSection:
            numRows = kHighlightNumRowsForPhotoSection;
            break;
        default:
            // Should never happen
            NSAssert(NO, @"Asking for number of rows in a section that doesn't exist: %d", section);
            break;
    }
    
    return numRows;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger section = [indexPath section];
    NSInteger row = [indexPath row];
    id cell = nil;
    
    switch (section) {
        case kHighlightHeaderSection:
            cell = [self headerSectionCellForTableView:tableView forRow:row];
            break;
        case kHighlightCommentsSection:
            cell = [self commentCellForTableView:tableView forRow:row];
            break;
        case kHighlightPhotosSection:
            cell = [self imageGalleryCellForTableView:tableView];
            break;
        default:
            // Should never happen
            NSAssert(NO, @"Asking for cell in a section that doesn't exist: %d", section);
            break;
    }
    
    return cell;
}

- (UITableViewCell *)headerSectionCellForTableView:(UITableView *)tableView forRow:(NSInteger)row
{
    id cell;
    
    switch (row) {
        case kHighlightHeaderRow:
            cell = [self headerCellForTableView:tableView];
            break;
        case kHighlightFeedbackActivityRow:
            cell = [self feedbackActivityCellForTableView:tableView];
            break;
        default:
            NSAssert(NO, @"Asking for a row in the header section that doesn't exist: %d", row);
            break;
    }
    
    return cell;
}

- (ActionViewCell *)headerCellForTableView:(UITableView *)tableView
{
    ActionViewCell *cell = (ActionViewCell *)[tableView dequeueReusableCellWithIdentifier:kHighlightHeaderCellIdentifier];
    
    if (cell == nil) {
        cell = [[ActionViewCell alloc] initWithStyle:UITableViewCellStyleDefault 
                                     reuseIdentifier:kHighlightHeaderCellIdentifier
                                            cellType:ActionViewCellTypeHeader];
    }
    
    [cell setDelegate:self];
    Action *action = self.highlight;
    [cell setWithAction:action];
    
    return cell;
}

- (FeedbackActivityCell *)feedbackActivityCellForTableView:(UITableView *)tableView
{
    FeedbackActivityCell *cell = (FeedbackActivityCell *)[tableView dequeueReusableCellWithIdentifier:kHighlightFeedbackCellIdentifier];
    
    if (cell == nil) {
        cell = [[FeedbackActivityCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kHighlightFeedbackCellIdentifier action:nil];
    }
    
    Action *action = self.highlight;
    [cell setWithAction:action];
    
    return cell;
}

- (ActionViewCell *)commentCellForTableView:(UITableView *)tableView forRow:(NSInteger)row
{
    ActionViewCell *cell = (ActionViewCell *)[tableView dequeueReusableCellWithIdentifier:kHighlightCommentCellIdentifier];
    
    if (cell == nil) {
        cell = [[ActionViewCell alloc] initWithStyle:UITableViewCellStyleDefault 
                                     reuseIdentifier:kHighlightCommentCellIdentifier
                                            cellType:ActionViewCellTypeFootprint];
    }
    
    [cell setDelegate:self];
    Action *action = [self.comments objectAtIndex:row];
    [cell setWithAction:action];
    
    return cell;
}

- (UITableViewCell *)imageGalleryCellForTableView:(UITableView *)tableView
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
        
        CGSize size = CGSizeMake(57.0f, 57.0f);
        UIImage *image;
        NSString *iconPath;
        NSMutableArray *images = [[NSMutableArray alloc] initWithCapacity:24];
        Action *comment;
        for (int i = 0; i < 16; i++) {
            comment = [self.comments objectAtIndex:i%4];
            iconPath = [[[comment author] profilepic] localpath];
            image = [[UIImage imageNamed:iconPath] imageCroppedToFitSize:size];
            [images addObject:image];
        }
        
        CGRect frame = CGRectMake(0.0f, 0.0f, 320.0f, 80.0f);
        cell.frame = frame;
        self.imageGalleryViewController = [[JCImageGalleryViewController alloc] initWithImages:images superview:cell];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
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

#pragma mark - Action view cell delegate

- (void)cellBackButtonWasTapped:(ActionViewCell *)cell
{
    
}

@end
