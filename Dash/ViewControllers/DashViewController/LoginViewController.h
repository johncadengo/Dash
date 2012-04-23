//
//  LoginViewController.h
//  Dash
//
//  Created by John Cadengo on 3/1/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FBConnect.h"

@class DashViewController;

@interface LoginViewController : UIViewController <UIGestureRecognizerDelegate, FBSessionDelegate>

@property (nonatomic, strong) UIButton *fbconnect;
@property (nonatomic, strong) UIButton *skip;
@property (nonatomic, strong) DashViewController *dashViewController;
@property (nonatomic, strong) Facebook *facebook;

- (void)setViewMovedUp:(BOOL)movedUp;
- (void)startDashing:(id) sender;
- (void)loginWithConnect:(id) sender;
- (void)fbDidLogin;
- (void)showDash:(id) sender;


@end
