//
//  DashAPI.m
//  Dash
//
//  Created by John Cadengo on 10/24/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "DashAPI.h"

#import "NSArray+Helpers.h"
#import "NSString+RandomStrings.h"
#import "NSDate+RandomDates.h"
#import "Place.h"
#import "Place+Helper.h"
#import "TestFlight.h"
#import "Appirater.h"

// Private properties
@interface DashAPI ()

@end

// Static class variables
// Taken from: http://stackoverflow.com/a/1250088/693754
static BOOL _skipLogin = NO;
static BOOL _loggedIn = NO;
static BOOL _shouldRefreshFavorites = NO;
static BOOL _shouldRefreshProfile = NO;
static Person *_me = nil;
static NSInteger _curPage = 0;
static NSDate *_lastPop = nil;

@implementation DashAPI

@synthesize managedObjectContext = __managedObjectContext;
@synthesize delegate = _delegate;

NSString * const kKey = @"KAEMyqRkVRgShNWGZW73u2Fk";

#pragma mark - Mappings
+ (RKManagedObjectMapping *)placeMapping 
{
    // Define our category mapping
    RKManagedObjectMapping *categoryMapping = [RKManagedObjectMapping mappingForEntityWithName:@"Category"];
    [categoryMapping mapKeyPath:@"id" toAttribute:@"uid"];
    [categoryMapping mapAttributes:@"name", nil];
    
    // Define our author mapping for highlights
    RKManagedObjectMapping *authorMapping = [RKManagedObjectMapping mappingForEntityWithName:@"Person"];
    [authorMapping mapKeyPath:@"id" toAttribute:@"uid"];
    [authorMapping mapAttributes:@"name", @"fb_uid", nil];
    
    // Define our highlight mapping, which has a relationship with author
    RKManagedObjectMapping *highlightMapping = [RKManagedObjectMapping mappingForEntityWithName:@"Highlight"];
    [highlightMapping mapKeyPath:@"id" toAttribute:@"uid"];
    [highlightMapping mapKeyPath:@"name" toAttribute:@"text"];
    [highlightMapping mapKeyPath:@"likecount" toAttribute:@"likecount"];
    
    // Define the relationship mapping between highlight and author
    [highlightMapping mapKeyPath:@"author" toRelationship:@"author" withMapping:authorMapping];
    [highlightMapping mapKeyPath:@"likes" toRelationship:@"likes" withMapping:authorMapping];
    
    // Define the location mapping
    RKManagedObjectMapping *locationMapping = [RKManagedObjectMapping mappingForEntityWithName:@"PlaceLocation"];
    [locationMapping mapKeyPath:@"lat" toAttribute:@"latitude"];
    [locationMapping mapKeyPath:@"lng" toAttribute:@"longitude"];
    
    // Define the badge mapping
    RKManagedObjectMapping *badgeMapping = [RKManagedObjectMapping mappingForEntityWithName:@"Badge"];
    [badgeMapping mapKeyPath:@"id" toAttribute:@"uid"];
    [badgeMapping mapAttributes:@"name", nil];
    
    // Define the hours mapping
    RKManagedObjectMapping *hoursMapping = [RKManagedObjectMapping mappingForEntityWithName:@"Hours"];
    [hoursMapping mapKeyPath:@"id" toAttribute:@"uid"];
    [hoursMapping mapAttributes:@"days", @"open", @"close", nil];
    
    // Define our place mapping, which also has 
    // a relationship with category, highlight, and location
    RKManagedObjectMapping *placeMapping = [RKManagedObjectMapping mappingForEntityWithName:@"Place"];
    [placeMapping mapKeyPath:@"id" toAttribute:@"uid"];
    [placeMapping mapKeyPath:@"up" toAttribute:@"thumbsupcount"];
    [placeMapping mapKeyPath:@"down" toAttribute:@"thumbsdowncount"];
    [placeMapping mapAttributes:@"name", @"address", @"phone", @"price", @"rating", @"num_ratings", nil];
    
    // Define the relationship mappings between place and category, highlight, location
    [placeMapping mapKeyPath:@"categories" toRelationship:@"categories" withMapping:categoryMapping];
    [placeMapping mapKeyPath:@"highlights" toRelationship:@"highlights" withMapping:highlightMapping];
    [placeMapping mapKeyPath:@"location" toRelationship:@"location" withMapping:locationMapping];
    [placeMapping mapKeyPath:@"badges" toRelationship:@"badges" withMapping:badgeMapping];
    [placeMapping mapKeyPath:@"recommends" toRelationship:@"recommends" withMapping:authorMapping];
    [placeMapping mapKeyPath:@"saves" toRelationship:@"saves" withMapping:authorMapping];
    [placeMapping mapKeyPath:@"hours" toRelationship:@"hours" withMapping:hoursMapping];
    
    return placeMapping;
}

