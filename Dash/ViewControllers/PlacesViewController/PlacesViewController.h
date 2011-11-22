//
//  PlacesViewController.h
//  Dash
//
//  Created by John Cadengo on 10/20/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "PlaceViewCell.h"
#import "EGORefreshTableHeaderView.h"

/** There is only one section.
 */
enum {
    kPlaceListSection = 0,
    kNumSections = 1
};

@class DashAPI;
@class PlaceViewCell;

@interface PlacesViewController : TISwipeableTableViewController <UITableViewDataSource, UITableViewDelegate,EGORefreshTableHeaderDelegate, PlaceViewCellDelegate>

@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, strong) DashAPI *api;
@property (nonatomic, strong) EGORefreshTableHeaderView *refreshHeaderView;
@property (nonatomic, strong) NSMutableArray *feedItems;

/** Dynamically generate the row height for feed item cells
 */
- (CGFloat)heightForFeedCellForRow:(NSInteger)row;

@end
