//
//  DashTests.m
//  DashTests
//
//  Created by John Cadengo on 10/12/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "DashTests.h"
#import "DashAPI.h"
#import "JSONKit.h"
#import "Person.h"
#import "Rating.h"
#import "Place.h"
#import "Location.h"

@implementation DashTests

@synthesize managedObjectContext = __managedObjectContext;
@synthesize dash = _dash;

#pragma mark -
#pragma mark Setup and TearDown

/** Run before each test, creates an example data model we can play with during our tests.
 */
- (void)setUp
{
    NSLog(@"%@ setUp", self.name);
    [super setUp];
    
    // Create our DashAPI object
    self.dash = [[DashAPI alloc] init];
    STAssertNotNil(self.dash, @"Cannot create DashAPI instance");
    
    // Build a core data stack in memory so it can be quick and teardown will be simple.
    NSManagedObjectModel *managedObjectModel = [NSManagedObjectModel mergedModelFromBundles:[NSArray arrayWithObject:[NSBundle mainBundle]]];
    NSPersistentStoreCoordinator *persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:managedObjectModel];
    STAssertTrue([persistentStoreCoordinator addPersistentStoreWithType:NSInMemoryStoreType configuration:nil URL:nil options:nil error:NULL] ? YES : NO, @"Failed to add in-memory persistent store");
    
    // Create our managedObjectContext and point it to the in-memory core data stack.
    self.managedObjectContext = [[NSManagedObjectContext alloc] init];
    self.managedObjectContext.persistentStoreCoordinator = persistentStoreCoordinator;
    STAssertNotNil(self.managedObjectContext, @"Failed to create managed object context");
    
    // Create and configure a new instance of the Person entity.
    Person *person = (Person *)[NSEntityDescription insertNewObjectForEntityForName: @"Person" inManagedObjectContext: self.managedObjectContext];
    [person setName: @"john"];
    [person setEmail:@"john@john.com"];
    STAssertTrue([[person name] isEqualToString:@"john"], @"Name failed to store properly.");
    STAssertTrue([[person email] isEqualToString:@"john@john.com"], @"Email failed to store properly.");
    
    // Saves the managed object context into the persistent store.
    NSError *error = nil; 
    STAssertTrue([self.managedObjectContext save:&error], @"Failed to save Person entity to persistent store: %@", error);
    
}

/** Run after each test, makes sure to dispose of everything we've created during setup.
 
    TODO: Actually tear down things. Right now, it does not.
 */
- (void)tearDown
{
    NSLog(@"%@ tearDown", self.name);
    
    [super tearDown];
}

#pragma mark -
#pragma mark Helper Methods to be used throughout tests

- (void)saveContext
{
    NSLog(@"%@ saveContext", self.name);
    
    NSError *saveError = nil; 
    STAssertTrue([self.managedObjectContext save:&saveError], @"Failed to save Person entity to persistent store: %@", saveError);
}

- (NSMutableArray*) fetchEntity:(NSString*) entityName
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

- (Person*)getLastPerson
{
    NSLog(@"%@ getLastPerson", self.name);

    NSMutableArray *mutableFetchResults = [self fetchEntity: @"Person"];
    
    // Get the person from the results of the request
    Person *person = (Person*)[mutableFetchResults lastObject];
    
    return person;
}

#pragma mark -
#pragma mark Tests

/**
 testPerson fetches a Person entity from the persistent store
 then tests setting and getting its properties
 and finally tests saving the context and making sure it went through.
 */
- (void)testGetPerson 
{
    NSLog(@"%@ start", self.name); 
    
    // First, get the last person entity from the persistent store, which is john.
    Person *john = [self getLastPerson];
    
    // Check initial values of the person fetched
    STAssertTrue([[john name] isEqualToString:@"john"], @"Name failed to store properly.");
    STAssertTrue([[john email] isEqualToString:@"john@john.com"], @"Email failed to store properly.");
    
    // Change the values
    [john setName:@"brown"];
    [john setEmail:@"brwn@paris.com"];
    
    // Try to save
    [self saveContext];
    
    // Now refetch it and make sure that it has updated the values
    Person *brown = [self getLastPerson];
    
    STAssertTrue([[brown name] isEqualToString:@"brown"], @"Name failed to store properly.");
    STAssertTrue([[brown email] isEqualToString:@"brwn@paris.com"], @"Email failed to store properly.");
    
    NSLog(@"%@ end", self.name); 
}

@end
