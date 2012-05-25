//
//  Badge+Helper.m
//  Dash
//
//  Created by John Cadengo on 4/10/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Badge+Helper.h"
#import "NSArray+Helpers.h"
#import "DashAPI.h"
#import "Constants.h"

@implementation Badge (Helper)

+ (NSDictionary *)badgesDictionary
{
    static dispatch_once_t pred;
    static NSDictionary *badgesDictionary = nil;
    dispatch_once(&pred, ^{
        badgesDictionary = [NSDictionary dictionaryWithKeysAndObjects:
                            [NSNumber numberWithInt:kBadgeDash],@"DashGold",
                            [NSNumber numberWithInt:kBadgeFork],@"SpoonForkKnife",
                            [NSNumber numberWithInt:kBadgeNews],@"NewspaperIcon",
                            [NSNumber numberWithInt:kBadgeLaptop],@"LaptopIcon",nil];
    });
    return badgesDictionary;
}

+ (NSDictionary *)flattenBadgesDictionary
{
    static dispatch_once_t pred;
    static NSDictionary *flattenBadgesDictionary = nil;
    dispatch_once(&pred, ^{
        flattenBadgesDictionary = [NSDictionary dictionaryWithKeysAndObjects:
                                   @"dash", [NSNumber numberWithInt:kBadgeDash],
                                   @"james beard", [NSNumber numberWithInt:kBadgeFork],
                                   @"michelin star", [NSNumber numberWithInt:kBadgeFork],
                                   @"classics", [NSNumber numberWithInt:kBadgeFork],
                                   @"zagat", [NSNumber numberWithInt:kBadgeFork],
                                   @"gayot", [NSNumber numberWithInt:kBadgeFork],
                                   @"nytimes", [NSNumber numberWithInt:kBadgeNews],
                                   @"midwest living magazine", [NSNumber numberWithInt:kBadgeNews],
                                   @"nymag", [NSNumber numberWithInt:kBadgeNews],
                                   @"timeout", [NSNumber numberWithInt:kBadgeNews],
                                   @"southern living magazine", [NSNumber numberWithInt:kBadgeNews],
                                   @"sunset magazine", [NSNumber numberWithInt:kBadgeNews],
                                   @"latimes", [NSNumber numberWithInt:kBadgeNews],
                                   @"yankee magazine", [NSNumber numberWithInt:kBadgeNews],
                                   @"baltimore magazine", [NSNumber numberWithInt:kBadgeNews],
                                   @"vegas magazine", [NSNumber numberWithInt:kBadgeNews],
                                   @"seattle metro mag", [NSNumber numberWithInt:kBadgeNews],
                                   @"philadelphia magazine", [NSNumber numberWithInt:kBadgeNews],
                                   @"boston magazine", [NSNumber numberWithInt:kBadgeNews],
                                   @"d magazine", [NSNumber numberWithInt:kBadgeNews],
                                   @"washingtonian", [NSNumber numberWithInt:kBadgeNews],
                                   @"time out la", [NSNumber numberWithInt:kBadgeNews], nil];
    });
    return flattenBadgesDictionary;
}

- (UIImage *)icon
{
    NSNumber *type = [[self.class flattenBadgesDictionary] objectForKey:self.name];
    
    if (!type) {
        // The default is blog
        type = [NSNumber numberWithInt:kBadgeLaptop];
    }
    
    NSString *filename = [[self.class badgesDictionary] objectForKey:type];

    return [UIImage imageNamed:filename];
}

- (NSComparisonResult)compare:(Badge *)other
{
    return [self.uid compare:other.uid];
}


@end
