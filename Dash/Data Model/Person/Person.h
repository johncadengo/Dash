//
//  Person.h
//  Dash
//
//  Created by John Cadengo on 10/27/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "Uniqueness.h"

@class Action, Friendships, PersonPhoto, Pop;

@interface Person : Uniqueness

@property (nonatomic, retain) NSString * email;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSSet *actions;
@property (nonatomic, retain) NSSet *friends;
@property (nonatomic, retain) NSSet *pops;
@property (nonatomic, retain) PersonPhoto *profilepic;
@end

@interface Person (CoreDataGeneratedAccessors)

- (void)addActionsObject:(Action *)value;
- (void)removeActionsObject:(Action *)value;
- (void)addActions:(NSSet *)values;
- (void)removeActions:(NSSet *)values;
- (void)addFriendsObject:(Friendships *)value;
- (void)removeFriendsObject:(Friendships *)value;
- (void)addFriends:(NSSet *)values;
- (void)removeFriends:(NSSet *)values;
- (void)addPopsObject:(Pop *)value;
- (void)removePopsObject:(Pop *)value;
- (void)addPops:(NSSet *)values;
- (void)removePops:(NSSet *)values;
@end
