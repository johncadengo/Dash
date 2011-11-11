//
//  JCViewController.m
//  
//
//  Created by John Cadengo on 11/10/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "JCViewController.h"

@implementation JCViewController

@synthesize delegate = _delegate;

- (id)init
{
    NSAssert(NO, @"Must initialize a JCViewController with a delegate.");
}

- (id)initWithDelegate:(id)delegate;
{
    self = [super init];
    
    if (self) {
        self.delegate = delegate;
    }
    
    return self;
}

@end
