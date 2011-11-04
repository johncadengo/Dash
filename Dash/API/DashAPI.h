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
    kDefaultNumFeedItems = 50,
    kDefaultNumComments = 3
};


#pragma - Class definition

@class Person;
@class Highlight;
@class Place;
@class Photo;

@interface DashAPI : NSObject

@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;

-(id) initWithManagedObjectContext:(NSManagedObjectContext *)context;

#pragma mark - Gets
/** Returns a pop for that location.
    TODO: Figure this out.
 */
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

/** Returns an array of comments for a particular highlight.
    Defaults count.
 */
- (NSMutableArray *)commentsForHighlight:(Highlight *)highlight;

/** Returns an array with count number of comments for a particular highlight.
 */
- (NSMutableArray *)commentsForHighlight:(Highlight *)highlight withCount:(NSUInteger)count;

#pragma mark - Posts
/**
 */
- (void)person:(Person*)person comments:(NSString *)text onHighlight:(Highlight *)highlight;

/**
 */
- (void)person:(Person *)person addsHighlight:(NSString *)text toPlace:(Place *) withPhoto:(Photo *) photo;

@end
