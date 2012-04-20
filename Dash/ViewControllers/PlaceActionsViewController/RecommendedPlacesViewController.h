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

@class DashAPI;

@interface RecommendedPlacesViewController : UITableViewController <UITableViewDataSource, UITableViewDelegate, RKObjectLoaderDelegate, MBProgressHUDDelegate>

@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, strong) DashAPI *api;
@property (nonatomic, strong) MBProgressHUD *hud;

// We want to be able to filter through the feed items 
// so will have different arrays for each type
@property (nonatomic, strong) NSMutableArray *feedItems;

- (RecommendedPlaceViewCellType)recommendedPlaceViewCellTypeForRow:(NSInteger)row;
- (void)refreshFeed;

@end
