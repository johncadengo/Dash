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
    kHeaderSection = 0,
    kCommentsSection = 1,
    kPhotosSection = 2,
    kNumHighlightViewSections = 3
};

/** Only 1 row to contain the UITableViewCell which will house the segmented control
 */
enum {
    kNumRowsForHeaderSection = 2,   // Highlight and footer (# comments, # likes)
    kNumRowsForPhotoSection = 1
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

@end
