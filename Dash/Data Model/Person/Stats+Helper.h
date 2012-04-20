//
//  Stats+Helper.h
//  Dash
//
//  Created by John Cadengo on 3/9/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Stats.h"

// The kinds of stats we are going to display in the profile
typedef enum {
    kFavoritesStat = 0,
    kFollowersStat = 1,
    kFollowingStat = 2,
    kNumStatsTypes = 3
} StatsTypes;

@interface Stats (Helper)

/** TODO: There's gotta be a better way to do this. 
 *  Give it a type: save, recommend, highlight
 *  And will return its name
 */
+ (NSString *)nameForType:(NSNumber *)type;

/** Give it a type: save, recommend, highlight
 *  And will return a string describing it: 
 *  For example: "Highlights: 5"
 */
- (NSString *)descriptionForType:(NSNumber *)type;

@end
