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

// Private properties
@interface DashAPI ()

@end

// Static class variables
// Taken from: http://stackoverflow.com/a/1250088/693754
static BOOL _skipLogin = NO;
static BOOL _loggedIn = NO;
static Person *_me = nil;

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
    [authorMapping mapAttributes:@"name", nil];
    
    // Define our highlight mapping, which has a relationship with author
    RKManagedObjectMapping *highlightMapping = [RKManagedObjectMapping mappingForEntityWithName:@"Highlight"];
    [highlightMapping mapKeyPath:@"id" toAttribute:@"uid"];
    [highlightMapping mapKeyPath:@"name" toAttribute:@"text"];
    
    // Define the relationship mapping between highlight and author
    [highlightMapping mapKeyPath:@"author" toRelationship:@"author" withMapping:authorMapping];
    
    // Define the location mapping
    RKManagedObjectMapping *locationMapping = [RKManagedObjectMapping mappingForEntityWithName:@"PlaceLocation"];
    [locationMapping mapKeyPath:@"lat" toAttribute:@"latitude"];
    [locationMapping mapKeyPath:@"lng" toAttribute:@"longitude"];
    
    // Define the badge mapping
    RKManagedObjectMapping *badgeMapping = [RKManagedObjectMapping mappingForEntityWithName:@"Badge"];
    [badgeMapping mapKeyPath:@"id" toAttribute:@"uid"];
    [badgeMapping mapAttributes:@"name", nil];
    
    // Define our place mapping, which also has 
    // a relationship with category, highlight, and location
    RKManagedObjectMapping *placeMapping = [RKManagedObjectMapping mappingForEntityWithName:@"Place"];
    [placeMapping mapKeyPath:@"id" toAttribute:@"uid"];
    [placeMapping mapAttributes:@"name", @"address", @"phone", @"price", nil];
    
    // Define the relationship mappings between place and category, highlight, location
    [placeMapping mapKeyPath:@"categories" toRelationship:@"categories" withMapping:categoryMapping];
    [placeMapping mapKeyPath:@"highlights" toRelationship:@"highlights" withMapping:highlightMapping];
    [placeMapping mapKeyPath:@"location" toRelationship:@"location" withMapping:locationMapping];
    [placeMapping mapKeyPath:@"badges" toRelationship:@"badges" withMapping:badgeMapping];
    
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
}

+ (Person *)me
{
    return _me;
}

