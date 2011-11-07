//
//  FeedViewController.h
//  Dash
//
//  Created by John Cadengo on 10/20/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ActionViewCell.h"
#import "ListModeCell.h"
#import "EGORefreshTableHeaderView.h"

#pragma - Enum constants
/** There are two sections: 
    1) segemented control for list mode
    2) items in the news feed
 */
enum {
    kFeedListModeSection = 0,
    kFeedFeedItemsSection = 1,
    kFeedNumSections = 2
};

/** Only 1 row to contain the UITableViewCell which will house the segmented control
 */
enum {
    kNumRowsForListModeSection = 1
};

#pragma - Class definition

@class DashAPI;
@class ListModeCell;
@class ActionViewCell;

@interface FeedViewController : TISwipeableTableViewController <UITableViewDataSource, UITableViewDelegate,EGORefreshTableHeaderDelegate, ListModeCellDelegate, ActionVIewCellDelegate>

@property (nonatomic) ListMode listMode;
@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, strong) DashAPI *api;
@property (nonatomic, strong) NSMutableArray *feedItems;
@property (nonatomic, strong) EGORefreshTableHeaderView *refreshHeaderView;;

/** Dynamically generate the row height for feed item cells
 */
- (CGFloat)heightForFeedCellForRow:(NSInteger)row;

- (void)setListMode:(ListMode)listMode;
- (ListModeCell *)listModeCellForTableView:(UITableView *)tableView;
- (ActionViewCell *)feedCellForTableView:(UITableView *)tableView forRow:(NSInteger)row;

@end
