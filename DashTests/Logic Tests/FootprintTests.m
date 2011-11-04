//
//  FootprintTests.m
//  Dash
//
//  Created by John Cadengo on 10/31/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "FootprintTests.h"
#import "Action.h"
#import "Action+Helper.h"
#import "Highlight.h"
#import "Person.h"
#import "Place.h"

@implementation FootprintTests

@synthesize highlight = _highlight;

#pragma mark -
#pragma mark Setup and TearDown

/** Run before each test. Populates the database with objects to play with.
 */
- (void)setUp
{
    NSLog(@"%@ setUp", self.name);
    
    // Creates our persistent store in memory and initializes our managed object context for us.
    [super setUp];
    
    // Have John create a Highlight at Sheep on a Box
    Person *john = [self fetchLastPerson];
    Place *sheepbox = [self fetchLastPlace];
    self.highlight = (Highlight *)[NSEntityDescription insertNewObjectForEntityForName: @"Highlight" inManagedObjectContext: self.managedObjectContext];
    [self.highlight setUid: [NSNumber numberWithInt: 1]];
    [self.highlight setText: @"Great soup dumplings!"];
    [self.highlight setAuthor: john];
    [self.highlight setPlace: sheepbox];
    
    // Saves the managed object context into the persistent store.
    [self saveContext];
    
    STAssertNotNil(self.highlight.uid, @"UID didn't stick.");
    STAssertNotNil(self.highlight.text, @"Text didn't stick.");
    STAssertNotNil(self.highlight.author, @"Author didn't stick.");
    STAssertNotNil(self.highlight.place, @"Place didn't stick.");
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

/** Creates a Footprint with an Action and makes sure everything gets set alright.
 */
- (void)testActionsFootprint
{
    NSLog(@"%@", self.name);
    
    Action *action = self.highlight;
    NSString *photoPath = [action photoPath];
    NSString *description = [action description];
    NSString *relativeTimestamp = [action relativeTimestamp]; 
    
    STAssertNotNil(photoPath, @"photoPath didn't stick.");
    STAssertNotNil(description, @"description didn't stick.");
    STAssertNotNil(relativeTimestamp, @"relativeTimestamp didn't stick.");
}


@end
