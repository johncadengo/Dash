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
    kDefaultNumFeedItems = 100
};


#pragma - Class definition

@class Person;

@interface DashAPI : NSObject

@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;

-(id) initWithManagedObjectContext:(NSManagedObjectContext *)context;

- (void)pop:(CLLocation *)location;

/** Returns a feed of news items nearby.
    Defaults count and person.
 */
- (NSMutableArray *)feedForLocation:(CLLocation *)location;

/** Returns count number of news items nearby.
    Defaults person.
 */
- (NSMutableArray *)feedForLocation:(CLLocation *)location WithCount:(NSUInteger)count;

/** Returns a feed of news items for a specific person.
    Defaults count.
 */
- (NSMutableArray *)feedForPerson:(Person *)person;

/** Returns count number of news items for a specific person.
    Defaults nothing.
 */
- (NSMutableArray *)feedForPerson:(Person *)person withCount:(NSUInteger)count;

@end
