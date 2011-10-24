//
//  DashTests.m
//  DashTests
//
//  Created by John Cadengo on 10/12/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "DashTests.h"
#import "AppDelegate.h"
#import "DashAPI.h"
#import "JSONKit.h"
#import "Person.h"
#import "Rating.h"
#import "Place.h"
#import "Location.h"

@implementation DashTests

@synthesize managedObjectContext = __managedObjectContext;
@synthesize dash = _dash;

- (void)setUp
{
    [super setUp];
    
    // Set-up code here.
    NSLog(@"%@ setUp", self.name);
    self.dash = [[DashAPI alloc] init];
    STAssertNotNil(self.dash, @"Cannot create DashAPI instance");
    
    // Get managed object context from the app delegate
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    self.managedObjectContext = [appDelegate managedObjectContext];
    STAssertNotNil(self.managedObjectContext, @"Cannot get managed object context");
    
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

- (void)tearDown
{
    NSLog(@"%@ tearDown", self.name);
    
    [super tearDown];
}

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

/* testPerson fetches a Person entity from the persistent store
 * then tests setting and getting its properties
 * and finally tests saving the context and making sure it went through.
 */
- (void)testGetPerson 
{
    NSLog(@"%@ start", self.name); 
    
    Person *person = [self getLastPerson];
    
    // First check initial values of the person fetched
    STAssertTrue([[person name] isEqualToString:@"john"], @"Name failed to store properly.");
    STAssertTrue([[person email] isEqualToString:@"john@john.com"], @"Email failed to store properly.");
    
    // Change the values

    // Try to save
    [self saveContext];
    
    NSLog(@"%@ end", self.name); 
}

@end
