//
//  DashTests.m
//  DashTests
//
//  Created by John Cadengo on 10/12/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "DashTests.h"

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

@end
