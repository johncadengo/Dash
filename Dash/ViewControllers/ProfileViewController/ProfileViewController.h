//
//  ProfileViewController.h
//  Dash
//
//  Created by John Cadengo on 10/20/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <RestKit/RestKit.h>
#import "RecommendedPlaceViewCell.h"
#import "FBConnect.h"
#import "MBProgressHUD.h"

@class DashAPI;
@class Person;
@class ProfileHeaderCell;
@class RecommendedPlaceViewCell;
@class TitleViewCell;

// For our settings actionsheet
enum {
    kLogoutButtonIndex = 0,
    kFeedbackButtonIndex = 1,
    kCancelButtonIndex = 2,
    kNumberOfButtons = 3,
};

@interface ProfileViewController : UITableViewController <UITextFieldDelegate, UIGestureRecognizerDelegate, RKObjectLoaderDelegate, UIActionSheetDelegate, FBSessionDelegate, FBRequestDelegate, MBProgressHUDDelegate>

@property (nonatomic) BOOL showingProfileView;
@property (nonatomic, strong) Facebook *facebook;

- (void)logout;
- (void)fbDidLogout;
- (void)fbDidLogin;

#pragma mark - For when not logged in
@property (nonatomic, strong) UIButton *fbconnect;
@property (nonatomic, strong) UIImageView *backgroundView;

- (void)loadLoginView;
- (void)loginWithConnect:(id) sender;

#pragma mark - For when logged in
@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, strong) DashAPI *api;
@property (nonatomic, strong) Person *person;
@property (nonatomic, strong) NSMutableArray *recommends;
@property (nonatomic, strong) NSMutableArray *highlights;
@property (nonatomic, strong) NSMutableArray *likeHighlights;
@property (nonatomic, strong) UIBarButtonItem *settingsButton;
@property (nonatomic, strong) UIActionSheet *settingsSheet;
@property (nonatomic, strong) MBProgressHUD *hud;
@property (nonatomic, strong) UIAlertView *alertView;
@property (nonatomic) BOOL myProfile;

- (void)loadProfileView;
- (void)requestProfile;
- (void)showSettingsView:(id)sender;
- (void)newProfile:(NSNotification *)sender;

- (ProfileHeaderCell *)headerCellForTableView:(UITableView *)tableView;
- (TitleViewCell *)titleViewCellForTableView:(UITableView *)tableView section:(NSInteger)section;
- (RecommendedPlaceViewCell *)recommendCellForTableView:(UITableView *)tableView row:(NSIndexPath *)indexPath;
- (RecommendedPlaceViewCell *)highlightCellForTableView:(UITableView *)tableView row:(NSIndexPath *)indexPath;
- (RecommendedPlaceViewCell *)likeHighlightCellForTableView:(UITableView *)tableView row:(NSIndexPath *)indexPath;
- (RecommendedPlaceViewCellType)recommendedPlaceViewCellTypeForRow:(NSIndexPath *)indexPath;

@end
