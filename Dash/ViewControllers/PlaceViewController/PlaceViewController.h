//
//  PlaceViewController.h
//  Dash
//
//  Created by John Cadengo on 11/22/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "TISwipeableTableView.h"

#pragma mark - Constants
/** Sections
 */
enum {
    kPlaceHeaderSection = 0,
    kPlaceHighlightsSection = 1,
    kPlaceFootprintsSection = 2,
    kPlaceNumSections = 3
};

/** Number of rows.
    The rest are dynamic.
 */
enum {
    kPlaceNumRowsForHeaderSection = 2   // The place and more info.
};

/** Rows.
 */
enum {
    kPlaceHeaderRow = 0,
    kPlaceMoreInfoRow = 1
};

#pragma mark - Class definition

@class Place;
@class DashAPI;
@class JCImageGalleryViewController;

@interface PlaceViewController : TISwipeableTableViewController

@property (nonatomic, strong) Place *place;
@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, strong) DashAPI *api;
@property (nonatomic, strong) NSMutableArray *highlights;
@property (nonatomic, strong) NSMutableArray *footprints;
@property (nonatomic, strong) JCImageGalleryViewController *imageGalleryViewController;

- (CGFloat)heightForHeaderSectionCellForRow:(NSInteger)row;

- (UITableViewCell *)headerSectionCellForTableView:(UITableView *)tableView forRow:(NSInteger)row;
- (UITableViewCell *)headerRowForTableView:(UITableView *)tableView;
- (UITableViewCell *)moreInfoRowForTableView:(UITableView *)tableView;

@end