#pragma mark - Class variables
+ (BOOL)skipLogin
{
    return _skipLogin;
}

+ (void)setSkipLogin:(BOOL)newValue
{
    _skipLogin = newValue;
}

+ (BOOL)loggedIn
{
    return _loggedIn;
}

+ (void)setLoggedIn:(BOOL)newValue
{
    _loggedIn = newValue;
    
    // Cascades
    if (newValue) {
        [self setSkipLogin:YES];
        [self setShouldRefreshProfile:YES];
        [self setShouldRefreshFavorites:YES];
        
        [TestFlight passCheckpoint:@"Logged into Facebook"];
    }
    else {
        // If we log out, refresh favorites
        [self setShouldRefreshFavorites:YES];
        
        [TestFlight passCheckpoint:@"Logged out of Facebook"];
    }
}

+ (BOOL)shouldRefreshFavorites
{
    return _shouldRefreshFavorites;
}

+ (void)setShouldRefreshFavorites:(BOOL)newValue
{
    _shouldRefreshFavorites = newValue;
}

+ (BOOL)shouldRefreshProfile
{
    return _shouldRefreshProfile;
}

+ (void)setShouldRefreshProfile:(BOOL)newValue
{
    _shouldRefreshProfile = newValue;
}

+ (Person *)me
{
    return _me;
}

+ (void)setMe:(Person *)newMe
{
    _me = newMe;
}

+ (void)updateLastPop
{
    _lastPop = [NSDate date];
}

+ (NSDate *)lastPop
{
    return _lastPop;
}

+ (void)setCurPage:(NSInteger)newValue
{
    _curPage = newValue;
}

+ (void)incrementCurPage
{
    ++_curPage;
}

+ (void)resetCurPage
{
    _curPage = 0;
}

+ (NSInteger)curPage
{
    return _curPage;
}

+ (NSString *)uuid
{
    static dispatch_once_t pred;
    static NSString *uuidString = nil;
    dispatch_once(&pred, ^{
        // Taken from: http://www.tuaw.com/2011/08/21/dev-juice-help-me-generate-unique-identifiers/
        CFUUIDRef theUUID = CFUUIDCreate(NULL);
        uuidString = 
            (__bridge_transfer NSString *)
            CFUUIDCreateString(NULL, theUUID);
        CFRelease(theUUID);});
    return uuidString;
}

#pragma mark - Init

-(id) init
{
    NSAssert(NO, @"Must init with a managed object context.");
    return nil;
}

-(id) initWithManagedObjectContext:(NSManagedObjectContext *)context
{
    self = [super init];
    
    if (self) {
        self.managedObjectContext = context;
        
        // Set up object store of the shared object manager
        RKObjectManager *objectManager = [RKObjectManager sharedManager];
        if (!objectManager.objectStore) {
            RKManagedObjectStore* objectStore = [RKManagedObjectStore objectStoreWithStoreFilename:@"Dash.sqlite"];
            objectManager.objectStore = objectStore;
        }
    }
    
    return self;
}

-(id) initWithManagedObjectContext:(NSManagedObjectContext *)context delegate:(id)delegate
{
    self = [self initWithManagedObjectContext:context];
    
    if (self) {
        self.delegate = delegate;
    }
    
    return self;
}

#pragma mark - Params
- (NSString *)key
{
    // TODO: Obfuscate
    return kKey;
}

#pragma mark - Gets

-(void) pop:(CLLocation *)location
{
    NSString *locParam = [NSString stringWithFormat:@"%f, %f", location.coordinate.latitude,
                          location.coordinate.longitude];
    [self pop:locParam types:@"" prices:@"$, $$, $$$," distance:@""];
}

- (void)pop:(NSString *)loc types:(NSString *)types prices:(NSString *)prices distance:(NSString *)distance
{
    return [self pop:loc types:types prices:prices distance:distance page:self.class.curPage];
}

