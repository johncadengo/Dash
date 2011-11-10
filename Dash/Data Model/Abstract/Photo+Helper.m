//
//  Photo+Helper.m
//  Dash
//
//  Created by John Cadengo on 11/8/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "Photo+Helper.h"
#import "NSArray+Helpers.h"

@implementation Photo (Helper)

- (NSString *)localpath {
    NSArray *photos = [NSArray arrayWithObjects:@"icon.png", @"Dash.png", @"DashApp.png", nil];
    
    return [NSString stringWithFormat:[photos randomObject]];
}


@end
