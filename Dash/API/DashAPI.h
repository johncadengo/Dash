//
//  DashAPI.h
//  Dash
//
//  Created by John Cadengo on 10/24/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

#pragma - Enum constants
// Some defaults
enum {
    kDefaultNumFeedItems = 25
};


#pragma - Class definition

@class Person;

@interface DashAPI : NSObject

- (void)pop:(CLLocation *)location;

/** Returns a feed of news items.
    Defaults count and person.
 */
- (NSMutableArray *)feed;

/** Returns count number of news items.
    Defaults person.
 */
- (NSMutableArray *)feedWithCount:(NSUInteger)count;

/** Returns a feed of news items for a specific person.
    Defaults count.
 */
- (NSMutableArray *)feedForPerson:(Person *)person;

/** Returns count number of news items for a specific person.
    Defaults nothing.
 */
- (NSMutableArray *)feedForPerson:(Person *)person withCount:(NSUInteger)count;

@end
