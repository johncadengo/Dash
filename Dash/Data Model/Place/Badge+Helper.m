//
//  Badge+Helper.m
//  Dash
//
//  Created by John Cadengo on 4/10/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Badge+Helper.h"
#import "NSArray+Helpers.h"

@implementation Badge (Helper)

- (UIImage *)icon
{
    // TODO: Pick icon based on what badge it is.
    NSArray *icons = [NSArray arrayWithObjects:[UIImage imageNamed:@"DashGold.png"],
                      [UIImage imageNamed:@"LaptopIcon.png"], 
                      [UIImage imageNamed:@"NewspaperIcon.png"],
                      [UIImage imageNamed:@"SpoonForkKnife.png"],
                      [UIImage imageNamed:@"TVIcon.png"], nil];

    return [icons randomObject];
}

@end
