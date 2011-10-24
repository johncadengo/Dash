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

@property (nonatomic, strong) NSString * address;
@property (nonatomic, strong) NSString * name;
@property (nonatomic, strong) NSString * phone;
@property (nonatomic, strong) NSString * price;
@property (nonatomic, strong) Location *location;
@property (nonatomic, strong) NSSet *rating;
@end

@interface Place (CoreDataGeneratedAccessors)

- (void)addRatingObject:(NSManagedObject *)value;
- (void)removeRatingObject:(NSManagedObject *)value;
- (void)addRating:(NSSet *)values;
- (void)removeRating:(NSSet *)values;
@end
