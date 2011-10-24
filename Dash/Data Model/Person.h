//
//  Person.h
//  Dash
//
//  Created by John Cadengo on 10/24/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Location, Rating;

@interface Person : NSManagedObject

@property (nonatomic, retain) NSString * email;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSSet *rating;
@property (nonatomic, retain) NSSet *location;
@end

@interface Person (CoreDataGeneratedAccessors)

- (void)addRatingObject:(Rating *)value;
- (void)removeRatingObject:(Rating *)value;
- (void)addRating:(NSSet *)values;
- (void)removeRating:(NSSet *)values;
- (void)addLocationObject:(Location *)value;
- (void)removeLocationObject:(Location *)value;
- (void)addLocation:(NSSet *)values;
- (void)removeLocation:(NSSet *)values;
@end
