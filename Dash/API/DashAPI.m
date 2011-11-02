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

- (NSMutableArray *)feed
{
    return [self feedForPerson:nil withCount:kDefaultNumFeedItems];
}

- (NSMutableArray *)feedWithCount:(NSUInteger)count
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
        [feed addObject:highlight];
    }
    
    return feed;
}

@end
