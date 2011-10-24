//
//  Place.h
//  Dash
//
//  Created by John Cadengo on 10/24/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Location;

@interface Place : NSManagedObject

@property (nonatomic, retain) NSString * address;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * phone;
@property (nonatomic, retain) NSString * price;
@property (nonatomic, retain) Location *location;
@property (nonatomic, retain) NSSet *rating;
@end

@interface Place (CoreDataGeneratedAccessors)

- (void)addRatingObject:(NSManagedObject *)value;
- (void)removeRatingObject:(NSManagedObject *)value;
- (void)addRating:(NSSet *)values;
- (void)removeRating:(NSSet *)values;
@end
