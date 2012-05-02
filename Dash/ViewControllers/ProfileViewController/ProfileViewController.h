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

// For our settings actionsheet
enum {
    kLogoutButtonIndex = 0,
    kCancelButtonIndex = 1,
    kNumberOfButtons = 2,
};

@interface ProfileViewController : UITableViewController <UITextFieldDelegate, UIGestureRecognizerDelegate, RKObjectLoaderDelegate, UIActionSheetDelegate, FBSessionDelegate, FBRequestDelegate, MBProgressHUDDelegate>

@property (nonatomic) BOOL showingProfileView;
@property (nonatomic, strong) Facebook *facebook;

- (void)logout;
- (void)fbDidLogout;

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
@property (nonatomic, strong) UIBarButtonItem *settingsButton;
@property (nonatomic, strong) UIActionSheet *settingsSheet;
@property (nonatomic, strong) MBProgressHUD *hud;

- (void)loadProfileView;
- (void)requestProfile;
- (void)showSettingsView:(id)sender;

- (ProfileHeaderCell *)headerCellForTableView:(UITableView *)tableView;
- (RecommendedPlaceViewCell *)recommendCellForTableView:(UITableView *)tableView row:(NSInteger)row;
- (RecommendedPlaceViewCellType)recommendedPlaceViewCellTypeForRow:(NSInteger)row;

@end