- (void)pop:(NSString *)loc types:(NSString *)types prices:(NSString *)prices distance:(NSString *)distance page:(NSInteger)page
{
    // Create an object manager and connect core data's persistent store to it
    RKObjectManager *objectManager = [RKObjectManager sharedManager];
    
    RKManagedObjectMapping *placeMapping = [[self class] placeMapping];
    
    // We expect to find the place entity inside of a dictionary keyed "places"
    [objectManager.mappingProvider setMapping:placeMapping forKeyPath:@"places"];
    
    // Authentication
    // Params are backwards compared to the way 
    // it is shown in the http: /pops?key=object
    Person *person = self.class.me;
    NSString *rangeStr = ([distance length] == 0) ? @"fake_range" : @"range";
    NSDictionary* params = [NSDictionary dictionaryWithObjectsAndKeys:
                            [NSString stringWithFormat:@"%@", person.fb_uid], @"fb_uid",
                            self.key, @"must_fix",
                            loc, @"loc",
                            prices, @"prices",
                            types, @"types", 
                            [NSNumber numberWithInt:self.class.curPage], @"page",
                            distance, rangeStr,
                            self.class.uuid, @"uuid", nil];
    
    // Prepare our object loader to load and map objects from remote server, and send
    RKObjectLoader *objectLoader = [objectManager objectLoaderWithResourcePath:@"pops" delegate:self.delegate];
    objectLoader.method = RKRequestMethodPOST;
    objectLoader.params = params;
    [objectLoader send];
    
    TFLog(@"Pop params %@", params);
    [TestFlight passCheckpoint:@"Popped"];
    [Appirater userDidSignificantEvent:YES];
    
    // Increment our cur page
    [self.class incrementCurPage];
}

- (void)feedForPerson:(Person *)person near:(CLLocation *)location
{
    // Create an object manager and connect core data's persistent store to it
    RKObjectManager *objectManager = [RKObjectManager sharedManager];
    
    // Author mapping
    RKManagedObjectMapping *authorMapping = [RKManagedObjectMapping mappingForEntityWithName:@"Person"];
    [authorMapping mapKeyPath:@"id" toAttribute:@"uid"];
    [authorMapping mapAttributes:@"name", @"fb_uid", nil];
    
    // Define our news item mapping
    RKManagedObjectMapping *newsItemMapping = [RKManagedObjectMapping mappingForEntityWithName:@"NewsItem"];
    [newsItemMapping mapAttributes:@"blurb", @"timestamp", nil];
    
    // Get place mapping
    RKManagedObjectMapping *placeMapping = [[self class] placeMapping];
    
    // Map the relationships
    [newsItemMapping mapKeyPath:@"place" toRelationship:@"place" withMapping:placeMapping];
    [newsItemMapping mapKeyPath:@"author" toRelationship:@"author" withMapping:authorMapping];

    // We expect to find the place entity inside of a dictionary keyed "feed"
    [objectManager.mappingProvider setMapping:newsItemMapping forKeyPath:@"feed"];
    
    // Authentication
    // Params are backwards compared to the way 
    // it is shown in the http: /pops?key=object
    NSNumber *count = [NSNumber numberWithInt:10];
    NSString *locParam = [NSString stringWithFormat:@"%f, %f", location.coordinate.latitude,
                          location.coordinate.longitude];
    
    NSDictionary* params;
    if (person.fb_uid) {
        params = [NSDictionary dictionaryWithObjectsAndKeys:
                    self.key, @"must_fix",
                    [NSString stringWithFormat:@"%@", person.fb_uid], @"fb_uid",
                    locParam, @"loc",
                    count, @"count",nil];
    }
    else {
        params = [NSDictionary dictionaryWithObjectsAndKeys:
                    self.key, @"must_fix",
                    locParam, @"loc",
                    count, @"count",nil];
    }
    
    // Prepare our object loader to load and map objects from remote server, and send
    RKObjectLoader *objectLoader= [objectManager objectLoaderWithResourcePath:[@"feed" appendQueryParams:params] delegate:self.delegate];
    objectLoader.method = RKRequestMethodGET;
    objectLoader.userData = [NSNumber numberWithInt:kFeed];
    [objectLoader send];
    
    [TestFlight passCheckpoint:@"Requested Feed"];
}

#pragma mark - Place actions

- (void)recommendsForPerson:(Person *) person
{
    return [self recommendsForPerson:person withCount:kDefaultNumFeedItems];
}

