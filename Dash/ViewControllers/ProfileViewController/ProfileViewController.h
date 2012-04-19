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

@interface ProfileViewController : UITableViewController <UITextFieldDelegate, UIGestureRecognizerDelegate, RKObjectLoaderDelegate>

@property (nonatomic) BOOL showingProfileView;

#pragma mark - For when not logged in
@property (nonatomic, strong) UIButton *fbconnect;

- (void)loadLoginView;
- (void)loginWithConnect:(id) sender;

#pragma mark - For when logged in
@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, strong) DashAPI *api;
@property (nonatomic, strong) Person *person;
@property (nonatomic, strong) NSMutableArray *stats;

- (void)loadProfileView;
- (void)requestProfile;

@end
