//
//  ProfileViewController.h
//  Dash
//
//  Created by John Cadengo on 10/20/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProfileViewController : UITableViewController <UITextFieldDelegate>

@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;

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

- (void)loadProfileView;

@end