- (void)recommendsForPerson:(Person *) person withCount:(NSUInteger)count
{
    // Create an object manager and connect core data's persistent store to it
    RKObjectManager *objectManager = [RKObjectManager sharedManager];
    
    // Define our author mapping for recommended places
    RKManagedObjectMapping *authorMapping = [RKManagedObjectMapping mappingForEntityWithName:@"Person"];
    [authorMapping mapKeyPath:@"id" toAttribute:@"uid"];
    [authorMapping mapAttributes:@"name", @"fb_uid", nil];
    
    // Define our place mapping
    RKManagedObjectMapping *placeMapping = [[self class] placeMapping];
    
    // Now, connect the two via a recommend
    RKManagedObjectMapping *recommendMapping = [RKManagedObjectMapping mappingForEntityWithName:@"Recommend"];
    [recommendMapping mapKeyPath:@"id" toAttribute:@"uid"];
    [recommendMapping mapAttributes:@"timestamp", nil];
    
    [recommendMapping mapKeyPath:@"place" toRelationship:@"place" withMapping:placeMapping];
    [recommendMapping mapKeyPath:@"author" toRelationship:@"author" withMapping:authorMapping];
    
    // We expect to find the place entity inside of a dictionary keyed "recommends"
    [objectManager.mappingProvider setMapping:recommendMapping forKeyPath:@"recommends"];
    
    // Authentication
    // Params are backwards compared to the way 
    // it is shown in the http: /pops?key=object
    NSDictionary* params = [NSDictionary dictionaryWithObjectsAndKeys:
                            [NSString stringWithFormat:@"%@", person.fb_uid], @"fb_uid",
                            self.key, @"must_fix",
                            [NSNumber numberWithInt:count], @"count",nil];
    
    // Prepare our object loader to load and map objects from remote server, and send
    RKObjectLoader *objectLoader = [objectManager objectLoaderWithResourcePath:RKPathAppendQueryParams(@"places/recommends", params) delegate:self.delegate];
    objectLoader.method = RKRequestMethodGET;
    objectLoader.userData = [NSNumber numberWithInt:kRecommends];
    [objectLoader send];
    
    
}


- (void)highlightsForPerson:(Person *) person
{
    return [self highlightsForPerson:person withCount:kDefaultNumFeedItems];
}

- (void)highlightsForPerson:(Person *) person withCount:(NSUInteger)count
{
    // Create an object manager and connect core data's persistent store to it
    RKObjectManager *objectManager = [RKObjectManager sharedManager];
    
    // Define our author mapping for recommended places
    RKManagedObjectMapping *authorMapping = [RKManagedObjectMapping mappingForEntityWithName:@"Person"];
    [authorMapping mapKeyPath:@"id" toAttribute:@"uid"];
    [authorMapping mapAttributes:@"name", @"fb_uid", nil];
    
    // Define our place mapping
    RKManagedObjectMapping *placeMapping = [[self class] placeMapping];
    
    // Now, connect the two via a recommend
    RKManagedObjectMapping *recommendMapping = [RKManagedObjectMapping mappingForEntityWithName:@"Recommend"];
    [recommendMapping mapKeyPath:@"id" toAttribute:@"uid"];
    [recommendMapping mapAttributes:@"timestamp", nil];
    
    [recommendMapping mapKeyPath:@"place" toRelationship:@"place" withMapping:placeMapping];
    [recommendMapping mapKeyPath:@"author" toRelationship:@"author" withMapping:authorMapping];
    
    // We expect to find the place entity inside of a dictionary keyed "recommends"
    [objectManager.mappingProvider setMapping:recommendMapping forKeyPath:@"highlights"];
    
    // Authentication
    // Params are backwards compared to the way 
    // it is shown in the http: /pops?key=object
    NSDictionary* params = [NSDictionary dictionaryWithObjectsAndKeys:
                            [NSString stringWithFormat:@"%@", person.fb_uid], @"fb_uid",
                            self.key, @"must_fix",
                            [NSNumber numberWithInt:count], @"count",nil];
    
    // Prepare our object loader to load and map objects from remote server, and send
    RKObjectLoader *objectLoader = [objectManager objectLoaderWithResourcePath:RKPathAppendQueryParams(@"places/highlights", params) delegate:self.delegate];
    objectLoader.method = RKRequestMethodGET;
    objectLoader.userData = [NSNumber numberWithInt:kRecommends];
    [objectLoader send];
    
    
}

