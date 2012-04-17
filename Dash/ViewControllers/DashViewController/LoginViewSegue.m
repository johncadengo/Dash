//
//  LoginViewSegue.m
//  Dash
//
//  Created by John Cadengo on 4/17/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "LoginViewSegue.h"
#import "LoginViewController.h"

@implementation LoginViewSegue

- (void)perform
{
    // Hook up
    LoginViewController *loginViewController = (LoginViewController *)self.destinationViewController;
    loginViewController.dashViewController = self.sourceViewController;
    
    // And make out
    [self.sourceViewController presentModalViewController:self.destinationViewController animated:NO];
}


@end
