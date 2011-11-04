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
    kHighlightCommentsSection = 1,
    kHighlightPhotosSection = 2,
    kHighlightNumSections = 3
};

/** 
 */
enum {
    kHighlightNumRowsForHeaderSection = 2,   // Highlight and footer (# comments, # likes)
    kHighlightNumRowsForPhotoSection = 1
};

#pragma - Class definition

@class Highlight;
@class DashAPI;

@interface HighlightViewController : TISwipeableTableViewController <UITableViewDataSource, UITableViewDelegate, ActionVIewCellDelegate>

@property (nonatomic, strong) Highlight *highlight;
@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, strong) DashAPI *api;
@property (nonatomic, strong) NSMutableArray *comments;

/** Dynamically generate the row height for action cells
 */
- (CGFloat)heightForActionCellForRow:(NSInteger)row;

- (ActionViewCell *)HeaderCellForTableView:(UITableView *)tableView;
- (ActionViewCell *)CommentCellForTableView:(UITableView *)tableView forRow:(NSInteger)row;

@end
