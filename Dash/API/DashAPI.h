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
#import <RestKit/CoreData/CoreData.h>

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

@interface DashAPI : NSObject <RKObjectLoaderDelegate>

@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, weak) id <RKObjectLoaderDelegate> delegate;

-(id) initWithManagedObjectContext:(NSManagedObjectContext *)context;
-(id) initWithManagedObjectContext:(NSManagedObjectContext *)context delegate:(id)delegate;

#pragma mark - Mappings
/**
 */
+ (RKManagedObjectMapping *)placeMapping;

#pragma mark - For scaffolding purposes
/** Generates a random person
 */
- (Person *)randomGhost;

/** Generates a random place
 */
- (Place *)randomCrypt;

#pragma mark - Key
/** Generates the key
 */
- (NSString *)key;

#pragma mark - Gets
/** Returns a pop for that location.
 */
- (void)pop:(CLLocation *)location;

/** Returns a feed of news items nearby.
    Defaults count and person.
 */
- (NSMutableArray *)feedForLocation:(CLLocation *)location;

/** Returns count number of news items nearby.
    Defaults person.
 */
//- (NSMutableArray *)feedForLocation:(CLLocation *)location WithCount:(NSUInteger)count;

/** Returns a feed of news items for a specific person.
    Defaults count.
 */
- (NSMutableArray *)feedForPerson:(Person *)person;

/** Returns count number of news items for a specific person.
    Defaults nothing.
 */
- (void)feedForPerson:(Person *)person withCount:(NSUInteger)count;

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


/** Sends a request to autocomplete a query string for a place
 *  Returns a list of suggested names for places
 */
- (RKRequest *)autocomplete:(NSString *)query;

/** Senda a request to query a string for a place and 
 *  unlike autocomplete, it returns places with details
 */
- (RKObjectLoader *)search:(NSString *)query;

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
