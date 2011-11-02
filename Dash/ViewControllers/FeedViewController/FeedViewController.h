//
//  FeedViewController.h
//  Dash
//
//  Created by John Cadengo on 10/20/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FeedCell.h"

#pragma - Enum constants
/** There are two sections: 
    1) segemented control for list mode
    2) items in the news feed
 */
enum {
    kListModeSection = 0,
    kFeedItemsSection = 1,
    kNumSections = 2
};

/** Only 1 row to contain the UITableViewCell which will house the segmented control
 */
enum {
    kNumRowsForListModeSection = 1
};

#pragma - Class definition

@class DashAPI;
@class ListModeCell;
@class FeedCell;

@interface FeedViewController : TISwipeableTableViewController <FeedCellDelegate>

@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, strong) DashAPI *api;
@property (nonatomic, strong) NSMutableArray *feedItems;

- (ListModeCell *)listModeCellForTableView:(UITableView *)tableView;
- (FeedCell *)feedCellForTableView:(UITableView *)tableView atIndexPath:(NSIndexPath *) indexPath;

@end
