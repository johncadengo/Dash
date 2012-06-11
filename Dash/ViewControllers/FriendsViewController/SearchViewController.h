//
//  FriendsViewController.h
//  Dash
//
//  Created by John Cadengo on 10/20/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <RestKit/RestKit.h>
#import <CoreLocation/CoreLocation.h>
#import "MBProgressHUD.h"
#import "RecommendedPlaceViewCell.h"

@class DashAPI;

@interface SearchViewController : UITableViewController <UISearchDisplayDelegate, UITableViewDataSource, UITableViewDelegate, RKObjectLoaderDelegate, MBProgressHUDDelegate>

@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic, strong) DashAPI *api;
@property (nonatomic, strong) NSString *currentQuery;
@property (nonatomic, strong) MBProgressHUD *hud;
@property (nonatomic, getter = isSearching) BOOL searching;
@property (nonatomic, strong) UIAlertView *alertView;
@property (nonatomic, strong) UISearchDisplayController *searchController;
@property (nonatomic, strong) IBOutlet UISearchBar *searchBar;
@property (nonatomic, strong) UIBarButtonItem *nearbyButton;
@property (nonatomic, strong) UIBarButtonItem *mapButton;

- (void)searchNearby:(id)sender;
- (void)map:(id)sender;
- (void)clearSearchBarBackground;

/** Stores the results keyed by query. We clear these results, 
    because they act as a cache, everytime this view disappears
 */
@property (nonatomic, strong) NSMutableDictionary *resultsForAutocompleteQuery;
@property (nonatomic, strong) NSMutableDictionary *resultsForSearchQuery;

- (UITableViewCell *)tableView:(UITableView *)tableView cellForSearchQueryRow:(NSInteger)row;
- (UITableViewCell *)tableView:(UITableView *)tableView cellForAutocompleteRow:(NSInteger)row;

- (RecommendedPlaceViewCellType)recommendedPlaceViewCellTypeForRow:(NSInteger)row;

@end
