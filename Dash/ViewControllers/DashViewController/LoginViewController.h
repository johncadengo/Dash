//
//  LoginViewController.h
//  Dash
//
//  Created by John Cadengo on 3/1/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoginViewController : UIViewController

@property (nonatomic, strong) UILabel *welcome;
@property (nonatomic, strong) UILabel *introduction;
@property (nonatomic, strong) UIButton *fbconnect;
@property (nonatomic, strong) UIButton *skip;


- (void)loginWithConnect:(id) sender;
- (void)showDash:(id) sender;

@end
