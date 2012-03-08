//
//  ProfileViewController.h
//  Dash
//
//  Created by John Cadengo on 10/20/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProfileViewController : UITableViewController

@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;

#pragma mark - For when not logged in
@property (nonatomic, strong) UILabel *introduction;
@property (nonatomic, strong) UIButton *fbconnect;
@property (nonatomic, strong) UIButton *start;

- (void)loginWithConnect:(id) sender;
- (void)startDashing:(id) sender;

@end
