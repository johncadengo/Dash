//
//  DashAPI.m
//  Dash
//
//  Created by John Cadengo on 10/24/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "DashAPI.h"
#import "Person.h"
#import "Person+Helper.h"
#import "Highlight.h"
#import "Highlight+Helper.h"


// Private properties
@interface DashAPI ()

@end

@implementation DashAPI

@synthesize managedObjectContext = __managedObjectContext;

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
    }
    
    return self;
}

-(void) pop:(CLLocation *)location
{
    
    
}

- (NSMutableArray *)feedForLocation:(CLLocation *)location
{
    // -1 to differentiate between location and person, for now. since im always passing nil haha
    return [self feedForPerson:nil withCount:kDefaultNumFeedItems - 1];
}

- (NSMutableArray *)feedForLocation:(CLLocation *)location WithCount:(NSUInteger)count
{
    return [self feedForPerson:nil withCount:count];
}

- (NSMutableArray *)feedForPerson:(Person *)person
{
    return [self feedForPerson:person withCount:kDefaultNumFeedItems];
}

- (NSMutableArray *)feedForPerson:(Person *)person withCount:(NSUInteger)count
{
    // TODO: This is a stub for now. Actually request news items from model!
    Highlight *highlight;
    NSMutableArray *feed = [[NSMutableArray alloc] initWithCapacity:count];

    for (int i = 0; i < count; ++i) {
        highlight = (Highlight *)[NSEntityDescription insertNewObjectForEntityForName:@"Highlight" inManagedObjectContext:self.managedObjectContext];
        
        if (count == kDefaultNumFeedItems) {
            [highlight setText: @"mint tea leaves on the thai fried rice are excellent!"];
        }
        else {
            [highlight setText: @"black coffee has free refills! awesome! i just have to write more because it lets me type up to 140 characters just like a tweet and i want to see if this is really what it says it is."];
        }
        
        [feed addObject:highlight];
    }
    
    return feed;
}

@end
