//
//  LoginViewController.h
//  Dash
//
//  Created by John Cadengo on 3/1/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoginViewController : UIViewController <UIGestureRecognizerDelegate>

@property (nonatomic, strong) UIButton *fbconnect;
@property (nonatomic, strong) UIButton *skip;

- (void)setViewMovedUp:(BOOL)movedUp;
- (void)startDashing:(id) sender;
- (void)loginWithConnect:(id) sender;
- (void)showDash:(id) sender;

@end
