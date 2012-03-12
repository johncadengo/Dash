//
//  LoginViewController.h
//  Dash
//
//  Created by John Cadengo on 3/1/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoginViewController : UIViewController <UITextFieldDelegate>

@property (nonatomic, strong) UILabel *welcome;
@property (nonatomic, strong) UILabel *introduction;
@property (nonatomic, strong) UITextField *emailField;
@property (nonatomic, strong) UITextField *passwordField;
@property (nonatomic, strong) UIButton *create;
@property (nonatomic, strong) UIButton *fbconnect;
@property (nonatomic, strong) UIButton *skip;

/** For dismissing keyboard when view is tapped
 */
@property (nonatomic, strong) UITapGestureRecognizer *tap;

- (void)setViewMovedUp:(BOOL)movedUp;
- (void)loginWithConnect:(id) sender;
- (void)startDashing:(id) sender;
- (void)dismissKeyboard:(id) sender;
- (void)loginWithConnect:(id) sender;
- (void)showDash:(id) sender;

@end