+ (void)setMe:(Person *)newMe
{
    _me = newMe;
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

#pragma mark - Scaffolding

- (Person *)randomGhost
{
    Person *author;
    
    NSArray *names = [NSArray arrayWithObjects:@"Laura Byun", @"Grace Chi", @"Chloe Choe", @"Eunice Chung", @"Andrew Park", @"Chris Kim", @"Amos Kim", @"Julia Yang", nil];
    author = (Person *)[NSEntityDescription insertNewObjectForEntityForName:@"Person" inManagedObjectContext:self.managedObjectContext];
    [author setName:[NSString stringWithFormat:[names randomObject]]];
    
    Photo *profilePic = [NSEntityDescription insertNewObjectForEntityForName:@"Photo" inManagedObjectContext:self.managedObjectContext];
    [author setProfilepic:profilePic];
    
    return author;
}

- (Place *)randomCrypt
{
    Place *place;
    
    NSArray *names = [NSArray arrayWithObjects:@"Totto Ramen", @"Mamoun's Falafel", @"Ben's Pizzeria", @"Shake Shack", @"Halal Chicken & Rice", @"Whole Foods", nil];
    place = (Place *)[NSEntityDescription insertNewObjectForEntityForName:@"Place" inManagedObjectContext:self.managedObjectContext];
    [place setName:[NSString stringWithFormat:[names randomObject]]];
    [place setAddress:[NSString stringWithFormat:@"226 Thompson St. 10012"]];
    
    return place;
}

#pragma mark - Params
- (NSString *)key
{
    // TODO: Obfuscate
    return kKey;
}

#pragma mark - RKRequestDelegate

- (void)request:(RKRequest*)request didLoadResponse:(RKResponse*)response 
{ 
//    NSLog(@"request %@", [request OAuth1ConsumerKey]);
//    NSLog(@"response %@", [response bodyAsString]);
}

#pragma mark - RKObjectLoaderDelegate methods

- (void)objectLoader:(RKObjectLoader *)objectLoader didLoadObjects:(NSArray *)objects 
{
    // Forward this call to the delegate
    [self.delegate objectLoader:objectLoader didLoadObjects:objects];
}

- (void)objectLoader:(RKObjectLoader *)objectLoader didFailWithError:(NSError *)error 
{
    NSLog(@"Encountered an error: %@", error);
}

#pragma mark - Gets

-(void) pop:(CLLocation *)location
{
    NSString *locParam = [NSString stringWithFormat:@"%f, %f", location.coordinate.latitude,
                          location.coordinate.longitude];
    [self pop:locParam types:@"" prices:@"$, $$, $$$," distance:@""];
}

- (void)pop:(NSString *)loc types:(NSString *)type prices:(NSString *)prices distance:(NSString *)distance;
{
    
    // Create an object manager and connect core data's persistent store to it
    RKObjectManager *objectManager = [RKObjectManager sharedManager];
    
    RKManagedObjectMapping *placeMapping = [[self class] placeMapping];
    
    // We expect to find the place entity inside of a dictionary keyed "places"
    [objectManager.mappingProvider setMapping:placeMapping forKeyPath:@"places"];
    
    // Authentication
    // Params are backwards compared to the way 
    // it is shown in the http: /pops?key=object
    NSString *rangeStr = (distance == @"") ? @"fake_range": @"range";
    NSLog(@"%@ %@", rangeStr, distance);
    NSDictionary* params = [NSDictionary dictionaryWithObjectsAndKeys:
                            self.key, @"must_fix",
                            loc, @"loc",
                            distance, rangeStr,
                            prices, @"prices", nil];
    
    // Prepare our object loader to load and map objects from remote server, and send
    RKObjectLoader *objectLoader = [objectManager objectLoaderWithResourcePath:@"pops" delegate:self];
    objectLoader.method = RKRequestMethodPOST;
    objectLoader.params = params;
    [objectLoader send];
}

- (void)feedForLocation:(CLLocation *)location
{
    [self feedForPerson:nil];
}

- (void)feedForPerson:(Person *)person
{
    [self feedForPerson:person withCount:kDefaultNumFeedItems];
}

- (void)feedForPerson:(Person *)person withCount:(NSUInteger)count
{
    // Create an object manager and connect core data's persistent store to it
    RKObjectManager *objectManager = [RKObjectManager sharedManager];
    
    // Define our news item mapping
    RKManagedObjectMapping *newsItemMapping = [RKManagedObjectMapping mappingForEntityWithName:@"NewsItem"];
    [newsItemMapping mapAttributes:@"blurb", @"timestamp", nil];
    
    // Get place mapping
    RKManagedObjectMapping *placeMapping = [[self class] placeMapping];
    
    // Map the relationships
    [newsItemMapping mapKeyPath:@"place" toRelationship:@"place" withMapping:placeMapping];

    // We expect to find the place entity inside of a dictionary keyed "feed"
    [objectManager.mappingProvider setMapping:newsItemMapping forKeyPath:@"feed"];
    
    // Authentication
    // Params are backwards compared to the way 
    // it is shown in the http: /pops?key=object
    NSDictionary* params = [NSDictionary dictionaryWithObjectsAndKeys:
                            self.key, @"must_fix",
                            [NSNumber numberWithInt:count], @"count",nil];
    
    // Prepare our object loader to load and map objects from remote server, and send
    RKObjectLoader *objectLoader= [objectManager objectLoaderWithResourcePath:@"feed" delegate:self];
    objectLoader.method = RKRequestMethodGET;
    objectLoader.params = params;
    objectLoader.userData = [NSNumber numberWithInt:kFeed];
    [objectLoader send];
}

- (NSMutableArray *)commentsForHighlight:(Highlight *)highlight
{
    return [self commentsForHighlight:highlight withCount:kDefaultNumComments];
}

- (NSMutableArray *)commentsForHighlight:(Highlight *)highlight withCount:(NSUInteger)count
{
    // TODO: This is a stub for now. Actually request comments from model!
    Comment *comment;
    NSMutableArray *comments = [[NSMutableArray alloc] initWithCapacity:count];

    NSArray *texts = [NSArray arrayWithObjects:@"ahaha, i totally love this.",
                      @"me too!", @"my fav :D", @"ur so kewl", @"LOL!!!", nil];
    
    for (int i = 0; i < count; ++i) {
        comment = [self person:nil comments:[texts randomObject] onAction:highlight];
        [comments addObject:comment];
    }
    
    return comments;
}

#pragma mark - Place actions

- (void)savesForPerson:(Person *)person
{
    return [self savesForPerson:person withCount:kDefaultNumFeedItems];
}

- (void)savesForPerson:(Person *)person withCount:(NSUInteger)count
{
    // Create an object manager and connect core data's persistent store to it
    RKObjectManager *objectManager = [RKObjectManager sharedManager];
    
    // Define our author mapping for saved places
    RKManagedObjectMapping *authorMapping = [RKManagedObjectMapping mappingForEntityWithName:@"Person"];
    [authorMapping mapKeyPath:@"id" toAttribute:@"uid"];
    
    // Define our place mapping
    RKManagedObjectMapping *placeMapping = [[self class] placeMapping];
    
    // Now, connect the two via a save
    RKManagedObjectMapping *saveMapping = [RKManagedObjectMapping mappingForEntityWithName:@"Save"];
    [saveMapping mapKeyPath:@"id" toAttribute:@"uid"];
    [saveMapping mapAttributes:@"timestamp", nil];
    
    [saveMapping mapKeyPath:@"place" toRelationship:@"place" withMapping:placeMapping];
    [saveMapping mapKeyPath:@"author" toRelationship:@"author" withMapping:authorMapping];
    
    // We expect to find the place entity inside of a dictionary keyed "saves"
    [objectManager.mappingProvider setMapping:saveMapping forKeyPath:@"saves"];
    
    // Authentication
    // Params are backwards compared to the way 
    // it is shown in the http: /pops?key=object
    NSDictionary* params = [NSDictionary dictionaryWithObjectsAndKeys:
                            self.key, @"must_fix",
                            [NSNumber numberWithInt:count], @"count",nil];
    
    // Prepare our object loader to load and map objects from remote server, and send
    RKObjectLoader *objectLoader= [objectManager objectLoaderWithResourcePath:@"places/saves" delegate:self];
    objectLoader.method = RKRequestMethodGET;
    objectLoader.params = params;
    objectLoader.userData = [NSNumber numberWithInt:kSaves];
    [objectLoader send];
}

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
                            self.key, @"must_fix",
                            [NSNumber numberWithInt:count], @"count",nil];
    
    // Prepare our object loader to load and map objects from remote server, and send
    RKObjectLoader *objectLoader = [objectManager objectLoaderWithResourcePath:@"places/recommends" delegate:self];
    objectLoader.method = RKRequestMethodGET;
    objectLoader.params = params;
    objectLoader.userData = [NSNumber numberWithInt:kRecommends];
    [objectLoader send];
    
    
}

