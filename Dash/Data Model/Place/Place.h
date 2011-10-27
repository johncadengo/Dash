//
//  Place.h
//  Dash
//
//  Created by John Cadengo on 10/27/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "Uniqueness.h"

@class PlaceAction, Category, Hours, FlagPlace, PlaceLocation, PlacePhoto, Pop;

@interface Place : Uniqueness

@property (nonatomic, retain) NSString * address;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * phone;
@property (nonatomic, retain) NSString * price;
@property (nonatomic, retain) NSSet *actions;
@property (nonatomic, retain) NSSet *categories;
@property (nonatomic, retain) NSSet *flags;
@property (nonatomic, retain) NSSet *hours;
@property (nonatomic, retain) PlaceLocation *location;
@property (nonatomic, retain) NSSet *photos;
@property (nonatomic, retain) NSSet *pops;
@end

@interface Place (CoreDataGeneratedAccessors)

- (void)addActionsObject:(PlaceAction *)value;
- (void)removeActionsObject:(PlaceAction *)value;
- (void)addActions:(NSSet *)values;
- (void)removeActions:(NSSet *)values;
- (void)addCategoriesObject:(Category *)value;
- (void)removeCategoriesObject:(Category *)value;
- (void)addCategories:(NSSet *)values;
- (void)removeCategories:(NSSet *)values;
- (void)addFlagsObject:(FlagPlace *)value;
- (void)removeFlagsObject:(FlagPlace *)value;
- (void)addFlags:(NSSet *)values;
- (void)removeFlags:(NSSet *)values;
- (void)addHoursObject:(Hours *)value;
- (void)removeHoursObject:(Hours *)value;
- (void)addHours:(NSSet *)values;
- (void)removeHours:(NSSet *)values;
- (void)addPhotosObject:(PlacePhoto *)value;
- (void)removePhotosObject:(PlacePhoto *)value;
- (void)addPhotos:(NSSet *)values;
- (void)removePhotos:(NSSet *)values;
- (void)addPopsObject:(Pop *)value;
- (void)removePopsObject:(Pop *)value;
- (void)addPops:(NSSet *)values;
- (void)removePops:(NSSet *)values;
@end
