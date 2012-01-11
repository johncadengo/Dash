//
//  DashTests.m
//  DashTests
//
//  Created by John Cadengo on 10/12/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "DashTests.h"
#import "Person.h"
#import "Place.h"
#import "PlaceLocation.h"

@implementation DashTests

@synthesize managedObjectContext = __managedObjectContext;

#pragma mark -
#pragma mark Setup and TearDown

- (void)setUp
{
    NSLog(@"%@ DashTests setUp", self.name);
    [super setUp];

    // Build a core data stack in memory so it can be quick and teardown will be simple.
    NSManagedObjectModel *managedObjectModel = [NSManagedObjectModel mergedModelFromBundles:[NSArray arrayWithObject:[NSBundle mainBundle]]];
    NSPersistentStoreCoordinator *persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:managedObjectModel];
    STAssertTrue([persistentStoreCoordinator addPersistentStoreWithType:NSInMemoryStoreType configuration:nil URL:nil options:nil error:NULL] ? YES : NO, @"Failed to add in-memory persistent store");
    
    // Create our managedObjectContext and point it to the in-memory core data stack.
    self.managedObjectContext = [[NSManagedObjectContext alloc] init];
    self.managedObjectContext.persistentStoreCoordinator = persistentStoreCoordinator;
    STAssertNotNil(self.managedObjectContext, @"Failed to create managed object context");
    
    // Create some sample objects to populate our database with.
    Person *person = (Person *)[NSEntityDescription insertNewObjectForEntityForName: @"Person" inManagedObjectContext: self.managedObjectContext];
    [person setUid: [NSNumber numberWithInt: 1]];
    [person setName: @"john"];
    [person setEmail:@"john@john.com"];
    STAssertTrue([[person name] isEqualToString:@"john"], @"Name failed to store properly.");
    STAssertTrue([[person email] isEqualToString:@"john@john.com"], @"Email failed to store properly.");
    
    // Create a fictional Place
    Place *place = (Place *)[NSEntityDescription insertNewObjectForEntityForName: @"Place" inManagedObjectContext: self.managedObjectContext];
    [place setUid: [NSNumber numberWithInt: 1]];
    [place setName: @"Sheep on a Box"];
    [place setAddress: @"226 Thompson St."];
    [place setPhone: @"123-345-6789"];
    [place setPrice: @"$$"];
    STAssertNotNil([place name], @"Name failed to stick.");
    STAssertNotNil([place address], @"Address failed to stick.");
    STAssertNotNil([place phone], @"Phone failed to stick.");
    STAssertNotNil([place price], @"Price failed to stick.");
    
    // All Places need a Location
    // Google Map coordinates of 226 Thompson St 10012
    // LAT = 40.7292540
    // LNG = -73.9988530
    PlaceLocation *location = (PlaceLocation *)[NSEntityDescription insertNewObjectForEntityForName: @"PlaceLocation" inManagedObjectContext: self.managedObjectContext];
    [location setLatitude: [NSNumber numberWithDouble:40.7292540]];
    [location setLongitude: [NSNumber numberWithDouble:-73.9988530]];

    // Attach the Location to the Place
    [place setLocation: location];
    
    // Saves the managed object context into the persistent store.
    [self saveContext];
}

- (void)tearDown
{
    NSLog(@"%@ DashTests tearDown", self.name);
    
    [super tearDown];
}

#pragma mark -
#pragma mark Helper Methods to be used throughout tests

- (void)saveContext
{
    NSLog(@"%@ saveContext", self.name);
    
    NSError *saveError = nil; 
    STAssertTrue([self.managedObjectContext save:&saveError], @"Failed to save context to persistent store: %@", saveError);
}

- (NSMutableArray *) fetchEntity:(NSString*) entityName
{
    NSLog(@"%@ fetchEntity", self.name);
    
    NSFetchRequest *request = [[NSFetchRequest alloc] init]; 
    NSEntityDescription *entity = [NSEntityDescription entityForName:entityName inManagedObjectContext:self.managedObjectContext]; 
    [request setEntity:entity];
    
    // Execute the request
    NSError *fetchError = nil; 
    NSMutableArray *mutableFetchResults = [[self.managedObjectContext executeFetchRequest:request error:&fetchError] mutableCopy];
    STAssertNotNil(mutableFetchResults, @"Failed to fetch %@ entity from persistent store: %@", entityName, fetchError);
    
    return mutableFetchResults;
}

- (Person *)fetchLastPerson
{
    NSLog(@"%@ getLastPerson", self.name);
    
    NSMutableArray *mutableFetchResults = [self fetchEntity: @"Person"];
    
    // Get the person from the results of the request
    Person *person = (Person *)[mutableFetchResults lastObject];
    
    return person;
}

- (Place *)fetchLastPlace
{
    NSLog(@"%@ getLastPlace", self.name);
    
    NSMutableArray *mutableFetchResults = [self fetchEntity: @"Place"];
    
    // Get the person from the results of the request
    Place *place = (Place *)[mutableFetchResults lastObject];
    
    return place;
}

- (Location *)fetchLastPlaceLocation
{
    NSLog(@"%@ getLastLocation", self.name);
    
    NSMutableArray *mutableFetchResults = [self fetchEntity: @"PlaceLocation"];
    
    // Get the person from the results of the request
    PlaceLocation *placeLocation = (PlaceLocation *)[mutableFetchResults lastObject];
    
    return placeLocation;
}

- (Person *)fetchPersonWithName:(NSString *)name
{
    NSLog(@"%@ getLastPerson", self.name);
    
    NSMutableArray *mutableFetchResults = [self fetchEntity: @"Person"];
    
    // Lazy man's way, after bringing the whole database into memory LOL
    // TODO: Use NSPredicate and NSExpression to do this more efficiently
    for (Person *person in mutableFetchResults) {
        if (person.name == name) {
            return person;
        }
    }
    
    // Otherwise, we couldn't find it so we return nil
    return nil;
}

- (id)fetchEntity:(NSString *)entityName withUid:(NSNumber *)uid
{
    NSLog(@"%@ fetchEntity:withUid:", self.name);
    
    NSMutableArray *mutableFetchResults = [self fetchEntity: entityName];
    
    // Again, lazy man's way
    // TODO: Use NSPredicate and NSExpression to do this more efficiently
    for (id entity in mutableFetchResults) {
        if ([entity uid] == uid) {
            return entity;
        }
    }
    
    // Otherwise, we couldn't find it so we return nil
    return nil;
}

@end
