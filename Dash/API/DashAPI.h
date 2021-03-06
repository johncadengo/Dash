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
#import "Stats+Helper.h"
#import "Highlight.h"
#import "Highlight+Helper.h"
#import "Comment.h"
#import "Comment+Helper.h"
#import "Photo.h"
#import "Action+Helper.h"
#import "Badge.h"

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

@interface DashAPI : NSObject

@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, weak) id <RKObjectLoaderDelegate> delegate;

-(id) initWithManagedObjectContext:(NSManagedObjectContext *)context;
-(id) initWithManagedObjectContext:(NSManagedObjectContext *)context delegate:(id)delegate;

#pragma mark - Mappings
/**
 */
+ (RKManagedObjectMapping *)placeMapping;

+ (BOOL)skipLogin;
+ (void)setLoggedIn:(BOOL)newValue;
+ (BOOL)loggedIn;
+ (void)setSkipLogin:(BOOL)newValue;
+ (BOOL)shouldRefreshFavorites;
+ (void)setShouldRefreshFavorites:(BOOL)newValue;
+ (BOOL)shouldRefreshProfile;
+ (void)setShouldRefreshProfile:(BOOL)newValue;
+ (Person *)me;
+ (void)setMe:(Person *)newMe;
+ (void)updateLastPop;
+ (NSDate *)lastPop;
+ (void)setCurPage:(NSInteger)newValue;
+ (void)incrementCurPage;
+ (void)resetCurPage;
+ (NSInteger)curPage;
+ (NSString *)uuid;

#pragma mark - Key
/** Generates the key
 */
- (NSString *)key;

/* GETS */

#pragma mark - Pop

/** Returns a pop for that location.
 */
- (void)pop:(CLLocation *)location;

/** Pop with filters.
 */
- (void)pop:(NSString *)loc types:(NSString *)types prices:(NSString *)prices distance:(NSString *)distance;

/** Pop with page.
 */
- (void)pop:(NSString *)loc types:(NSString *)types prices:(NSString *)prices distance:(NSString *)distance page:(NSInteger)page;

#pragma mark - Feed

- (void)feedForPerson:(Person *)person near:(CLLocation *)location;

#pragma mark - Place actions
// These are located inside of the Places tab: saves, recommends, and more to be added later.

/** Requests the recommends that a person has made.
 */
- (void)recommendsForPerson:(Person *) person;

/** Requests count number of the recommends that a person has made.
 */
- (void)recommendsForPerson:(Person *) person withCount:(NSUInteger)count;

- (void)highlightsForPerson:(Person *) person;
- (void)likeHighlightsForPerson:(Person *) person;
- (void)highlightsForPerson:(Person *) person withCount:(NSUInteger)count;
- (void)likeHighlightsForPerson:(Person *) person withCount:(NSUInteger)count;

#pragma mark - 

- (void)placeByID:(NSNumber *)uid;

#pragma mark - 

/** Sends a request to autocomplete a query string for a place
 *  Returns a list of suggested names for places
 */
- (void)autocomplete:(NSString *)query;

/** Sends a request to query a string for a place and
 *  unlike autocomplete, it returns places with details
 */
- (void)search:(NSString *)query;

/** Orders search request by proximity to given location.
 */
- (void)search:(NSString *)query near:(CLLocation *)location;

#pragma mark -

/** Uploads the person to our database backend.
 */
- (void)createPerson:(Person *)person;

/** Must be logged in for this to work.
 */
- (void)thumbsUpPlace:(Place *)place;
- (void)thumbsDownPlace:(Place *)place;

- (void)createHighlight:(NSString *)text atPlace:(Place *)place;
- (void)likeHighlight:(Highlight *)highlight;


#pragma mark - 

/** Gets the profile for the person who is currently logged in
 */
- (void)myProfile;


/** Get the profile for a person
 */
- (void)profileForPerson:(Person *)person;

- (void)cancelRequests;

@end
