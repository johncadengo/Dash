//
//  DashTests.h
//  DashTests
//
//  Created by John Cadengo on 10/12/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <SenTestingKit/SenTestingKit.h>

@class DashAPI;
@class Person;
@class Place;
@class PlaceLocation;

/** Handles testing our model, the managed object context, the persistent store, etc.
    All of our tests which need to access Core Data will inherit from this test case.
 */
@interface DashTests : SenTestCase

/** Returns the managed object context attached to the test cases, gotten from the app delegate
 */
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;


/** Run before each test, creates an example data model we can play with during our tests.
 */
- (void)setUp;

/** Run after each test, makes sure to dispose of everything we've created during setup.
 
 TODO: Actually tear down things. Right now, it does not.
 */
- (void)tearDown;

/** Saves to the persistent store in memory.
 */
- (void)saveContext;

/** Fetches an entity by name from the managed object context.
 */
- (NSMutableArray *) fetchEntity:(NSString*) entityName;

- (Person *)fetchLastPerson;
- (Place *)fetchLastPlace;
- (PlaceLocation *)fetchLastPlaceLocation;

- (Person *)fetchPersonWithName:(NSString *)name;

- (id)fetchEntity:(NSString *)entityName withUid:(NSNumber *)uid;

@end
