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

/** Run before each test. Populates the database with objects to play with.
 */
- (void)setUp
{
    NSLog(@"%@ setUp", self.name);
    
    // Creates our persistent store in memory and initializes our managed object context for us.
    [super setUp];
    
    // Create and configure a new instance of the Person entity.
    Person *person = (Person *)[NSEntityDescription insertNewObjectForEntityForName: @"Person" inManagedObjectContext: self.managedObjectContext];
    [person setUid: [NSNumber numberWithInt: 2]];
    [person setName: @"brown"];
    [person setEmail:@"brown@paris.com"];
    STAssertTrue([[person name] isEqualToString:@"brown"], @"Name failed to store properly.");
    STAssertTrue([[person email] isEqualToString:@"brown@paris.com"], @"Email failed to store properly.");
    
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
#pragma mark Tests


/** Makes sure our GetPersonByName works.
    Goes into the database, fetches the Person entity and 
    searches for the Person with the name that matches our argument.
 */
- (void)testGetPersonByName
{
    // Get John
    Person *john = [self getPersonWithName: @"john"];
    
    // Check if he's the right onw
    STAssertTrue([[john name] isEqualToString:@"john"], @"Name failed to store properly.");
    STAssertTrue([[john email] isEqualToString:@"john@john.com"], @"Email failed to store properly.");
}

/** testPerson fetches a Person entity from the persistent store
    then tests setting and getting its properties
    and finally tests saving the context and making sure it went through.
 */
- (void)testGetPerson 
{
    NSLog(@"%@ start", self.name); 
    
    // First, get the last person entity from the persistent store, which is john.
    Person *brown = [self getLastPerson];
    
    // Check initial values of the person fetched
    NSString *name = [brown name];
    NSString *email = [brown email];
    STAssertTrue([name isEqualToString:@"brown"], @"Name failed to store properly. Got instead: %@", name);
    STAssertTrue([email isEqualToString:@"brown@paris.com"], @"Email failed to store properly. Got instead: %@", email);
    
    // Change the values
    [brown setName: @"BRWN"];
    [brown setEmail: @"BRWN@paris.com"];
    
    // Try to save
    [self saveContext];
    
    // Now refetch it and make sure that it has updated the values
    Person *BRWN = [self getPersonWithName: @"BRWN"];
    
    name = [BRWN name];
    email = [BRWN email];
    STAssertTrue([name isEqualToString:@"BRWN"], @"Name failed to store properly. Got instead: %@", name);
    STAssertTrue([email isEqualToString:@"BRWN@paris.com"], @"Email failed to store properly. Got instead: %@", email);
    
    NSLog(@"%@ end", self.name); 
}

@end
