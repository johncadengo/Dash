//
//  PlacesViewController.h
//  Dash
//
//  Created by John Cadengo on 10/20/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <RestKit/RestKit.h>
#import "MBProgressHUD.h"
#import "RecommendedPlaceViewCell.h"
#import "EGORefreshTableHeaderView.h"

/** There is only one section.
 */
enum {
    kPlaceListSection = 0,
    kNumSections = 1
};

@class DashAPI;

@interface RecommendedPlacesViewController : UITableViewController <UITableViewDataSource, UITableViewDelegate, RKObjectLoaderDelegate, MBProgressHUDDelegate, EGORefreshTableHeaderDelegate>

@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, strong) DashAPI *api;
@property (nonatomic, strong) EGORefreshTableHeaderView *refreshHeaderView;
@property (nonatomic, strong) MBProgressHUD *hud;

/** The requests stored according to type: saves, recommends, etc.
 */
@property (nonatomic, strong) NSDictionary *requests;

// We want to be able to filter through the feed items 
// so will have different arrays for each type
@property (nonatomic, strong) NSMutableArray *feedItems;
@property (nonatomic, strong) NSMutableArray *recommended;
@property (nonatomic, strong) NSMutableArray *saved;

/** Dynamically generate the row height for feed item cells
 */
- (CGFloat)heightForFeedCellForRow:(NSInteger)row;

- (void)refreshFeed;

@end
