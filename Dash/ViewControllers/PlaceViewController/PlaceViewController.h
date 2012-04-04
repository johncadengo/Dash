//
//  PlaceViewController.h
//  Dash
//
//  Created by John Cadengo on 11/22/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "TISwipeableTableView.h"
#import "MoreInfoViewCell.h"

#pragma mark - Constants
/** Sections
 */
enum {
    kPlaceHeaderSection = 0,
    kPlaceBadgesSection = 1,
    kPlaceHighlightsSection = 2,
    kPlaceFootprintsSection = 3,
    kPlaceNumSections = 4
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

/** Color themes
 */
typedef enum {
    kPlaceThemeOrange = 0,
    kPlaceThemeTeal = 1,
    kPlaceThemeBlue = 2,
    kPlaceThemePink = 3
} PlaceThemeColor;

#pragma mark - Class definition

@class Place;
@class DashAPI;

@interface PlaceViewController : TISwipeableTableViewController <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) Place *place;
@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, strong) DashAPI *api;
@property (nonatomic, strong) NSMutableArray *badges;
@property (nonatomic, strong) NSMutableArray *highlights;
@property (nonatomic, strong) NSMutableArray *footprints;

@property (nonatomic, strong) MoreInfoViewCell *moreInfoCell;
@property (nonatomic) PlaceThemeColor themeColor;

/** Should only call after the view loads. Cascades appropriate changes to view properties as necessary.
 */
- (void)setThemeColor:(PlaceThemeColor) newColor;

- (CGFloat)heightForHeaderSectionCellForRow:(NSInteger)row;
- (CGFloat)heightForHighlightSectionCellForRow:(NSInteger)row;
- (CGFloat)heightForFootprintSectionCellForRow:(NSInteger)row;


- (UITableViewCell *)headerSectionCellForTableView:(UITableView *)tableView forRow:(NSInteger)row;
- (UITableViewCell *)badgesSectionCellForTableView:(UITableView *)tableView forRow:(NSInteger)row;
- (UITableViewCell *)highlightsSectionCellForTableView:(UITableView *)tableView forRow:(NSInteger)row;
- (UITableViewCell *)footprintsSectionCellForTableView:(UITableView *)tableView forRow:(NSInteger)row;

- (UITableViewCell *)headerRowForTableView:(UITableView *)tableView;
- (UITableViewCell *)moreInfoRowForTableView:(UITableView *)tableView;

/** Will toggle whether or not the back view of the more info cell is shown.
 */
- (void)toggleMoreInfo;

@end
