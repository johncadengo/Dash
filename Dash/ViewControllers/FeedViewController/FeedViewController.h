//
//  FeedViewController.h
//  Dash
//
//  Created by John Cadengo on 10/20/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FeedItemCell.h"
#import "ListModeCell.h"

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
@class FeedItemCell;

@interface FeedViewController : TISwipeableTableViewController <UITableViewDataSource, UITableViewDelegate, ListModeCellDelegate, FeedCellDelegate>

@property (nonatomic) ListMode listMode;
@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, strong) DashAPI *api;
@property (nonatomic, strong) NSMutableArray *feedItems;

- (CGFloat)heightForFeedCellForRow:(NSInteger)row;

- (void)setListMode:(ListMode)listMode;
- (ListModeCell *)listModeCellForTableView:(UITableView *)tableView;
- (FeedItemCell *)feedCellForTableView:(UITableView *)tableView forRow:(NSInteger)row;

@end
