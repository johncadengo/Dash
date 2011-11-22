//
//  DashAPI.m
//  Dash
//
//  Created by John Cadengo on 10/24/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "DashAPI.h"

#import "NSArray+Helpers.h"
#import "NSString+RandomStrings.h"
#import "NSDate+RandomDates.h"

#import "Place.h"

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

#pragma mark - Scaffolding

- (Person *)randomGhost
{
    Person *author;
    
    NSArray *names = [NSArray arrayWithObjects:@"Laura Byun", @"Grace Chi", @"Chloe Choe", @"Eunice Chung", @"Andrew Park", @"Chris Kim", @"Amos Kim", @"Julia Yang", nil];
    author = (Person *)[NSEntityDescription insertNewObjectForEntityForName:@"Person" inManagedObjectContext:self.managedObjectContext];
    [author setName:[NSString stringWithFormat:[names randomObject]]];
    
    PersonPhoto *profilePic = [NSEntityDescription insertNewObjectForEntityForName:@"PersonPhoto" inManagedObjectContext:self.managedObjectContext];
    [author setProfilepic:profilePic];
    
    return author;
}

- (Place *)randomCrypt
{
    Place *place;
    
    NSArray *names = [NSArray arrayWithObjects:@"Totto Ramen", @"Mamoun's Falafel", @"Ben's Pizzeria", @"Shake Shack", @"Halal Chicken & Rice", @"Whole Foods", nil];
    place = (Place *)[NSEntityDescription insertNewObjectForEntityForName:@"Place" inManagedObjectContext:self.managedObjectContext];
    [place setName:[NSString stringWithFormat:[names randomObject]]];
    [place setAddress:[NSString stringWithFormat:@"226 Thompson St. 10012"]];
    
    return place;
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
        highlight = [self person:nil addsHighlight:[NSString randomStringOfMaxLength:140] toPlace:nil withPhoto:nil];
        
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
    // TODO: This is a stub for now. Actually request comments from model!
    Comment *comment;
    NSMutableArray *comments = [[NSMutableArray alloc] initWithCapacity:count];

    NSArray *texts = [NSArray arrayWithObjects:@"ahaha, i totally love this.",
                      @"me too!", @"my fav :D", @"ur so kewl", @"LOL!!!", nil];
    
    for (int i = 0; i < count; ++i) {
        comment = [self person:nil comments:[texts randomObject] onAction:highlight];
        [comments addObject:comment];
    }
    
    return comments;
}

- (NSMutableArray *)placeActionsForPerson:(Person *)person
{
    return [self placeActionsForPerson:person withCount:kDefaultNumFeedItems];
}

- (NSMutableArray *)placeActionsForPerson:(Person *)person withCount:(NSUInteger)count
{
    Save *save;
    NSMutableArray *feed = [[NSMutableArray alloc] initWithCapacity:count];
    
    for (int i = 0; i < count; ++i) {
        save = [self person:[self randomGhost] savesPlace:[self randomCrypt]];
        
        [feed addObject:save];
    }
    
    return feed;
}

#pragma mark - Posts

- (Comment *)person:(Person *)person comments:(NSString *)text onAction:(Action *)action
{
    // TODO: Validation?
    Comment *comment = (Comment *)[NSEntityDescription insertNewObjectForEntityForName:@"Comment" inManagedObjectContext:self.managedObjectContext];
    
    Person *author;
    
    if (person == nil) {
        author = [self randomGhost];
    }
    else {
        author = person;
    }
    
    [comment setAuthor:author];
    [comment setText:text];
    [comment setAction:action];
    [comment setTimestamp:[NSDate randomDateWithinRelativeTime:RelativeTimeDays]];
    
    return comment;
}

- (Highlight *)person:(Person *)person addsHighlight:(NSString *)text toPlace:(Place *)place withPhoto:(Photo *)photo
{
    // TODO: Validation?
    Highlight *highlight = (Highlight *)[NSEntityDescription insertNewObjectForEntityForName:@"Highlight" inManagedObjectContext:self.managedObjectContext];

    Person *author;
    
    if (person == nil) {
        author = [self randomGhost];
    }
    else {
        author = person;
    }
    
    [highlight setAuthor:author];
    [highlight setText:text];
    [highlight setTimestamp:[NSDate randomDateWithinRelativeTime:RelativeTimeDays]];
    // TODO: Handle Photos?
    //[highlight setPhotos:];
    
    return highlight;
}

- (Save *)person:(Person *)person savesPlace:(Place *)place
{
    Save *save = (Save *)[NSEntityDescription insertNewObjectForEntityForName:@"Save" inManagedObjectContext:self.managedObjectContext];

    [save setAuthor:person];
    [save setPlace:place];
    
    return save;
}



@end
