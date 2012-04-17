//
//  LoginViewSegue.m
//  Dash
//
//  Created by John Cadengo on 4/17/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "LoginViewSegue.h"

@implementation LoginViewSegue

- (void)perform
{
    [self.sourceViewController presentModalViewController:self.destinationViewController animated:NO];
}


@end
