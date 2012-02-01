//
//  FriendsViewController.h
//  Dash
//
//  Created by John Cadengo on 10/20/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <RestKit/RestKit.h>
#import "MBProgressHUD.h"

@class DashAPI;

@interface SearchViewController : UITableViewController <UISearchDisplayDelegate, UITableViewDataSource, UITableViewDelegate, RKObjectLoaderDelegate>

@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, strong) DashAPI *api;
@property (nonatomic, strong) NSString *currentQuery;

/** Stores the results keyed by query. We clear these results, 
    because they act as a cache, everytime this view disappears
 */
@property (nonatomic, strong) NSMutableDictionary *resultsForQuery;

@end
