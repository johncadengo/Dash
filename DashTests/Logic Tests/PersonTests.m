//
//  PersonTests.m
//  Dash
//
//  Created by John Cadengo on 10/27/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "PersonTests.h"
#import "Person.h"

@implementation PersonTests

@synthesize managedObjectContext = __managedObjectContext;

#pragma mark -
#pragma mark Setup and TearDown

/** Run before each test. We need a database to play with, so creates one and adds a Person.
 */
- (void)setUp
{
    NSLog(@"%@ setUp", self.name);
    
    // Creates our persistent store in memory and initializes our managed object context for us.
    [super setUp];
    
    // Create and configure a new instance of the Person entity.
    Person *person = (Person *)[NSEntityDescription insertNewObjectForEntityForName: @"Person" inManagedObjectContext: self.managedObjectContext];
    [person setName: @"john"];
    [person setEmail:@"john@john.com"];
    STAssertTrue([[person name] isEqualToString:@"john"], @"Name failed to store properly.");
    STAssertTrue([[person email] isEqualToString:@"john@john.com"], @"Email failed to store properly.");
    
    // Saves the managed object context into the persistent store.
    [self saveContext];
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
