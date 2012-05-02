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
#import "FBConnect.h"

@class DashAPI;

@interface RecommendedPlacesViewController : UITableViewController <UITableViewDataSource, UITableViewDelegate, RKObjectLoaderDelegate, MBProgressHUDDelegate, FBSessionDelegate, FBRequestDelegate>

@property (nonatomic) BOOL showingFavoritesView;
@property (nonatomic, strong) Facebook *facebook;

#pragma mark - For when not logged in
@property (nonatomic, strong) UIButton *fbconnect;
@property (nonatomic, strong) UIImageView *backgroundView;

- (void)loadLoginView;
- (void)loginWithConnect:(id) sender;

#pragma mark - For when logged in

@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, strong) DashAPI *api;
@property (nonatomic, strong) MBProgressHUD *hud;

// We want to be able to filter through the feed items 
// so will have different arrays for each type
@property (nonatomic, strong) NSMutableArray *feedItems;

- (void)loadFavoritesView;
- (RecommendedPlaceViewCellType)recommendedPlaceViewCellTypeForRow:(NSInteger)row;
- (void)refreshFeed;
- (void)fbDidLogin;

@end
