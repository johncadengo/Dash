//
//  FeedViewController.h
//  Dash
//
//  Created by John Cadengo on 10/20/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <RestKit/RestKit.h>
#import <CoreLocation/CoreLocation.h>
#import "MBProgressHUD.h"
#import "NewsItemViewCell.h"
#import "EGORefreshTableHeaderView.h"

#pragma - Class definition

@class DashAPI;
@class NewsItemViewCell;
@class CustomSegmentView;

@interface FeedViewController : UITableViewController <UITableViewDataSource, UITableViewDelegate,EGORefreshTableHeaderDelegate, MBProgressHUDDelegate, RKObjectLoaderDelegate, CLLocationManagerDelegate>

@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic, strong) DashAPI *api;
@property (nonatomic, strong) NSMutableArray *feedItems;
@property (nonatomic, strong) EGORefreshTableHeaderView *refreshHeaderView;
@property (nonatomic, strong) MBProgressHUD *hud;

@property (nonatomic, strong) CustomSegmentView *customSegmentView;
@property (nonatomic, strong) UIImageView *backgroundBubble;

/** Want to be able to display recommending a place, liking a highlight, or adding a highlight.
 *  Also, if a friend has joined dash.
 */

- (void)refreshFeed;

@end
