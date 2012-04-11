//
//  PlaceViewController.h
//  Dash
//
//  Created by John Cadengo on 11/22/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "MoreInfoViewCell.h"
#import "HighlightViewCell.h"

#pragma mark - Constants
/** Sections
 */
enum {
    kPlaceHeaderSection = 0,
    kPlaceBadgesSection = 1,
    kPlaceMoreInfoSection = 2,
    kPlaceHighlightsSection = 3,
    kPlaceFootprintsSection = 4,
    kPlaceNumSections = 5
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
@class TitleViewCell;

@interface PlaceViewController : UITableViewController <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) Place *place;
@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, strong) DashAPI *api;
@property (nonatomic, strong) NSMutableArray *badges;
@property (nonatomic, strong) NSMutableArray *highlights;
@property (nonatomic, strong) NSMutableArray *footprints;
@property (nonatomic, strong) MoreInfoViewCell *moreInfoCell;
@property (nonatomic) PlaceThemeColor themeColor;
@property (nonatomic, strong) IBOutlet UIToolbar *toolbar;

@property (nonatomic, strong) TitleViewCell *highlightTitle;

/** Should only call after the view loads. Cascades appropriate changes to view properties as necessary.
 */
- (void)setThemeColor:(PlaceThemeColor) newColor;

- (CGFloat)heightForHighlightSectionCellForRow:(NSInteger)row;
- (CGFloat)heightForBadgeSectionCellForRow:(NSInteger)row;
- (CGFloat)heightForFootprintSectionCellForRow:(NSInteger)row;

- (HighlightViewCellType)highlightViewCellTypeForRow:(NSInteger)row;

- (UITableViewCell *)headerSectionCellForTableView:(UITableView *)tableView forRow:(NSInteger)row;
- (UITableViewCell *)badgesSectionCellForTableView:(UITableView *)tableView forRow:(NSInteger)row;
- (UITableViewCell *)moreInfoCellForTableView:(UITableView *)tableView;
- (UITableViewCell *)highlightsSectionCellForTableView:(UITableView *)tableView forRow:(NSInteger)row;
- (UITableViewCell *)footprintsSectionCellForTableView:(UITableView *)tableView forRow:(NSInteger)row;

- (UITableViewCell *)titleViewCellForTableView:(UITableView *) tableView WithTitle:(NSString *)title;

- (void)heartTapped:(id)sender;

@end
