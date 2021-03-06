//
//  Place.h
//  Dash
//
//  Created by John Cadengo on 5/24/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "Uniqueness.h"

@class Badge, Category, FlagPlace, Highlight, Hours, NewsItem, Person, PlaceAction, PlaceLocation, Pop;

@interface Place : Uniqueness

@property (nonatomic, retain) NSString * address;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * phone;
@property (nonatomic, retain) NSString * price;
@property (nonatomic, retain) NSNumber * thumbsdowncount;
@property (nonatomic, retain) NSNumber * thumbsupcount;
@property (nonatomic, retain) NSNumber * rating;
@property (nonatomic, retain) NSNumber * num_ratings;
@property (nonatomic, retain) NSSet *actions;
@property (nonatomic, retain) NSSet *badges;
@property (nonatomic, retain) NSSet *categories;
@property (nonatomic, retain) NSSet *flags;
@property (nonatomic, retain) NSSet *highlights;
@property (nonatomic, retain) NSSet *hours;
@property (nonatomic, retain) PlaceLocation *location;
@property (nonatomic, retain) NSSet *newsItems;
@property (nonatomic, retain) NSSet *pops;
@property (nonatomic, retain) NSSet *recommends;
@property (nonatomic, retain) NSSet *saves;
@end

@interface Place (CoreDataGeneratedAccessors)

- (void)addActionsObject:(PlaceAction *)value;
- (void)removeActionsObject:(PlaceAction *)value;
- (void)addActions:(NSSet *)values;
- (void)removeActions:(NSSet *)values;

- (void)addBadgesObject:(Badge *)value;
- (void)removeBadgesObject:(Badge *)value;
- (void)addBadges:(NSSet *)values;
- (void)removeBadges:(NSSet *)values;

- (void)addCategoriesObject:(Category *)value;
- (void)removeCategoriesObject:(Category *)value;
- (void)addCategories:(NSSet *)values;
- (void)removeCategories:(NSSet *)values;

- (void)addFlagsObject:(FlagPlace *)value;
- (void)removeFlagsObject:(FlagPlace *)value;
- (void)addFlags:(NSSet *)values;
- (void)removeFlags:(NSSet *)values;

- (void)addHighlightsObject:(Highlight *)value;
- (void)removeHighlightsObject:(Highlight *)value;
- (void)addHighlights:(NSSet *)values;
- (void)removeHighlights:(NSSet *)values;

- (void)addHoursObject:(Hours *)value;
- (void)removeHoursObject:(Hours *)value;
- (void)addHours:(NSSet *)values;
- (void)removeHours:(NSSet *)values;

- (void)addNewsItemsObject:(NewsItem *)value;
- (void)removeNewsItemsObject:(NewsItem *)value;
- (void)addNewsItems:(NSSet *)values;
- (void)removeNewsItems:(NSSet *)values;

- (void)addPopsObject:(Pop *)value;
- (void)removePopsObject:(Pop *)value;
- (void)addPops:(NSSet *)values;
- (void)removePops:(NSSet *)values;

- (void)addRecommendsObject:(Person *)value;
- (void)removeRecommendsObject:(Person *)value;
- (void)addRecommends:(NSSet *)values;
- (void)removeRecommends:(NSSet *)values;

- (void)addSavesObject:(Person *)value;
- (void)removeSavesObject:(Person *)value;
- (void)addSaves:(NSSet *)values;
- (void)removeSaves:(NSSet *)values;

@end
