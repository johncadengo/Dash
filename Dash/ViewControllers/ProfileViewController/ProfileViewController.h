//
//  ProfileViewController.h
//  Dash
//
//  Created by John Cadengo on 10/20/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <RestKit/RestKit.h>

@class DashAPI;
@class Person;

// The kinds of stats we are going to display in the profile
typedef enum {
    kSavesStat = 0,
    kRecommendsStat = 1,
    kHightlightsStat = 2,
    kNumStatsTypes = 3
} StatsTypes;

@interface ProfileViewController : UITableViewController <UITextFieldDelegate, RKObjectLoaderDelegate>

@property (nonatomic) BOOL showingProfileView;

#pragma mark - For when not logged in
@property (nonatomic, strong) UILabel *introduction;
@property (nonatomic, strong) UIButton *fbconnect;
@property (nonatomic, strong) UIButton *start;
@property (nonatomic, strong) UITextField *emailField;
@property (nonatomic, strong) UITextField *passwordField;

- (void)loadLoginView;
- (void)setViewMovedUp:(BOOL)movedUp;
- (void)loginWithConnect:(id) sender;
- (void)startDashing:(id) sender;

#pragma mark - For when logged in
@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, strong) DashAPI *api;
@property (nonatomic, strong) Person *person;
@property (nonatomic, strong) NSMutableArray *stats;

- (void)loadProfileView;
- (void)requestProfile;

@end
