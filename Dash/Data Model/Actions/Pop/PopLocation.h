//
//  PopLocation.h
//  Dash
//
//  Created by John Cadengo on 10/27/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "Location.h"

@class Pop;

@interface PopLocation : Location

@property (nonatomic, retain) NSSet *pops;
@end

@interface PopLocation (CoreDataGeneratedAccessors)

- (void)addPopsObject:(Pop *)value;
- (void)removePopsObject:(Pop *)value;
- (void)addPops:(NSSet *)values;
- (void)removePops:(NSSet *)values;
@end
