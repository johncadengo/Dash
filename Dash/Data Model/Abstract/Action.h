//
//  Action.h
//  Dash
//
//  Created by John Cadengo on 10/27/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "Uniqueness.h"

@class Comment, Like, Person;

@interface Action : Uniqueness

@property (nonatomic, retain) NSDate * timestamp;
@property (nonatomic, retain) Person *author;
@property (nonatomic, retain) NSSet *comments;
@property (nonatomic, retain) NSSet *likes;
@end

@interface Action (CoreDataGeneratedAccessors)

- (void)addCommentsObject:(Comment *)value;
- (void)removeCommentsObject:(Comment *)value;
- (void)addComments:(NSSet *)values;
- (void)removeComments:(NSSet *)values;
- (void)addLikesObject:(Like *)value;
- (void)removeLikesObject:(Like *)value;
- (void)addLikes:(NSSet *)values;
- (void)removeLikes:(NSSet *)values;
@end
