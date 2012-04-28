//
//  PlaceViewController.h
//  Dash
//
//  Created by John Cadengo on 11/22/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "MoreInfoViewCell.h"
#import "HighlightViewCell.h"
#import <RestKit/RestKit.h>

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

@interface PlaceViewController : UITableViewController <UITableViewDataSource, UITableViewDelegate, RKObjectLoaderDelegate, RKRequestDelegate>

@property (nonatomic, strong) Place *place;
@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, strong) DashAPI *api;
@property (nonatomic, strong) NSMutableArray *badges;
@property (nonatomic, strong) NSMutableArray *highlights;
@property (nonatomic, strong) NSMutableArray *footprints;
@property (nonatomic) PlaceThemeColor themeColor;
@property (nonatomic, strong) TitleViewCell *highlightTitle;
@property (nonatomic, strong) MoreInfoViewCell *moreInfoCell;
@property (nonatomic) BOOL moreInfoOpen;
@property (nonatomic, strong) UIToolbar *toolbar;
@property (nonatomic, strong) UIBarButtonItem *createHighlightButton;
@property (nonatomic, strong) UIBarButtonItem *thumbsUpButton;
@property (nonatomic, strong) UIBarButtonItem *thumbsDownButton;
@property (nonatomic, strong) UIButton *upButton;
@property (nonatomic, strong) UIButton *downButton;
@property (nonatomic, strong) UILabel *upLabel;
@property (nonatomic, strong) UILabel *downLabel;
@property (nonatomic, strong) UIAlertView *alertView;

/** Should only call after the view loads. Cascades appropriate changes to view properties as necessary.
 */
- (void)setThemeColor:(PlaceThemeColor) newColor;

- (CGFloat)heightForHighlightSectionCellForRow:(NSInteger)row;
- (CGFloat)heightForBadgeSectionCellForRow:(NSInteger)row;
- (CGFloat)heightForFootprintSectionCellForRow:(NSInteger)row;
- (CGFloat)heightForMoreInforSection;

- (HighlightViewCellType)highlightViewCellTypeForRow:(NSInteger)row;

- (UITableViewCell *)headerSectionCellForTableView:(UITableView *)tableView forRow:(NSInteger)row;
- (UITableViewCell *)badgesSectionCellForTableView:(UITableView *)tableView forRow:(NSInteger)row;
- (UITableViewCell *)moreInfoCellForTableView:(UITableView *)tableView;
- (UITableViewCell *)highlightsSectionCellForTableView:(UITableView *)tableView forRow:(NSInteger)row;
- (UITableViewCell *)footprintsSectionCellForTableView:(UITableView *)tableView forRow:(NSInteger)row;

- (UITableViewCell *)titleViewCellForTableView:(UITableView *)tableView WithTitle:(NSString *)title;
- (UITableViewCell *)createHighlightViewCellForTableView:(UITableView *)tableView;

- (void)heartTapped:(id)sender;
- (void)toggleMoreInfo;

- (void)createHighlight:(id)sender;
- (void)thumbsUp:(id)sender;
- (void)thumbsDown:(id)sender;

- (void)refresh;

@end