- (void)likeHighlightsForPerson:(Person *) person
{
    return [self likeHighlightsForPerson:person withCount:kDefaultNumFeedItems];
}

- (void)likeHighlightsForPerson:(Person *) person withCount:(NSUInteger)count
{
    // Create an object manager and connect core data's persistent store to it
    RKObjectManager *objectManager = [RKObjectManager sharedManager];
    
    // Define our author mapping for recommended places
    RKManagedObjectMapping *authorMapping = [RKManagedObjectMapping mappingForEntityWithName:@"Person"];
    [authorMapping mapKeyPath:@"id" toAttribute:@"uid"];
    [authorMapping mapAttributes:@"name", @"fb_uid", nil];
    
    // Define our place mapping
    RKManagedObjectMapping *placeMapping = [[self class] placeMapping];
    
    // Now, connect the two via a recommend
    RKManagedObjectMapping *recommendMapping = [RKManagedObjectMapping mappingForEntityWithName:@"Recommend"];
    [recommendMapping mapKeyPath:@"id" toAttribute:@"uid"];
    [recommendMapping mapAttributes:@"timestamp", nil];
    
    [recommendMapping mapKeyPath:@"place" toRelationship:@"place" withMapping:placeMapping];
    [recommendMapping mapKeyPath:@"author" toRelationship:@"author" withMapping:authorMapping];
    
    // We expect to find the place entity inside of a dictionary keyed "recommends"
    [objectManager.mappingProvider setMapping:recommendMapping forKeyPath:@"like_highlights"];
    
    // Authentication
    // Params are backwards compared to the way 
    // it is shown in the http: /pops?key=object
    NSDictionary* params = [NSDictionary dictionaryWithObjectsAndKeys:
                            [NSString stringWithFormat:@"%@", person.fb_uid], @"fb_uid",
                            self.key, @"must_fix",
                            [NSNumber numberWithInt:count], @"count",nil];
    
    // Prepare our object loader to load and map objects from remote server, and send
    RKObjectLoader *objectLoader = [objectManager objectLoaderWithResourcePath:RKPathAppendQueryParams(@"places/saves", params) delegate:self.delegate];
    objectLoader.method = RKRequestMethodGET;
    objectLoader.userData = [NSNumber numberWithInt:kRecommends];
    [objectLoader send];
    
    
}

#pragma mark - 

- (void)placeByID:(NSNumber *)uid
{
    // Create an object manager and connect core data's persistent store to it
    RKObjectManager *objectManager = [RKObjectManager sharedManager];
    
    RKManagedObjectMapping *placeMapping = [[self class] placeMapping];
    
    // We expect to find the place entity inside of a dictionary keyed "place"
    [objectManager.mappingProvider setMapping:placeMapping forKeyPath:@"place"];
    
    // Params
    NSDictionary* params = [NSDictionary dictionaryWithObjectsAndKeys:
                            self.key, @"must_fix",
                            uid, @"uid", nil];
    
    // Prepare our object loader to load and map objects from remote server, and send
    RKObjectLoader *objectLoader = [objectManager objectLoaderWithResourcePath:@"places" delegate:self.delegate];
    objectLoader.method = RKRequestMethodPOST;
    objectLoader.params = params;
    [objectLoader send];
}

#pragma mark -

- (void)autocomplete:(NSString *)query
{
    NSNumber *count = [NSNumber numberWithInt:10];
    NSDictionary *params = [[NSDictionary alloc] initWithObjectsAndKeys:
                            query, @"query", 
                            count, @"count", nil];
    [[RKClient sharedClient] get:@"/search/autocomplete" queryParams:params delegate:self.delegate];
}

- (void)search:(NSString *)query
{
    // Create an object manager and connect core data's persistent store to it
    RKObjectManager *objectManager = [RKObjectManager sharedManager];
    
    RKManagedObjectMapping *placeMapping = [[self class] placeMapping];
    
    // We expect to find the place entity inside of a dictionary keyed "places"
    [objectManager.mappingProvider setMapping:placeMapping forKeyPath:@"places"];
    
    // Authentication
    // Params are backwards compared to the way 
    // it is shown in the http: /pops?key=object
    NSNumber *count = [NSNumber numberWithInt:10];
    NSDictionary* params = [NSDictionary dictionaryWithObjectsAndKeys:
                            self.key, @"must_fix",
                            query, @"query", 
                            count, @"count", nil];
    
    // Prepare our object loader to load and map objects from remote server, and send
    RKObjectLoader *objectLoader = [objectManager objectLoaderWithResourcePath:@"search" delegate:self.delegate];
    objectLoader.method = RKRequestMethodPOST;
    objectLoader.params = params;
    [objectLoader send];
    
    [TestFlight passCheckpoint:@"Searched"];
}