- (NSDictionary *)placeActionsForPerson:(Person *)person
{
    return [self placeActionsForPerson:person withCount:kDefaultNumFeedItems];
}

- (NSDictionary *)placeActionsForPerson:(Person *)person withCount:(NSUInteger)count
{
    // Right now, we only have saves and recommends. So make a request for each.
    [self recommendsForPerson:person withCount:count];
    //[self savesForPerson:person withCount:count];
    
    //NSDictionary *requests = [[NSDictionary alloc] initWithObjectsAndKeys:
    //                          savesRequest, [NSNumber numberWithInt:kSaves],
    //                          recommendsRequest, [NSNumber numberWithInt:kRecommends], nil];
    
    return nil;
}

- (NSMutableArray *)highlightsForPlace:(Place *)place
{
    return [self highlightsForPlace:place withCount:kDefaultNumComments];
}

- (NSMutableArray *)highlightsForPlace:(Place *)place withCount:(NSUInteger)count
{
    Highlight *highlight;
    NSMutableArray *feed = [[NSMutableArray alloc] initWithCapacity:count];
    
    for (int i = 0; i < count; ++i) {
        highlight = [self person:nil addsHighlight:[NSString randomStringOfMaxLength:140] toPlace:nil withPhoto:nil];
        
        [feed addObject:highlight];
    }
    
    return feed;
}

