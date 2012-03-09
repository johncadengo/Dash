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
#import "Stats.h"
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
#import "Recommend.h"

#pragma - Enum constants
// Some defaults
enum {
    kDefaultNumFeedItems = 50,
    kDefaultNumComments = 4
};

typedef enum {
    kPop,
    kFeed,
    kHighlights,
    kAutocomplete,
    KSearch,
    kSaves,
    kRecommends,
    kProfile,
    kNumDashAPIRequestTypes
} DashAPIRequestType;

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

+ (BOOL)skipLogin;
+ (BOOL)loggedIn;
+ (void)setLoggedIn:(BOOL)newValue;
+ (void)setSkipLogin:(BOOL)newValue;

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

/* GETS */

#pragma mark - Pop

/** Returns a pop for that location.
 */
- (void)pop:(CLLocation *)location;

#pragma mark - Feed

/** Returns a feed of news items nearby.
    Defaults count and person.
 */
- (void)feedForLocation:(CLLocation *)location;

/** Returns count number of news items nearby.
    Defaults person.
 */
- (void)feedForLocation:(CLLocation *)location WithCount:(NSUInteger)count;

/** Returns a feed of news items for a specific person.
    Defaults count.
 */
- (void)feedForPerson:(Person *)person;

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

#pragma mark - Place actions
// These are located inside of the Places tab: saves, recommends, and more to be added later.

/** Requests the saves that a person has made.
 */ 
- (void)savesForPerson:(Person *)person;

/** Requests count number of the saves that a person has made.
 */
- (void)savesForPerson:(Person *)person withCount:(NSUInteger)count;

/** Requests the recommends that a person has made.
 */
- (void)recommendsForPerson:(Person *) person;

/** Requests count number of the recommends that a person has made.
 */
- (void)recommendsForPerson:(Person *) person withCount:(NSUInteger)count;

/** Makes a request for all place actions associated with a specific person: saves, likes, invites, etc.
 
    Returns a dictionary of the RKObjectLoaders corresponding to each request made.
 */
- (NSDictionary *)placeActionsForPerson:(Person *)person;

/** Returns count number of all thee places actions associated with a specific person.

    Returns a dictionary of the RKObjectLoaders corresponding to each request made.
 */
- (NSDictionary *)placeActionsForPerson:(Person *)person withCount:(NSUInteger)count;


#pragma mark - 

/** Returns hightlights associated with a place.
 */
- (NSMutableArray *)highlightsForPlace:(Place *)place;

/** Returns count number of highlights associated with a place.
 */
- (NSMutableArray *)highlightsForPlace:(Place *)place withCount:(NSUInteger)count;


/** Sends a request to autocomplete a query string for a place
 *  Returns a list of suggested names for places
 */
- (void)autocomplete:(NSString *)query;

/** Sends a request to query a string for a place and 
 *  unlike autocomplete, it returns places with details
 */
- (void)search:(NSString *)query;

#pragma mark - 

/** Gets the profile for the person who is currently logged in
 */
- (void)myProfile;


/** Get the profile for a person
 */
- (void)profileForPerson:(Person *)person;

/* POSTS */

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