- (void)search:(NSString *)query near:(CLLocation *)location
{
    // Create an object manager and connect core data's persistent store to it
    RKObjectManager *objectManager = [RKObjectManager sharedManager];
    
    RKManagedObjectMapping *placeMapping = [[self class] placeMapping];
    
    // We expect to find the place entity inside of a dictionary keyed "places"
    [objectManager.mappingProvider setMapping:placeMapping forKeyPath:@"places"];
    
    // Authentication
    // Params are backwards compared to the way 
    // it is shown in the http: /pops?key=object
    NSNumber *count = [NSNumber numberWithInt:10];
    NSString *locParam = [NSString stringWithFormat:@"%f, %f", location.coordinate.latitude,
                          location.coordinate.longitude];
    NSDictionary* params = [NSDictionary dictionaryWithObjectsAndKeys:
                            self.key, @"must_fix",
                            query, @"query", 
                            count, @"count",
                            locParam, @"loc", nil];
    
    // Prepare our object loader to load and map objects from remote server, and send
    RKObjectLoader *objectLoader = [objectManager objectLoaderWithResourcePath:@"search_nearby" delegate:self.delegate];
    objectLoader.method = RKRequestMethodPOST;
    objectLoader.params = params;
    [objectLoader send];
    
    [TestFlight passCheckpoint:@"Searched Nearby"];
}

#pragma mark - 

- (void)createPerson:(Person *)person
{
    NSDictionary* params = [NSDictionary dictionaryWithObjectsAndKeys:
                            self.key, @"must_fix",
                            person.name, @"name",
                            person.fb_uid, @"fb_uid",
                            person.email, @"email", nil];
    [[RKClient sharedClient] post:@"/people/people" params:params delegate:self.delegate];
}

- (void)thumbsUpPlace:(Place *)place
{
    Person *person = self.class.me;
    NSDictionary* params = [NSDictionary dictionaryWithObjectsAndKeys:
                            self.key, @"must_fix",
                            person.fb_uid, @"fb_uid",
                            place.uid, @"place_id", nil];
    if ([place recommendedByMe]) {
        // Toggle
        NSString *resourceEndPoint = [NSString stringWithFormat:@"/places/recommends/%d", 1];
        [[[RKClient sharedClient] delete:[resourceEndPoint appendQueryParams:params] delegate:self.delegate] setUserData:[NSNumber numberWithInt:kRecommends]];
    }
    else {
        if ([place savedByMe]) {
            // Undo
            NSString *resourceEndPoint = [NSString stringWithFormat:@"/places/saves/%d", 1];
            [[[RKClient sharedClient] delete:[resourceEndPoint appendQueryParams:params] delegate:self.delegate] setUserData:[NSNumber numberWithInt:kSaves]];
        }
        // Create
        [[[RKClient sharedClient] post:@"/places/recommends" params:params delegate:self.delegate] setUserData:[NSNumber numberWithInt:kRecommends]];
    }
    
    [self.class setShouldRefreshFavorites:YES];
    [self.class setShouldRefreshProfile:YES];
    
    [TestFlight passCheckpoint:@"Favorited a place"];
}

