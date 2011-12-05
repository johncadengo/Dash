//
//  DashAPI.h
//  Dash
//
//  Created by John Cadengo on 10/24/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import <RestKit/RestKit.h>

#import "Person.h"
#import "Person+Helper.h"
#import "Highlight.h"
#import "Highlight+Helper.h"
#import "Comment.h"
#import "Comment+Helper.h"

#import "Photo.h"

#import "Action+Helper.h"
#import "PersonPhoto+Helper.h"
#import "PersonPhoto.h"
#import "PlacePhoto.h"

#import "Save.h"

#pragma - Enum constants
// Some defaults
enum {
    kDefaultNumFeedItems = 50,
    kDefaultNumComments = 4
};


#pragma - Class definition

@interface DashAPI : NSObject <RKRequestDelegate>

@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, weak) id <RKRequestDelegate> delegate;

-(id) initWithManagedObjectContext:(NSManagedObjectContext *)context;
-(id) initWithManagedObjectContext:(NSManagedObjectContext *)context delegate:(id)delegate;


#pragma mark - For scaffolding purposes
/** Generates a random person
 */
- (Person *)randomGhost;

/** Generates a random place
 */
- (Place *)randomCrypt;

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

/** Returns place actions associated with a specific person: saves, likes, invites, etc.
 */
- (NSMutableArray *)placeActionsForPerson:(Person *)person;

/** Returns count number of places actions associated with a specific person.
 */
- (NSMutableArray *)placeActionsForPerson:(Person *)person withCount:(NSUInteger)count;

/** Returns hightlights associated with a place.
 */
- (NSMutableArray *)highlightsForPlace:(Place *)place;

/** Returns count number of highlights associated with a place.
 */
- (NSMutableArray *)highlightsForPlace:(Place *)place withCount:(NSUInteger)count;


#pragma mark - Posts
/** Returns a newly made comment by a person on an action.
 */
- (Comment *)person:(Person *)person comments:(NSString *)text onAction:(Action *)action;

/**
 */
- (Highlight *)person:(Person *)person addsHighlight:(NSString *)text toPlace:(Place *)place withPhoto:(Photo *)photo;

/**
 */
- (Save *)person:(Person *)person savesPlace:(Place *)place;

@end
