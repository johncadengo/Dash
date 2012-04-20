//
//  Stats+Helper.m
//  Dash
//
//  Created by John Cadengo on 3/9/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Stats+Helper.h"

static NSDictionary *types = nil;

@implementation Stats (Helper)

+ (NSString *)nameForType:(NSNumber *)type
{
    if (!types) {
        types = [[NSDictionary alloc] initWithObjectsAndKeys:
                 @"Saves:", [NSNumber numberWithInt:kFavoritesStat],
                 @"Recommends:", [NSNumber numberWithInt:kFollowersStat],
                 @"Highlights:", [NSNumber numberWithInt:kFollowingStat],
                 nil];
    }
    
    // TODO: Check if type is inside types?
    return [types objectForKey:type];
}

- (NSString *)descriptionForType:(NSNumber *)type
{
    NSString *typeName = [[self class] nameForType:type];
    
    NSNumber *stat;
    
    switch ([type intValue]) {
        case kFavoritesStat:
            stat = self.favorites;
            break;
        case kFollowersStat:
            stat = self.followers;
            break;
        case kFollowingStat:
            stat = self.following;
            break;
        default:
            // Should never happen
            stat = [NSNumber numberWithInt:0];
            break;
    }
    
    return [NSString stringWithFormat:@"%@ %@", typeName, stat];
}

@end