- (void)thumbsDownPlace:(Place *)place
{
    Person *person = self.class.me;
    NSDictionary* params = [NSDictionary dictionaryWithObjectsAndKeys:
                            self.key, @"must_fix",
                            person.fb_uid, @"fb_uid",
                            place.uid, @"place_id", nil];
    if ([place savedByMe]) {
        // Toggle
        NSString *resourceEndPoint = [NSString stringWithFormat:@"/places/saves/%d", 1];
        [[[RKClient sharedClient] delete:[resourceEndPoint appendQueryParams:params] delegate:self.delegate] setUserData:[NSNumber numberWithInt:kSaves]];
    }
    else {
        if ([place recommendedByMe]) {
            // Undo
            NSString *resourceEndPoint = [NSString stringWithFormat:@"/places/recommends/%d", 1];
            [[[RKClient sharedClient] delete:[resourceEndPoint appendQueryParams:params] delegate:self.delegate] setUserData:[NSNumber numberWithInt:kRecommends]];
        }
        // Create
        NSLog(@"Trying to thumbs down! %@", params);
        [[[RKClient sharedClient] post:@"/places/saves" params:params delegate:self.delegate] setUserData:[NSNumber numberWithInt:kSaves]];
    }
    
    [self.class setShouldRefreshFavorites:YES];
    [self.class setShouldRefreshProfile:YES];
    
    [TestFlight passCheckpoint:@"Disliked a place"];
}

- (void)createHighlight:(NSString *)text atPlace:(Place *)place
{
    Person *person = self.class.me;
    NSDictionary* params = [NSDictionary dictionaryWithObjectsAndKeys:
                            self.key, @"must_fix",
                            person.fb_uid, @"fb_uid",
                            place.uid, @"place_id",
                            text, @"text", nil];
    [[[RKClient sharedClient] post:@"/places/highlights" params:params delegate:self.delegate] setUserData:[NSNumber numberWithInt:kHighlights]];
    
    [TestFlight passCheckpoint:@"Created a highlight"];
}

- (void)likeHighlight:(Highlight *)highlight
{
    Person *person = self.class.me;
    Person *highlightAuthor = highlight.author;
    
    NSDictionary* params = [NSDictionary dictionaryWithObjectsAndKeys:
                            self.key, @"must_fix",
                            person.fb_uid, @"fb_uid",
                            highlight.uid, @"hl_id",
                            highlightAuthor.uid, @"hl_author_id", nil];
    
    // Lazy. Toggle, for now
    if ([highlight likedByMe]) {
        // If we already have liked it, this means we are unliking it
        // TODO: Right now this URL scheme is funky...
        NSString *resourceEndPoint = [NSString stringWithFormat:@"/feedback/likes/%d", 1];
        [[RKClient sharedClient] delete:[resourceEndPoint appendQueryParams:params] delegate:self.delegate];
        
        [TestFlight passCheckpoint:@"Unliked a highlight"];
    }
    else {
        // Create new heart
        [[RKClient sharedClient] post:@"/feedback/likes" params:params delegate:self.delegate];
        
        [TestFlight passCheckpoint:@"Liked a highlight"];
    }
    
}
#pragma mark -

- (void)myProfile
{
    [self profileForPerson:[self.class me]];
    
    [TestFlight passCheckpoint:@"Viewed my profile"];
}


- (void)profileForPerson:(Person *)person
{
    // Create an object manager and connect core data's persistent store to it
    RKObjectManager *objectManager = [RKObjectManager sharedManager];
    
    // Define our author mapping for saved places
    RKManagedObjectMapping *personMapping = [RKManagedObjectMapping mappingForEntityWithName:@"Person"];
    [personMapping mapKeyPath:@"id" toAttribute:@"uid"];
    [personMapping mapAttributes:@"email", @"name", @"fb_uid", nil];
    
    // Define our stats mapping
    RKManagedObjectMapping *statsMapping = [RKManagedObjectMapping mappingForEntityWithName:@"Stats"];
    [statsMapping mapAttributes:@"favorites", @"following", @"followers", nil];
    
    [personMapping mapKeyPath:@"stats" toRelationship:@"stats" withMapping:statsMapping];
    
    // We expect to find the place entity inside of a dictionary keyed "saves"
    [objectManager.mappingProvider setMapping:personMapping forKeyPath:@"profiles"];
    
    // Authentication
    // Params are backwards compared to the way 
    // it is shown in the http: /pops?key=object
    // TODO: Paramterize request based on persons' id(s)
    NSDictionary* params = [NSDictionary dictionaryWithObjectsAndKeys:
                            self.key, @"must_fix",
                            @"1", @"id", nil];
    
    // Prepare our object loader to load and map objects from remote server, and send
    RKObjectLoader *objectLoader= [objectManager objectLoaderWithResourcePath:@"people/people" delegate:self.delegate];
    objectLoader.method = RKRequestMethodGET;
    objectLoader.params = params;
    objectLoader.userData = [NSNumber numberWithInt:kProfile];
    //[objectLoader send];    
    
}




@end
