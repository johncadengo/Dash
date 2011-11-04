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
#import "Comment.h"
#import "Comment+Helper.h"
#import "NSArray+Helpers.h"
#import "NSString+RandomStrings.h"


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

#pragma mark - Gets

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
        
        [highlight setText: [NSString randomStringOfMaxLength:140]];
        
        [feed addObject:highlight];
    }
    
    return feed;
}

- (NSMutableArray *)commentsForHighlight:(Highlight *)highlight
{
    return [self commentsForHighlight:highlight withCount:kDefaultNumComments];
}

- (NSMutableArray *)commentsForHighlight:(Highlight *)highlight withCount:(NSUInteger)count
{
    // TODO: This is a stub for now. Actually request comments fro model!
    Comment *comment;
    NSMutableArray *comments = [[NSMutableArray alloc] initWithCapacity:count];

    comment = (Comment *)[NSEntityDescription insertNewObjectForEntityForName:@"Comment" inManagedObjectContext:self.managedObjectContext];
    [comment setText:@"ahahaha, i really like this place too!"];
    [comments addObject:comment];
    
    comment = (Comment *)[NSEntityDescription insertNewObjectForEntityForName:@"Comment" inManagedObjectContext:self.managedObjectContext];
    [comment setText:@"my favorite :)"];
    [comments addObject:comment];
    
    comment = (Comment *)[NSEntityDescription insertNewObjectForEntityForName:@"Comment" inManagedObjectContext:self.managedObjectContext];
    [comment setText:@"ur so kewl"];
    [comments addObject:comment];
    
    for (int i = 3; i < count; ++i) {
        comment = (Comment *)[NSEntityDescription insertNewObjectForEntityForName:@"Comment" inManagedObjectContext:self.managedObjectContext];
        [comment setText:@"quick brown foxes jumping"];
    }
    
    return comments;
}


#pragma mark - Posts

- (void)person:(Person*)person comments:(NSString *)text onHighlight:(Highlight *)highlight
{
    
}

- (void)person:(Person *)person addsHighlight:(NSString *)text toPlace:(Place *) withPhoto:(Photo *) photo
{
    
}

@end
