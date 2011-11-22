//
//  PlacesViewController.h
//  Dash
//
//  Created by John Cadengo on 10/20/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "PlaceActionViewCell.h"
#import "EGORefreshTableHeaderView.h"

/** There is only one section.
 */
enum {
    kPlaceListSection = 0,
    kNumSections = 1
};

@class DashAPI;
@class PlaceActionViewCell;

@interface PlaceActionsViewController : TISwipeableTableViewController <UITableViewDataSource, UITableViewDelegate,EGORefreshTableHeaderDelegate, PlaceActionViewCellDelegate>

@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, strong) DashAPI *api;
@property (nonatomic, strong) EGORefreshTableHeaderView *refreshHeaderView;
@property (nonatomic, strong) NSMutableArray *feedItems;

/** Dynamically generate the row height for feed item cells
 */
- (CGFloat)heightForFeedCellForRow:(NSInteger)row;

- (void)refreshFeed;

@end
