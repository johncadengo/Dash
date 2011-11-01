//
//  HighlightTests.m
//  Dash
//
//  Created by John Cadengo on 11/1/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "HighlightTests.h"
#import "Highlight.h"
#import "Highlight+Helper.h"

@implementation HighlightTests


@synthesize managedObjectContext = __managedObjectContext;
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
    
    // Get a person and a place to create a highlight between
    Person *john = [self getLastPerson];
    Place *sheepbox = [self getLastPlace];
    
    // Create the highlight
    self.highlight = (Highlight *)[NSEntityDescription insertNewObjectForEntityForName: @"Highlight" inManagedObjectContext: self.managedObjectContext];
    
    // Initialize the highlight's properties all at once
    NSNumber *uid = [NSNumber numberWithInt: 1];
    NSDate *date = [NSDate date];
    NSString *text = [NSString stringWithFormat: @"Great soup dumplings!"];
    [self.highlight setUID:uid timestamp:date text:text];
    
    // Connect it
    [self.highlight setAuthor: john];
    [self.highlight setPlace: sheepbox];
    
    // Saves the managed object context into the persistent store.
    [self saveContext];
    
    //
    
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


@end
