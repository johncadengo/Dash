//
//  Pop.h
//  Dash
//
//  Created by John Cadengo on 10/27/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "Action.h"

@class Person, Place, PopLocation;

@interface Pop : Action

@property (nonatomic, retain) PopLocation *location;
@property (nonatomic, retain) NSSet *party;
@property (nonatomic, retain) NSSet *places;
@end

@interface Pop (CoreDataGeneratedAccessors)

- (void)addPartyObject:(Person *)value;
- (void)removePartyObject:(Person *)value;
- (void)addParty:(NSSet *)values;
- (void)removeParty:(NSSet *)values;
- (void)addPlacesObject:(Place *)value;
- (void)removePlacesObject:(Place *)value;
- (void)addPlaces:(NSSet *)values;
- (void)removePlaces:(NSSet *)values;
@end
