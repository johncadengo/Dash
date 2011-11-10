//
//  ActionViewController.h
//  Dash
//
//  Created by John Cadengo on 11/4/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ActionViewCell.h"

#pragma - Enum constants
/** There are two sections: 
 1) segemented control for list mode
 2) items in the news feed
 */
enum {
    kHighlightHeaderSection = 0,
    kHighlightPhotosSection = 1,
    kHighlightCommentsSection = 2,
    kHighlightNumSections = 3
};

/** 
 */
enum {
    kHighlightNumRowsForHeaderSection = 1,   // Highlight and footer (# comments, # likes)
    kHighlightNumRowsForPhotoSection = 1
};

/**
 */
enum {
    kHighlightHeaderRow = 0,
    kHighlightFeedbackActivityRow = 1
};

#pragma - Class definition

@class Highlight;
@class DashAPI;
@class FeedbackActivityCell;
@class JCImageGalleryViewController;

@interface HighlightViewController : TISwipeableTableViewController <UITableViewDataSource, UITableViewDelegate, ActionVIewCellDelegate>

@property (nonatomic, strong) Highlight *highlight;
@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, strong) DashAPI *api;
@property (nonatomic, strong) NSMutableArray *comments;
@property (nonatomic, strong) JCImageGalleryViewController *imageGalleryViewController;

/** Two rows in this section so far: Header and the feedback activity
 */
- (CGFloat)heightForHeaderSectionCellForRow:(NSInteger)row;

/** Dynamically generate the row height for action cells
 */
- (CGFloat)heightForActionCellForRow:(NSInteger)row;

- (UITableViewCell *)headerSectionCellForTableView:(UITableView *)tableView forRow:(NSInteger)row;
- (ActionViewCell *)headerCellForTableView:(UITableView *)tableView;
- (FeedbackActivityCell *)feedbackActivityCellForTableView:(UITableView *)tableView;
- (ActionViewCell *)commentCellForTableView:(UITableView *)tableView forRow:(NSInteger)row;
- (UITableViewCell *)imageGalleryCellForTableView:(UITableView *)tableView;

@end