- (RKRequest *)autocomplete:(NSString *)query
{
    NSNumber *count = [NSNumber numberWithInt:10];
    NSDictionary *params = [[NSDictionary alloc] initWithObjectsAndKeys:
                            query, @"query", 
                            count, @"count", nil];
    return [[RKClient sharedClient] get:@"/search/autocomplete" queryParams:params delegate:self.delegate];
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
    RKObjectLoader *objectLoader = [objectManager objectLoaderWithResourcePath:@"search" delegate:self];
    objectLoader.method = RKRequestMethodPOST;
    objectLoader.params = params;
    [objectLoader send];
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
    RKObjectLoader *objectLoader = [objectManager objectLoaderWithResourcePath:@"search_nearby" delegate:self];
    objectLoader.method = RKRequestMethodPOST;
    objectLoader.params = params;
    [objectLoader send];
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

#pragma mark -

- (void)myProfile
{
    // TODO: Instance variable for currently logged in user?
    // TODO: Handle login logic?
    [self profileForPerson:nil];
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
    RKObjectLoader *objectLoader= [objectManager objectLoaderWithResourcePath:@"people/people" delegate:self];
    objectLoader.method = RKRequestMethodGET;
    objectLoader.params = params;
    objectLoader.userData = [NSNumber numberWithInt:kProfile];
    [objectLoader send];    
    
    NSLog(@"Profile For Person");
}

#pragma mark - Posts

- (Comment *)person:(Person *)person comments:(NSString *)text onAction:(Action *)action
{
    // TODO: Validation?
    Comment *comment = (Comment *)[NSEntityDescription insertNewObjectForEntityForName:@"Comment" inManagedObjectContext:self.managedObjectContext];
    
    Person *author;
    
    if (person == nil) {
        author = [self randomGhost];
    }
    else {
        author = person;
    }
    
    [comment setAuthor:author];
    [comment setText:text];
    [comment setAction:action];
    [comment setTimestamp:[NSDate randomDateWithinRelativeTime:RelativeTimeDays]];
    
    return comment;
}

- (Highlight *)person:(Person *)person addsHighlight:(NSString *)text toPlace:(Place *)place withPhoto:(Photo *)photo
{
    // TODO: Validation?
    Highlight *highlight = (Highlight *)[NSEntityDescription insertNewObjectForEntityForName:@"Highlight" inManagedObjectContext:self.managedObjectContext];

    Person *author;
    
    if (person == nil) {
        author = [self randomGhost];
    }
    else {
        author = person;
    }
    
    [highlight setAuthor:author];
    [highlight setText:text];
    [highlight setTimestamp:[NSDate randomDateWithinRelativeTime:RelativeTimeDays]];
    // TODO: Handle Photos?
    //[highlight setPhotos:];
    
    return highlight;
}

- (Save *)person:(Person *)person savesPlace:(Place *)place
{
    Save *save = (Save *)[NSEntityDescription insertNewObjectForEntityForName:@"Save" inManagedObjectContext:self.managedObjectContext];

    [save setAuthor:person];
    [save setPlace:place];
    
    return save;
}



@end
