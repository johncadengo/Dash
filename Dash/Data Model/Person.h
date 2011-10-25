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

/** Person is a custom class to represent the Person entity in our core data model.
 */
@interface Person : NSManagedObject

@property (nonatomic, strong) NSString * email;
@property (nonatomic, strong) NSString * name;
@property (nonatomic, strong) NSSet *rating;
@property (nonatomic, strong) NSSet *location;
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
