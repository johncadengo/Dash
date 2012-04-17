//
//  LoginViewController.h
//  Dash
//
//  Created by John Cadengo on 3/1/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DashViewController;

@interface LoginViewController : UIViewController <UIGestureRecognizerDelegate>

@property (nonatomic, strong) UIButton *fbconnect;
@property (nonatomic, strong) UIButton *skip;
@property (nonatomic, strong) DashViewController *dashViewController;

- (void)setViewMovedUp:(BOOL)movedUp;
- (void)startDashing:(id) sender;
- (void)loginWithConnect:(id) sender;
- (void)showDash:(id) sender;

@end
